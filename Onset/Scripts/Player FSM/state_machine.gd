extends Node
class_name state_machine

# signals               i.e signal my_signal(value, other_value) / signal my_signal
# enums                 i.e enum MoveDirection {UP, DOWN, LEFT, RIGHT}
# constants             i.e const MOVE_SPEED: float = 50.0
# exported variables    i.e export(PackedScene) var scene_file / export var scene_file: PackedScene
export var states_dictionary = {}
# public variables      i.e var a: int = 2
# private variables     i.e var _b: String = "text"
var _current_state: state = null
# onready variables     i.e onready var player_anim: AnimationPlayer = $AnimationPlayer

# optional built-in virtual _init method
# built-in virtual _ready method
# remaining built-in virtual methods
# public methods
# private methods


func _set_state(new_state: state) -> void:
	pass
