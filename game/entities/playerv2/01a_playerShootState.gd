class_name PlayerShootState
extends PlayerState
#========================= TODO LIST ===================
# - Add modular 5 punch combo
# - Add slight movement to the punches
# - Add animation

var _aerial: bool = false

func enter(prev: PlayerState) -> void:
	super(prev)
	_aerial = not is_on_floor()
	character.velocity.x=0.0
	character.current_hand_size-=1

func physics_update(delta: float) -> StringName:
	super(delta)

	if _aerial:
		apply_gravity(delta)

	var startup := 1
	var recovery := 1
	
	var arrow = preload('res://game/entities/projectile/card_placeholder.tscn')

	# Startup → active
	if frame == startup:
		#print(character.look_dir)
		var arrow_instance = arrow.instantiate() as CharacterBody3D
		arrow_instance.speed = 75
		arrow_instance.look_dir = character.look_dir
		#arrow_instance.apply_strategy_patterns()
		character.get_parent().add_child(arrow_instance)
		arrow_instance.global_position = character.global_position
		
		
		

	# Active → recovery

	# Recovery complete
	if frame >= startup + recovery:
		return &"IdleState"

	return &""
	


#func exit() -> void:
	#character.get_node("HitboxPunch").set_active(false)
