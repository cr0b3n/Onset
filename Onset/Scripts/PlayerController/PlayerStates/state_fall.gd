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

		_get_platform(controller)
		
		if !controller.jump_buffer_timer.is_stopped():
			_end("Jump", controller)
		else:
			Global.show_jump_effect(controller.obstacle_raycast.global_position)
			Global.play_player_audio(Global.LAND, true)
			_end("Idle", controller)


#Transitioning part here
#func _end(key: String, controller: player_controller) -> void:
#	controller.set_new_state(key)


func _get_platform(controller) -> void:
	for r in controller.ground_raycasts:

		if r.is_colliding():
			var platform = r.get_collider()

			if platform is Platform:
				platform.get_points(controller)
			return
			
	return
