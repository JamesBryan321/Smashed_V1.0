extends VehicleBody

#export var horse_power = 200
export var max_power = 100
export var takeoff_power = 800
var horse_power = max_power
export var accel_speed = 20

var steer_angle = deg2rad(30)
export var  steer_speed = 3

export var brake_power = 40
export var brake_speed = 40

export var frontwheel_friction = 10.5
export var backwheel_friction = 8.0

export var avel_to_smoke = 4
export var backwheel_steering = true

export (NodePath) var tire_smoke_L_nodepath
export (NodePath) var tire_smoke_R_nodepath

export (NodePath) var wheel_FL_nodepath
export (NodePath) var wheel_FR_nodepath
export (NodePath) var wheel_BL_nodepath
export (NodePath) var wheel_BR_nodepath

export (NodePath) var ground_check_nodepath

var tire_smoke_L = null
var tire_smoke_R = null
var ground_check = null

var wheel_FL = null
var wheel_FR = null
var wheel_BL = null
var wheel_BR = null

# BREAKABLE PART STUFF
onready var door_left = $LDoor
onready var door_right = $RDoor
onready var glass = $Glass
onready var door_hinge_left = $DoorHinge_Left
onready var door_hinge_right = $DoorHinge_Right
onready var door_parts = [door_left, door_right]
onready var door_hinges = [door_hinge_left, door_hinge_right]
var break_counter = 0


func _ready():
	tire_smoke_L = get_node(tire_smoke_L_nodepath)
	tire_smoke_R = get_node(tire_smoke_R_nodepath)
	ground_check = get_node(ground_check_nodepath)
	wheel_FL = get_node(wheel_FL_nodepath)
	wheel_FR = get_node(wheel_FR_nodepath)
	wheel_BL = get_node(wheel_BL_nodepath)
	wheel_BR = get_node(wheel_BR_nodepath)
	set_wheel_friction_slip()

func _physics_process(delta):
	if Input.is_action_just_pressed("ESC") and break_counter <= 2:
		if break_counter ==1:
			release_doors()
		elif break_counter == 2:
			break_car()
		break_counter +=1
	
	#throttle
	var throt_input = -Input.get_action_strength("X_P0")+Input.get_action_strength("CIRCLE_P0")
	#var throt_input = -Input.get_action_strength("W")+Input.get_action_strength("S")
	engine_force = lerp(engine_force, throt_input*horse_power, accel_speed*delta)
	power_control()
	
	#steering
	var steer_input = -Input.get_action_strength("LSTICK_RIGHT_P0")+Input.get_action_strength("LSTICK_LEFT_P0")
	#var steer_input = -Input.get_action_strength("D")+Input.get_action_strength("A")
	steering = lerp_angle(steering, steer_input*steer_angle,steer_speed*delta)
	if backwheel_steering:
		wheel_BL.steering = lerp_angle(wheel_BL.steering, -steer_input*steer_angle,steer_speed*delta)
		wheel_BR.steering = lerp_angle(wheel_BR.steering, -steer_input*steer_angle,steer_speed*delta)
	
	#brake
	var brake_input = Input.get_action_strength("SQUARE_P0")
	#var brake_input = Input.get_action_strength("SPACE")
	brake = lerp(brake,brake_input*brake_power,brake_speed*delta)
	if brake_input == 0:
		brake = 0

	tire_smoke_control(brake_input,throt_input)

func tire_smoke_control(brake_input,throt_input):
	if angular_velocity.length() >= avel_to_smoke and ground_check.is_colliding():
		tire_smoke_L.emitting = true
		tire_smoke_R.emitting = true
	else:
		tire_smoke_L.emitting = false
		tire_smoke_R.emitting = false

func set_wheel_friction_slip():
	wheel_BL.wheel_friction_slip = backwheel_friction
	wheel_BR.wheel_friction_slip = backwheel_friction
	wheel_FL.wheel_friction_slip = frontwheel_friction
	wheel_FR.wheel_friction_slip = frontwheel_friction

func power_control():
	if linear_velocity.length() > 20:
		horse_power = max_power
	elif brake == 0 :
		horse_power = takeoff_power


# DEBUG DESTRUCTION FUNCTION
func break_car():
	for h in door_hinges:
		h.queue_free()
	for d in door_parts:
		d.mass = 1
		d.gravity_scale = 1
	glass.set_as_toplevel(true)
	glass.mass = 1
	glass.gravity_scale = 1

# DEBUG DESTRUCTION FUNCTION
func release_doors():
	for d in door_parts:
		d.set_as_toplevel(true)
#		d.mass = 1
#		d.gravity_scale = 1
