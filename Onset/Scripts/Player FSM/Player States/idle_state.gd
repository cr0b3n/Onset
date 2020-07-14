tool
extends extended_state
class_name idle_state


export(NodePath) var coyote_timer_path setget set_coyote_timer_path

var is_coyote: bool

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
	_apply_transition(input, is_grounded)


func _apply_transition(input: player_input, is_grounded: bool) -> void:
	if input.jump_pressed:
		_end("Jump")
		coyote_timer.stop()
	elif !is_grounded:
		_enter_coyote_mode()
	elif abs(input.horizontal) > 0:
		_end("Run")


func _enter_coyote_mode() -> void:
	
	if !is_coyote:
		is_coyote = true
		
		if coyote_timer.is_stopped(): #Check if it's already ticking to avoid endless timer reset when changing state
			coyote_timer.start()

	elif coyote_timer.is_stopped(): 
		_end("Fall")
