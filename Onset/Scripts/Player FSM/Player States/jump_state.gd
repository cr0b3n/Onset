extends state


signal jump_buffer_activated

var _min_jump_height: float = 1.5 * Global.TILE_SIZE
var _max_jump_height: float = 3.5 * Global.TILE_SIZE #If _max_jump_height is updated please also update global.gd to get proper gravity
var _max_jump_velocity: float
var _min_jump_velocity: float

onready var movement: movement_state = get_parent().get_node("MovementState")


func _ready() -> void:
	_max_jump_velocity = -sqrt( 2 * Global.gravity * _max_jump_height)
	_min_jump_velocity = -sqrt( 2 * Global.gravity * _min_jump_height)


func _start(fsm) -> void:
	._start(fsm)
	_jump(fsm.m_player_input.input_jump_release)


func _update(delta: float, body: KinematicBody2D, input: player_input, is_grounded: bool) -> void:
	movement.update(delta, body, input, is_grounded)
	_apply_air_movement(input, is_grounded)

	if movement.current_velocity.y > 0:
		_end("Fall")

#func _end(key: String) -> void:
#	pass


func _apply_air_movement(input: player_input, is_grounded: bool) -> void:

	if input.jump_pressed:
		emit_signal("jump_buffer_activated")

	if input.jump_released:
		if movement.current_velocity.y < _min_jump_velocity: #for minimum height jump
			movement.current_velocity.y = _adjust_jump_velocity(_min_jump_velocity) #returns negative
		elif movement.current_velocity.y < 0: #cancel's jump to send the character down
			movement.current_velocity.y = _adjust_jump_velocity(_min_jump_velocity) #returns posi


func _jump(short_jump: bool = false) -> void:
	movement.current_velocity.y = _min_jump_velocity if short_jump else _max_jump_velocity


func _adjust_jump_velocity(vel_y: float) -> float:
	return (abs(_max_jump_velocity) + movement.current_velocity.y) + vel_y
