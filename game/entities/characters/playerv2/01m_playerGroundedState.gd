class_name PlayerGroundedState
extends PlayerState

func enter(prev: PlayerState) -> void:
	super(prev)
	character.jumps_remaining = 2
	set_vel_x(0.0)


func physics_update(delta: float) -> StringName:
	super(delta)
	
	if not is_on_floor():
		return &"AirState"
	# Handle Movement
	apply_gravity(delta)
	
	var dir := input.get_move_direction()
	set_vel_x(dir * stats.walk_speed)
	
	if input.buffer.consume(InputBuffer.Action.JUMP) and character.jumps_remaining > 0:
		return &"JumpState"

	# Passive: face the opponent while idle
	return &""
