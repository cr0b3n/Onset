extends input_so
class_name mobile_input_so


const SWIPE_DISTANCE: float = 25.0
const TARGET_STOP_DISTANCE: float = 40.0

var _click_held: bool
var _init_click_pos: Vector2
var _click_held_pos: Vector2 = Vector2.ZERO


#Always reset since values of scriptable objects are stored
func _setup() -> void:
	_reset_click()
	_click_held = false


func _check_inputs(event: InputEvent, controller: input_controller) -> void:
	if event is InputEventMouseButton:
		_process_mouse_click(event, controller)
		
	if event is InputEventMouseMotion:
	   _process_mouse_motion(event, controller)


func _update(delta: float, controller: input_controller) -> void:
	_update_click_held(controller)
	_set_target_rearched(controller)


func _process_mouse_click(event: InputEventMouseButton, controller: input_controller) -> void:
	controller.set_target_position(event.position)
	controller.notify_direction_change(_check_mouse_base_directions(controller.target_x_pos, controller))
	_click_held = !_click_held

	if !_click_held: # Check if mouse has been unclick or release
		_reset_click()
		#if !target_canceled:
		controller.set_jump_release()
		return # No need to continue if was release
		
	_init_click_pos = event.position
	controller.set_target_x_pos()
	
	if event.doubleclick:
		controller.dash_pressed = true
		controller.notify_direction_change(_check_mouse_base_directions(controller.target_x_pos, controller))


func _process_mouse_motion(event: InputEventMouseMotion, controller: input_controller) -> void:
	controller.set_target_position(event.position)
	_click_held_pos = event.position #added for updated swipe
	
	
func _reset_click(reset_pos: Vector2 = Vector2.ZERO) -> void:
	_init_click_pos = reset_pos
	_click_held_pos = reset_pos


func _update_click_held(controller: input_controller) -> void:
	
	if !_click_held:
		return

	#var direction = fingerDownPosition.y - fingerUpPosition.y > 0 ? SwipeDirection.Up : SwipeDirection.Down;
	if abs(_init_click_pos.y - _click_held_pos.y) > SWIPE_DISTANCE: #Swipe up/down detected
		
		if _click_held_pos.y - _init_click_pos.y < 0: #swipe up
			controller.set_jump_pressed()
		else: #swipe down
			controller.set_jump_release()
		_init_click_pos = _click_held_pos
		
	controller.target_x_pos = controller.target.global_position.x
	controller.notify_direction_change(_check_mouse_base_directions(controller.target_x_pos, controller))


#mouse_x also identify as target_x_pos
func _check_mouse_base_directions(mouse_x: float, controller: input_controller) -> int:
	if controller.global_position.x > mouse_x:
		return -1 #_notify_direction_change(-1)
	elif controller.global_position.x < mouse_x:
		return 1 #_notify_direction_change(1)

	return controller.x_direction


func _set_target_rearched(controller: input_controller) -> void:
	controller.target_reached = _is_target_reached(controller)


func _is_target_reached(controller: input_controller) -> bool:
	return (controller.x_direction < 0 && controller.target_x_pos >= controller.global_position.x - TARGET_STOP_DISTANCE) || \
		(controller.x_direction > 0 && controller.target_x_pos <= controller.global_position.x + TARGET_STOP_DISTANCE)# || \
		#target_canceled) #&& !click_held
