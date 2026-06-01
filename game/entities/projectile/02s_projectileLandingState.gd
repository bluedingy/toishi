class_name ProjectileLandingState
extends ProjectileState

func enter(prev: ProjectileState) -> void:
	super(prev)
	
	set_velocity(Vector3(0,0,0))


func physics_update(delta: float) -> StringName:
	super(delta)
	return &""
