class_name StateFall
extends State


#Setup or reset values here
#func _start(controller) -> void:
#	controller.was_off_platform = true


#Called per _physics_process
func _update(delta, controller) -> void:
	controller.apply_fall_gravity(delta)
	controller.apply_movement()

	if controller.input.jump_pressed:
		controller.jump_buffer_timer.start()
		
	if controller.is_grounded && controller.is_on_floor(): 

		get_platform(controller)
		
		if !controller.jump_buffer_timer.is_stopped():
			_end("Jump", controller)
		else:
			_end("Idle", controller)


#Transitioning part here
#func _end(key: String, controller: player_controller) -> void:
#	controller.set_new_state(key)


func get_platform(controller) -> void:
	for r in controller.ground_raycasts:
		if  r.is_colliding():
			
			var platform = r.get_collider()
			
			if platform is Platform:
				platform.get_points(controller.jump_x_pos,
					controller.global_position.x, controller)
		return
