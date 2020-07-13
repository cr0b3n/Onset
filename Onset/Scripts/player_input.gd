extends Node
class_name player_input

# signals               i.e signal my_signal(value, other_value) / signal my_signal
# enums                 i.e enum MoveDirection {UP, DOWN, LEFT, RIGHT}
# constants             i.e const MOVE_SPEED: float = 50.0
# exported variables    i.e export(PackedScene) var scene_file / export var scene_file: PackedScene
# public variables      i.e var a: int = 2
var jump_pressed: bool
var jump_released: bool
var horizontal: float

# private variables     i.e var _b: String = "text"
var _ready_to_clear: bool = true
# onready variables     i.e onready var player_anim: AnimationPlayer = $AnimationPlayer

# optional built-in virtual _init method
# built-in virtual _ready method
# remaining built-in virtual methods
# public methods
# private methods

func _input(event: InputEvent) -> void:
	jump_pressed = event.is_action_pressed("c_jump")
	jump_released = event.is_action_released("c_jump")


func _process(delta: float) -> void:
	_clear_inputs()
	_process_inputs()

func _physics_process(delta: float) -> void:
	_ready_to_clear = true


func _process_inputs() -> void:
	horizontal = (Input.get_action_strength("c_right") - Input.get_action_strength("c_left"))
	horizontal = clamp(horizontal, -1.0, 1.0)


func _clear_inputs() -> void:
	
	if !_ready_to_clear:
		return
		
	jump_pressed = false
	jump_released = false
	horizontal = 0.0
