extends KinematicBody2D
class_name player

# signals               i.e signal my_signal(value, other_value) / signal my_signal
# enums                 i.e enum MoveDirection {UP, DOWN, LEFT, RIGHT}
# constants             i.e const MOVE_SPEED: float = 50.0
const TILE_SIZE: float = 128.0
const MOVE_SPEED: float = 5.0 * TILE_SIZE
const MAX_Y_VELOCITY: float = 3000.0
const FLOOR: Vector2 = Vector2.UP
const FALL_GRAVITY_MULTIPLIER: float = 1.7
const JUMP_DURATION: float = 0.5
# exported variables    i.e export(PackedScene) var scene_file / export var scene_file: PackedScene
# public variables      i.e var a: int = 2
var is_grounded: bool = false
var is_jumping: bool = false
var is_falling: bool = false
var current_velocity: Vector2 = Vector2.ZERO

# private variables     i.e var _b: String = "text"
var _facing_direction: int = 1
var _can_coyote_time: bool = false
var _jump_key_pressed: bool = false
var _jump_key_released: bool = true
var _min_jump_height: float = 1.2 * TILE_SIZE
var _max_jump_height: float = 3.5 * TILE_SIZE
var _max_jump_velocity: float
var _min_jump_velocity: float
var _gravity: float = 2 * _max_jump_height / pow(JUMP_DURATION, 2)
# onready variables     i.e onready var player_anim: AnimationPlayer = $AnimationPlayer
onready var graphic: Node2D = $Graphic
onready var raycasts: Array = $CollisionBox.get_children()
onready var coyote_timer: Timer = $CoyoteTimer
onready var jump_buffer_timer: Timer = $JumpBufferTimer
onready var input: player_input = $PlayerInput
# optional built-in virtual _init method
# built-in virtual _ready method
# remaining built-in virtual methods
# public methods
# private methods


func _ready() -> void:
	jump_buffer_timer.connect("timeout", self, "_on_jump_buffer_expire")
	_max_jump_velocity = -sqrt( 2 * _gravity * _max_jump_height)
	_min_jump_velocity = -sqrt( 2 * _gravity * _min_jump_height)

	var anim: = $AnimationTree
	anim.m_player = self


func _process(delta: float) -> void:
	#Place in _process check per frame & make coyote time more acurate
	is_grounded = _is_on_ground()
	_check_coyote_time()


func _physics_process(delta: float) -> void:
	#increase gravity when falling or peek is reached of the jump
	_apply_gravity(delta, !is_grounded && current_velocity.y > 0)
	_apply_movement(delta)
	_apply_air_movement()


func _apply_gravity(delta: float, has_multiplier: bool) -> void:

	current_velocity.y += (_gravity * delta * (FALL_GRAVITY_MULTIPLIER if has_multiplier else 1.0))
	
	if current_velocity.y > MAX_Y_VELOCITY:
		current_velocity.y = MAX_Y_VELOCITY


func _apply_movement(delta: float) -> void:
	current_velocity.x = input.horizontal * MOVE_SPEED
	current_velocity = move_and_slide(current_velocity, FLOOR)
	_adjust_facing_direction()


func _adjust_facing_direction() -> void:
	if current_velocity.x * _facing_direction < 0.0:
		_facing_direction *= -1
		graphic.scale.x = _facing_direction


func _is_on_ground() -> bool:
	for r in raycasts:
		if r.is_colliding():
			return true
	return false


func _apply_air_movement() -> void:
	
	if _jump_key_pressed && is_grounded:
		_jump(_jump_key_released)
		
	if input.jump_pressed:
		_jump_key_pressed = true
		_jump_key_released = false
			
		if is_grounded || !coyote_timer.is_stopped():
			_jump()
		else:
			jump_buffer_timer.start()
		
	if input.jump_released:
		_jump_key_released = true
		
		if current_velocity.y < _min_jump_velocity: #for minimum height jump
			current_velocity.y = _adjust_jump_velocity(_min_jump_velocity) #returns negative
		elif !is_falling: #cancel's jump to send the character down
			current_velocity.y = _adjust_jump_velocity(_min_jump_velocity) #returns posi

	if current_velocity.y > 0:
		is_jumping = false
		is_falling = true

	else:
		is_falling = false


func _adjust_jump_velocity(vel_y: float) -> float:
	return (abs(_max_jump_velocity) + current_velocity.y) + vel_y


func _jump(short_jump: bool = false) -> void:

	if is_jumping:
		return

	current_velocity.y = _max_jump_velocity if !short_jump else _min_jump_velocity
	is_jumping = true
	_jump_key_pressed = false
	_can_coyote_time = false 
	coyote_timer.stop()
	jump_buffer_timer.stop()
	

func _check_coyote_time() -> void:
	
	if is_grounded && !is_jumping: #reset coyote time whenever the character touch the ground
		_can_coyote_time = true #no need to reset anywhere since coyote should only 
		return					#apply if character was previously grounded
	
	if !_can_coyote_time:
		return

	_can_coyote_time  = false
	coyote_timer.start()


func _on_jump_buffer_expire() -> void:
	_jump_key_pressed = false
