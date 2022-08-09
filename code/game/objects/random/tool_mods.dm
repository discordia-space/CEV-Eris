//Random tool upgrades
/obj/spawner/tool_upgrade
	name = "random tool upgrade"
	icon_state = "tech-orange"
	tags_to_spawn = list(SPAWN_TOOL_UPGRADE)

/obj/spawner/tool_upgrade/low_chance
	name = "low chance random tool upgrade"
	icon_state = "tech-orange-low"
	spawn_nothing_percentage = 75

//A fancier subset of the most desireable upgrades
/obj/spawner/tool_upgrade/rare
	name = "random rare tool upgrade"
	icon_state = "tech-red"
	tags_to_spawn = list(SPAWN_TOOL_UPGRADE_RARE)

/obj/spawner/tool_upgrade/rare/low_chance
	name = "low chance random rare tool upgrade"
	icon_state = "tech-red-low"
	spawn_nothing_percentage = 75

/obj/spawner/tool_upgrade/rare/onestar
	name = "random onestar tool upgrade"
	icon_state = "tech-red"
	tags_to_spawn = list(SPAWN_OS_TOOL_UPGRADE)
