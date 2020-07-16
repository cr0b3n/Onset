extends Node

# signals               i.e signal my_signal(value, other_value) / signal my_signal
# enums                 i.e enum MoveDirection {UP, DOWN, LEFT, RIGHT}
# constants             i.e const MOVE_SPEED: float = 50.0
# exported variables    i.e export(PackedScene) var scene_file / export var scene_file: PackedScene
# public variables      i.e var a: int = 2
var is_paused: bool = false
var lbl_game_data: Label
var p_monitor
# private variables     i.e var _b: String = "text"
# onready variables     i.e onready var player_anim: AnimationPlayer = $AnimationPlayer

# optional built-in virtual _init method
# built-in virtual _ready method
# remaining built-in virtual methods
# public methods
# private methods



func _ready() -> void:
	var device_data: String = ""
	device_data += str(" OS Name: ", OS.get_name())
	device_data += str("\n Device Touch Support: ", OS.has_touchscreen_ui_hint())

	$Control/VBoxContainer/LblOSData.text = device_data
	lbl_game_data = $Control/VBoxContainer/LblGameData


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		is_paused = !is_paused
		get_tree().paused = is_paused


func _physics_process(delta: float) -> void:
		lbl_game_data.text = "FPS: " + str(Performance.get_monitor(Performance.TIME_FPS)) \
							+ "\n" + "MEM: " + String.humanize_size(Performance.get_monitor(Performance.MEMORY_STATIC)) \
							+ "\n" + "DCALL: " + str(Performance.get_monitor(Performance.RENDER_2D_DRAW_CALLS_IN_FRAME)) \
							+ "\n" + "VMEM: " + String.humanize_size(Performance.get_monitor(Performance.RENDER_VIDEO_MEM_USED))
