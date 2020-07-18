extends state_so
class_name idle_state_so


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


func _update(delta: float, controller: player_controller) -> void:
	_apply_transition(controller)


func _apply_transition(controller: player_controller) -> void:
	if controller.input.jump_pressed:
		_end("Jump", controller)
		#coyote_timer.stop()
	elif !controller.is_grounded:
		_enter_coyote_mode(controller)
	elif controller.input.dash_pressed:
		_end("Dash", controller)
	elif _has_horizontal_movement(controller):
		_horizontal_transition(controller)


func _has_horizontal_movement(controller: player_controller) -> bool:
	return (controller.input.horizontal != 0 || !controller.input.target_reached) && !controller.has_obstacle()


func _horizontal_transition(controller: player_controller) -> void:
	_end("Run", controller)


func _enter_coyote_mode(controller: player_controller) -> void:
	_end("Fall", controller)
#	if !is_coyote:
#		is_coyote = true
#
#		if coyote_timer.is_stopped(): #Check if it's already ticking to avoid endless timer reset when changing state
#			coyote_timer.start()
#
#	elif coyote_timer.is_stopped(): 
#		_end("Fall")
