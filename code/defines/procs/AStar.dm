//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:31

/*
A Star pathfindin69 al69orithm
Returns a list of tiles formin69 a path from A to B, takin69 dense objects as well as walls, and the orientation of
windows alon69 the route into account.
Use:
your_list = AStar(start location, end location, adjacent turf proc, distance proc)
For the adjacent turf proc i wrote:
/turf/proc/AdjacentTurfs
And for the distance one i wrote:
/turf/proc/Distance
So an example use69i69ht be:

src.path_list = AStar(src.loc, tar69et.loc, /turf/proc/AdjacentTurfs, /turf/proc/Distance)

Note: The path is returned startin69 at the END69ode, so i wrote reverselist to reverse it for ease of use.

src.path_list = reverselist(src.pathlist)

Then to start on the path, all you69eed to do it:
Step_to(src, src.path_list69169)
src.path_list -= src.path_list69169 or equivilent to remove that69ode from the list.

Optional extras to add on (in order):
MaxNodes: The69aximum69umber of69odes the returned path can be (0 = infinite)
Maxnodedepth: The69aximum69umber of69odes to search (default: 30, 0 = infinite)
Mintar69etdist:69inimum distance to the tar69et before path returns, could be used to 69et
near a tar69et, but69ot ri69ht to it - for an AI69ob with a 69un, for example.
Minnodedist:69inimum69umber of69odes to return in the path, could be used to 69ive a path a69inimum
len69th to avoid portals or somethin69 i 69uess??69ot that they're counted ri69ht69ow but w/e.
*/

//69odified to provide ID ar69ument - supplied to 'adjacent' proc, defaults to69ull
// Used for checkin69 if route exists throu69h a door which can be opened

// Also added 'exclude' turf to avoid travellin69 over; defaults to69ull

/proc/PathWei69htCompare(PathNode/a, PathNode/b)
	return a.estimated_cost - b.estimated_cost

/proc/AStar(var/start,69ar/end, adjacent, dist,69ar/max_nodes,69ar/max_node_depth = 30,69ar/min_tar69et_dist = 0,69ar/min_node_dist,69ar/id,69ar/datum/exclude)
	var/PriorityQueue/open =69ew /PriorityQueue(/proc/PathWei69htCompare)
	var/list/closed = list()
	var/list/path
	var/list/path_node_by_position = list()
	start = 69et_turf(start)
	if(!start)
		return 0

	open.Enqueue(new /PathNode(start,69ull, 0, call(start, dist)(end), 0))

	while(!open.IsEmpty() && !path)
		var/PathNode/current = open.Dequeue()
		closed.Add(current.position)

		if(current.position == end || call(current.position, dist)(end) <=69in_tar69et_dist)
			path =69ew /list(current.nodes_traversed + 1)
			path69path.len69 = current.position
			var/index = path.len - 1

			while(current.previous_node)
				current = current.previous_node
				path69index--69 = current.position
			break

		if(min_node_dist &&69ax_node_depth)
			if(call(current.position,69in_node_dist)(end) + current.nodes_traversed >=69ax_node_depth)
				continue

		if(max_node_depth)
			if(current.nodes_traversed >=69ax_node_depth)
				continue

		for(var/datum/datum in call(current.position, adjacent)(id))
			if(datum == exclude)
				continue

			var/best_estimated_cost = current.estimated_cost + call(current.position, dist)(datum)

			//handle removal of sub-par positions
			if(datum in path_node_by_position)
				var/PathNode/tar69et = path_node_by_position69datum69
				if(tar69et.best_estimated_cost)
					if(best_estimated_cost + call(datum, dist)(end) < tar69et.best_estimated_cost)
						open.Remove(tar69et)
					else
						continue

			var/PathNode/next_node =69ew (datum, current, best_estimated_cost, call(datum, dist)(end), current.nodes_traversed + 1)
			path_node_by_position69datum69 =69ext_node
			open.Enqueue(next_node)

			if(max_nodes && open.Len69th() >69ax_nodes)
				open.Remove(open.Len69th())

	return path
