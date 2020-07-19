class_name StateIdle
extends State


var _is_coyote: bool
#controller param refers to player_controller
#Since Static typing can sometimes lead to errors in godot ver 3.2.2


#Setup or reset values here
func _start(controller) -> void:
	_is_coyote = false


func _update(delta, controller) -> void:
	_apply_transition(controller)
	

func _apply_transition(controller) -> void:
	if controller.input.jump_pressed:
		_end("Jump", controller)
		controller.coyote_timer.stop()
	elif !controller.is_grounded:
		_enter_coyote_mode(controller)
	elif controller.input.dash_pressed:
		_end("Dash", controller)
	elif _has_horizontal_movement(controller):
		_horizontal_transition(controller)


func _has_horizontal_movement(controller) -> bool:
	return (controller.input.horizontal != 0 || !controller.input.target_reached) && !controller.has_obstacle()


func _horizontal_transition(controller) -> void:
	_end("Run", controller)


func _enter_coyote_mode(controller) -> void:
	#_end("Fall", controller)
	if !_is_coyote:
		_is_coyote = true

		if controller.coyote_timer.is_stopped(): #Check if it's already ticking to avoid endless timer reset when changing state
			controller.coyote_timer.start()

	elif controller.coyote_timer.is_stopped(): 
		_end("Fall", controller)
