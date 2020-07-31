class_name Platform
extends Node2D

# signals               i.e signal my_signal(value, other_value) / signal my_signal
# enums                 i.e enum MoveDirection {UP, DOWN, LEFT, RIGHT}
# constants             i.e const MOVE_SPEED: float = 50.0
# exported variables    i.e export(PackedScene) var scene_file / export var scene_file: PackedScene
export(int, 50, 500) var points = 50
# public variables      i.e var a: int = 2
var height_bonus: int = 2
# private variables     i.e var _b: String = "text"
var _is_active: bool = true
# onready variables     i.e onready var player_anim: AnimationPlayer = $AnimationPlayer

# optional built-in virtual _init method
# built-in virtual _ready method
# remaining built-in virtual methods
# public methods
# private methods



func get_points(player) -> void:
	
	if !_is_active:
		return

	var jump_bonus: int = floor(abs(player.jump_x_pos - player.global_position.x) / 200) + 1
	var final_score = height_bonus * jump_bonus * points
	var text: String = ""
	var color: Color = Color("d4a350")

	text += str(final_score)
	player.add_score(final_score)
	
	if jump_bonus > 1:
		text+= str("\nLong Jump x",jump_bonus)#print("High Jump Bonus: x", jump_bonus)
		color = Color("850fff")
		
	Global.show_text_effect(Vector2(player.global_position.x, player.global_position.y -110), text, color)
	#print(text)
	#print("score: ", height_bonus * jump_bonus * points)
	_is_active = false

