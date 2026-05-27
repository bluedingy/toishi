class_name IdleState
extends CharacterState

func enter(prev: CharacterState) -> void:
	super(prev)
	set_vel_x(0.0)


func physics_update(delta: float) -> StringName:
	super(delta)

	# Transitions out of idlea
	if not is_on_floor():
		return &"AirState"

	var dir := input.get_move_direction()
	if dir != 0:
		return &"RunState"

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

	if input.buffer.is_held(InputBuffer.Action.SPECIAL_HOLD):
		return &"ChargedRocketState"

	if input.buffer.is_held(InputBuffer.Action.BLOCK):
		return &"BlockState"

	# Passive: face the opponent while idle
	face_opponent()
	return &""
