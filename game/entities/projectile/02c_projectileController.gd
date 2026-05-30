class_name ProjectileController
extends CharacterBody3D

## Root character controller for the robot boxer.
## Owns the state machine, input reader, poise system, and stats.
## Exposes public state flags read by states and the hurtbox receiver.

# ── Configuration ─────────────────────────────────────────────────────────────
@export var source_player_index: int = 0
@export var base_stats: CharacterStats

# ── Runtime Stats (modified by upgrades) ─────────────────────────────────────
var stats: CharacterStats

# ── Subsystems ────────────────────────────────────────────────────────────────
var state_machine: ProjectileStateMachine

# ── Public State Flags (read by states and hurtbox) ──────────────────────────-
var look_dir: Vector3 = Vector3(1,0,0)
var damage: float = 55.0
var speed: float = 100

# ── Signals ──────────────────────────────────────────────────────────────────


func _ready() -> void:
	
	assert(base_stats != null, "RobotBoxer requires a CharacterStats resource.")

	# Deep copy so upgrades don't mutate the base resource
	stats = base_stats.duplicate_stats()

	# State machine
	state_machine = ProjectileStateMachine.new(self)
	_register_states()
	state_machine.start(&"FlyState")


func _physics_process(delta: float) -> void:
		
	look_dir = get_mouse_look_direction()
		
	# Update state machine
	state_machine.update(delta)

	# Apply movement
	move_and_slide()



# ── State Registration ────────────────────────────────────────────────────────

func _register_states() -> void:
	#state_machine.register_state(&"IdleState",         ProjectileIdleState.new())
	#state_machine.register_state(&"ShootState",          ProjectileAimingState.new())
	state_machine.register_state(&"FlyState",         ProjectileFlyingState.new())
	#state_machine.register_state(&"HitState",         ProjectileHittingState.new())
	#state_machine.register_state(&"ClashState",         ProjectileClashingState.new())
	#state_machine.register_state(&"LandState",         ProjectileLandingState.new())
	#state_machine.register_state(&"IdleState",         ProjectileIdleState.new())
	#state_machine.register_state(&"PickupState",         ProjectilePickupState.new())


# ── Public API ────────────────────────────────────────────────────────────────


## Reset to base state for a new round (keeps upgrades, resets health/poise).
func reset_for_round() -> void:
	velocity = Vector3.ZERO
	state_machine.force_transition(&"IdleState")
	



# ── Private Callbacks ─────────────────────────────────────────────────────────

func get_mouse_look_direction() -> Vector3:
	var mouse_pos = get_mouse_world_position()
	#DebugDraw3D.draw_line(global_position, mouse_pos, Color.RED)
	var look_vector = global_position - mouse_pos
	var look_unit_vector = look_vector.normalized()
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

		
