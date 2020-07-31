class_name Spike
extends Node2D

# signals               i.e signal my_signal(value, other_value) / signal my_signal
signal level_changed(level)
signal player_died
# enums                 i.e enum MoveDirection {UP, DOWN, LEFT, RIGHT}
# constants             i.e const MOVE_SPEED: float = 50.0
const CATCH_UP_GAP: float = 630.0
const LEVEL_UP_GAP: float = 2000.0
var speed: float = 40.0
var player: Node2D
var is_respositioning: bool = false
#var cur_level: int = 1
# exported variables    i.e export(PackedScene) var scene_file / export var scene_file: PackedScene
# public variables      i.e var a: int = 2
# private variables     i.e var _b: String = "text"
# onready variables     i.e onready var player_anim: AnimationPlayer = $AnimationPlayer

# optional built-in virtual _init method
# built-in virtual _ready method
# remaining built-in virtual methods
# public methods
# private methods


func _physics_process(delta: float) -> void:
	
	if is_respositioning:
		is_respositioning = _catch_up(delta)
		#print("repositioning")
		return
	elif _has_level_up():
		is_respositioning = true
		speed+= 5
		emit_signal("level_changed", 1)
		Global.play_spike_audio(Global.LEVEL)
		Global.show_text_effect(
			Vector2(player.global_position.x, player.global_position.y -110),
			"Level Up!",
			Color("16de25"))
		return
	
	global_position.y -= (speed * delta)
	#print("moving")


func _on_Spike_body_entered(body: Node) -> void:
	
	if body is PlayerController:
		body.set_new_state("Death")
		Global.play_spike_audio(Global.DEATH)
		set_physics_process(false)
		emit_signal("player_died")


func _on_Spike_body_exited(body: Node) -> void:

	if !body is PlayerController:
		body.queue_free()


func _has_level_up() -> bool:
	var distance: float = global_position.y - player.global_position.y
	return distance > LEVEL_UP_GAP
	

func _catch_up(delta: float) -> bool:
	
	var distance: float = global_position.y - player.global_position.y
	var burst: float = distance * delta
	global_position.y -= burst 

	return distance > CATCH_UP_GAP

