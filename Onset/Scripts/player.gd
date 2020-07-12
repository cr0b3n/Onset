extends KinematicBody2D

# signals               i.e signal my_signal(value, other_value) / signal my_signal
# enums                 i.e enum MoveDirection {UP, DOWN, LEFT, RIGHT}
# constants             i.e const MOVE_SPEED: float = 50.0
const TILE_SIZE: float = 128.0
const MOVE_SPEED: float = 5.0 * TILE_SIZE
const MAX_VELOCITY: Vector2 = Vector2(150.0, 3000.0)
const FLOOR: Vector2 = Vector2.UP
const FALL_GRAVITY_MULTIPLIER: float = 1.7
const JUMP_DURATION: float = 0.5
# exported variables    i.e export(PackedScene) var scene_file / export var scene_file: PackedScene
# public variables      i.e var a: int = 2
var is_grounded: bool = false
# private variables     i.e var _b: String = "text"
var _velocity: Vector2 = Vector2.ZERO
var _is_jumping: bool = false
var _is_falling: bool = false
var _facing_direction: int = 1
var _can_coyote_time: bool = false
var _jump_key_pressed: bool = false
var _jump_key_released: bool = true
var _min_jump_height: float = 1.2 * TILE_SIZE
var _max_jump_height: float = 3.5 * TILE_SIZE
var _max_jump_velocity: float
#var _mid_jump_velocity: float
var _min_jump_velocity: float
var _gravity: float = 2 * _max_jump_height / pow(JUMP_DURATION, 2)
# onready variables     i.e onready var player_anim: AnimationPlayer = $AnimationPlayer
onready var graphic: Node2D = $Graphic
onready var raycasts: Array = $CollisionBox.get_children()
onready var coyote_timer: Timer = $CoyoteTimer
onready var jump_buffer_timer: Timer = $JumpBufferTimer
onready var anim_tree: AnimationTree = $AnimationTree
# optional built-in virtual _init method
# built-in virtual _ready method
# remaining built-in virtual methods
# public methods
# private methods


func _ready() -> void:
	jump_buffer_timer.connect("timeout", self, "_on_jump_buffer_expire")
	_max_jump_velocity = -sqrt( 2 * _gravity * _max_jump_height)
	_min_jump_velocity = -sqrt( 2 * _gravity * _min_jump_height)
	#_mid_jump_velocity = -sqrt( 2 * _gravity * ((_min_jump_height + _max_jump_height) /2))


func _input(event: InputEvent) -> void:
	
	if event.is_action_pressed("c_jump"):
		_jump_key_pressed = true
		_jump_key_released = false
		jump_buffer_timer.start()
		
		if is_grounded || !coyote_timer.is_stopped():
			_jump()
	
	if event.is_action_released("c_jump"):
		_jump_key_released = true
		
		if _velocity.y < _min_jump_velocity: #for minimum height jump
			_velocity.y = _apply_adjusted_velocity(_min_jump_velocity) #returns negative
		elif !_is_falling: #cancel's jump to send the character down
			_velocity.y = _apply_adjusted_velocity(_min_jump_velocity) #returns positive


func _process(delta: float) -> void:
	#Place in _process check per frame & make coyote time more acurate
	is_grounded = _is_on_ground()
	_check_coyote_time()


func _physics_process(delta: float) -> void:
	_apply_movement(delta)


func _apply_adjusted_velocity(vel_y: float) -> float:
	return (abs(_max_jump_velocity) + _velocity.y) + vel_y


func _apply_movement(delta: float) -> void:
	#increase gravity when falling or peek is reached of the jump
	_apply_gravity(delta, !is_grounded && _velocity.y > 0)

	_velocity.x = (Input.get_action_strength("c_right") - Input.get_action_strength("c_left")) * MOVE_SPEED
	
	_adjust_facing_direction()

	if _jump_key_pressed && is_grounded:
		_jump(_jump_key_released)

	_velocity = move_and_slide(_velocity, FLOOR)
	
	if _velocity.y > 0:
		_is_jumping = false
		_is_falling = true

		#anim_tree.get("parameters/playback").travel("Fall")
	else:
		_is_falling = false
		
	_set_animations()
#	if !_is_jumping && !_is_falling: #is_grounded: NOTE: using is_grounded causes animation bug
#		if abs(_velocity.x) <= 0.01:
#			anim_tree.get("parameters/playback").travel("Idle")
#		else:
#			anim_tree.get("parameters/playback").travel("Run")
	
	#_is_falling = _velocity.y >= 0 #set boolean weather falling or not


func _set_animations() -> void:
	
	var is_moving: bool = abs(_velocity.x) > 0.01
	
	anim_tree["parameters/conditions/idle"] = !is_moving
	anim_tree["parameters/conditions/run"] = is_moving
	anim_tree["parameters/conditions/jump"] = _is_jumping
	anim_tree["parameters/conditions/fall"] = _is_falling
	anim_tree["parameters/conditions/grounded"]= is_grounded
	

func _jump(short_jump: bool = false) -> void:

	if _is_jumping:
		return

	#anim_tree.get("parameters/playback").travel("Jump")
	_velocity.y = _max_jump_velocity if !short_jump else _min_jump_velocity
	_is_jumping = true
	_jump_key_pressed = false
	_can_coyote_time = false 
	coyote_timer.stop()
	jump_buffer_timer.stop()
	

func _check_coyote_time() -> void:
	
	if is_grounded && !_is_jumping: #reset coyote time whenever the character touch the ground
		_can_coyote_time = true #no need to reset anywhere since coyote should only 
		return					#apply if character was previously grounded
	
	if !_can_coyote_time:
		return

	_can_coyote_time  = false
	coyote_timer.start()


func _apply_gravity(delta: float, has_multiplier: bool) -> void:

	_velocity.y += (_gravity * delta * (FALL_GRAVITY_MULTIPLIER if has_multiplier else 1.0))
	
	if _velocity.y > MAX_VELOCITY.y:
		_velocity.y = MAX_VELOCITY.y


func _adjust_facing_direction() -> void:
	if _velocity.x * _facing_direction < 0.0:
		_facing_direction *= -1
		graphic.scale.x = _facing_direction
	
	
func _is_on_ground() -> bool:
	for r in raycasts:
		if r.is_colliding():
			return true
	return false


func _on_jump_buffer_expire() -> void:
	_jump_key_pressed = false
