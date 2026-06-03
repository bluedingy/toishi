class_name ProjectilePickUpState
extends ProjectileState



var acceleration = 0.5
var speed = 5

func enter(prev: ProjectileState) -> void:
	super(prev)
	print("Im being picked up")
	#set_vel_x(projectile.speed)


func physics_update(delta: float) -> StringName:
	super(delta)
	var proj_pos = projectile.global_position
	var target_pos = projectile.destination_player_reference.global_position
	if proj_pos.distance_to(target_pos)<1:
		print("I just picked up a card")
		projectile.destination_player_reference.current_hand_size += 1
		projectile.queue_free()
	projectile.global_position = proj_pos.move_toward(target_pos, speed * delta)
	speed += acceleration
	DebugDraw3D.draw_line(projectile.global_position,projectile.destination_player_reference.global_position, Color.GREEN)
	
	
	# Setting the movement direction
	var move_angle = (PI/2)+atan2(projectile.velocity.y, projectile.velocity.x)
	projectile.global_rotation = Vector3(0,0,move_angle)
	
	return &""
