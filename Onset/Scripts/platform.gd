class_name Platform
extends Node2D

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



#func set_x_position(num_gen: RandomNumberGenerator) -> void:
#
#	var num: int = num_gen.randi_range(-3,3)
#
#	if num % 2 == 0:
#		num += 1 if num_gen.randfn() > 0.5 else -1
#
#	global_position.x = 64 * num
