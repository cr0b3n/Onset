class_name StateJump
extends State


#controller param refers to player_controller
#Since Static typing can sometimes lead to errors in godot ver 3.2.2


#Setup or reset values here
func _start(controller) -> void:
	_jump(controller, controller.input.input_jump_release)
	controller.jump_buffer_timer.stop()
	controller.coyote_timer.stop()
	controller.jump_x_pos = controller.global_position.x
	show_jump_effect(controller)


#Called per _physics_process
func _update(delta, controller) -> void:
	controller.apply_gravity_and_movement(delta)
	_apply_air_movement(controller)
	
	if controller.current_velocity.y > 0:
		_end("Fall", controller)


##Transitioning part here
#func _end(key: String, controller: player_controller) -> void:
#	controller.change_state(key)


func _apply_air_movement(controller) -> void:

	if controller.input.jump_pressed:
		controller.jump_buffer_timer.start()

	if controller.input.jump_released:
		if controller.current_velocity.y < controller.min_jump_velocity: #for minimum height jump
#			print(controller.current_velocity.y)
			var d: float = (-1 * controller.min_jump_velocity) + controller.current_velocity.y
			controller.current_velocity.y = d#-sqrt( 2 * Global.gravity * (abs(d)/128))#returns negative
#			print(controller.current_velocity.y)
#			print (controller.min_jump_velocity)
		elif controller.current_velocity.y < 0: #cancel's jump to send the character down
			controller.current_velocity.y = _adjust_jump_velocity(controller) #returns positive
			#print("cancelled")


#short_jump: bool
func _jump(controller, short_jump) -> void:
	controller.current_velocity.y = controller.min_jump_velocity if short_jump else controller.max_jump_velocity


#To smooth out the jump before falling. abs(max_vel) - min_vel and cur_vel to effectively bring the vel cdown
func _adjust_jump_velocity(controller) -> float:
	#print(controller.current_velocity.y)
	return ((controller.max_jump_velocity * -1) + controller.current_velocity.y) + controller.min_jump_velocity
#	return (abs(controller.max_jump_velocity) + controller.current_velocity.y) + vel_y


func show_jump_effect(controller) -> void:
	if !controller.is_grounded:
		return
	
	Global.get_jump_effect(controller.obstacle_raycast.global_position)

