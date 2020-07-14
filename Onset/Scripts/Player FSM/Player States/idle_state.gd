tool
extends extended_state
class_name idle_state


export(NodePath) var coyote_timer_path setget set_coyote_timer_path

var is_coyote: bool
#CoyoteTimer is shared between Run and Idle so it's necessary to have 1 for both
onready var coyote_timer: Timer = get_node(coyote_timer_path)


func _get_configuration_warning() -> String:
	
	var warnings: String = ""
	
	warnings += ._get_configuration_warning()
	
	if coyote_timer_path == "":
		warnings += "\nPlease add a timer node path!"
	
	return warnings


func set_coyote_timer_path(value: String) -> void:
	coyote_timer_path = value
	update_configuration_warning()


func _start(fsm) -> void:
	._start(fsm)
	is_coyote = false


func _update(delta: float, body: KinematicBody2D, input: player_input, is_grounded: bool) -> void:
	
	extra_state._update(delta, body, input, is_grounded)
	var is_transitioning: bool = _apply_transition(input, is_grounded)
	
	if !is_transitioning:
		_check_horizontal(input)


func _apply_transition(input: player_input, is_grounded: bool) -> bool:
	if input.jump_pressed:
		_end("Jump")
		coyote_timer.stop()
		return true
	elif !is_grounded:
		_enter_coyote_mode()
		return true
	elif input.dash_pressed:
		_end("Dash")
	
	return false


func _check_horizontal(input: player_input) -> void:
	if abs(input.horizontal) > 0:
		_end("Run")


func _enter_coyote_mode() -> void:
	
	if !is_coyote:
		is_coyote = true
		
		if coyote_timer.is_stopped(): #Check if it's already ticking to avoid endless timer reset when changing state
			coyote_timer.start()

	elif coyote_timer.is_stopped(): 
		_end("Fall")
