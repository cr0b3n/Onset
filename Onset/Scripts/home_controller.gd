extends Node

# signals               i.e signal my_signal(value, other_value) / signal my_signal
# enums                 i.e enum MoveDirection {UP, DOWN, LEFT, RIGHT}
# constants             i.e const MOVE_SPEED: float = 50.0
# exported variables    i.e export(PackedScene) var scene_file / export var scene_file: PackedScene
# public variables      i.e var a: int = 2
# private variables     i.e var _b: String = "text"
var _controls: ButtonGroup = ButtonGroup.new()
var _can_play: bool = true
# onready variables     i.e onready var player_anim: AnimationPlayer = $AnimationPlayer
onready var control_lbl: Label = $CanvasLayer/Settings/Panel/MarginContainer/VBoxContainer/MarginContainer/ControlsLbl
onready var kb_btn: BaseButton = $CanvasLayer/Settings/Panel/MarginContainer/VBoxContainer/HBoxContainer/KeyboardBtn
onready var touch_btn: BaseButton = $CanvasLayer/Settings/Panel/MarginContainer/VBoxContainer/HBoxContainer/TouchBtn
# optional built-in virtual _init method
# built-in virtual _ready method
# remaining built-in virtual methods
# public methods
# private methods


func _ready() -> void:
	Global.scene_loaded()
	Global.play_bgm(true)
	
	#Set Score Label
	var top_score: String = str(Global.top_score)
	for i in range(top_score.length()-3, 0, -3):
		top_score = top_score.insert(i, ",")
	$CanvasLayer/Footer/HBoxContainer/TopScoreLabel.text = top_score
	
	#Set Controls Toogle
	kb_btn.set_button_group(_controls)
	touch_btn.set_button_group(_controls)
	
	if !Global.has_touch:
		touch_btn.self_modulate = Color.gray
		_control_lbl_kb()
	else:
		kb_btn.self_modulate = Color.gray
		_control_lbl_touch()


func _on_PlayButton_pressed() -> void:
	
	if !_can_play:
		return
	
	Global.change_scene(1)


func _on_TouchBtn_pressed() -> void:
	_control_lbl_touch()
	_set_settings_btn(kb_btn, true)


func _on_KeyboardBtn_pressed() -> void:
	_control_lbl_kb()
	_set_settings_btn(touch_btn, false)


func _set_settings_btn(btn: BaseButton, has_touch: bool) -> void:
	btn.self_modulate = Color.gray
	Global.has_touch = has_touch
	Global.play_ui_audio(Global.BUTTON)


func _control_lbl_kb() -> void:
	control_lbl.text = "Move: A / D\nJump: W / Space\nDash: 2x A / D"


func _control_lbl_touch() -> void:
	control_lbl.text = "Move: Tap\nJump: Swipe Up\nDash: Double Tap"


func _on_CloseBtn_pressed() -> void:
	_can_play = true
	_open_close_settings(_can_play)
	Global.play_ui_audio(Global.BUTTON)


func _on_SettingsButton_pressed() -> void:
	_can_play = false
	_open_close_settings(_can_play)
	Global.play_ui_audio(Global.BUTTON)
	

func _open_close_settings(has_settings: bool) -> void:
	$CanvasLayer/Settings.visible = !has_settings
	$CanvasLayer/Body.visible = has_settings
	$CanvasLayer/Footer/HBoxContainer/SettingsButton. visible = has_settings
