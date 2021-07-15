extends PathFollow

export var speed = 20.0
export var speed_scalar = 2

var cars = null

onready var path = get_parent()
onready var follow_target = get_parent().get_node("Position3D")

var target_offset = 0.0
var lerp_offset = 0.0
var path_length = 0.0

func _ready():
	cars = get_tree().get_nodes_in_group("car")
	path_length = path.curve.get_baked_length()


func _physics_process(delta):
	#get midpoint of cars & follow
	var mp = calc_midpoint(cars)
	follow_target.global_transform.origin = mp
	# look at cars midpoint
	#get_node("DebugMesh").look_at(mp, Vector3.UP)
	#get_node("DebugMesh").set_rotation(Vector3(0, get_node("DebugMesh").get_rotation().y, 0))
	# control movement
	move_along_path(delta)


func move_along_path(delta):
	target_offset = path.curve.get_closest_offset(follow_target.get_translation())
	var diff = abs(target_offset-get_offset())
	var n_sign = +1
	
	# if crossed path start point
	if diff > path_length/2:
		if rollover_check():
			# crossed forward
			diff = path_length-get_offset() + target_offset
			n_sign = +1
		else:
			# crossed backward
			diff = get_offset() + path_length - target_offset
			n_sign = -1
	elif get_offset() < target_offset:
		n_sign = +1
	else:
		n_sign = -1
	
	set_offset(get_offset() + (diff*speed_scalar * delta) * n_sign)
	

func rollover_check():
	if target_offset < path_length/2:
		# crossed forward
		return true
	else:
		# crossed backward
		return false


func calc_midpoint(car_list):
	var m = Vector3.ZERO
	for c in car_list:
		m += c.global_transform.origin
	m = m/len(car_list)
	return m



#==============================================================================



#================================================
# OLDER FOLLOW ATTEMPT 1 (LERP)
#================================================
#func _physics_process(delta):
#	var mp = calc_midpoint(cars)
#	follow_target.global_transform.origin = mp
#	#get_node("DebugMesh").look_at(mp, Vector3.UP)
#
#	target_offset = path.curve.get_closest_offset(follow_target.get_translation())
#	var diff = abs(target_offset-lerp_offset)
#	#print(diff)
#	if diff>path_length/2:
#		lerp_rollover_check(delta)
#	else:
#		lerp_offset = lerp(lerp_offset, target_offset, (speed)*delta)
#		#lerp_offset = clamp(lerp_offset,get_offset()-(speed*delta),get_offset()+(speed*delta))
#
#	set_offset(lerp_offset)

#func lerp_rollover_check(delta):
#	if target_offset < path_length/2:
#		print("crossed forward")
#		set_offset(get_offset() + (speed * delta))
#		lerp_offset = get_offset()
#	else:
#		print("crossed backward")
#		set_offset(get_offset() - (speed * delta))
#		lerp_offset = get_offset()

#================================================
# OLDER FOLLOW ATTEMPT 2 (TWEEN)
#================================================

#func _physics_process(delta):
#	var mp = calc_midpoint(cars)
#	follow_target.global_transform.origin = mp
#	get_node("DebugMesh").look_at(mp, Vector3.UP)
#
#	target_offset = path.curve.get_closest_offset(follow_target.get_translation())
#	var diff = abs(offset-path.curve.get_closest_offset(follow_target.get_translation()))
#	print(diff)
#	if diff>0:
#		#tween_node.interpolate_method(self,"set_offset", get_offset(),target_offset,diff/speed,Tween.TRANS_BACK,Tween.EASE_OUT)
#		tween_node.interpolate_property(self, "offset", get_offset(), target_offset, diff/5, Tween.TRANS_BACK,Tween.EASE_OUT)
#		tween_node.start()
##	
##	if diff>0:
##		tween_node.interpolate_property(self, "offset", offset, target_offset, diff/speed, Tween.TRANS_BACK,Tween.EASE_OUT)
##		tween_node.start()

#================================================
# OLDER FOLLOW ATTEMPT 3
#================================================

#func _process(delta):
#	set_offset(get_offset() + speed * delta)
