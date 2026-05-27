class_name CharacterState
extends RefCounted

## Base class for all character states.
## Each state has access to the owner character node and can read input,
## modify velocity, and request state transitions.

var character: CharacterBody3D    # the robot boxer node
var stats: CharacterStats
var input: LocalInputReader

# Frame counter — incremented each physics frame while in this state.
var frame: int = 0


func setup(p_character: CharacterBody3D, p_input: LocalInputReader) -> void:
	character = p_character
	stats = p_character.stats
	input = p_input


## Called when entering this state. prev_state may be null.
func enter(_prev_state: CharacterState) -> void:
	frame = 0


## Called every physics frame. Return the next state name to transition,
## or an empty string to stay in this state.
func physics_update(_delta: float) -> StringName:
	frame += 1
	return &""


## Called when leaving this state.
func exit() -> void:
	pass


## Shorthand helpers used by most states ─────────────────────────────────────

func is_on_floor() -> bool:
	return character.is_on_floor()


func velocity() -> Vector3:
	return character.velocity


func set_velocity(v: Vector3) -> void:
	character.velocity = v


func set_vel_x(x: float) -> void:
	character.velocity.x = x


func set_vel_y(y: float) -> void:
	character.velocity.y = y


func apply_gravity(delta: float) -> void:
	var grav := stats.gravity
	if character.velocity.y < 0.0:
		grav *= stats.fall_gravity_multiplier
	character.velocity.y = maxf(
		character.velocity.y - grav * delta,
		stats.max_fall_speed
	)


func face_opponent() -> void:
	# Character node exposes a reference to the current opponent.
	var opp: Node3D = character.opponent
	if opp == null:
		return
	character.facing = sign(opp.global_position.x - character.global_position.x)
	if character.facing == 0:
		character.facing = 1
