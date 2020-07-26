extends Node2D

# signals               i.e signal my_signal(value, other_value) / signal my_signal
# enums                 i.e enum MoveDirection {UP, DOWN, LEFT, RIGHT}
# constants             i.e const MOVE_SPEED: float = 50.0
const BORDER_LENGHT: float = 2560.0
# exported variables    i.e export(PackedScene) var scene_file / export var scene_file: PackedScene
# public variables      i.e var a: int = 2
# private variables     i.e var _b: String = "text"
var _active_border: Node2D
var _inactive_border: Node2D
# onready variables     i.e onready var player_anim: AnimationPlayer = $AnimationPlayer

# optional built-in virtual _init method
# built-in virtual _ready method
# remaining built-in virtual methods
# public methods
# private methods


func _ready() -> void:
	
	var player: Node2D = $Godette
	
	$Spawner.player = player
	$Spike.player = player
#	var spawner: Spawner = $Spawner
#	spawner.player = $Godette
	#spawner.spawn_platform()

	for i in range(10):
		yield(get_tree(), "idle_frame")

	var border1: Border = $Borders
	border1.connect("player_advanced", self, "_on_player_advanced")
	border1.connect("border_activated", self, "_on_active_border_changed")
	
	var border2: Border = $Borders2
	border2.connect("player_advanced", self, "_on_player_advanced")
	border2.connect("border_activated", self, "_on_active_border_changed")
	
	_active_border = border2
	_inactive_border = border1


#func _process(delta: float) -> void:
#   pass


#func _physics_process(delta: float) -> void:
#	pass


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
		
