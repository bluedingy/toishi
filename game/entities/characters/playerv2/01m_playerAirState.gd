class_name PlayerAirState
extends PlayerState

var _coyote_frames_remaining: int = 0


func enter(prev: PlayerState) -> void:
	super(prev)
	# Grant coyote time if we walked off a ledge (not from a jump)
	character.jumps_remaining-=1
	if prev is PlayerGroundedState:
		_coyote_frames_remaining = stats.coyote_frames
	else:
		_coyote_frames_remaining = 0


func physics_update(delta: float) -> StringName:
	super(delta)

	apply_gravity(delta)

	# Horizontal air drift
	var dir := input.get_move_direction()
	var target_x := dir * stats.air_speed
	# TODO: Add a max speed here lower than the dash speed
	character.velocity.x = move_toward(
		character.velocity.x,
		target_x,
		stats.air_acceleration * delta
	)
	if dir != 0:
		character.facing = dir

	# Coyote jump
	if _coyote_frames_remaining > 0:
		_coyote_frames_remaining -= 1
		if input.buffer.consume(InputBuffer.Action.JUMP) and character.jumps_remaining>=0:
			set_vel_y(stats.jump_velocity)
			_coyote_frames_remaining = 0
			return &""

	# Normal / double jump
	if character.jumps_remaining > 0:
		if input.buffer.consume(InputBuffer.Action.JUMP):
			character.jumps_remaining -= 1
			set_vel_y(stats.double_jump_velocity)

	# Landing
	if is_on_floor():
		return &"GroundedState"

	return &""
