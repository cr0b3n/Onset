tool
extends extended_state

# signals               i.e signal my_signal(value, other_value) / signal my_signal
# enums                 i.e enum MoveDirection {UP, DOWN, LEFT, RIGHT}
# constants             i.e const MOVE_SPEED: float = 50.0
# exported variables    i.e export(PackedScene) var scene_file / export var scene_file: PackedScene
# public variables      i.e var a: int = 2
# private variables     i.e var _b: String = "text"
var _jump_buffer_active: bool = false
# onready variables     i.e onready var player_anim: AnimationPlayer = $AnimationPlayer
onready var jump_buffer_timer: Timer = $JumpBufferTimer
# optional built-in virtual _init method
# built-in virtual _ready method
# remaining built-in virtual methods
# public methods
# private methods


func _ready() -> void:
	jump_buffer_timer.connect("timeout", self, "_on_jump_timer_expired")
	get_parent().get_node("JumpState").connect("jump_buffer_activated", self, "_activate_jump_buffer")
	

func _update(delta: float, body: KinematicBody2D, input: player_input, is_grounded: bool) -> void:
	extra_state._update(delta, body, input, is_grounded)
	
	if input.jump_pressed:
		_activate_jump_buffer()
	#Also check using is_on_floor() for fail check on raycast on collider with 1 way collision
	if is_grounded && body.is_on_floor(): 
		if _jump_buffer_active:
			jump_buffer_timer.stop()
			_jump_buffer_active = false
			_end("Jump")
		else:
			_end("Idle")


#func _end(key: String) -> void:
#	current_fsm._set_state(key)


func _activate_jump_buffer() -> void:
	_jump_buffer_active = true
	jump_buffer_timer.start() #Reset the timer to wait time no need to reset manually


func _on_jump_timer_expired() -> void:
	_jump_buffer_active = false
