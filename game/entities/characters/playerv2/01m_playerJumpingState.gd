class_name PlayerJumpState
extends PlayerState

func enter(prev: PlayerState) -> void:
	super(prev)
	set_vel_y(stats.jump_velocity)


func physics_update(delta: float) -> StringName:
	super(delta)
	return &"AirState"
