tool
extends idle_state

# signals               i.e signal my_signal(value, other_value) / signal my_signal
# enums                 i.e enum MoveDirection {UP, DOWN, LEFT, RIGHT}
# constants             i.e const MOVE_SPEED: float = 50.0
# exported variables    i.e export(PackedScene) var scene_file / export var scene_file: PackedScene
# public variables      i.e var a: int = 2
# private variables     i.e var _b: String = "text"
# onready variables     i.e onready var player_anim: AnimationPlayer = $AnimationPlayer
onready var movement: movement_state = get_parent().get_node("MovementState")
# optional built-in virtual _init method
# built-in virtual _ready method
# remaining built-in virtual methods
# public methods
# private methods


func _update(delta: float, body: KinematicBody2D, input: player_input, is_grounded: bool) -> void:
	movement.update(delta, body, input, is_grounded)
	._update(delta, body, input, is_grounded)


func _check_horizontal(body: KinematicBody2D, input: player_input) -> void:
	#if abs(input.horizontal) == 0 && !_is_on_target_position(body, input):
	if movement.current_velocity.x  == 0:
	#if movement.current_velocity.x  == 0 || (abs(input.horizontal) == 0 && input.target_canceled):
		_end("Idle")
