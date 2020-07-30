extends Node2D


const WIDTH: float = 947.0

export(float) var speed = 50.0


#func _ready() -> void:
#	pass


func _physics_process(delta: float) -> void:
	
	position.y += speed * delta
	
	if position.y > WIDTH:
		position.y = -WIDTH
	
