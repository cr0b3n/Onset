class_name StateDeath
extends State

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


func _start(controller) -> void:
	controller.is_uninteruptible = true


##Called per _physics_process
#func _update(delta, controller) -> void:
#	pass
#
#
##Transitioning part here
#func _end(key, controller) -> void:
#	controller.set_new_state(key)
