tool
extends extended_state

# signals               i.e signal my_signal(value, other_value) / signal my_signal
# enums                 i.e enum MoveDirection {UP, DOWN, LEFT, RIGHT}
# constants             i.e const MOVE_SPEED: float = 50.0
# exported variables    i.e export(PackedScene) var scene_file / export var scene_file: PackedScene
# public variables      i.e var a: int = 2
# private variables     i.e var _b: String = "text"
# onready variables     i.e onready var player_anim: AnimationPlayer = $AnimationPlayer

# optional built-in virtual _init method
# built-in virtual _ready method
# remaining built-in virtual methods
# public methods
# private methods


func _start(fsm) -> void:
	pass


func _update(delta: float, body: KinematicBody2D, input: player_input, is_grounded: bool) -> void:
	extra_state._update(delta, body, input, is_grounded)


func _end() -> void:
	pass
