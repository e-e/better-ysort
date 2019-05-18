extends Node2D
class_name BetterYSort

func _ready():
	# we don't want child BetterYSort's to try to sort anything, 
	# since their children just re-parented
	set_process(false)
	
	# this is the top-level BetterYSort
	if not get_parent().has_method("is_better_sort"):
		set_process(true)
		flatten()

# stupid method because you can't reference a class_name inside the class itself
# so this is used to tell if the node is a BetterYSort instance
func is_better_sort():
	pass

# supports nested BetterYSort's
#
# takes all sortable children of nested BetterYSorts and 
# re-parents to the base BetterYSort node
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

# this can be overridden to define how you want certain nodes to be sorted
# each item in `children` needs to be an array with to elements: the y-position to sort on
# and the node which should be moved in the tree
func get_sort_array() -> Array:
	var children : Array = []
	
	for child in get_children():
		var data : Array = []
		if child is Path2D:
			var sort_node : PathFollow2D = child.get_children()[0]
			data = [sort_node.global_position.y, child]
		else:
			data = [child.global_position.y, child]
		
		children.append(data)
	
	return children

# perform the sort based on global y-position
func _sort():
	var children : Array = get_sort_array()
	
	children.sort_custom(self, "compare_nodes")
		
	for index in range(0, children.size()):
		var child = children[index][1]
		var current_index = child.get_index()
		
		if current_index != index:
			move_child(child, index)

func compare_nodes(node_a : Array, node_b : Array) -> bool:
	var y_a = node_a[0]
	var y_b = node_b[0]
	
	if y_a < y_b:
		return true
		
	return false