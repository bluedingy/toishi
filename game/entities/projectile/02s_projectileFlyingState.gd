class_name ProjectileFlyingState
extends ProjectileState

func enter(prev: ProjectileState) -> void:
	super(prev)
	var shoot_vec = projectile.look_dir
	set_velocity(shoot_vec * projectile.speed)
	#set_vel_x(projectile.speed)


func physics_update(delta: float) -> StringName:
	super(delta)
	apply_gravity(delta)

	
	for i in range(projectile.get_slide_collision_count()):
		var collision = projectile.get_slide_collision(i)
		var collider = collision.get_collider()
		var collision_layer = collider.get_collision_layer()
		if collision_layer == 1: #Floor
			var hit_point = collision.get_position()
			var hit_normal = collision.get_normal()
			var velocity_vector = projectile.velocity.normalized()
			var max_embed_depth = 0.1
			var alignment = abs(hit_normal.dot(velocity_vector))
			print(alignment)
			var embed_depth = max_embed_depth * (alignment)
			projectile.global_position = hit_point + (velocity_vector * embed_depth)
			var collider_health_component = collider.get_node_or_null("HealthComponent")
			if collider_health_component != null:
				collider_health_component.damage(projectile.damage)
			return &"LandState"
	
	# Setting the movement direction
	var move_angle = (PI/2)+atan2(projectile.velocity.y, projectile.velocity.x)
	projectile.global_rotation = Vector3(0,0,move_angle)
	
	
	return &""
