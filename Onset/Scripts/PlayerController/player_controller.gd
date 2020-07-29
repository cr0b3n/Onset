class_name PlayerController
extends KinematicBody2D


# signals               i.e signal my_signal(value, other_value) / signal my_signal
signal score_added(score)
# enums                 i.e enum MoveDirection {UP, DOWN, LEFT, RIGHT}
# constants             i.e const MOVE_SPEED: float = 50.0
const MOVE_SPEED: float = 5.0 * Global.TILE_SIZE
const FLOOR: Vector2 = Vector2.UP
const MAX_Y_VELOCITY: float = 3000.0
const FALL_GRAVITY_MULTIPLIER: float = 1.5
#const JUMP_DURATION: float = 0.5
# exported variables    i.e export(PackedScene) var scene_file / export var scene_file: PackedScene
# public variables      i.e var a: int = 2
var current_velocity: Vector2 = Vector2.ZERO
var is_grounded: bool = false
var is_uninteruptible: bool = false
#Jump variables
var jump_x_pos: float
var max_jump_velocity: float
var min_jump_velocity: float
#var was_off_platform: bool = false
# private variables     i.e var _b: String = "text"
var _states: = {}
var _cur_state #DO NOT Static Type state_so
var _gravity: float 
var _anim_state #AnimationNodeStateMachine asigned on _ready cannot by static typed
# onready variables     i.e onready var player_anim: AnimationPlayer = $AnimationPlayer
onready var coyote_timer: Timer = $CoyoteTimer
onready var jump_buffer_timer: Timer = $JumpBufferTimer
onready var graphic: Node2D = $Graphic
onready var ground_raycasts: Array = [$CollisionBoxAndInput/LeftRayCast,
	$CollisionBoxAndInput/RightRayCast]
onready var obstacle_raycast: RayCast2D = $CollisionBoxAndInput/ObstacleRayCast
onready var input: InputController = $CollisionBoxAndInput
onready var jump_effect_pool: ParticlePooler = $JumpBufferTimer
onready var step_effect_pool: ParticlePooler = $CoyoteTimer
onready var dash_effect_pool: ParticlePooler = $AnimationPlayer
# optional built-in virtual _init method
# built-in virtual _ready method
# remaining built-in virtual methods
# public methods
# private methods


func _ready() -> void:
	_states["Idle"] = StateIdle.new()
	_states["Run"] = StateRun.new()
	_states["Jump"] = StateJump.new()
	_states["Fall"] = StateFall.new()
	_states["Dash"] = StateDash.new()

	#Set up Animation
	var anim_tree: AnimationTree = $AnimationTree
	anim_tree.active = true #Activate animation tree then asign AnimationNodeStateMachine to anim_state
	_anim_state = anim_tree.get("parameters/playback")
	set_new_state("Idle")
	#Connect to movement state signal to determine facing directions
	input.connect("x_direction_changed", self, "on_direction_changed")
	#Setup jumping velocity and gravity
	var min_jump_height: float = 1.5 * Global.TILE_SIZE
	var max_jump_height: float = 3.8 * Global.TILE_SIZE 
	_gravity = 2 * max_jump_height / pow(0.5, 2) #0.5 is JUMP_DURATION
	max_jump_velocity = -sqrt( 2 * _gravity * max_jump_height)
	min_jump_velocity = -sqrt( 2 * _gravity * min_jump_height)


func _process(delta: float) -> void:
	#Place in _process check per frame & make coyote time more acurate
	is_grounded = _is_on_ground()


func _physics_process(delta: float) -> void:
	_cur_state._update(delta, self)


func set_new_state(key: String) -> void:
	_cur_state = _states[key]
	_cur_state._start(self)
	_anim_state.travel(key)


#func apply_gravity(delta: float, has_multiplier: bool) -> void:
#	current_velocity.y += (_gravity * delta * (FALL_GRAVITY_MULTIPLIER if has_multiplier else 1.0))
#
#	if current_velocity.y > MAX_Y_VELOCITY:
#		current_velocity.y = MAX_Y_VELOCITY

func apply_fall_gravity(delta: float) -> void:
	current_velocity.y += (_gravity * delta * FALL_GRAVITY_MULTIPLIER) #(FALL_GRAVITY_MULTIPLIER if has_multiplier else 1.0))
	if current_velocity.y > MAX_Y_VELOCITY:
		current_velocity.y = MAX_Y_VELOCITY


func apply_gravity(delta: float) -> void:
	current_velocity.y += (_gravity * delta) 


func apply_gravity_and_movement(delta: float) -> void:
	apply_gravity(delta)
	apply_movement()


func apply_movement() -> void:
	
	if input.horizontal != 0: #Keyboard base movement
		current_velocity.x = input.horizontal * MOVE_SPEED
	#Catch excess or cancelled movement! DO NOT REMOVE!!! Other wise will overshoot
	elif input.target_reached:
		current_velocity.x = 0
	else: #Mouse base movement
		current_velocity.x = input.x_direction * MOVE_SPEED

	current_velocity = move_and_slide(current_velocity, FLOOR)


func has_obstacle() -> bool:
	return obstacle_raycast.is_colliding()


func on_direction_changed(direction: float) -> void:
	
	if is_uninteruptible:
		return
	
	graphic.scale.x = direction
	obstacle_raycast.scale.x = direction


func add_score(score: int) -> void:
	emit_signal("score_added", score)


func show_jump_effect() -> void:
	if !is_grounded:
		return
		
	jump_effect_pool.get_particle(Vector2(global_position.x,
		global_position.y + 111.0)).restart()


func foot_step() -> void:
	_show_ground_effect(step_effect_pool)


func show_dash_effect() -> void:
	_show_ground_effect(dash_effect_pool)


func _show_ground_effect(pool: ParticlePooler) -> void:
	if !is_grounded:
		return
	
	var p: CPUParticles2D = pool.get_particle(obstacle_raycast.global_position)
	p.scale.x = graphic.scale.x
	p.restart()


func _is_on_ground() -> bool:

#	for i in ground_raycasts.size():
#		if ground_raycasts[i].is_colliding():
#			return true
	
	for r in ground_raycasts:
		if  r.is_colliding():
			return true
	return false
