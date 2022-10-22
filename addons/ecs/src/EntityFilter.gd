extends Reference

class_name EntityFilter

signal entity_added(entity)
signal entity_removed(entity)

var valid_entities : Array = [] # for changing by ECS
var entity_signature : EntitySignature


func _init(necessary_components:Array, banned_components:Array=[]): # Filter registration lies on it owner
	entity_signature = EntitySignature.new()
	entity_signature.add_several_necessary(necessary_components)
	entity_signature.add_several_banned(banned_components)


func add_entity(entity:Entity): # Only for use in ECS autoload!
	valid_entities.append(entity)
	
	emit_signal("entity_added", entity)


func remove_entity(entity:Entity): # Only for use in ECS autoload!
	valid_entities.erase(entity)
	
	emit_signal("entity_removed", entity)
