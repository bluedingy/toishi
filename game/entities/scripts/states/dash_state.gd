class_name DashState
extends CharacterState

func enter(prev: CharacterState) -> void:
	super(prev)
	# Dash in the facing direction (or input direction if available)
	var dir := input.get_move_direction()
	if dir == 0:
		dir = character.facing
	character.facing = dir
	set_velocity(Vector3(dir * stats.dash_speed, 0.0, 0.0))
	character.dash_cooldown_remaining = stats.dash_cooldown


func physics_update(delta: float) -> StringName:
	super(delta)
	
	if frame >= 5:
		var dir := input.get_move_direction()
		if character.facing != dir:
			if not is_on_floor():
				return &"AirState"
				
			return &"IdleState"
		

	if frame >= stats.dash_duration:
		if not is_on_floor():
			return &"AirState"
		if input.buffer.consume(InputBuffer.Action.DASH_HOLD):
			print('Running')
			return &"RunState"
		return &"IdleState"

	# Can cancel a dash into attack
	if input.buffer.consume(InputBuffer.Action.ATTACK):
		return &"AttackState"

	return &""
