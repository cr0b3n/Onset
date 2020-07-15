extends KinematicBody2D
class_name player

# signals               i.e signal my_signal(value, other_value) / signal my_signal
# enums                 i.e enum MoveDirection {UP, DOWN, LEFT, RIGHT}
# constants             i.e const MOVE_SPEED: float = 50.0
# exported variables    i.e export(PackedScene) var scene_file / export var scene_file: PackedScene
# public variables      i.e var a: int = 2
var is_grounded: bool = false
var anim_state #AnimationNodeStateMachine asigned on _ready cannot by static typed
# private variables     i.e var _b: String = "text"
# onready variables     i.e onready var player_anim: AnimationPlayer = $AnimationPlayer
onready var graphic: Node2D = $Graphic
onready var raycasts: Array = $CollisionBox.get_children()

# optional built-in virtual _init method
# built-in virtual _ready method
# remaining built-in virtual methods
# public methods
# private methods


func _ready() -> void:
	#Connect to movement state signal to determine facing directions
	#$PlayerFSM/MovementState.connect("direction_changed", self, "on_direction_changed")
	var input: player_input = $PlayerInput
	input.connect("x_direction_changed", self, "on_direction_changed")

	#Connect to player state machine to apply new animation on state change
	var fsm: = $PlayerFSM
	fsm.connect("state_changed", self, "on_state_changed")
	fsm.m_player = self
	fsm.m_player_input = input
	
	var anim_tree: AnimationTree = $AnimationTree
	anim_tree.active = true #Activate animation tree then asign AnimationNodeStateMachine to anim_state
	anim_state = anim_tree.get("parameters/playback")


func _process(delta: float) -> void:
	#Place in _process check per frame & make coyote time more acurate
	is_grounded = _is_on_ground()
#
#	if $PlayerInput.dash_pressed:
#		print(get_global_mouse_position())
#		print(get_local_mouse_position())


func on_direction_changed(direction: float) -> void:
	graphic.scale.x = direction


func _is_on_ground() -> bool:
	for r in raycasts:
		if r.is_colliding():
			return true
	return false


func on_state_changed(key: String) -> void:
	anim_state.travel(key)
