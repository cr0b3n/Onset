extends idle_state_so
class_name run_state_so

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
	#controller.apply_gravity_and_movement(delta)
	controller.apply_movement()
	._update(delta, controller)


func _has_horizontal_movement(controller: player_controller) -> bool:
	return controller.current_velocity.x  == 0|| controller.has_obstacle()


func _horizontal_transition(controller: player_controller) -> void:
	_end("Idle", controller)
