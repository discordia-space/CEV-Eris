/turf/simulated/wall/r_wall
	icon_state = "rgeneric"
/turf/simulated/wall/r_wall/New(var/newloc)
	..(newloc, "plasteel","plasteel") //3strong

/turf/simulated/wall/cult
	icon_state = "cult"
/turf/simulated/wall/cult/New(var/newloc)
	..(newloc,"cult","cult2")
/turf/unsimulated/wall/cult
	name = "cult wall"
	desc = "Hideous images dance beneath the surface."
	icon = 'icons/turf/wall_masks.dmi'
	icon_state = "cult"

/turf/simulated/shuttle/wall
	name = "wall"
	icon_state = "wall1"
	opacity = 1
	density = 1
	blocks_air = 1

/turf/simulated/shuttle/wall/cargo
	name = "Cargo Transport Shuttle (A5)"
	icon = 'icons/turf/shuttlecargo.dmi'
	icon_state = "cargoshwall1"

/turf/simulated/shuttle/wall/escpod
	name = "Escape Pod"
	icon = 'icons/turf/shuttleescpod.dmi'
	icon_state = "escpodwall1"

/turf/simulated/shuttle/wall/mining
	name = "Mining Barge"
	icon = 'icons/turf/shuttlemining.dmi'
	icon_state = "11,23"

/turf/simulated/shuttle/wall/science
	name = "Science Shuttle"
	icon = 'icons/turf/shuttlescience.dmi'
	icon_state = "6,18"

/obj/structure/shuttle_part //For placing them over space, if sprite covers not whole tile.
	name = "shuttle"
	icon = 'icons/turf/shuttle.dmi'
	anchored = 1
	density = 1

/obj/structure/shuttle_part/cargo
	name = "Cargo Transport Shuttle (A5)"
	icon = 'icons/turf/shuttlecargo.dmi'
	icon_state = "cargoshwall1"

/obj/structure/shuttle_part/escpod
	name = "Escape Pod"
	icon = 'icons/turf/shuttleescpod.dmi'
	icon_state = "escpodwall1"

/obj/structure/shuttle_part/mining
	name = "Mining Barge"
	icon = 'icons/turf/shuttlemining.dmi'
	icon_state = "11,23"

/obj/structure/shuttle_part/science
	name = "Science Shuttle"
	icon = 'icons/turf/shuttlescience.dmi'
	icon_state = "6,18"

/obj/structure/shuttle_part/ex_act(severity) //Making them indestructible, like shuttle walls
    return 0

/turf/simulated/wall/iron/New(var/newloc)
	..(newloc,MATERIAL_IRON)
/turf/simulated/wall/uranium/New(var/newloc)
	..(newloc,MATERIAL_URANIUM)
/turf/simulated/wall/diamond/New(var/newloc)
	..(newloc,MATERIAL_DIAMOND)
/turf/simulated/wall/gold/New(var/newloc)
	..(newloc,MATERIAL_GOLD)
/turf/simulated/wall/silver/New(var/newloc)
	..(newloc,MATERIAL_SILVER)
/turf/simulated/wall/plasma/New(var/newloc)
	..(newloc,MATERIAL_PLASMA)
/turf/simulated/wall/sandstone/New(var/newloc)
	..(newloc,MATERIAL_SANDSTONE)
/turf/simulated/wall/ironplasma/New(var/newloc)
	..(newloc,MATERIAL_IRON,MATERIAL_PLASMA)
/turf/simulated/wall/golddiamond/New(var/newloc)
	..(newloc,MATERIAL_GOLD,MATERIAL_DIAMOND)
/turf/simulated/wall/silvergold/New(var/newloc)
	..(newloc,MATERIAL_SILVER,MATERIAL_GOLD)
/turf/simulated/wall/sandstonediamond/New(var/newloc)
	..(newloc,MATERIAL_SANDSTONE,MATERIAL_DIAMOND)

// Kind of wondering if this is going to bite me in the butt.
/turf/simulated/wall/voxshuttle/New(var/newloc)
	..(newloc,"voxalloy")
/turf/simulated/wall/voxshuttle/attackby()
	return
/turf/simulated/wall/titanium/New(var/newloc)
	..(newloc,"titanium")
