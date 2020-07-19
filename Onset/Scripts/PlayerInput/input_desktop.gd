class_name InputDesktop
extends CrobenInput


var target_canceled: bool
var _mobile_input


#Always reset since values of scriptable objects are stored
func _setup() -> void:
	#_mobile_input = load("res://Scripts/PlayerInput/MobileInputSO.tres")
	_mobile_input = InputMobile.new()
	_mobile_input._setup()
	target_canceled = true
	#_reset_dash()


func _check_inputs(event, controller) -> void:
	
	if event.is_action_pressed("c_jump"):
		controller.set_jump_pressed()
	elif event.is_action_released("c_jump"):
		controller.set_jump_release()
		
	if event.is_action_pressed("c_right"):
		target_canceled = true
		controller.check_dash_and_direction(1)
		
	if event.is_action_pressed("c_left"):
		target_canceled = true
		controller.check_dash_and_direction(-1)
	
	if controller.horizontal != 0:
		return

	if event is InputEventMouseButton:
		target_canceled = false
		_mobile_input._process_mouse_click(event, controller)

	if event is InputEventMouseMotion:
	   _mobile_input._process_mouse_motion(event, controller)


func _update(delta, controller) -> void:
	_process_x_inputs(controller)
	controller.update_dash_timer(delta)
	
	if !target_canceled: #Only update when mouse is used
		_mobile_input._update_click_held(controller)
	#Set target reach true if 1 of the requirement is met
	controller.target_reached = (_mobile_input._is_target_reached(controller) || target_canceled)


func _process_x_inputs(controller) -> void:
	controller.horizontal = (Input.get_action_strength("c_right") - Input.get_action_strength("c_left"))
	controller.horizontal = clamp(controller.horizontal, -1.0, 1.0)


#func _update_dash_timer(delta: float) -> void:
#
#	if _dash_press_count == 0: #No need to update timer if no new press
#		return
#
#	_dash_pressed_time += delta
#
#	if _dash_pressed_time > DOUBLE_PRESS_TIME:
#		_dash_pressed_time = 0
#		_dash_press_count = 0


##dir: int
#func _check_dash_and_direction(dir, controller) -> void:
#
#	if controller.x_direction != dir:
#		_dash_press_count = 1
#		controller.notify_direction_change(dir)
#	else:
#		_dash_press_count +=1
#
#		if _dash_press_count > 1:
#			controller.dash_pressed = true
#			_dash_press_count = 0
#
#	_dash_pressed_time = 0.0


#func _reset_dash() -> void:
#	_dash_pressed_time = 0.0
#	_dash_press_count = 0
