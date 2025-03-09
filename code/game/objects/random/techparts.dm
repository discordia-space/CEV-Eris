/obj/spawner/techpart
	name = "random techpart"
	icon_state = "tech-orange"
	tags_to_spawn = list(SPAWN_ASSEMBLY,SPAWN_STOCK_PARTS,SPAWN_DESIGN_COMMON,SPAWN_COMPUTER_HARDWERE)

/obj/spawner/techpart/low_chance
	name = "low chance random techpart"
	icon_state = "tech-orange-low"
	spawn_nothing_percentage = 60

/obj/spawner/techpart/onestar
	name = "random onestar techpart"
	icon_state = "tech-orange"
	allow_blacklist = TRUE
	tags_to_spawn = list(SPAWN_STOCK_PARTS_OS)
