extends Reference

class_name EntitySignature

var necessary_components : Array = []
var banned_components : Array = []


func add_necessary_component(comp_name:String):
	if not comp_name in necessary_components:
		necessary_components.append(comp_name)


func add_several_necessary(several:Array):
	for i in several:
		add_necessary_component(i)


func add_banned_component(comp_name:String):
	if not comp_name in banned_components:
		banned_components.append(comp_name)


func add_several_banned(several:Array):
	for i in several:
		add_banned_component(i)


func match_entity(ent:Entity):
	for comp in necessary_components:
		if not ent.has_component(comp):
			return false
	
	for comp in banned_components:
		if ent.has_component(comp):
			return false
	
	return true
