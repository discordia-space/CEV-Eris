/PathNode
	var/datum/position
	var/PathNode/previous_node

	var/best_estimated_cost
	var/estimated_cost
	var/known_cost
	var/cost
	var/nodes_traversed

/PathNode/New(_position, _previous_node, _known_cost, _cost, _nodes_traversed)
	position = _position
	previous_node = _previous_node

	known_cost = _known_cost
	cost = _cost
	estimated_cost = cost + known_cost

	best_estimated_cost = estimated_cost
	nodes_traversed = _nodes_traversed

