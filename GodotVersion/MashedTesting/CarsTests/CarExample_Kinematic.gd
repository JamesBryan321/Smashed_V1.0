extends "res://CarsTests/car_base.gd"

func get_input():
	var turn = Input.get_action_strength("A")
	turn -= Input.get_action_strength("D")
	steer_angle = turn * deg2rad(steering_limit)
	#$RootNode/SM_Veh_Classic_01/SM_Veh_Classic_01_Wheel_fr.rotation.y = steer_angle*2
	#$RootNode/SM_Veh_Classic_01/SM_Veh_Classic_01_Wheel_fl.rotation.y = steer_angle*2
	acceleration = Vector3.ZERO
	if Input.is_action_pressed("W"):
		acceleration = -transform.basis.z * engine_power
	if Input.is_action_pressed("S"):
		acceleration = -transform.basis.z * braking
