extends Reference

class_name EntityFilter

signal entity_added(entity)
signal entity_removed(entity)

var valid_entities : Array = [] # for changing by ECS
var entity_signature : Dictionary


func _init(signature:Dictionary): # Filter registration lies on it owner
	entity_signature = signature.duplicate(true)


func add_entity(entity:Entity): # Only for use in ECS autoload!
	valid_entities.append(entity)
	
	emit_signal("entity_added", entity)


func remove_entity(entity:Entity): # Only for use in ECS autoload!
	valid_entities.erase(entity)
	
	emit_signal("entity_removed", entity)
