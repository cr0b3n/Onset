class_name StateDash
extends State


const DASH_TIME: float = 0.2
const EFFECT_TIME: float = 0.025

#Might be better to set _dash_speed as exported variable
var _dash_speed: float = 15 * 128 #Global.TILE_SIZE
var _dash_timer: float #Dash timer like this is applicable because dash track in one state
var _dash_dir: int
var _effect_timer: float


#Setup or reset values here
func _start(controller) -> void:
	_effect_timer = 0
	_dash_timer = 0
	_dash_dir = controller.input.x_direction
	controller.is_uninteruptible = true


#Called per _physics_process
func _update(delta, controller) -> void:
	
	_dash_timer += delta
	_effect_timer += delta
	
	if _effect_timer >= EFFECT_TIME:
		show_dash_effect(controller)
		_effect_timer = 0
	
	controller.move_and_slide(Vector2(_dash_speed * _dash_dir, 0))
	
	if controller.input.jump_pressed:
		_end("Jump", controller)
	elif !controller.is_grounded:
		_end("Fall", controller)
	elif _dash_timer > DASH_TIME:
		controller.foot_step()
		_end("Idle", controller)


#Transitioning part here
func _end(key, controller) -> void:
	controller.is_uninteruptible = false
	controller.on_direction_changed(controller.input.x_direction)
	._end(key, controller)


#Transitioning part here
#func _end(key: String, controller: player_controller) -> void:
#	controller.set_new_state(key)


func show_dash_effect(controller) -> void:
	if !controller.is_grounded:
		return
	
	Global.show_dash_effect(controller.obstacle_raycast.global_position,
		 controller.graphic.scale.x)


