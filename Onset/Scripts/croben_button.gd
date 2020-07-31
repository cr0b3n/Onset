class_name CrobenButton
extends BaseButton

# signals               i.e signal my_signal(value, other_value) / signal my_signal
# enums                 i.e enum MoveDirection {UP, DOWN, LEFT, RIGHT}
# constants             i.e const MOVE_SPEED: float = 50.0
# exported variables    i.e export(PackedScene) var scene_file / export var scene_file: PackedScene
export(float, 1.0, 2.0) var max_scale = 1.2
export(float, 10.0) var scale_speed = 8.0
export(Color) var pressed_color = Color.orange
# public variables      i.e var a: int = 2
# private variables     i.e var _b: String = "text"
var _is_scaling: bool = false
var _original_color: Color
# onready variables     i.e onready var player_anim: AnimationPlayer = $AnimationPlayer

# optional built-in virtual _init method
# built-in virtual _ready method
# remaining built-in virtual methods
# public methods
# private methods


func _ready() -> void:
	_original_color = self_modulate
	rect_pivot_offset = rect_size *.5
	
	connect("button_down", self, "_on_button_down")
	connect("button_up", self, "_on_button_up")
	connect("mouse_entered", self, "_on_mouse_entered")
	connect("mouse_exited", self, "_on_mouse_exited")
	connect("visibility_changed", self, "_on_visibility_changed")
	#connect("focus_exited", self, "_on_focus_exited")
	#print("ancestor ready")


#func _process(delta: float) -> void:
#	print("test")


func _on_mouse_entered() -> void:
	_is_scaling = true
	rect_scale = Vector2.ONE
	_scale(rect_scale, Vector2.ONE * max_scale, _is_scaling)


func _on_mouse_exited() -> void:
	_is_scaling = false
	_scale(rect_scale, Vector2.ONE, _is_scaling)


func _on_button_down() -> void:
	self_modulate = pressed_color


func _on_button_up() -> void:
	self_modulate = _original_color


func _on_visibility_changed() -> void:
	_is_scaling = false
	rect_scale = Vector2.ONE


#func _on_focus_exited() -> void:
#	print("focus loss")


func _scale(from: Vector2, target: Vector2, scale_status: bool) -> void:
	
	var progress: float = 0.0
	#print(get_process_delta_time())
	while progress < 1:
		
		if _is_scaling != scale_status:
			#print("stopping coroutine " + name)
			break
		
		#print("scaling up " + String(_is_scaling) + " " + name)
		rect_scale = lerp(from, target, progress)
		progress += (scale_speed * get_process_delta_time())
		yield(get_tree(), "idle_frame")
	
	rect_scale = target #incase the coroutine under or over scale
