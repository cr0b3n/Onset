extends input_so
class_name mobile_input_so

# signals               i.e signal my_signal(value, other_value) / signal my_signal
# enums                 i.e enum MoveDirection {UP, DOWN, LEFT, RIGHT}
# constants             i.e const MOVE_SPEED: float = 50.0
const SWIPE_DISTANCE: float = 25.0
# exported variables    i.e export(PackedScene) var scene_file / export var scene_file: PackedScene
# public variables      i.e var a: int = 2
var _click_held: bool = false
#Swipe 
var _init_click_pos: Vector2 = Vector2.ZERO
var _click_held_pos: Vector2 = Vector2.ZERO
# private variables     i.e var _b: String = "text"
# onready variables     i.e onready var player_anim: AnimationPlayer = $AnimationPlayer

# optional built-in virtual _init method
# built-in virtual _ready method
# remaining built-in virtual methods
# public methods
# private methods


func _setup() -> void:
	pass


func _check_inputs(event: InputEvent, controller: input_controller) -> void:
	if event is InputEventMouseButton:
		_process_mouse_click(event, controller)
		
	if event is InputEventMouseMotion:
	   _process_mouse_motion(event, controller)


func _update(delta: float, controller: input_controller) -> void:
	_update_click_held(controller)


func _process_mouse_click(event: InputEventMouseButton, controller: input_controller) -> void:
	controller.set_target_position(event.position)
	_click_held = !_click_held

	if !_click_held: # Check if mouse has been unclick or release
		_reset_click()
		#if !target_canceled:
		controller.set_jump_release()
		return # No need to continue if was release
		
	_init_click_pos = event.position #target.position
	#if controller.horizontal == 0:
	controller.set_target_x_pos()
	
	if event.doubleclick:
		controller.dash_pressed = true
		_check_mouse_base_directions(controller.target_x_pos, controller)
#	controller.check_dash_and_direction(_check_mouse_base_directions(controller.target_x_pos, controller))
			#target_canceled = dash_pressed #target_cancel depends on the dash check
	#else: #If keyboard & mouse is use at the same time prioritize keyboard values
#			check_dash_and_direction(x_direction, false)
#			target_canceled = true


func _process_mouse_motion(event: InputEventMouseMotion, controller: input_controller) -> void:
	controller.set_target_position(event.position)
	_click_held_pos = event.position #added for updated swipe
	
	
func _reset_click(reset_pos: Vector2 = Vector2.ZERO) -> void:
	_init_click_pos = reset_pos
	_click_held_pos = reset_pos


func _update_click_held(controller: input_controller) -> void:
	
	if !_click_held: #|| target_canceled:
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


func _check_mouse_base_directions(mouse_x: float, controller: input_controller) -> int:
	if controller.global_position.x > mouse_x:
		return -1 #_notify_direction_change(-1)
	elif controller.global_position.x < mouse_x:
		return 1 #_notify_direction_change(1)

	return controller.x_direction
