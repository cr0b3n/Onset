tool
extends state
class_name idle_state


export(NodePath) var coyote_timer_path setget set_coyote_timer_path

var is_coyote: bool
#var stop_offset: float = 40.0 #IF UPDATED ALSO UPDATE MOVEMENT STATE
var _wall_raycast: RayCast2D

#CoyoteTimer is shared between Run and Idle so it's necessary to have 1 for both
onready var coyote_timer: Timer = get_node(coyote_timer_path)


func _get_configuration_warning() -> String:
	
	var warnings: String = ""

	if coyote_timer_path == "":
		warnings += "\nPlease add a timer node path!"
	
	return warnings


func set_coyote_timer_path(value: String) -> void:
	coyote_timer_path = value
	update_configuration_warning()


func _ready() -> void:
	_set_wall_raycast()

func _set_wall_raycast() -> void:
	_wall_raycast = get_parent().get_parent().get_node("CollisionBox/WallRayCast")


func _start(fsm) -> void:
	._start(fsm)
	is_coyote = false


func _update(delta: float, body: KinematicBody2D, input: input_controller, is_grounded: bool) -> void:
	var is_transitioning: bool = _apply_transition(input, is_grounded)
	
	if !is_transitioning:
		_check_horizontal(body, input)


func _apply_transition(input: input_controller, is_grounded: bool) -> bool:
	if input.jump_pressed:
		_end("Jump")
		coyote_timer.stop()
		return true
	elif !is_grounded:
		_enter_coyote_mode()
		return true
	elif input.dash_pressed:
		_end("Dash")
		return true
		
	return false


func _check_horizontal(body: KinematicBody2D, input: input_controller) -> void:

	if (input.horizontal != 0 || !input.target_reached) && !_has_obstacle(input): #(_is_not_on_target_position(body, input) && !input.target_canceled):
		_end("Run")


func _enter_coyote_mode() -> void:
	
	if !is_coyote:
		is_coyote = true
		
		if coyote_timer.is_stopped(): #Check if it's already ticking to avoid endless timer reset when changing state
			coyote_timer.start()

	elif coyote_timer.is_stopped(): 
		_end("Fall")


#func _has_obstacle(body: KinematicBody2D, input: player_input) -> Dictionary:
#	var space_state: Physics2DDirectSpaceState = body.get_world_2d().direct_space_state
#	#The collision mask 2 refers to ground alone hover mouse on mask to know the conbination of bit to enable then add values
#	#body.global_position.y + 100 means raycast is near the foot can be check by placing a raycast node with y = 100 & rotation 90
#	var result: Dictionary = space_state.intersect_ray(body.global_position\
#			, Vector2(body.global_position.x + (input.x_direction * stop_offset), body.global_position.y - 100), [body], 2)
#
#	return result

func _has_obstacle(input: input_controller) -> bool:
#	_wall_raycast.cast_to = Vector2(_wall_raycast.cast_to.x * input.x_direction, 0) 
#	print(_wall_raycast.cast_to)
	return _wall_raycast.is_colliding()
