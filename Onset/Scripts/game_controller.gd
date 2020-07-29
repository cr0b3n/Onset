extends Node2D

# signals               i.e signal my_signal(value, other_value) / signal my_signal
# enums                 i.e enum MoveDirection {UP, DOWN, LEFT, RIGHT}
# constants             i.e const MOVE_SPEED: float = 50.0
const BORDER_LENGHT: float = 2560.0
# exported variables    i.e export(PackedScene) var scene_file / export var scene_file: PackedScene
# public variables      i.e var a: int = 2
# private variables     i.e var _b: String = "text"
var _cur_score: int = 0
var _cur_level: int = 1
var _active_border: Node2D
var _inactive_border: Node2D
# onready variables     i.e onready var player_anim: AnimationPlayer = $AnimationPlayer
onready var gui: GUIController = $GUI
# optional built-in virtual _init method
# built-in virtual _ready method
# remaining built-in virtual methods
# public methods
# private methods


func _ready() -> void:

	var player: PlayerController = $Godette
	var spike: Spike = $Spike
	
	player.connect("score_added", self, "_on_score_added")
	spike.connect("level_changed", self, "_on_level_changed")
	spike.connect("player_died", self, "_on_player_death")
	
	spike.player = player
	$Spawner.player = player

	for i in range(10): #Use coroutine to avoid detecting when the scene finished loading
		yield(get_tree(), "idle_frame")

	var border1: Border = $Borders
	border1.connect("player_advanced", self, "_on_player_advanced")
	border1.connect("border_activated", self, "_on_active_border_changed")
	
	var border2: Border = $Borders2
	border2.connect("player_advanced", self, "_on_player_advanced")
	border2.connect("border_activated", self, "_on_active_border_changed")
	
	_active_border = border2
	_inactive_border = border1
	Global.scene_loaded()


func _on_player_advanced() -> void:
	_inactive_border.global_position.y = _active_border.global_position.y - BORDER_LENGHT


func _on_active_border_changed(border: Node2D, is_active: bool) -> void:

	if is_active:
		_inactive_border = _active_border
		_active_border = border
	else:
		_active_border = _inactive_border
		_inactive_border = border
		_active_border.global_position.y = _inactive_border.global_position.y + BORDER_LENGHT
		

func _on_score_added(score: int) -> void:
	_cur_score+= score
	gui.update_score(str(_cur_score))


func _on_level_changed(level: int) -> void:
	_cur_level+= level
	gui.update_level(_cur_level)


func _on_player_death() -> void:
	Global.submit_score(_cur_score)
	gui.game_over()
