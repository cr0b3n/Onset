class_name TextEffect
extends Node2D

# signals               i.e signal my_signal(value, other_value) / signal my_signal
# enums                 i.e enum MoveDirection {UP, DOWN, LEFT, RIGHT}
# constants             i.e const MOVE_SPEED: float = 50.0
# exported variables    i.e export(PackedScene) var scene_file / export var scene_file: PackedScene
# public variables      i.e var a: int = 2
# private variables     i.e var _b: String = "text"
# onready variables     i.e onready var player_anim: AnimationPlayer = $AnimationPlayer
onready var display: Label = $Label
onready var tween: Tween = $Tween
#onready var rect_pos: Vector2 = display.rect_position
# optional built-in virtual _init method
# built-in virtual _ready method
# remaining built-in virtual methods
# public methods
# private methods

func _ready() -> void:

	tween.interpolate_property(
		display,
		"rect_position",
		display.rect_position,
		Vector2(display.rect_position.x, display.rect_position.y * 5),
		0.3,
		Tween.TRANS_LINEAR,
		Tween.EASE_OUT)
	
	tween.interpolate_property(
		display,
		"self_modulate:a",
		1.0,
		0.0,
		0.3,
		Tween.TRANS_LINEAR,
		Tween.EASE_OUT, 
		0.7)
	
	tween.start()

	#display.set("custom_colors/font_outline_modulate", Color("d4a350"))
	#display.set("custom_colors/font_outline_modulate", Color("850fff"))
	#display.set("custom_colors/font_outline_modulate", Color("16de25"))


func setup(text: String, color: Color) -> void:
#	visible = true
#	display.rect_position = rect_pos
	display.text = text
	display.set("custom_colors/font_outline_modulate", color)
	#display.modulate.a = 1.0


func _on_Tween_tween_all_completed() -> void:
	queue_free()
	#visible = false
