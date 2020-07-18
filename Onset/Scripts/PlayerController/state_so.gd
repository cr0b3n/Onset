extends Resource
class_name state_so


#Setup or reset values here
func _start(controller: player_controller) -> void:
	pass


#Called per _physics_process
func _update(delta: float, controller: player_controller) -> void:
	pass


#Transitioning part here
func _end(key: String, controller: player_controller) -> void:
	controller.set_new_state(key)
