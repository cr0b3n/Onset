class_name ParticlePooler
extends Node

# signals               i.e signal my_signal(value, other_value) / signal my_signal
# enums                 i.e enum MoveDirection {UP, DOWN, LEFT, RIGHT}
# constants             i.e const MOVE_SPEED: float = 50.0
# exported variables    i.e export(PackedScene) var scene_file / export var scene_file: PackedScene
export(PackedScene) var particle
# public variables      i.e var a: int = 2
# private variables     i.e var _b: String = "text"
var _particles: Array = []
# onready variables     i.e onready var player_anim: AnimationPlayer = $AnimationPlayer

# optional built-in virtual _init method
# built-in virtual _ready method
# remaining built-in virtual methods
# public methods
# private methods


func _ready() -> void:
	_spawn_new_particle(Vector2(1.0,1000.0))


func get_particle(pos: Vector2) -> CPUParticles2D:
	
	for p in _particles:
		if  !p.emitting:
			p.global_position = pos
			#print("recycled a particle")
			return p
	
	return _spawn_new_particle(pos)


func _spawn_new_particle(pos: Vector2) -> CPUParticles2D:
	var p: CPUParticles2D = particle.instance()
	p.global_position = pos
	p.set_as_toplevel(true)
	add_child(p)
	_particles.append(p)
	#print("created a new particle")
	return p


