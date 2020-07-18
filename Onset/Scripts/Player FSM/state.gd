extends Node
class_name state

# signals               i.e signal my_signal(value, other_value) / signal my_signal
# enums                 i.e enum MoveDirection {UP, DOWN, LEFT, RIGHT}
# constants             i.e const MOVE_SPEED: float = 50.0
# exported variables    i.e export(PackedScene) var scene_file / export var scene_file: PackedScene
# public variables      i.e var a: int = 2
var current_fsm #state_machine
# private variables     i.e var _b: String = "text"
# onready variables     i.e onready var player_anim: AnimationPlayer = $AnimationPlayer

# optional built-in virtual _init method
# built-in virtual _ready method
# remaining built-in virtual methods
# public methods
# private methods


func _start(fsm) -> void:
	if current_fsm == null:
		current_fsm = fsm


func _update(delta: float, body: KinematicBody2D, input: input_controller, is_grounded: bool) -> void:
	pass


func _end(key: String) -> void:
	if current_fsm == null:
		return
	
	current_fsm._set_state(key)
