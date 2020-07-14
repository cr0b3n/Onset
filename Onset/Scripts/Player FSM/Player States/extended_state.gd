tool
extends state
class_name extended_state

# signals               i.e signal my_signal(value, other_value) / signal my_signal
# enums                 i.e enum MoveDirection {UP, DOWN, LEFT, RIGHT}
# constants             i.e const MOVE_SPEED: float = 50.0
# exported variables    i.e export(PackedScene) var scene_file / export var scene_file: PackedScene
export(NodePath) var extra_state_node_path setget set_movement_node_path
# public variables      i.e var a: int = 2
# private variables     i.e var _b: String = "text"
# onready variables     i.e onready var player_anim: AnimationPlayer = $AnimationPlayer
onready var extra_state = get_node(extra_state_node_path)
# optional built-in virtual _init method
# built-in virtual _ready method
# remaining built-in virtual methods
# public methods
# private methods

func _get_configuration_warning() -> String:
	
	var warnings: String = ""

	if extra_state_node_path == "":
		warnings += "Please add a state node path!"
	
	return warnings


func set_movement_node_path(value: String) -> void:
	extra_state_node_path = value
	update_configuration_warning()
