extends VehicleBody

export var horse_power = 200
export var accel_speed = 20

var steer_angle = deg2rad(30)
export var  steer_speed = 3

export var brake_power = 40
export var brake_speed = 40

export var frontwheel_friction = 10.5
export var backwheel_friction = 8.0

export var avel_to_smoke = 4

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
	#throttle
	var throt_input = -Input.get_action_strength("W")+Input.get_action_strength("S")
	engine_force = lerp(engine_force, throt_input*horse_power, accel_speed*delta)
	#steering
	var steer_input = -Input.get_action_strength("D")+Input.get_action_strength("A")
	steering = lerp_angle(steering, steer_input*steer_angle,steer_speed*delta)
	
	#brake
	var brake_input = Input.get_action_strength("SPACE")
	brake = lerp(brake,brake_input*brake_power,brake_speed*delta)
	if brake_input == 0:
		brake = 0

	tire_smoke_control()

func tire_smoke_control():
	#if linear_velocity.length() >= 35 and angular_velocity.length() >= 4:
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
