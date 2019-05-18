extends Node2D
class_name YSortGroup

func get_group_children() -> Array:
	var group_children : Array = []
	for child in get_children():
		if child is YSortGroup:
			for sub_child in child.get_group_children():
				group_children.append(child)
			child.add_to_group("ysort_group_remove")
		else:
			group_children.append(child)
	
	return group_children