class_name GUIController
extends Node

# signals               i.e signal my_signal(value, other_value) / signal my_signal
# enums                 i.e enum MoveDirection {UP, DOWN, LEFT, RIGHT}
# constants             i.e const MOVE_SPEED: float = 50.0
const SCORE_TEXT: String = "Score: %s"
const LEVEL_TEXT: String = "Level: %s"
const Menu: PackedScene = preload("res://Prefabs/Menu.tscn")
# exported variables    i.e export(PackedScene) var scene_file / export var scene_file: PackedScene
# public variables      i.e var a: int = 2
# private variables     i.e var _b: String = "text"
var _game_over: bool = false
# onready variables     i.e onready var player_anim: AnimationPlayer = $AnimationPlayer
onready var score_label: Label = $HUD/HBoxContainer/VBoxContainer/ScoreLabel
onready var level_label: Label = $HUD/HBoxContainer/VBoxContainer/LevelLabel

# optional built-in virtual _init method
# built-in virtual _ready method
# remaining built-in virtual methods
# public methods
# private methods

#
#func _ready() -> void:
#	print(get_child_count())
#	print(get_child(get_child_count()-1).name)


func update_score(score: String) -> void:
	
	#if score.length() > 3: #Remove check since for the most part it's 4 digits
	#Loop backwards starting at the last 3 digits add comma then repeat every 3rd step
	for i in range(score.length()-3, 0, -3):#Use 0 instead of -1 to remove if check
		#if i > 0: #Avoid inserting at the beginning
		score = score.insert(i, ",")

	score_label.text = SCORE_TEXT %score


func update_level(level: int) -> void:
	level_label.text = LEVEL_TEXT %level


func game_over(is_topscore: bool) -> void:
	
	if is_topscore:
		var top_ui = load("res://Prefabs/TopScore.tscn").instance()
		add_child(top_ui)
		
	_game_over = true
	var btn: Control = $HUD/HBoxContainer/MenuButton
	
	if btn.visible: #Check if the menu is not open
		#Make sure it invisible to avoid double press incase instancing is longer
		btn.visible = false
		_create_menu().open(btn, "Game Over!")
		return
	
	#Get a reference of the menu from this control	
	for i in range(get_child_count() -1, 0, -1):
		if get_child(i) is MenuController:
			get_child(i).open(btn, "Game Over!")
			return


func _on_MenuButton_pressed() -> void:
	var btn: Control = $HUD/HBoxContainer/MenuButton
	#Make sure it invisible to avoid double press incase instancing is longer
	btn.visible = false
	#Added _game_over check incase the menu was closed after the player died
	_create_menu().open(btn, "Game Over!" if _game_over else "Menu")
	Global.play_ui_audio(Global.BUTTON, false)


func _create_menu() -> MenuController:
	var menu: MenuController = load("res://Prefabs/Menu.tscn").instance()
	add_child(menu)
	return menu
