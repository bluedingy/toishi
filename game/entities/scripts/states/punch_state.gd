class_name AttackState
extends CharacterState
#========================= TODO LIST ===================
# - Add modular 5 punch combo
# - Add slight movement to the punches
# - Add animation

var _aerial: bool = false

func enter(prev: CharacterState) -> void:
	super(prev)
	_aerial = not is_on_floor()
	character.velocity.x=0.0
	print('Winding Up...')
	
	
	# Testing disc
	print("Making disc")
	var angle = input.get_move_angle()-(PI/2)
	print(angle)
	var range = 10
	var x_dist = range*cos(angle)
	var y_dist = -range*sin(angle)
	create_disc(Vector3(0,0,0), # (X,Y,Z)
				Vector3(x_dist,y_dist,0),
				Vector3(0,0,0) , range)
	#character.get_node("HitboxPunch").set_active(false)

func physics_update(delta: float) -> StringName:
	super(delta)

	if _aerial:
		apply_gravity(delta)

	var startup := stats.punch_startup
	var active  := stats.punch_active
	var recovery := stats.punch_recovery
	
	var arrow = preload('res://game/scenes/lobby/arrow.tscn')

	# Startup → active
	if frame == startup:
		var arrow_instance = arrow.instantiate() as RigidBody3D
		#arrow_instance.apply_strategy_patterns()
		character.get_parent().add_child(arrow_instance)
		arrow_instance.global_position = character.global_position
		var angle = input.get_move_angle()-(PI/2)
		print(angle)
		var range = 100
		var x_dist = range*cos(angle)
		var y_dist = -range*sin(angle)
		arrow_instance.linear_velocity = Vector3(x_dist,y_dist,0)
		arrow_instance.global_rotation = Vector3(0, 0, (PI/2)-angle)
		arrow_instance.global_position.x += character.facing*1
		
		
		

	# Active → recovery
	if frame == startup + active:
		print('Recovering...')

	# Recovery complete
	if frame >= startup + active + recovery:
		return &"LandState" if is_on_floor() else &"AirState"

	return &""
	
func create_disc(center: Vector3, p1: Vector3, p2: Vector3, radius: float):
	#var st = SurfaceTool.new()
	#st.begin(Mesh.PRIMITIVE_TRIANGLES)
	#
	## 1. Calculate Basis Vectors
	#var v1 = (p1 - center).normalized()
	#var v2 = (p2 - center).normalized()
	#var normal = v1.cross(v2).normalized()
	#var v_perp = normal.cross(v1).normalized() # Second axis in plane
	#
	## 2. Build the Fan
	#var resolution = 32
	#for i in range(resolution):
		#var angle_current = (float(i) / resolution) * TAU
		#var angle_next = (float(i + 1) / resolution) * TAU
		#
		## Vertex positions
		#var pos_current = center + (v1 * cos(angle_current) + v_perp * sin(angle_current)) * radius
		#var pos_next = center + (v1 * cos(angle_next) + v_perp * sin(angle_next)) * radius
		#
		## Add a triangle for this slice
		#st.add_vertex(center)
		#st.add_vertex(pos_current)
		#st.add_vertex(pos_next)
#
	## 3. Create Mesh Instance
	#var mesh = st.commit()
	#var mesh_instance = MeshInstance3D.new()
	#mesh_instance.mesh = mesh
	var mesh_instance1 = MeshInstance3D.new()
	mesh_instance1.mesh = BoxMesh.new()
	var mesh_instance2 = MeshInstance3D.new()
	mesh_instance2.mesh = BoxMesh.new()
	var mesh_instance3 = MeshInstance3D.new()
	mesh_instance3.mesh = BoxMesh.new()
	character.add_child(mesh_instance1)
	character.add_child(mesh_instance2)
	character.add_child(mesh_instance3)
	mesh_instance2.position = p1
	mesh_instance3.position = p2
	


#func exit() -> void:
	#character.get_node("HitboxPunch").set_active(false)
