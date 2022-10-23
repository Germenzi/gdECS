# ECS addon for godot v3.5.1

Simple ECS addon for godot v3.5.1

This addon doesn't focus on performance, due to it was written on GDScript, so there is no point to count msecs and care about memory etc.
Main target is simple api and usability, so this is good choice for prototyping and acquaintance with ECS basic concepts.

:exclamation: code snippets like `some_class.function(param:int=0)` doesn't fit GDScript syntax and represents only for methods signature demonstration

![gif-ecs](https://user-images.githubusercontent.com/66486400/197368212-0811de8e-4923-4178-b2ab-919b9691f03d.gif)

## :large_orange_diamond: Key features
- any `Object` can be a component
- readonly components
- handy entity filtering outside `System` class
- nodes binding with entity

## :large_orange_diamond: Addon classes
- `Entity` - a class of component container
- `EntitySignature` - a class of component set for matching entities
- `EntityFilter` - class which gets filtered entities from ECS
- `ECS` - autoload which binds all together
- `System` - system implementation as `Node`


## :large_orange_diamond: Components

To create component just assing `COMPONENT_TYPE` property to any instance. ECS detects components exacly by its existence. There is no point is it `Object` or `AnimationPlayer`, so you can easily control animations and nodes parameters through systems. Example:
``` gdscript
extends Node2D

class_name C_JustNode2D

const COMPONENT_TYPE = "C_JustNode2D" # this line makes C_JustNode2D a component
```

Readonly status sets by `ECS.set_component_readonly(component:Object)` autoload (see 'ECS autoload' section)

## :large_orange_diamond: ECS autoload

Autoload keeping all filters and entites existing now.

You can register an entity filter for giving it a matching entities:
```gdscript
ECS.register_filter(filter:EntityFilter)
```

Unregister it for stop monitoring entities for it:
```gdscript
ECS.unregister_filter(filter:EntityFilter)
```

Register entity for passing it into filters it matches:
```
ECS.register_entity(entity:Entity)
```

Unregister it for remove from all registered filters and stop passing it into them:
```gdscript
ECS.unregister_entity(entity:Entity)
```

But usually you shouldn't register and unregister entity manually, `Entity` do it for you, what wrong for entity filters.

Also you can call `ECS.revise_entity(entity:Entity)` for adding and removing it from filters. It useful when entity got or lost component and should be added or removed from filter because of changing it components set. But like registration you shouldn't call this method, it will be automatically called in `Entity` class in methods changing entity components set.

You can call `ECS.clear_entities()` for freeing all registered entities.

And finally, `ECS` singleton provides you methods for checking if object is component, set and check component readonly status:
```gdscript
ECS.is_instance_component(object:Object)

ECS.is_component_readonly(object:Object)

ECS.set_component_readonly(object:Object)
```

## :large_orange_diamond: Entities

You can create entities by `Entity` class. Its constructor takes two optional arguments:
``` gdscript
var entity : Entity = Entity.new(components:Array=[], # list of components instances
                                 autoregister:bool=true) # will it be automatically registered in ECS (see 'ECS autoload' section)
```

It has the signals below:
``` gdscript

signal enter_ecs # emittied when entity registered in ECS
signal exit_ecs # emmited when entity unregistered in ECS

```

Control entity components with the methods below:

```gdscript

entity.add_component(comp_instance:Object,  # component instance
                      readonly:bool=false,  # readonly components cannot be removed or overwritten (component's data still can be modified)
                      overwrite:bool=false) # allows or not overwriting existing component with the same name as comp_instance has if has it


# removes component with specified typename if it isn't readonly
# prints message if has no component with specified typename or it was set as readonly
entity.remove_component(comp_type:String) 


entity.has_component(comp_type:String) # returns whether entity has component with specified typename


# returns component instance with specified typename
# otherwise just returns null
entity.get_component(comp_type:String)


entity.get_all_components() # returns an array with all components instances


entity.get_all_components_names() # returns an array with all components typenames
```

Also you can specify nodes which will be freed at the same time entity will be freed:
```gdscript

entity.bind_node(node:Node) # entity will call `node.queue_free()` when deleted
                            # of course, you can bind several nodes
```

You can safely free entity like any other object:
```gdscript
entity.free() # it will automatically do needed things
```

## :large_orange_diamond: Entity signature

`EntitySignature` is a class for checking entity for having and not specified components. Juts create an instance and use it:
```gdscript
var entity_signature = EntitySignature.new() # no constructor parameters
```

You can control component set with the methods below:

```gdscript
entity_signature.add_necessary_component(comp_type:String)

entity_signature.add_several_necessary(several:Array) # just adds several necessary

entity_signature.add_banned_component(comp_type:String)

entity_signature.add_several_banned(several:Array) # just adds several banned
```

And check does entity match specified component set:
```gdscript
entity_signature.match_entity(entity:Entity)
```

## :large_orange_diamond: Entity filter

Class, instance of which can be registered in ECS autoload (see 'ECS autoload' section) and get valid entities from it. Just specify necessary and, optionally, banned components typenames:
```gdscript
var entity_filter : EntityFilter = EntityFilter.new(necessary_components:Array, # components, entities without which will not be valid
                                                    banned_components:Array=[]) # components, entities with which will not be valid
```

And you should register it for able it getting entities:
``` gdscript
ECS.register_filter(filter:EntityFilter)
```

After it valid entities will automatically be added to `valid_entites` array.
```gdscript
entity_filter.valid_entites # keeps all valid entities
```

Also you can stop monitoring entities, but be aware of that deleted entities will not be removed from `valid_entites`:
```gdscript
ECS.unregister_filter(filter:EntityFilter)
```

Also it has signals:
``` gdscript
signal entity_added(entity) # emmited when valid entity added to valid_entitites array
signal entity_removed(entity) # emmited when entity leaves valid_entities because of any reason
```

## :large_orange_diamond: Systems

Addon provides you simple system implementation with `System` class. Just overwrite this three methods:
```gdscript
# here system logic
on_entity_process(entity:Entity, # entity to process
                  delta:float)   # the same as delta in `_process`

# returns an array of necessary components
get_necessary_components()

# returns an array of banned components
get_banned_components()
```

Activate and deactivate it with related export variable.

But you can create any system implementation you want using EntityFilter.
