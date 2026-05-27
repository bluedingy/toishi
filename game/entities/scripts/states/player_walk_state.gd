class_name RunState
extends CharacterState

func physics_update(delta: float) -> StringName:
	super(delta)

	if not is_on_floor():
		return &"AirState"

	var dir := input.get_move_direction()

	if dir == 0:
		return &"IdleState"

	if input.buffer.consume(InputBuffer.Action.JUMP):
		return &"JumpState"

	if input.buffer.consume(InputBuffer.Action.DASH):
		return &"DashState"

	if input.buffer.consume(InputBuffer.Action.ATTACK):
		return &"AttackState"

	if input.buffer.is_held(InputBuffer.Action.ATTACK_HOLD):
		return &"ChargedAttackState"

	if input.buffer.consume(InputBuffer.Action.SPECIAL):
		return &"RocketState"

	if input.buffer.is_held(InputBuffer.Action.BLOCK):
		return &"BlockState"

	# Update facing
	character.facing = dir
	set_vel_x(dir * stats.walk_speed)
	return &""
