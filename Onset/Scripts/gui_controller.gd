class_name GUIController
extends Node

# signals               i.e signal my_signal(value, other_value) / signal my_signal
# enums                 i.e enum MoveDirection {UP, DOWN, LEFT, RIGHT}
# constants             i.e const MOVE_SPEED: float = 50.0
const SCORE_TEXT: String = "Score: %s"
const LEVEL_TEXT: String = "Level: %s"
# exported variables    i.e export(PackedScene) var scene_file / export var scene_file: PackedScene
# public variables      i.e var a: int = 2
# private variables     i.e var _b: String = "text"

# onready variables     i.e onready var player_anim: AnimationPlayer = $AnimationPlayer
onready var score_label: Label = $HOD2/Margin/HBoxContainer/VBoxContainer/ScoreLabel
onready var level_label: Label = $HOD2/Margin/HBoxContainer/VBoxContainer/LevelLabel
# optional built-in virtual _init method
# built-in virtual _ready method
# remaining built-in virtual methods
# public methods
# private methods


func _ready() -> void:
	pass


func update_score(score: String) -> void:
	
	#if score.length() > 3:
	for i in range(score.length()-3, -1, -3):
		if i > 0:
			score = score.insert(i, ",")

	score_label.text = SCORE_TEXT %score



func update_level(level: int) -> void:
	level_label.text = LEVEL_TEXT %level
