class_name MenuController
extends Node

# signals               i.e signal my_signal(value, other_value) / signal my_signal
# enums                 i.e enum MoveDirection {UP, DOWN, LEFT, RIGHT}
# constants             i.e const MOVE_SPEED: float = 50.0
# exported variables    i.e export(PackedScene) var scene_file / export var scene_file: PackedScene
# public variables      i.e var a: int = 2
# private variables     i.e var _b: String = "text"
var _trigger: Control
# onready variables     i.e onready var player_anim: AnimationPlayer = $AnimationPlayer

# optional built-in virtual _init method
# built-in virtual _ready method
# remaining built-in virtual methods
# public methods
# private methods


func open(btn: Control, title: String = "Menu") -> void:
	$VBoxContainer/Panel/MenuLabel.text = title
	_trigger = btn
	btn.visible = false


func _on_Home_pressed() -> void:
	Global.change_scene(0)


func _on_Restart_pressed() -> void:
	Global.restart_scene()


func _on_Close_pressed() -> void:
	
	if _trigger != null:
		_trigger.visible = true
	
	queue_free()
