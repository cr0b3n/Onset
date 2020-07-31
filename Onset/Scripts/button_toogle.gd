class_name ButtonToggle
extends CrobenButton

# signals               i.e signal my_signal(value, other_value) / signal my_signal
# enums                 i.e enum MoveDirection {UP, DOWN, LEFT, RIGHT}
# constants             i.e const MOVE_SPEED: float = 50.0
# exported variables    i.e export(PackedScene) var scene_file / export var scene_file: PackedScene
export(Color) var toogle_off_color = Color.gray
# public variables      i.e var a: int = 2
# private variables     i.e var _b: String = "text"
# onready variables     i.e onready var player_anim: AnimationPlayer = $AnimationPlayer

# optional built-in virtual _init method
# built-in virtual _ready method
# remaining built-in virtual methods
# public methods
# private methods



func _toggled(button_pressed: bool) -> void:
	
	if !button_pressed:
		self_modulate = toogle_off_color


#func _process(delta: float) -> void:
#   pass


#func _physics_process(delta: float) -> void:
#	pass
