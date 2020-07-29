extends Node

# signals               i.e signal my_signal(value, other_value) / signal my_signal
# enums                 i.e enum MoveDirection {UP, DOWN, LEFT, RIGHT}
# constants             i.e const MOVE_SPEED: float = 50.0
const TILE_SIZE: float = 128.0
#const JUMP_DURATION: float = 0.5
#var _max_jump_height: float = 3.5 * TILE_SIZE
#var gravity: float = 2 * _max_jump_height / pow(JUMP_DURATION, 2)
# exported variables    i.e export(PackedScene) var scene_file / export var scene_file: PackedScene
# public variables      i.e var a: int = 2
var has_touch: bool = OS.has_touchscreen_ui_hint()
var top_score: int = 0
var restart_count: int  = 0
# private variables     i.e var _b: String = "text"
var _transition: TransitionController
var _step_effects: Array = []
var _dash_effects: Array = []
var _jump_effects: Array = []
# onready variables     i.e onready var player_anim: AnimationPlayer = $AnimationPlayer

# optional built-in virtual _init method
# built-in virtual _ready method
# remaining built-in virtual methods
# public methods
# private methods


#https://docs.godotengine.org/en/stable/getting_started/step_by_step/singletons_autoload.html
#use call_deferred("_deferred_goto_scene", path) to transition to next scenes

func _ready() -> void:
	_transition = ResourceLoader.load("res://Prefabs/Transition.tscn").instance()
	add_child(_transition)

	for i in range(2):
		get_jump_effect(Vector2(1, 1000))
	for i in range(2):
		get_step_effect(Vector2(1, 1000))
	for	i in range(5):
		get_dash_effect(Vector2(1, 1000))


func submit_score(score: int) -> bool:
	
	if score > top_score:
		top_score = score
		print("new top score: ", top_score)
		return true
	return false


func get_jump_effect(pos: Vector2) -> CPUParticles2D:
	return _get_effect(pos, _jump_effects, 0)


func get_step_effect(pos: Vector2) -> CPUParticles2D:
	return _get_effect(pos, _step_effects, 1)


func get_dash_effect(pos: Vector2) -> CPUParticles2D:
	return _get_effect(pos, _dash_effects, 2)


func _get_effect(pos: Vector2, effects: Array, e_type: int) -> CPUParticles2D:
	
	for p in effects:
		if  !p.emitting:
			p.global_position = pos
			p.restart()
			return p

	var e: CPUParticles2D

	if e_type == 0:
		e = load("res://Prefabs/JumpParticle.tscn").instance()
	elif e_type == 2:
		e = load("res://Prefabs/DashParticle.tscn").instance()
	else:
		e = load("res://Prefabs/StepParticle.tscn").instance()
	
	return _spawn_new_particle(pos, e, effects)


func _spawn_new_particle(pos: Vector2, effect: CPUParticles2D, effects: Array) -> CPUParticles2D:
	effect.global_position = pos
	effect.set_as_toplevel(true)
	add_child(effect)
	effects.append(effect)
	effect.restart()
	return effect


func scene_loaded() -> void:
	_transition.play_transition()
	yield(_transition, "transition_completed")
	_transition.enable_transition(false)


func change_scene(scene: int) -> void:
	_transition.enable_transition(true)
	_transition.play_transition()
	yield(_transition, "transition_completed")
	call_deferred("_load_scene", scene)


func _load_scene(scene: int) -> void: 
	if scene == 1:
		get_tree().change_scene("res://Gameplay Scenes/MainScene.tscn")
	else:
		get_tree().change_scene("res://Gameplay Scenes/MenuScene.tscn")


func restart_scene() -> void:
	_transition.enable_transition(true)
	_transition.play_transition()
	yield(_transition, "transition_completed")
	call_deferred("_restart_deferred")


func _restart_deferred() -> void:
	get_tree().reload_current_scene()
