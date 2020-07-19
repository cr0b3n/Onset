extends state_idle
class_name state_run


#controller param refers to player_controller
#Since Static typing can sometimes lead to errors in godot ver 3.2.2

func _update(delta, controller) -> void:
	#controller.apply_gravity_and_movement(delta)
	controller.apply_movement()
	._update(delta, controller)


func _has_horizontal_movement(controller) -> bool:
	return controller.current_velocity.x  == 0|| controller.has_obstacle()


func _horizontal_transition(controller) -> void:
	_end("Idle", controller)
