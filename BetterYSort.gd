extends Node2D
class_name BetterYSort

const GROUP_ROOT_YSORT = "root_ysort"

func _ready():
	# we don't want child BetterYSort's to try to sort anything, 
	# since their children just re-parented
	set_process(false)
	
	# this is the top-level BetterYSort
	if not get_parent().has_method("is_better_sort"):
		set_process(true)
		add_to_group(GROUP_ROOT_YSORT)
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
		
		self.additional_flatten_actions()
		return get_children()

func _process(delta : float):
	_sort()

# any node that implements the `get_ysort_yposition` takes control 
# of which position will be used during the sort
func get_sort_array() -> Array:
	var children : Array = []
	
	for child in get_children():
		var data : Array = []
		if child.has_method('get_ysort_yposition'):
			data = [child.get_ysort_yposition(), child]
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

# this can be overridden by any child class
# so that custom actions can be taken
func additional_flatten_actions():
	pass