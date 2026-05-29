extends Node
# GameManager.gd - Handles game state, networking, and rollback logic

class_name GameManager

# Network states
const ROLLBACK_WINDOW = 8  # Number of frames to keep in history
const TICK_RATE = 60  # Server ticks per second

var is_server: bool = false
var is_client: bool = false
var local_player_id: int = 0
var remote_player_id: int = 1
var confirmed_tick: int = 0
var predicted_tick: int = 0

# Frame history for rollback
var frame_history: Array = []
var player_inputs: Dictionary = {}  # {tick: {player_id: input_data}}

# Game state
var players: Dictionary = {}  # {player_id: Player node}
var is_paused: bool = false

signal player_joined(player_id: int)
signal player_left(player_id: int)
signal game_tick(tick: int)
signal rollback_occurred(from_tick: int, to_tick: int)

func _ready() -> void:
	set_physics_process(true)
	await get_tree().process_frame
	setup_network()

func setup_network() -> void:
	# For this example, we'll support both local 2-player and network modes
	# Default to local testing
	is_server = true
	local_player_id = 0
	remote_player_id = 1

func register_player(player_node: Node, player_id: int) -> void:
	players[player_id] = player_node
	player_joined.emit(player_id)

func submit_input(tick: int, player_id: int, input_data: Dictionary) -> void:
	if not player_inputs.has(tick):
		player_inputs[tick] = {}
	player_inputs[tick][player_id] = input_data

func get_player_input(tick: int, player_id: int) -> Dictionary:
	if player_inputs.has(tick) and player_inputs[tick].has(player_id):
		return player_inputs[tick][player_id]
	return {"jump": false, "move_x": 0}

func save_frame_state(tick: int) -> Dictionary:
	var state = {
		"tick": tick,
		"players": {}
	}
	for player_id in players:
		var player = players[player_id]
		state["players"][player_id] = {
			"position": player.global_position,
			"velocity": player.velocity if player.has_meta("velocity") else Vector2.ZERO,
			"is_jumping": player.is_jumping if player.has_meta("is_jumping") else false
		}
	return state

func load_frame_state(state: Dictionary) -> void:
	for player_id in state["players"]:
		if player_id in players:
			var player = players[player_id]
			var player_state = state["players"][player_id]
			player.global_position = player_state["position"]
			if player.has_meta("velocity"):
				player.set_meta("velocity", player_state["velocity"])
			if player.has_meta("is_jumping"):
				player.set_meta("is_jumping", player_state["is_jumping"])

func perform_rollback(from_tick: int, to_tick: int) -> void:
	rollback_occurred.emit(from_tick, to_tick)
	
	# Find the frame state to load
	for frame_state in frame_history:
		if frame_state["tick"] == to_tick:
			load_frame_state(frame_state)
			break

func cleanup_old_frames() -> void:
	# Keep only ROLLBACK_WINDOW frames
	if frame_history.size() > ROLLBACK_WINDOW:
		frame_history = frame_history.slice(-ROLLBACK_WINDOW)

func advance_tick() -> void:
	predicted_tick += 1
	game_tick.emit(predicted_tick)
	
	# Save frame state for rollback
	var state = save_frame_state(predicted_tick)
	frame_history.append(state)
	cleanup_old_frames()

func confirm_tick(tick: int) -> void:
	confirmed_tick = tick
	# In a real implementation, you'd reconcile predicted state with confirmed state

func _physics_process(delta: float) -> void:
	if not is_paused:
		advance_tick()
