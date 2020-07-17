extends Node2D
class_name player_input

# signals               i.e signal my_signal(value, other_value) / signal my_signal
signal x_direction_changed(dir)
# enums                 i.e enum MoveDirection {UP, DOWN, LEFT, RIGHT}
# constants             i.e const MOVE_SPEED: float = 50.0
const DOUBLE_PRESS_TIME: float = 0.2
# exported variables    i.e export(PackedScene) var scene_file / export var scene_file: PackedScene
# public variables      i.e var a: int = 2
#KEYBOARD MOVEMENTS VARIABLES
var jump_pressed: bool
var jump_released: bool
var input_jump_release: bool = true
var dash_pressed: bool
var horizontal: float
var x_direction: int = 1
var target_canceled: bool = true
var click_held: bool = false
# private variables     i.e var _b: String = "text"
#Swipe 
var _init_click_pos: Vector2 = Vector2.ZERO
var _click_held_pos: Vector2 = Vector2.ZERO
#Dash timer
var _dash_pressed_time: float = 0.0
var _dash_press_count: int = 0
#Boolean flag for clearing inputs
var _ready_to_clear: bool = true
# onready variables     i.e onready var player_anim: AnimationPlayer = $AnimationPlayer
onready var target_x_pos: float = global_position.x
onready var target: Node2D = $TargetPosition
# optional built-in virtual _init method
# built-in virtual _ready method
# remaining built-in virtual methods
# public methods
# private methods


func _input(event: InputEvent) -> void:

	if event.is_action_pressed("c_jump"):
		_set_jump_pressed()
	elif event.is_action_released("c_jump"):
		_set_jump_release()
	
	if event.is_action_pressed("c_right"):
		target_canceled = true
		_check_dash_and_direction(1)
		
	if event.is_action_pressed("c_left"):
		target_canceled = true
		_check_dash_and_direction(-1)

	if event is InputEventMouseButton:
		_process_mouse_click(event)
#
	if event is InputEventMouseMotion:
	   _process_mouse_motion(event)
	
#	if event is InputEventScreenDrag:
#		if event.relative.y > 25:
#			print("swipe down")
#		if event.relative.y < -25:
#			print("swipe up")
#		print(event.relative.y)


func _process(delta: float) -> void:
	_clear_inputs()
	_process_x_inputs()
	_update_dash_timer(delta)
	_update_click_held()
	

func _physics_process(delta: float) -> void:
	_ready_to_clear = true


func is_target_reached(offset: float) -> bool:
	return ((x_direction < 0 && target_x_pos >= global_position.x - offset) || \
		(x_direction > 0 && target_x_pos <= global_position.x + offset) || \
		target_canceled) #&& !click_held


func _process_mouse_click(event: InputEventMouseButton) -> void:
	_set_target_position(event.position)
	click_held = !click_held

	if !click_held: # Check if mouse has been unclick or release
		_reset_click()
		if !target_canceled:
			_set_jump_release()
		return # No need to continue if was release
		
	_init_click_pos = event.position #target.position
	if horizontal == 0:
			_set_target_x_pos()
			_check_dash_and_direction(_check_mouse_base_directions(target_x_pos), true)
			target_canceled = dash_pressed #target_cancel depends on the dash check
	else: #If keyboard & mouse is use at the same time prioritize keyboard values
			_check_dash_and_direction(x_direction, false)
			target_canceled = true


func _process_mouse_motion(event: InputEventMouseMotion) -> void:
	_set_target_position(event.position)
	_click_held_pos = event.position #added for updated swipe


func _set_target_position(event_pos: Vector2) -> void:
	target.global_position = _event_pos_to_world(event_pos)


func _set_jump_pressed() -> void:
	jump_pressed = true
	input_jump_release = false


func _set_jump_release() -> void:
	jump_released = true
	input_jump_release = true


func _reset_click(reset_pos: Vector2 = Vector2.ZERO) -> void:
	_init_click_pos = reset_pos
	_click_held_pos = reset_pos


func _update_click_held() -> void:
	
	if !click_held || target_canceled:
		return

	#var direction = fingerDownPosition.y - fingerUpPosition.y > 0 ? SwipeDirection.Up : SwipeDirection.Down;
	if abs(_init_click_pos.y - _click_held_pos.y) > 25.0: #Swipe up/down detected
		
		if _click_held_pos.y - _init_click_pos.y < 0: #swipe up
			_set_jump_pressed()
		else: #swipe down
			_set_jump_release()
		_init_click_pos = _click_held_pos
	#_click_held_pos = target.position - _init_click_pos 
		
#	if _click_held_pos.length_squared()  > 2000:
#		var y = _click_held_pos.y
#
#		if y < -25:
#			_set_jump_pressed()
#		#else:
#			#swipe_down
#		_reset_click(target.position)
		
	target_x_pos = target.global_position.x
	_notify_direction_change(_check_mouse_base_directions(target_x_pos))


func _set_target_x_pos() -> void:
	target_x_pos = target.global_position.x


func _event_pos_to_world(event_pos: Vector2) -> Vector2:
	return get_canvas_transform().affine_inverse().xform(event_pos)


func _check_mouse_base_directions(mouse_x: float) -> int:
	if global_position.x > mouse_x:
		return -1 #_notify_direction_change(-1)
	elif global_position.x < mouse_x:
		return 1 #_notify_direction_change(1)

	return x_direction


func _process_x_inputs() -> void:
	horizontal = (Input.get_action_strength("c_right") - Input.get_action_strength("c_left"))
	horizontal = clamp(horizontal, -1.0, 1.0)


func _clear_inputs() -> void:
	
	if !_ready_to_clear:
		return

	jump_pressed = false
	jump_released = false
	horizontal = 0.0
	dash_pressed = false #Must reset dash_pressed here & not on the _update_dash_timer


func _check_dash_and_direction(dir: int, notify: bool = true) -> void:
	
	if x_direction != dir:
		_dash_press_count = 1
		if notify:
			_notify_direction_change(dir)
	else:
		_dash_press_count +=1
		
		if _dash_press_count > 1:
			dash_pressed = true
			_dash_press_count = 0
			
	_dash_pressed_time = 0.0


func _update_dash_timer(delta: float) -> void:
	
	if _dash_press_count == 0: #No need to update timer if no new press
		return

	_dash_pressed_time += delta

	if _dash_pressed_time > DOUBLE_PRESS_TIME:
		_dash_pressed_time = 0
		_dash_press_count = 0


func _notify_direction_change(new_dir: int) -> void:
	
	if new_dir == x_direction:
		return

	x_direction = new_dir
	emit_signal("x_direction_changed", x_direction)
