extends state_machine

# signals               i.e signal my_signal(value, other_value) / signal my_signal
# enums                 i.e enum MoveDirection {UP, DOWN, LEFT, RIGHT}
# constants             i.e const MOVE_SPEED: float = 50.0
# exported variables    i.e export(PackedScene) var scene_file / export var scene_file: PackedScene
# public variables      i.e var a: int = 2
var m_player: player
# private variables     i.e var _b: String = "text"
# onready variables     i.e onready var player_anim: AnimationPlayer = $AnimationPlayer

# optional built-in virtual _init method
# built-in virtual _ready method
# remaining built-in virtual methods
# public methods
# private methods

func _ready() -> void:
	_current_state = get_node(states_dictionary["Idle"])
	_current_state._start(self)


func _physics_process(delta: float) -> void:
	
	if _current_state == null:
		return
	
	_current_state._update(delta, m_player, m_player.input, m_player.is_grounded)


func _set_state(key: String) -> void:
	_current_state = get_node(states_dictionary[key])
	_current_state._start(self)
	._set_state(key)
