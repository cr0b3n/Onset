class_name Spawner
extends Node2D

# signals               i.e signal my_signal(value, other_value) / signal my_signal
# enums                 i.e enum MoveDirection {UP, DOWN, LEFT, RIGHT}
# constants             i.e const MOVE_SPEED: float = 50.0
const TILE_SIZE: float = Global.TILE_SIZE
const MAX_DISTANCE: float = 1152.0
const Platform: PackedScene = preload("res://Prefabs/3x1Platform.tscn")
# exported variables    i.e export(PackedScene) var scene_file / export var scene_file: PackedScene
# public variables      i.e var a: int = 2
var player: Node2D
# private variables     i.e var _b: String = "text"
var _num_gen: RandomNumberGenerator = RandomNumberGenerator.new()
# onready variables     i.e onready var player_anim: AnimationPlayer = $AnimationPlayer
onready var spawn_timer: Timer = $Timer

# optional built-in virtual _init method
# built-in virtual _ready method
# remaining built-in virtual methods
# public methods
# private methods


func spawn_platform() -> void:
	
	while !_is_far_enough():
		var platform: Node2D = Platform.instance()
		platform.global_position = Vector2(global_position.x, global_position.y)
		platform.set_as_toplevel(true)
		add_child(platform)
		global_position.y -= (TILE_SIZE * _num_gen.randi_range(2, 3))
		#print("moving away " + str(global_position.y))
	
	
func _is_far_enough() -> bool:
	#print((global_position.y) - abs(player.global_position.y))
	return abs(global_position.y) - abs(player.global_position.y) > MAX_DISTANCE


func _on_Timer_timeout() -> void:
	spawn_platform()
