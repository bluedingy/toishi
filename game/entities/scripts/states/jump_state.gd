class_name JumpState
extends CharacterState

func enter(prev: CharacterState) -> void:
	super(prev)
	set_vel_y(stats.jump_velocity)
	character.jumps_remaining = 1   # one double-jump remaining


func physics_update(delta: float) -> StringName:
	super(delta)
	return &"AirState"
