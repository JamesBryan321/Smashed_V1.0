extends RigidBody

onready var ground_ray = $RayCast
onready var car_mesh = $SM_Veh_Classic_01

# Engine power
export var acceleration = 30
# Turn Amount, inn degrees
export var steering = 21.0
# How quickly the car turns
var turn_speed = 5
# Below this speed, the car doesn't turn
var turn_stop_limit = 0.75
# Amount to tilt the body on turns
var body_tilt = 35

# Variables for input values
var speed_input = 0
var rotate_input = 0

func _ready():
	ground_ray.add_exception(self)

func _physics_process(_delta):
	# Accelerate based on car's forward direction
	add_central_force(-global_transform.basis.z * speed_input)

func _process(delta):
	# Can't steer/accelerate when in the air
	if not ground_ray.is_colliding():
		return
	# Get accelerate/brake input
	speed_input = 0
	speed_input += Input.get_action_strength("W")
	speed_input -= Input.get_action_strength("S")
	speed_input *= acceleration
	# Get steering input
	rotate_input = 0
	rotate_input += Input.get_action_strength("A")
	rotate_input -= Input.get_action_strength("D")
	rotate_input *= deg2rad(steering)
	
	add_torque(Vector3(0,1,0)*rotate_input*30)
	if rotate_input == 0:
		angular_velocity = Vector3.ZERO
	# rotate wheels for effect
	#right_wheel.rotation.y = rotate_input
	#left_wheel.rotation.y = rotate_input
	
	# rotate car mesh
#	if linear_velocity.length() > turn_stop_limit:
#		var new_basis = car_mesh.global_transform.basis.rotated(car_mesh.global_transform.basis.z,rotate_input)
#		car_mesh.global_transform.basis = car_mesh.global_transform.basis.slerp(new_basis, turn_speed * delta)
#		car_mesh.global_transform = car_mesh.global_transform.orthonormalized()

		# tilt body for effect
		#var t = -rotate_input * linear_velocity.length() / body_tilt
		#body_mesh.rotation.z = lerp(body_mesh.rotation.z,t,10 * delta)
#
#	# align with ground
#	var n = ground_ray.get_collision_normal()
#	var xform = align_with_y(car_mesh.global_transform, n.normalized())
#	car_mesh.global_transform = car_mesh.global_transform.interpolate_with(xform, 10 * delta)

func align_with_y(xform, new_y):
	xform.basis.y = new_y
	xform.basis.x = -xform.basis.z.cross(new_y)
	xform.basis = xform.basis.orthonormalized()
	return xform
























#
#export var speed = 10
#var movement = Vector3()
#var angle_movement = Vector3()
#
## Called when the node enters the scene tree for the first time.
#func _ready():
#	pass # Replace with function body.
#
#
## Called every frame. 'delta' is the elapsed time since the previous frame.
##func _process(delta):
##	pass
#
#func _integrate_forces(state):
#	movement = Vector3(0,0,0)
#
#	if Input.is_action_pressed("W"):
#		movement.z = -1
#	if Input.is_action_pressed("S"):
#		movement.z = +1
#
#	if Input.is_action_pressed("A"):
#		angle_movement.y = +1
#	elif Input.is_action_pressed("D"):
#		angle_movement.y = -1
#	else:
#		angle_movement.y = 0
#
#	add_force(movement*speed, Vector3(0,0,0))
#	add_torque(angle_movement*30)
