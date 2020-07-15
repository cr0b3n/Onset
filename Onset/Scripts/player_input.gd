extends Node2D
class_name player_input

# signals               i.e signal my_signal(value, other_value) / signal my_signal
signal x_direction_changed(dir)
# enums                 i.e enum MoveDirection {UP, DOWN, LEFT, RIGHT}
# constants             i.e const MOVE_SPEED: float = 50.0
const DOUBLE_PRESS_TIME: float = 0.2
# exported variables    i.e export(PackedScene) var scene_file / export var scene_file: PackedScene
# public variables      i.e var a: int = 2
var jump_pressed: bool
var jump_released: bool
var input_jump_release: bool = true
var horizontal: float
var dash_pressed: bool
var x_direction: int = 1
# private variables     i.e var _b: String = "text"
var _last_pressed_time: float = 0.0
var _dash_press_count: int = 0


var _ready_to_clear: bool = true
# onready variables     i.e onready var player_anim: AnimationPlayer = $AnimationPlayer

# optional built-in virtual _init method
# built-in virtual _ready method
# remaining built-in virtual methods
# public methods
# private methods

func _input(event: InputEvent) -> void:

	if event.is_action_pressed("c_jump"):
		jump_pressed = true
		input_jump_release = false
	
	if event.is_action_released("c_jump"):
		jump_released = true
		input_jump_release = true
	
	if event.is_action_pressed("c_right"):
		_check_dash_and_direction(1)
		
	if event.is_action_pressed("c_left"):
		_check_dash_and_direction(-1)
	
	if event is InputEventMouseButton: #Check cause not all event is mousebutton so error could occur
		if event.doubleclick: #BOTH: pressed & double click must calculate direction
			dash_pressed = true
			_dash_press_count = 0
			_last_pressed_time = 0.0
			_check_mouse_base_directions()
#			print("Mouse Motion at: ", event.position)
#			print("Mouse Motion at: ", event.global_position)
		elif event.pressed: #BOTH: pressed & double click must calculate direction
#			print("Mouse Global at: ",get_global_mouse_position())
#			print("Global Position at: ",global_position)
			_check_mouse_base_directions()
			

func _process(delta: float) -> void:
	_clear_inputs()
	_process_x_inputs()
	_update_dash_timer(delta)
	

func _physics_process(delta: float) -> void:
	_ready_to_clear = true


func _check_mouse_base_directions() -> void:
	if global_position.x > get_global_mouse_position().x:
		_notify_direction_change(-1)
	elif global_position.x < get_global_mouse_position().x:
		_notify_direction_change(1)


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


func _check_dash_and_direction(dir: int) -> void:
	
	if x_direction != dir:
		_dash_press_count = 1
		_notify_direction_change(dir)
	else:
		_dash_press_count +=1
		
		if _dash_press_count > 1:
			dash_pressed = true
			_dash_press_count = 0
	
	_last_pressed_time = 0.0


func _update_dash_timer(delta: float) -> void:
	
	_last_pressed_time += delta

	if _last_pressed_time > DOUBLE_PRESS_TIME:
		_last_pressed_time = 0
		_dash_press_count = 0


func _notify_direction_change(new_dir: int) -> void:
	
	if new_dir == x_direction:
		return
	
	x_direction = new_dir
	emit_signal("x_direction_changed", x_direction)
#	print("direction changed")
