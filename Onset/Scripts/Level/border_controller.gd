class_name Border
extends Node2D

# signals               i.e signal my_signal(value, other_value) / signal my_signal
signal player_advanced
signal border_activated(border, is_active)
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


func _on_player_exited(body: PlayerController) -> void:
	
	if body == null:
		return
	
	if body.global_position.y < $Area2D.global_position.y: #going up
		emit_signal("player_advanced")
	else: #going down
		emit_signal("border_activated", self, false)
	#print("player exited")


func _on_player_entered(body: PlayerController) -> void:
	
	if body == null:
		return
	
	if body.global_position.y > $Area2D.global_position.y:
		emit_signal("border_activated", self, true)
