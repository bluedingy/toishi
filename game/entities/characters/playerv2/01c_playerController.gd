class_name PlayerController
extends CharacterBody3D

## Root character controller for the robot boxer.
## Owns the state machine, input reader, poise system, and stats.
## Exposes public state flags read by states and the hurtbox receiver.

# ── Configuration ─────────────────────────────────────────────────────────────
@export var player_index: int = 0
@export var base_stats: CharacterStats

# ── Runtime Stats (modified by upgrades) ─────────────────────────────────────
var stats: CharacterStats

# ── Subsystems ────────────────────────────────────────────────────────────────
var health_component: HealthComponent
var state_machine: PlayerStateMachine
var movement_machine: PlayerStateMachine
var input_reader: LocalInputReader

# ── Public State Flags (read by states and hurtbox) ──────────────────────────
var facing: int = 1               # 1 = right, -1 = left
var look_dir: Vector3 = Vector3(1,0,0)
var is_blocking: bool = false
var is_in_parry_window: bool = false
var is_invincible: bool = false   # i-frames during slip

var lives = 3
var jumps_remaining: int = 2
var max_hand_size = 10
var current_hand_size = 10
var dash_cooldown_remaining: int = 0


# ── References ────────────────────────────────────────────────────────────────
var opponent: Node3D = null       # set by GameManager each round

# ── Signals ──────────────────────────────────────────────────────────────────
signal health_changed(new_health: float, max_health: float)
signal died()


func _ready() -> void:
	
	add_to_group("Entities")
	assert(base_stats != null, "PlayerController requires a CharacterStats resource.")

	# Deep copy so upgrades don't mutate the base resource
	stats = base_stats.duplicate_stats()
	
	health_component = $HealthComponent
	health_component.initialize(stats.max_health*5, stats.max_health)
	health_component.health_depleted.connect(_on_health_component_died)

	# Input
	input_reader = LocalInputReader.new(player_index)

	# State machine
	state_machine = PlayerStateMachine.new(self, input_reader)
	movement_machine = PlayerStateMachine.new(self, input_reader)
	_register_states()
	state_machine.start(&"IdleState")
	movement_machine.start(&"GroundedState")


func _physics_process(delta: float) -> void:
	input_reader.poll()

	# Tick cooldowns
	if dash_cooldown_remaining > 0:
		dash_cooldown_remaining -= 1
		
	look_dir = get_mouse_look_direction()
	# Update state machine
	state_machine.update(delta)
	movement_machine.update(delta)

	# Apply movement
	move_and_slide()



# ── State Registration ────────────────────────────────────────────────────────

func _register_states() -> void:
	state_machine.register_state(&"IdleState",            PlayerIdleState.new())
	state_machine.register_state(&"ShootState",           PlayerShootState.new())
	state_machine.register_state(&"MeleeState",           PlayerMeleeState.new())
	state_machine.register_state(&"DamageState",          PlayerDamageState.new())
	
	movement_machine.register_state(&"GroundedState",     PlayerGroundedState.new())
	movement_machine.register_state(&"JumpState",         PlayerJumpState.new())
	movement_machine.register_state(&"AirState",          PlayerAirState.new())


# ── Public API ────────────────────────────────────────────────────────────────


## Reset to base state for a new round (keeps upgrades, resets health/poise).
func reset_for_round() -> void:
	velocity = Vector3.ZERO
	is_blocking = false
	is_in_parry_window = false
	is_invincible = false
	jumps_remaining = 1
	dash_cooldown_remaining = 0
	state_machine.force_transition(&"IdleState")
	



# ── Private Callbacks ─────────────────────────────────────────────────────────

func _on_hit_received(_hit_data) -> void:
		died.emit()
		

func get_mouse_look_direction() -> Vector3:
	var mouse_pos = get_mouse_world_position()
	DebugDraw3D.draw_line(global_position, mouse_pos, Color.RED)
	var look_vector = global_position - mouse_pos
	var look_unit_vector = look_vector.normalized().rotated(Vector3.FORWARD, PI)
	return look_unit_vector
	
func get_controller_look_direction() -> Vector3:
	var stick = Input.get_vector(
		"look_left",
		"look_right",
		"look_up",
		"look_down"
		)

	if stick.length() > 0.2:
		var look_direction = Vector3(
			stick.x,
			0,
			stick.y
		).normalized()
	return Vector3(0,0,0)

func get_mouse_world_position() -> Vector3:
	var camera = get_viewport().get_camera_3d()
	var mouse_pos = get_viewport().get_mouse_position()
	# Ray from camera through mouse
	var ray_origin = camera.project_ray_origin(mouse_pos)
	var ray_direction = camera.project_ray_normal(mouse_pos)
	# Plane representing your gameplay surface
	var plane = Plane(Vector3.FORWARD, 0.0) # y = 0 plane
	# Intersection point
	var hit = plane.intersects_ray(ray_origin, ray_direction)
	return hit
	
func get_mouse_vector() -> Vector3:
	var mouse_world = get_mouse_world_position()
	# Vector from character to mouse
	var vec = mouse_world - global_position
	return vec
	

func _on_health_component_died():
	print("The parent received the death signal!")
	
	if lives <= 0:
		queue_free() # Removes the parent from the game
	else: 
		lives -= 1
		health_component.initialize(stats.max_health*5, stats.max_health)
		

		
