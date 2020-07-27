extends Node

# signals               i.e signal my_signal(value, other_value) / signal my_signal
# enums                 i.e enum MoveDirection {UP, DOWN, LEFT, RIGHT}
# constants             i.e const MOVE_SPEED: float = 50.0
const TILE_SIZE: float = 128.0
#const JUMP_DURATION: float = 0.5
#var _max_jump_height: float = 3.5 * TILE_SIZE
#var gravity: float = 2 * _max_jump_height / pow(JUMP_DURATION, 2)
# exported variables    i.e export(PackedScene) var scene_file / export var scene_file: PackedScene
# public variables      i.e var a: int = 2
# private variables     i.e var _b: String = "text"
# onready variables     i.e onready var player_anim: AnimationPlayer = $AnimationPlayer
var has_touch: bool = OS.has_touchscreen_ui_hint()
var top_score: int = 0
var restart_count: int  = 0
# optional built-in virtual _init method
# built-in virtual _ready method
# remaining built-in virtual methods
# public methods
# private methods


#https://docs.godotengine.org/en/stable/getting_started/step_by_step/singletons_autoload.html
#use call_deferred("_deferred_goto_scene", path) to transition to next scenes

func _ready() -> void:
	print("singleton reloaded")
#	var s = ResourceLoader.load("res://Gameplay Scenes/MenuScene.tscn").instance()
#	add_child(s)

func submit_score(score: int) -> bool:
	
	if score > top_score:
		top_score = score
		return true
		
	return false


func change_scene(scene: int) -> void:
	#Play transitions by yield
	call_deferred("_load_scene", scene)


func _load_scene(scene: int) -> void: 
	
	if scene == 1:
		get_tree().change_scene("res://Gameplay Scenes/MainScene.tscn")
	else:
		get_tree().change_scene("res://Gameplay Scenes/MenuScene.tscn")


func restart_scene() -> void:
	#Play transitions by yield
	call_deferred("_restart_deferred")


func _restart_deferred() -> void:
	get_tree().reload_current_scene()
