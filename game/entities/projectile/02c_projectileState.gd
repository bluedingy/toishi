class_name ProjectileState
extends RefCounted

## Base class for all projectile states.
## Each state has access to the owner projectile node and can read input,
## modify velocity, and request state transitions.

var projectile: CharacterBody3D    # the robot boxer node
var stats:CharacterStats

# Frame counter — incremented each physics frame while in this state.
var frame: int = 0


func setup(p_projectile: CharacterBody3D) -> void:
	projectile = p_projectile
	stats = p_projectile.stats
	print(stats)


## Called when entering this state. prev_state may be null.
func enter(_prev_state: ProjectileState) -> void:
	frame = 0


## Called every physics frame. Return the next state name to transition,
## or an empty string to stay in this state.
func physics_update(_delta: float) -> StringName:
	frame += 1
	projectile.global_position.z=0
	apply_gravity(_delta)
	return &""


## Called when leaving this state.
func exit() -> void:
	pass


## Shorthand helpers used by most states ─────────────────────────────────────

func is_on_floor() -> bool:
	return projectile.is_on_floor()


func velocity() -> Vector3:
	return projectile.velocity


func set_velocity(v: Vector3) -> void:
	projectile.velocity = v


func set_vel_x(x: float) -> void:
	projectile.velocity.x = x


func set_vel_y(y: float) -> void:
	projectile.velocity.y = y


func apply_gravity(delta: float) -> void:
	var grav := stats.gravity
	if projectile.velocity.y < 0.0:
		grav *= stats.fall_gravity_multiplier
	projectile.velocity.y = maxf(
		projectile.velocity.y - grav * delta,
		stats.max_fall_speed
	)
