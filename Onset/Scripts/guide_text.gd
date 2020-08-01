class_name GuideText
extends Node2D

# signals               i.e signal my_signal(value, other_value) / signal my_signal
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

#func _ready() -> void:
#	print($JumpContainer.global_position.y)


func setup(jump_x_pos: float) -> void:
	#print($JumpContainer.global_position.y)
	$JumpContainer.global_position = Vector2(jump_x_pos, -441)

	if Global.has_touch:
		_set_labels("Move: Tap", "Dash: 2x Tap", "Jump: Swipe Up")
	else:
		_set_labels("Move: A / D", "Dash: 2x A / D", "Jump: W / Space")
	
	
func _set_labels(move: String, dash: String, jump: String) -> void:
	$DashLbl.text = dash
	$MoveLbl.text = move
	$JumpContainer/JumpLbl.text = jump
