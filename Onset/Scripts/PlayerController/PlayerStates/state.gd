class_name state


#Static Typing doesn't work well in Godot as of ver. 3.2.2
#So use default dynamic type for this kind of behavior
func _start(controller) -> void:
	pass


#Called per _physics_process
func _update(delta, controller) -> void:
	pass


#Transitioning part here
func _end(key, controller) -> void:
	controller.set_new_state(key)


#Setup or reset values here
#func _start(controller: player_controller) -> void:
#	pass


#Called per _physics_process
#func _update(delta: float, controller: player_controller) -> void:
#	pass
#
#
##Transitioning part here
#func _end(key: String, controller: player_controller) -> void:
#	controller.set_new_state(key)
