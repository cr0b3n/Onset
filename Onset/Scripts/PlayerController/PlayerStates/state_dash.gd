extends state
class_name state_dash


const DASH_TIME: float = 0.2

#Might be better to set _dash_speed as exported variable
var _dash_speed: float = 15 * 128 #Global.TILE_SIZE
var _dash_timer: float #Dash timer like this is applicable because dash track in one state
var _dash_dir: int


#Setup or reset values here
func _start(controller) -> void:
	_dash_timer = 0
	_dash_dir = controller.input.x_direction


#Called per _physics_process
func _update(delta, controller) -> void:
	
	_dash_timer += delta
	controller.move_and_slide(Vector2(_dash_speed * _dash_dir, 0))
	
	if controller.input.jump_pressed:
		_end("Jump", controller)
	elif !controller.is_grounded:
		_end("Fall", controller)
	elif _dash_timer > DASH_TIME:
		_end("Idle", controller)


#Transitioning part here
#func _end(key: String, controller: player_controller) -> void:
#	controller.set_new_state(key)
