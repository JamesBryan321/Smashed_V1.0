extends Spatial


# Node References
onready var ball = $Ball
onready var car_mesh = $TestCar
onready var ground_ray = $TestCar/RayCast
# mesh references
onready var right_wheel = $TestCar/RootNode/SM_Veh_Classic_01_Wheel_fr
onready var left_wheel = $TestCar/RootNode/SM_Veh_Classic_01_Wheel_fl
onready var body_mesh = $TestCar/RootNode/SM_Veh_Classic_01

# Where to place the car mesh relative to the sphere
var sphere_offset = Vector3(0, -1.5, 0)
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
	ground_ray.add_exception(ball)


func _physics_process(_delta):
	# Keep the car mesh aligned with the sphere
	car_mesh.transform.origin = ball.transform.origin + sphere_offset
	# Accelerate based on car's forward direction
	ball.add_central_force(-car_mesh.global_transform.basis.z * speed_input)
	#ball.

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
	
	# rotate wheels for effect
	right_wheel.rotation.y = rotate_input
	left_wheel.rotation.y = rotate_input
		
	# rotate car mesh
	if ball.linear_velocity.length() > turn_stop_limit:
		var new_basis = car_mesh.global_transform.basis.rotated(car_mesh.global_transform.basis.y,rotate_input)
		car_mesh.global_transform.basis = car_mesh.global_transform.basis.slerp(new_basis, turn_speed * delta)
		car_mesh.global_transform = car_mesh.global_transform.orthonormalized()
		
		# tilt body for effect
#		var t = -rotate_input * ball.linear_velocity.length() / body_tilt
#		body_mesh.rotation.z = lerp(body_mesh.rotation.z,t,10 * delta)
	
	# align with ground
	var n = ground_ray.get_collision_normal()
	var xform = align_with_y(car_mesh.global_transform, n.normalized())
	car_mesh.global_transform = car_mesh.global_transform.interpolate_with(xform, 10 * delta)

func align_with_y(xform, new_y):
	xform.basis.y = new_y
	xform.basis.x = -xform.basis.z.cross(new_y)
	xform.basis = xform.basis.orthonormalized()
	return xform
