extends AnimationTree
class_name player_animation

# signals               i.e signal my_signal(value, other_value) / signal my_signal
# enums                 i.e enum MoveDirection {UP, DOWN, LEFT, RIGHT}
# constants             i.e const MOVE_SPEED: float = 50.0
#const CONDITIONS_PATH: String = "parameters/conditions/"
# exported variables    i.e export(PackedScene) var scene_file / export var scene_file: PackedScene
# public variables      i.e var a: int = 2
#var m_player: player
# private variables     i.e var _b: String = "text"
# onready variables     i.e onready var player_anim: AnimationPlayer = $AnimationPlayer
onready var anim_state: AnimationNodeStateMachine = get("parameters/playback")
# optional built-in virtual _init method
# built-in virtual _ready method
# remaining built-in virtual methods
# public methods
# private methods

func _ready() -> void:
	active = true


func _on_state_changed(key: String) -> void:
	anim_state.travel(key)
#func _physics_process(delta: float) -> void:
#	_apply_animation_conditions()
#
#
#func _apply_animation_conditions() -> void:
#
#	var is_moving: bool = abs(m_player.current_velocity.x) > 0.01
#
#	self[CONDITIONS_PATH + "idle"] = !is_moving
#	self[CONDITIONS_PATH + "run"] = is_moving
#	self[CONDITIONS_PATH + "jump"] = m_player.is_jumping
#	self[CONDITIONS_PATH + "fall"] = m_player.is_falling
#	self[CONDITIONS_PATH + "grounded"] = m_player.is_grounded

