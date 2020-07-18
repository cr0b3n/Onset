extends state_so
class_name jump_state_so

# signals               i.e signal my_signal(value, other_value) / signal my_signal
# enums                 i.e enum MoveDirection {UP, DOWN, LEFT, RIGHT}
# constants             i.e const MOVE_SPEED: float = 50.0
# exported variables    i.e export(PackedScene) var scene_file / export var scene_file: PackedScene
# public variables      i.e var a: int = 2
# private variables     i.e var _b: String = "text"
# onready variables     i.e onready var player_anim: AnimationPlayer = $AnimationPlayer

# optional built-in virtual _init method
# built-in virtual _ready method
# remaining built-in virtual methods
# public methods
# private methods


#Setup or reset values here
func _start(controller: player_controller) -> void:
	_jump(controller, controller.input.input_jump_release)
	controller.jump_buffer_timer.stop()
	controller.coyote_timer.stop()


#Called per _physics_process
func _update(delta: float, controller: player_controller) -> void:
	controller.apply_gravity_and_movement(delta)
	_apply_air_movement(controller)
	
	if controller.current_velocity.y > 0:
		_end("Fall", controller)


##Transitioning part here
#func _end(key: String, controller: player_controller) -> void:
#	controller.change_state(key)


func _apply_air_movement(controller: player_controller) -> void:

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


func _jump(controller: player_controller, short_jump: bool) -> void:
	controller.current_velocity.y = controller.min_jump_velocity if short_jump else controller.max_jump_velocity


#To smooth out the jump before falling. abs(max_vel) - min_vel and cur_vel to effectively bring the vel cdown
func _adjust_jump_velocity(controller: player_controller) -> float:
	#print(controller.current_velocity.y)
	return ((controller.max_jump_velocity * -1) + controller.current_velocity.y) + controller.min_jump_velocity
#	return (abs(controller.max_jump_velocity) + controller.current_velocity.y) + vel_y

