extends state


const DASH_TIME: float = 0.2

var _dash_speed: float = 15 * Global.TILE_SIZE
var _dash_timer: float #Dash timer like this is applicable because dash track in one state
var _dash_dir: int


func _start(fsm) -> void:
	._start(fsm)
	_dash_dir = 0 #Reset dash direction each start will be set once in _update
	_dash_timer = 0


func _update(delta: float, body: KinematicBody2D, input: player_input, is_grounded: bool) -> void:

	if _dash_dir == 0:
		_dash_dir = input.x_direction
	
	_dash_timer += delta
	body.move_and_slide(Vector2(_dash_speed * _dash_dir, 0))
	
	if input.jump_pressed:
		_end("Jump")
	elif !is_grounded:
		_end("Fall")
	elif _dash_timer > DASH_TIME:
		_end("Idle")
	
	#	elif dash_timer.is_stopped(): #Dash on air without gravity
#		if !is_grounded:
#			_end("Fall")
#		else:
#			_end("Idle")
