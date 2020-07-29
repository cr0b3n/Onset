class_name TransitionController
extends Node

# signals               i.e signal my_signal(value, other_value) / signal my_signal
signal transition_completed
# enums                 i.e enum MoveDirection {UP, DOWN, LEFT, RIGHT}
# constants             i.e const MOVE_SPEED: float = 50.0
# exported variables    i.e export(PackedScene) var scene_file / export var scene_file: PackedScene
# public variables      i.e var a: int = 2
# private variables     i.e var _b: String = "text"
# onready variables     i.e onready var player_anim: AnimationPlayer = $AnimationPlayer
#onready var _transition: TextureProgress = $Transition
#onready var tween: Tween = $Tween
# optional built-in virtual _init method
# built-in virtual _ready method
# remaining built-in virtual methods
# public methods
# private methods


func play_transition() -> void:
	
	var _transition: TextureProgress = $Transition
	var tween: Tween = $Tween
	#Always set initial value to current transition value
	var initial_val: float = _transition.value
	var final_val: float  #Identified base on the current transition value
	
	#Swaping for continous wipe effect
	if _transition.value != _transition.max_value:
		final_val = _transition.max_value
		_transition.fill_mode = _transition.FILL_BOTTOM_TO_TOP
	else:
		final_val = _transition.min_value
		_transition.fill_mode = _transition.FILL_TOP_TO_BOTTOM
	
	tween.interpolate_property(
		_transition,
		"value",
		initial_val,
		final_val,
		0.35,
		Tween.TRANS_CIRC,
		Tween.EASE_OUT)
	
	tween.start()
	
	#Wait for tween to complete
	yield(tween, "tween_all_completed")
	
	#Make sure we don't under/over shoot when the animation complete
	_transition.value = final_val
	emit_signal("transition_completed") #Emit signal to notify that transition is complete


func enable_transition(enable: bool) -> void:
	$Transition.visible = enable
