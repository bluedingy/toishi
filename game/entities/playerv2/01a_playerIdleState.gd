class_name PlayerIdleState
extends PlayerState

func enter(prev: PlayerState) -> void:
	super(prev)
	set_vel_x(0.0)


func physics_update(delta: float) -> StringName:
	super(delta)

	# Transitions out of idle

	if input.buffer.consume(InputBuffer.Action.DASH):
		return &"DashState"

	if input.buffer.consume(InputBuffer.Action.DASH):
		return &"SlideState"

	if input.buffer.consume(InputBuffer.Action.DASH):
		return &"SprintState"

	if input.buffer.consume(InputBuffer.Action.ATTACK):
		if character.current_hand_size > 0:
			return &"ShootState"

	if input.buffer.is_held(InputBuffer.Action.ATTACK_HOLD):
		return &"AimState"

	if input.buffer.consume(InputBuffer.Action.SPECIAL):
		return &"MeleeState"

	if input.buffer.is_held(InputBuffer.Action.SPECIAL_HOLD):
		return &"heavyMeleeState"

	# Passive: face the opponent while idle
	return &""
