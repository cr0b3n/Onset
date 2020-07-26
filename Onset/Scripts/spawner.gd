class_name Spawner
extends Node2D

# signals               i.e signal my_signal(value, other_value) / signal my_signal
# enums                 i.e enum MoveDirection {UP, DOWN, LEFT, RIGHT}
# constants             i.e const MOVE_SPEED: float = 50.0
const TILE_SIZE: float = Global.TILE_SIZE
const MAX_DISTANCE: float = 1152.0
const Platforms: Array = [preload("res://Prefabs/1x1Platform.tscn"),
	preload("res://Prefabs/2x1Platform.tscn"),
	preload("res://Prefabs/3x1Platform.tscn")]
	
# exported variables    i.e export(PackedScene) var scene_file / export var scene_file: PackedScene
# public variables      i.e var a: int = 2
var player: Node2D
# private variables     i.e var _b: String = "text"
var _num_gen: RandomNumberGenerator = RandomNumberGenerator.new()
var _height: int = 2
# onready variables     i.e onready var player_anim: AnimationPlayer = $AnimationPlayer
onready var spawn_timer: Timer = $Timer

# optional built-in virtual _init method
# built-in virtual _ready method
# remaining built-in virtual methods
# public methods
# private methods


func _ready() -> void:
	_num_gen.randomize()


func spawn_platform() -> void:
		
	while !_is_far_enough():
		var index: int = _num_gen.randi_range(0, Platforms.size() -1)
		
		var platform: Platform = Platforms[index].instance()
		platform.global_position = Vector2(_get_x_position(index + 1), global_position.y)
		platform.height_bonus = _height
		platform.set_as_toplevel(true)
		add_child(platform)
		
		_height = _num_gen.randi_range(2, 3)
		global_position.y -= (TILE_SIZE * _height)


func _is_far_enough() -> bool:
	#print((global_position.y) - abs(player.global_position.y))
	return abs(global_position.y) - abs(player.global_position.y) > MAX_DISTANCE


func _on_Timer_timeout() -> void:
	spawn_platform()


func _get_x_position(pos_range: int) -> float:
	
	if pos_range == 2:
		return 128.0 * _num_gen.randi_range(1,5) # _num_gen.randi_range(-2,2)
		
	var num: int
	
	if (pos_range ==1):
		num = _num_gen.randi_range(1,11) # _num_gen.randi_range(-5,5)
	else:	
		num = _num_gen.randi_range(3,9) # _num_gen.randi_range(-3,3)
	
	if num % 2 == 0:
		num += 1 if _num_gen.randfn() > 0.5 else -1

	return 64.0 * num
