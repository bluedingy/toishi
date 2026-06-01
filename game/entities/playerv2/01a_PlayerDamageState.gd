class_name PlayerDamageState
extends PlayerState

func enter(prev: PlayerState) -> void:
	super(prev)
	set_vel_x(0.0)


func physics_update(delta: float) -> StringName:
	super(delta)

	# Passive: face the opponent while idle
	return &"IdleState"
