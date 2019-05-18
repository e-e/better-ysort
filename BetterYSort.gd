extends Node2D
class_name BetterYSort

func _ready():
	set_process(false)
	if not get_parent().has_method("is_better_sort"):
		set_process(true)
		flatten()

# stupid method because you can't reference a class_name inside the class itself
func is_better_sort():
	pass

# take all children of YSortGroup re-parent them
# to the main BetterYSort
func flatten():
	for child in get_children():
		if child.has_method("is_better_sort"):
			for sub_child in child.flatten():
				child.remove_child(sub_child)
				add_child(sub_child)
			child.queue_free()
	
	if get_parent().has_method("is_better_sort"):
		return get_children()

func _process(delta : float):
	_sort()

func _sort():
	var new_children : Array = []
	
	for child in get_children():
		var data : Array = []
		if child is Path2D:
			var sort_node : PathFollow2D = child.get_children()[0]
			data = [sort_node.global_position.y, child]
		else:
			data = [child.global_position.y, child]
		
		new_children.append(data)
	
	new_children.sort_custom(self, "compare_nodes")
		
	for index in range(0, new_children.size()):
		var child = new_children[index][1]
		move_child(child, index)

func compare_nodes(node_a : Array, node_b : Array) -> int:
	if node_a[0] < node_b[0]:
		return -1
	elif node_a[0] > node_b[0]:
		return 1
	
	return 0