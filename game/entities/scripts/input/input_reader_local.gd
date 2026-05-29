
class_name LocalInputReader
extends InputReaderInterface

## Maps Godot InputMap actions to InputBuffer.Action values.
## Supports multiple control schemes for local multiplayer (P1, P2, etc.)
## and can be swapped for a NetworkInputReader for online play.

var player_index: int

# Action map: InputBuffer.Action -> Godot InputMap action name
var _action_map: Dictionary = {}


func _init(p_index: int) -> void:
	player_index = p_index
	buffer = InputBuffer.new()
	_build_action_map(p_index)


func _build_action_map(p_index: int) -> void:
	# Actions are registered in the Godot InputMap as "p1_jump", "p2_jump", etc.
	#var prefix := "p%d_" % (p_index + 1)
	var prefix := ""
	_action_map = {
		InputBuffer.Action.MOVE_LEFT:   prefix + "move_left",
		InputBuffer.Action.MOVE_RIGHT:  prefix + "move_right",
		InputBuffer.Action.MOVE_UP:   prefix + "move_up",
		InputBuffer.Action.MOVE_DOWN:   prefix + "move_down",
		InputBuffer.Action.JUMP:        prefix + "jump",
		InputBuffer.Action.DASH:        prefix + "dash",
		InputBuffer.Action.DASH_HOLD:   prefix + "dash",
		InputBuffer.Action.ATTACK:      prefix + "attack",
		InputBuffer.Action.ATTACK_HOLD: prefix + "attack",   # same button, held state checked separately
		InputBuffer.Action.SPECIAL:      prefix + "special",
		InputBuffer.Action.SPECIAL_HOLD: prefix + "special",
		InputBuffer.Action.BLOCK:       prefix + "block",
	}


## Call every physics frame to poll hardware and feed the buffer.
func poll() -> void:
	var raw: Dictionary = {}
	for action in _action_map:
		raw[action] = Input.get_action_strength(_action_map[action])
	buffer.update(raw)


## Returns the intended horizontal movement direction (-1, 0, 1).
func get_move_direction() -> int:
	var left := buffer.is_held(InputBuffer.Action.MOVE_LEFT)
	var right := buffer.is_held(InputBuffer.Action.MOVE_RIGHT)
	var up :=  buffer.is_held(InputBuffer.Action.MOVE_UP)
	var down :=  buffer.is_held(InputBuffer.Action.MOVE_DOWN)
	
	var h_input = right - left
	var v_input = up - down
	
	var angle = atan2(h_input, v_input)
	var spawn_location = Vector2(200, 300)
	#print("UP: %s, DOWN: %s, LEFT: %s, RIGHT: %s, ANGLE: %s" % [str(up), str(down), str(left), str(right), str(angle)])
	if left and right:
		return 0
	if left:
		return -1
	if right:
		return 1
	return 0
## Returns the intended horizontal movement direction (-1, 0, 1).
func get_move_angle() -> float:
	var left := buffer.is_held(InputBuffer.Action.MOVE_LEFT)
	var right := buffer.is_held(InputBuffer.Action.MOVE_RIGHT)
	var up :=  buffer.is_held(InputBuffer.Action.MOVE_UP)
	var down :=  buffer.is_held(InputBuffer.Action.MOVE_DOWN)
	
	var h_input = right - left
	var v_input = up - down
	
	var angle = atan2(h_input, v_input)
	return angle
	
