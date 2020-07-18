extends state_so
class_name fall_state_so

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
#func _start(controller: player_controller) -> void:
#	pass


#Called per _physics_process
func _update(delta: float, controller: player_controller) -> void:
	controller.apply_fall_gravity(delta)
	controller.apply_movement()

	if controller.is_grounded && controller.is_on_floor(): 
#		if _jump_buffer_active:
#			jump_buffer_timer.stop()
#			_jump_buffer_active = false
#			_end("Jump")
#		else:
#			_end("Idle")
		_end("Idle", controller)
#Transitioning part here
#func _end(key: String, controller: player_controller) -> void:
#	controller.set_new_state(key)
