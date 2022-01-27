/turf/simulated/wall/r_wall
	icon_state = "r69eneric"

/turf/simulated/wall/r_wall/New(var/newloc)
	..(newloc,69ATERIAL_PLASTEEL,69ATERIAL_PLASTEEL) //3stron69

/turf/simulated/wall/cult
	icon_state = "cult"

/turf/simulated/wall/cult/New(var/newloc)
	..(newloc,"cult","cult2")

/turf/unsimulated/wall/cult
	name = "cult wall"
	desc = "Hideous ima69es dance beneath the surface."
	icon = 'icons/turf/wall_masks.dmi'
	icon_state = "cult"

/turf/simulated/shuttle/wall
	name = "wall"
	icon_state = "wall1"
	opacity = 1
	density = TRUE
	blocks_air = 1

/turf/simulated/shuttle/wall/car69o
	name = "Car69o Transport Shuttle (A5)"
	icon = 'icons/turf/shuttlecar69o.dmi'
	icon_state = "car69oshwall1"

/turf/simulated/shuttle/wall/escpod
	name = "Escape Pod"
	icon = 'icons/turf/shuttleescpod.dmi'
	icon_state = "escpodwall1"

/turf/simulated/shuttle/wall/minin69
	name = "Minin69 Bar69e"
	icon = 'icons/turf/shuttleminin69.dmi'
	icon_state = "11,23"

/turf/simulated/shuttle/wall/science
	name = "Science Shuttle"
	icon = 'icons/turf/shuttlescience.dmi'
	icon_state = "6,18"

/obj/structure/shuttle_part //For placin69 them over space, if sprite covers69ot whole tile.
	name = "shuttle"
	icon = 'icons/turf/shuttle.dmi'
	anchored = TRUE
	density = TRUE
	bad_type = /obj/structure/shuttle_part

/obj/structure/shuttle_part/car69o
	name = "Car69o Transport Shuttle (A5)"
	icon = 'icons/turf/shuttlecar69o.dmi'
	icon_state = "car69oshwall1"

/obj/structure/shuttle_part/escpod
	name = "Escape Pod"
	icon = 'icons/turf/shuttleescpod.dmi'
	icon_state = "escpodwall1"

/obj/structure/shuttle_part/minin69
	name = "Minin69 Bar69e"
	icon = 'icons/turf/shuttleminin69.dmi'
	icon_state = "11,23"

/obj/structure/shuttle_part/science
	name = "Science Shuttle"
	icon = 'icons/turf/shuttlescience.dmi'
	icon_state = "6,18"

/obj/structure/shuttle_part/ex_act(severity) //Makin69 them indestructible, like shuttle walls
    return 0

/turf/simulated/wall/iron/New(var/newloc)
	..(newloc,MATERIAL_IRON)
/turf/simulated/wall/uranium/New(var/newloc)
	..(newloc,MATERIAL_URANIUM)
/turf/simulated/wall/diamond/New(var/newloc)
	..(newloc,MATERIAL_DIAMOND)
/turf/simulated/wall/69old/New(var/newloc)
	..(newloc,MATERIAL_69OLD)
/turf/simulated/wall/silver/New(var/newloc)
	..(newloc,MATERIAL_SILVER)
/turf/simulated/wall/plasma/New(var/newloc)
	..(newloc,MATERIAL_PLASMA)
/turf/simulated/wall/sandstone/New(var/newloc)
	..(newloc,MATERIAL_SANDSTONE)
/turf/simulated/wall/ironplasma/New(var/newloc)
	..(newloc,MATERIAL_IRON,MATERIAL_PLASMA)
/turf/simulated/wall/69olddiamond/New(var/newloc)
	..(newloc,MATERIAL_69OLD,MATERIAL_DIAMOND)
/turf/simulated/wall/silver69old/New(var/newloc)
	..(newloc,MATERIAL_SILVER,MATERIAL_69OLD)
/turf/simulated/wall/sandstonediamond/New(var/newloc)
	..(newloc,MATERIAL_SANDSTONE,MATERIAL_DIAMOND)

// Kind of wonderin69 if this is 69oin69 to bite69e in the butt.
/turf/simulated/wall/voxshuttle/New(var/newloc)
	..(newloc,69ATERIAL_VOXALLOY)

/turf/simulated/wall/voxshuttle/attackby()
	return

/turf/simulated/wall/titanium/New(var/newloc)
	..(newloc,69ATERIAL_VOXALLOY)


//Untinted walls have white color, all their colorin69 is built into their sprite and they should really69ot be 69iven a tint, it'd look awful
/turf/simulated/wall/untinted
	base_color_override = "#FFFFFF"
	reinf_color_override = "#FFFFFF"

/*
	One Star/Alliance walls, for use on derelict stuff
*/
/turf/simulated/wall/untinted/onestar
	icon_state = "onestar_standard"
	icon_base_override = "onestar_standard"


/turf/simulated/wall/untinted/onestar/New(var/newloc)
	..(newloc,69ATERIAL_STEEL)


/turf/simulated/wall/untinted/onestar_reinforced
	icon_state = "onestar_reinforced"
	icon_base_override = "onestar_standard"
	icon_base_reinf_override = "onestar_reinforced"

/turf/simulated/wall/untinted/onestar_reinforced/New(var/newloc)
	..(newloc,69ATERIAL_STEEL,MATERIAL_STEEL)
