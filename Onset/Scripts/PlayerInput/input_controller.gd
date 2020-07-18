extends Node2D
class_name input_controller


signal x_direction_changed(dir)
# enums                 i.e enum MoveDirection {UP, DOWN, LEFT, RIGHT}
# constants             i.e const MOVE_SPEED: float = 50.0
const DOUBLE_PRESS_TIME: float = 0.2
const TARGET_STOP_DISTANCE: float = 50.0
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
var target_reached = true
# private variables     i.e var _b: String = "text"

#Dash timer
var _dash_pressed_time: float = 0.0
var _dash_press_count: int = 0
#Boolean flag for clearing inputs
var _ready_to_clear: bool = true

var _current_input

# onready variables     i.e onready var player_anim: AnimationPlayer = $AnimationPlayer
onready var target_x_pos: float = global_position.x
onready var target: Node2D

#onready var input = 
# optional built-in virtual _init method
# built-in virtual _ready method
# remaining built-in virtual methods
# public methods
# private methods


func _ready() -> void:
	#Create a Node2D that will act as a cursor for both desktop & and mobile
	target = Node2D.new()
	add_child(target)
	target.position = Vector2.ZERO
	
	if Global.has_touch: #Assign appropriate controls
		_current_input = load("res://Scripts/PlayerInput/MobileInput-SO.tres")		
	else:
		_current_input = load("res://Scripts/PlayerInput/DesktopInput-SO.tres")

	_current_input._setup()


func _input(event: InputEvent) -> void:
	_current_input._check_inputs(event, self)
	

func _process(delta: float) -> void:
	_clear_inputs()
	_current_input._update(delta, self)


func _physics_process(delta: float) -> void:
	_ready_to_clear = true
	target_reached = _is_target_reached()


func _is_target_reached() -> bool:
	return ((x_direction < 0 && target_x_pos >= global_position.x - TARGET_STOP_DISTANCE) || \
		(x_direction > 0 && target_x_pos <= global_position.x + TARGET_STOP_DISTANCE))# || \
		#target_canceled) #&& !click_held


func set_target_position(event_pos: Vector2) -> void:
	target.global_position = _event_pos_to_world(event_pos)


func set_jump_pressed() -> void:
	jump_pressed = true
	input_jump_release = false


func set_jump_release() -> void:
	jump_released = true
	input_jump_release = true


func set_target_x_pos() -> void:
	target_x_pos = target.global_position.x


func _event_pos_to_world(event_pos: Vector2) -> Vector2:
	return get_canvas_transform().affine_inverse().xform(event_pos)





#func _process_x_inputs() -> void:
#	horizontal = (Input.get_action_strength("c_right") - Input.get_action_strength("c_left"))
#	horizontal = clamp(horizontal, -1.0, 1.0)


func _clear_inputs() -> void:
	
	if !_ready_to_clear:
		return

	jump_pressed = false
	jump_released = false
	horizontal = 0.0
	dash_pressed = false #Must reset dash_pressed here & not on the _update_dash_timer


func check_dash_and_direction(dir: int, notify: bool = true) -> void:
	
	if x_direction != dir:
		_dash_press_count = 1
		if notify:
			notify_direction_change(dir)
	else:
		_dash_press_count +=1
		
		if _dash_press_count > 1:
			dash_pressed = true
			_dash_press_count = 0
			
	_dash_pressed_time = 0.0


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


func notify_direction_change(new_dir: int) -> void:
	
	if new_dir == x_direction:
		return

	x_direction = new_dir
	emit_signal("x_direction_changed", x_direction)
