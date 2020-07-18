extends input_so
class_name desktop_input_so

# signals               i.e signal my_signal(value, other_value) / signal my_signal
# enums                 i.e enum MoveDirection {UP, DOWN, LEFT, RIGHT}
# constants             i.e const MOVE_SPEED: float = 50.0
const DOUBLE_PRESS_TIME: float = 0.2
# exported variables    i.e export(PackedScene) var scene_file / export var scene_file: PackedScene
# public variables      i.e var a: int = 2
# private variables     i.e var _b: String = "text"
var _dash_pressed_time: float
var _dash_press_count: int
# onready variables     i.e onready var player_anim: AnimationPlayer = $AnimationPlayer

# optional built-in virtual _init method
# built-in virtual _ready method
# remaining built-in virtual methods
# public methods
# private methods


func _setup() -> void:
	_reset_dash()


func _check_inputs(event: InputEvent, controller: input_controller) -> void:
	pass


func _update(delta: float, controller: input_controller) -> void:
	_process_x_inputs(controller)
	_update_dash_timer(delta)
	

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


func _reset_dash() -> void:
	_dash_pressed_time = 0.0
	_dash_press_count = 0
