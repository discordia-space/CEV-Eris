/datum/map_template/dungeon_template
	name = "Crawler Template"
	desc = "Some text should go here. Maybe."
	template_group = null // If this is set, no more than one template in the same group will be spawned, per submap seeding.
	width = 13
	height = 9
	mappath = null
	annihilate = FALSE // If true, all (movable) atoms at the location where the map is loaded will be deleted before the map is loaded in.
	var/list/directional_flags = list("north",  "south" , "east", "west")
	var/room_tag = null
