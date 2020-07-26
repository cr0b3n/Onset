extends Node2D

# signals               i.e signal my_signal(value, other_value) / signal my_signal
# enums                 i.e enum MoveDirection {UP, DOWN, LEFT, RIGHT}
# constants             i.e const MOVE_SPEED: float = 50.0
var speed: float = 30.0
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
	position.y -= (speed * delta)
	


func _on_Spike_body_entered(body: Node) -> void:
	
	if body is PlayerController:
		print("Player Died!!!")


func _on_Spike_body_exited(body: Node) -> void:
	
	if body is Platform:
		body.queue_free()
