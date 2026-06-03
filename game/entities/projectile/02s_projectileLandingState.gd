class_name ProjectileLandingState
extends ProjectileState

var pickup_area: Area3D

func enter(prev: ProjectileState) -> void:
	super(prev)
	set_velocity(Vector3.ZERO)
	pickup_area = Area3D.new()
	var pickup_shape = SphereShape3D.new()
	pickup_shape.radius = 5.0
	var pickup_collider = CollisionShape3D.new()
	pickup_collider.shape = pickup_shape
	pickup_area.add_child(pickup_collider)
	pickup_area.body_entered.connect(_on_pickup_body_entered)
	projectile.add_child(pickup_area)


func physics_update(delta: float) -> StringName:
	super(delta)
	if projectile.destination_player_reference:
		return &"PickUpState"
	return &""

func exit() -> void:
	projectile.remove_child(pickup_area)

func _on_pickup_body_entered(body: Node3D) -> StringName:
	if body.is_in_group("Entities") and projectile.destination_player_reference == null:
		print('Its an Entity!')
		projectile.destination_player_reference = body
		return &"PickUpState"
	return &""
