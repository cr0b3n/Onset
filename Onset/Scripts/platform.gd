class_name Platform
extends Node2D

# signals               i.e signal my_signal(value, other_value) / signal my_signal
# enums                 i.e enum MoveDirection {UP, DOWN, LEFT, RIGHT}
# constants             i.e const MOVE_SPEED: float = 50.0
# exported variables    i.e export(PackedScene) var scene_file / export var scene_file: PackedScene
export(int, 50, 500) var points = 50
# public variables      i.e var a: int = 2
var height_bonus: int
# private variables     i.e var _b: String = "text"
var _is_active: bool = true
# onready variables     i.e onready var player_anim: AnimationPlayer = $AnimationPlayer

# optional built-in virtual _init method
# built-in virtual _ready method
# remaining built-in virtual methods
# public methods
# private methods



func get_points() -> void:
	
	if !_is_active:
		return
	
	_is_active = false
	#print("adding points: ", points * height_bonus)

