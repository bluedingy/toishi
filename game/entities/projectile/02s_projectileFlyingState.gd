class_name ProjectileFlyingState
extends ProjectileState

func enter(prev: ProjectileState) -> void:
	super(prev)
	var shoot_vec = projectile.look_dir
	print(shoot_vec)
	set_velocity(shoot_vec * projectile.speed)
	#set_vel_x(projectile.speed)


func physics_update(delta: float) -> StringName:
	super(delta)

	#if not is_on_floor():
		#return &"AirState"
	#set_vel_x(projectile.speed)
	var move_dir = (PI/2)+atan2(projectile.velocity.y, projectile.velocity.x)
	projectile.global_rotation = Vector3(0,0,move_dir)
	return &""
