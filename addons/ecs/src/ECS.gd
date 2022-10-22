extends Node

const COMPONENT_TYPE_PROPERTY = "COMPONENT_TYPE"
const COMPONENT_READONLY_META_NAME = "READONLY_COMPONENT"

var entities : Array = []
var filters : Array = []


func register_filter(filter:EntityFilter):
	filters.append(filter)
	
	for ent in entities:
		if filter.entity_signature.match_entity(ent):
			filter.add_entity(ent)


func unregister_filter(filter:EntityFilter):
	filters.erase(filter)


func register_entity(entity:Entity):
	if entity.inside_ecs:
		return
	
	entities.append(entity)
	
	entity.emit_signal("enter_ecs")
	entity.inside_ecs = true
	
	revise_entity(entity)


func unregister_entity(entity:Entity):
	if not entity.inside_ecs:
		return
	
	entities.erase(entity)
	
	for filter in filters:
		if entity in filter.valid_entities:
			filter.remove_entity(entity)
	
	entity.emit_signal("exit_ecs")
	entity.inside_ecs = false


func clear_entities():
	for ent in entities.duplicate():
		ent.free()


func revise_entity(entity:Entity):
	if not entity.inside_ecs:
		return
	
	for filter in filters:
		if filter.entity_signature.match_entity(entity):
			if not entity in filter.valid_entities:
				filter.add_entity(entity)
		else:
			if entity in filter.valid_entities:
				filter.remove_entity(entity)


func is_instance_component(instance:Object):
	return COMPONENT_TYPE_PROPERTY in instance


func is_component_readonly(instance:Object):
	if not is_instance_component(instance):
		return false # warning
	
	return instance.has_meta(COMPONENT_READONLY_META_NAME)


func set_component_readonly(instance:Object):
	if not is_instance_component(instance):
		return false # warning
	
	instance.set_meta(COMPONENT_READONLY_META_NAME, 0)
