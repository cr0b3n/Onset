extends state_so
class_name fall_state_so


#Setup or reset values here
#func _start(controller: player_controller) -> void:
#	pass


#Called per _physics_process
func _update(delta: float, controller: player_controller) -> void:
	controller.apply_fall_gravity(delta)
	controller.apply_movement()

	if controller.input.jump_pressed:
		controller.jump_buffer_timer.start()
		
	if controller.is_grounded && controller.is_on_floor(): 
		if !controller.jump_buffer_timer.is_stopped():
			_end("Jump", controller)
		else:
			_end("Idle", controller)


#Transitioning part here
#func _end(key: String, controller: player_controller) -> void:
#	controller.set_new_state(key)
