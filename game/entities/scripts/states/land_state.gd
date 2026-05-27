class_name LandState
extends CharacterState

const LAND_LAG: int = 4  # frames of landing lag

func enter(prev: CharacterState) -> void:
	super(prev)
	#set_vel_x(0.0)


func physics_update(delta: float) -> StringName:
	super(delta)
	if frame >= LAND_LAG:
		return &"IdleState"
	return &""
