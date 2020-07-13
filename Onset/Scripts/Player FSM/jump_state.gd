tool
extends extended_state

# signals               i.e signal my_signal(value, other_value) / signal my_signal
# enums                 i.e enum MoveDirection {UP, DOWN, LEFT, RIGHT}
# constants             i.e const MOVE_SPEED: float = 50.0
const TILE_SIZE: float = 128.0
const JUMP_DURATION: float = 0.5
# exported variables    i.e export(PackedScene) var scene_file / export var scene_file: PackedScene
# public variables      i.e var a: int = 2
# private variables     i.e var _b: String = "text"
var _min_jump_height: float = 1.2 * TILE_SIZE
var _max_jump_height: float = 3.5 * TILE_SIZE
var _max_jump_velocity: float
var _min_jump_velocity: float
# onready variables     i.e onready var player_anim: AnimationPlayer = $AnimationPlayer

# optional built-in virtual _init method
# built-in virtual _ready method
# remaining built-in virtual methods
# public methods
# private methods


func _ready() -> void:
	_max_jump_velocity = -sqrt( 2 * extra_state._gravity * _max_jump_height)
	_min_jump_velocity = -sqrt( 2 * extra_state._gravity * _min_jump_height)
	

func _start(fsm) -> void:
	current_fsm = fsm
	_jump()


func _update(delta: float, body: KinematicBody2D, input: player_input, is_grounded: bool) -> void:
	extra_state._update(delta, body, input, is_grounded)
	_apply_air_movement(input, is_grounded)

func _end() -> void:
	pass


func _apply_air_movement(input: player_input, is_grounded: bool) -> void:
	
#	if _jump_key_pressed && is_grounded:
#		_jump(_jump_key_released)
#
#	if input.jump_pressed:
#		_jump_key_pressed = true
#		_jump_key_released = false
#
#		if is_grounded || !coyote_timer.is_stopped():
#			_jump()
#		else:
#			jump_buffer_timer.start()

	if input.jump_released:
#		_jump_key_released = true
		
		if extra_state.current_velocity.y < _min_jump_velocity: #for minimum height jump
			extra_state.current_velocity.y = _adjust_jump_velocity(_min_jump_velocity) #returns negative
		elif extra_state.current_velocity.y < 0: #cancel's jump to send the character down
			extra_state.current_velocity.y = _adjust_jump_velocity(_min_jump_velocity) #returns posi

#	if extra_state.current_velocity.y > 0:
#		is_jumping = false
#		is_falling = true
#
#	else:
#		is_falling = false
		

func _adjust_jump_velocity(vel_y: float) -> float:
	return (abs(_max_jump_velocity) + extra_state.current_velocity.y) + vel_y


func _jump(short_jump: bool = false) -> void:
	
	extra_state.current_velocity.y = _max_jump_velocity if !short_jump else _min_jump_velocity
#	_jump_key_pressed = false
#	_can_coyote_time = false 
#	coyote_timer.stop()
#	jump_buffer_timer.stop()
