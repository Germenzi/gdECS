extends Reference

class_name C_NodeFreeingOnDelete

const COMPONENT_TYPE = "C_NodeFreeingOnDelete"

var node_to_del:Node

func _init(node:Node):
	node_to_del = node
