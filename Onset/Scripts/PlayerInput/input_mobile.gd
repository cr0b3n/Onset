extends input
class_name input_mobile


const SWIPE_DISTANCE: float = 25.0#10000.0
const TARGET_STOP_DISTANCE: float = 40.0

var _click_held: bool
var _init_click_pos: Vector2
var _click_held_pos: Vector2
#var _swipe_distance: Vector2 


#Always reset since values of scriptable objects are stored
func _setup() -> void:
	_reset_click()
	_click_held = false
	#_swipe_distance = Vector2.ZERO


func _check_inputs(event, controller) -> void:
	if event is InputEventMouseButton:
		_process_mouse_click(event, controller)	
	elif event is InputEventMouseMotion:
	   _process_mouse_motion(event, controller)


func _update(delta, controller) -> void:
	_update_click_held(controller)
	_set_target_rearched(controller)
	controller.update_dash_timer(delta)


func _process_mouse_click(event, controller) -> void:
	controller.set_target_position(event.position)
	_click_held = !_click_held

	if !_click_held: # Check if mouse has been unclick or release
		_reset_click()
		controller.set_jump_release()
		return # No need to continue if was release

	_reset_click(event.position)
	controller.set_target_x_pos()
	controller.check_dash_and_direction(_check_mouse_base_directions(controller))
	#_prev_dash_dir = cur_dash_dir	
#	if event.doubleclick:
#		controller.dash_pressed = true
#		controller.notify_direction_change(_check_mouse_base_directions(controller.target_x_pos, controller))


func _process_mouse_motion(event, controller) -> void:
	controller.set_target_position(event.position)
	_click_held_pos = event.position #controller.target.position #added for updated swipe
	
	
func _reset_click(reset_pos: Vector2 = Vector2.ZERO) -> void:
	_init_click_pos = reset_pos
	_click_held_pos = reset_pos


func _update_click_held(controller) -> void:
	
	if !_click_held:
		return

#	_swipe_distance = _click_held_pos - _init_click_pos
#	if _swipe_distance.length_squared() > SWIPE_DISTANCE: #10000.0
#		#print(_swipe_distance)
#		if _swipe_distance.y < -25: #25 is the angle's y
#			controller.set_jump_pressed()
#			#print("swipe up")
#		elif _swipe_distance.y > 25:
#			controller.set_jump_release()
#			#print("swipe down")
#		_init_click_pos = _click_held_pos
#
#	controller.target_x_pos = controller.target.global_position.x
#	controller.notify_direction_change(_check_mouse_base_directions(controller))

	#var direction = fingerDownPosition.y - fingerUpPosition.y > 0 ? SwipeDirection.Up : SwipeDirection.Down;
	if abs(_init_click_pos.y - _click_held_pos.y) > SWIPE_DISTANCE: #Swipe up/down detected

		if _click_held_pos.y - _init_click_pos.y < 0: #swipe up
			controller.set_jump_pressed()
		else: #swipe down
			controller.set_jump_release()
		_init_click_pos = _click_held_pos #Reset Initial Click Pos to Held Pos

	controller.target_x_pos = controller.target.global_position.x
	controller.notify_direction_change(_check_mouse_base_directions(controller))


func _check_mouse_base_directions(controller) -> int:
	if controller.global_position.x > controller.target_x_pos:
		return -1 #_notify_direction_change(-1)
	elif controller.global_position.x < controller.target_x_pos:
		return 1 #_notify_direction_change(1)

	return controller.x_direction


func _set_target_rearched(controller) -> void:
	controller.target_reached = _is_target_reached(controller)


func _is_target_reached(controller) -> bool:
	return (controller.x_direction < 0 && controller.target_x_pos >= controller.global_position.x - TARGET_STOP_DISTANCE) || \
		(controller.x_direction > 0 && controller.target_x_pos <= controller.global_position.x + TARGET_STOP_DISTANCE)# || \
		#target_canceled) #&& !click_held
