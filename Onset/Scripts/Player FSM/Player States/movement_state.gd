extends Node
class_name movement_state


# signals               i.e signal my_signal(value, other_value) / signal my_signal
#signal direction_changed(dir)
# enums                 i.e enum MoveDirection {UP, DOWN, LEFT, RIGHT}
# constants             i.e const MOVE_SPEED: float = 50.0
const MOVE_SPEED: float = 5.0 * Global.TILE_SIZE
const FLOOR: Vector2 = Vector2.UP
const MAX_Y_VELOCITY: float = 3000.0
const FALL_GRAVITY_MULTIPLIER: float = 1.7
# exported variables    i.e export(PackedScene) var scene_file / export var scene_file: PackedScene
# public variables      i.e var a: int = 2
var current_velocity: Vector2 = Vector2.ZERO
var stop_offset: float = 25.0 #IF UPDATED ALSO UPDATE IDLE
# private variables     i.e var _b: String = "text"
#var _facing_direction: int = 1
var _gravity: float = Global.gravity
# onready variables     i.e onready var player_anim: AnimationPlayer = $AnimationPlayer

# optional built-in virtual _init method
# built-in virtual _ready method
# remaining built-in virtual methods
# public methods
# private methods


func update(delta: float, body: KinematicBody2D, input: player_input, is_grounded: bool) -> void:
	#increase gravity when falling or peek is reached of the jump
	_apply_gravity(delta, !is_grounded && current_velocity.y > 0)
	_apply_movement(delta, body, input)


func _apply_gravity(delta: float, has_multiplier: bool) -> void:

	current_velocity.y += (_gravity * delta * (FALL_GRAVITY_MULTIPLIER if has_multiplier else 1.0))
	
	if current_velocity.y > MAX_Y_VELOCITY:
		current_velocity.y = MAX_Y_VELOCITY


func _apply_movement(delta: float, body: KinematicBody2D, input: player_input) -> void:
	
	if input.horizontal != 0: #Keyboard base movement
		current_velocity.x = input.horizontal * MOVE_SPEED
	#Catch excess or cancelled movement
	elif (input.x_direction < 0 && input.target_x_pos >= body.global_position.x - stop_offset) || \
		(input.x_direction > 0 && input.target_x_pos <= body.global_position.x + stop_offset) || \
		input.target_canceled:
			
		current_velocity.x = 0
	else: #Mouse base movement
		current_velocity.x = input.x_direction * MOVE_SPEED
			
	current_velocity = body.move_and_slide(current_velocity, FLOOR)
