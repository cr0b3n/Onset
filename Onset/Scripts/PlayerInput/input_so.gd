extends Resource
class_name input_so


#Always reset since values of scriptable objects are stored
func _setup() -> void:
	pass


#Preferable called _event & unhandle event
func _check_inputs(event: InputEvent, controller: input_controller) -> void:
	pass


#Preferable called on _process & _physics process
func _update(delta: float, controller: input_controller) -> void:
	pass


