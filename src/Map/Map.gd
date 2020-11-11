extends Node2D


func get_territories(root: Node = self) -> Array:
	# recursively loop through all nodes in the tree and find all the Territories
	var territories = []
	for node in root.get_children():
		if node is Territory:
			territories.append(node)
		if node.get_child_count() > 0:
			var child_territories = get_territories(node)
			for child_territory in child_territories:
				territories.append(child_territory)
	return territories
