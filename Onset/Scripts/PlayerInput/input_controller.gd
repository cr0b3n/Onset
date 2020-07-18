extends Node2D
class_name input_controller


signal x_direction_changed(dir)
# enums                 i.e enum MoveDirection {UP, DOWN, LEFT, RIGHT}
# constants             i.e const MOVE_SPEED: float = 50.0
# exported variables    i.e export(PackedScene) var scene_file / export var scene_file: PackedScene
# public variables      i.e var a: int = 2
var jump_pressed: bool
var jump_released: bool
var input_jump_release: bool = true
var dash_pressed: bool
var horizontal: float
var x_direction: int = 1
var target_reached = true
var target: Node2D
# private variables     i.e var _b: String = "text"
var _ready_to_clear: bool = true #Boolean flag for clearing inputs
var _current_input  #Current input used #DO NOT!!! Static Type input_so will cause error
# onready variables     i.e onready var player_anim: AnimationPlayer = $AnimationPlayer
onready var target_x_pos: float = global_position.x

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
	#Assign appropriate controls
	if Global.has_touch: #Mobile
		_current_input = load("res://Scripts/PlayerInput/MobileInput-SO.tres")
	else: #Desktop
		_current_input = load("res://Scripts/PlayerInput/DesktopInput-SO.tres")

	_current_input._setup()


func _input(event: InputEvent) -> void:
	_current_input._check_inputs(event, self)
	

func _process(delta: float) -> void:
	_clear_inputs()
	_current_input._update(delta, self)


func _physics_process(delta: float) -> void:
	_ready_to_clear = true


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


func notify_direction_change(new_dir: int) -> void:
	
	if new_dir == x_direction:
		return

	x_direction = new_dir
	emit_signal("x_direction_changed", x_direction)


func _clear_inputs() -> void:
	
	if !_ready_to_clear:
		return

	jump_pressed = false
	jump_released = false
	horizontal = 0.0
	dash_pressed = false #Must reset dash_pressed here & not on the _update_dash_timer


func _event_pos_to_world(event_pos: Vector2) -> Vector2:
	return get_canvas_transform().affine_inverse().xform(event_pos)

