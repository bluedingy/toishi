class_name PlayerMeleeState
extends PlayerState

var _aerial: bool = false

func enter(prev: PlayerState) -> void:
	super(prev)
	_aerial = not is_on_floor()

func physics_update(delta: float) -> StringName:
	super(delta)

	if _aerial:
		apply_gravity(delta)

	var startup := 1
	var recovery := 1
	print("Melee!")
		
		
		

	# Active → recovery

	# Recovery complete
	if frame >= startup + recovery:
		return &"IdleState"

	return &""
	


#func exit() -> void:
	#character.get_node("HitboxPunch").set_active(false)
