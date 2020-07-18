extends input_so
class_name desktop_input_so


const DOUBLE_PRESS_TIME: float = 0.2

var target_canceled: bool
var _dash_pressed_time: float
var _dash_press_count: int
var _mobile_input: mobile_input_so


#Always reset since values of scriptable objects are stored
func _setup() -> void:
	_mobile_input = load("res://Scripts/PlayerInput/MobileInputSO.tres")
	target_canceled = true
	_reset_dash()


func _check_inputs(event: InputEvent, controller: input_controller) -> void:
	
	if event.is_action_pressed("c_jump"):
		controller.set_jump_pressed()
	elif event.is_action_released("c_jump"):
		controller.set_jump_release()
		
	if event.is_action_pressed("c_right"):
		target_canceled = true
		_check_dash_and_direction(1, controller)
		
	if event.is_action_pressed("c_left"):
		target_canceled = true
		_check_dash_and_direction(-1, controller)
	
	if controller.horizontal != 0:
		return

	if event is InputEventMouseButton:
		target_canceled = false
		_mobile_input._process_mouse_click(event, controller)
		
	if event is InputEventMouseMotion:
	   _mobile_input._process_mouse_motion(event, controller)


func _update(delta: float, controller: input_controller) -> void:
	_process_x_inputs(controller)
	_update_dash_timer(delta)
	
	if !target_canceled: #Only update when mouse is used
		_mobile_input._update_click_held(controller)
	#Set target reach true if 1 of the requirement is met
	controller.target_reached = (_mobile_input._is_target_reached(controller) || target_canceled)


func _process_x_inputs(controller: input_controller) -> void:
	controller.horizontal = (Input.get_action_strength("c_right") - Input.get_action_strength("c_left"))
	controller.horizontal = clamp(controller.horizontal, -1.0, 1.0)


func _update_dash_timer(delta: float) -> void:
	
	if _dash_press_count == 0: #No need to update timer if no new press
		return

	_dash_pressed_time += delta

	if _dash_pressed_time > DOUBLE_PRESS_TIME:
		_dash_pressed_time = 0
		_dash_press_count = 0


func _check_dash_and_direction(dir: int, controller: input_controller) -> void:
	
	if controller.x_direction != dir:
		_dash_press_count = 1
		controller.notify_direction_change(dir)
	else:
		_dash_press_count +=1
		
		if _dash_press_count > 1:
			controller.dash_pressed = true
			_dash_press_count = 0
			
	_dash_pressed_time = 0.0


func _reset_dash() -> void:
	_dash_pressed_time = 0.0
	_dash_press_count = 0
