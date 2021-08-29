/obj/item/storage/belt/sheath/judgement
	icon_state = "sheath_judgement"
	name = "katana sheath"
	desc = "Made to store katanas. You can notice blue fog that coming from it. It has a patterned gold head on it's bottom part."
	can_hold = list(
		/obj/item/tool/sword/katana
	)
	rarity_value = 5

	handle_item_insertion(obj/item/W, prevent_warning = 0, mob/user)
		. = ..()
		if(. && istype(W, /obj/item/tool/sword/katana/spatial_cutter))
			var/obj/item/tool/sword/katana/spatial_cutter/cutter = W
			cutter.ActivateSpatialCuts(src, user)

	equiped
		rarity_value = 5
		New()
			new/obj/item/tool/sword/katana/spatial_cutter/yamato(src)
			. = ..()

/obj/item/tool/sword/katana/spatial_cutter
	desc = "This is a strange katana, when you move it in the air you can see something like shadow of it following it."
	rarity_value = 1
	var/LifeTimeOfSpatialCuts = 5 SECONDS

	var/list/SpatialCuts = list()
	var/SpatialCutsColor = "#ffffff"
	var/SpatialCutsType = /atom/movable/SpatialCut

	var/tmp/next_spatial_cut = 0

	var/SpatialCutCooldown = 0.5 SECOND

	afterattack(atom/target, mob/user, proximity_flag, params)
		. = ..()
		if(proximity_flag && world.time >= next_spatial_cut)
			SpatialCuts.Add(new SpatialCutsType(get_turf(target), src, SpatialCutsColor, rand(0, 36) * 10, LifeTimeOfSpatialCuts))
			next_spatial_cut = world.time + SpatialCutCooldown
	proc/ActivateSpatialCuts(obj/item/storage/belt/sheath/judgement/sheath, mob/user)
		. = length(SpatialCuts)
		for(var/atom/movable/SpatialCut/C in SpatialCuts)
			spawn(0)
				C.Activate(user)
	yamato
		desc = "This is a strange katana, when you move it in the air you can see something like shadow of it following it. When you look at it you almost hear something like 'I need more power!'"
		icon_state = "yamato"
		SpatialCutsColor = "#66aaff"
		ActivateSpatialCuts(obj/item/storage/belt/sheath/judgement/sheath)
			. = ..()
			if(.)
				var/quote = "<b>Voice from somewhere</b>, says '[pick("Too slow.", "You are finished!", "It's over!")]'"
				audible_message(quote, "You almost can hear someone's voice.", 3)

/atom/movable/SpatialCut
	var/time2activate = 5 SECONDS
	icon = 'icons/obj/spatial_cut.dmi'
	color = "#ffffff"
	alpha = 150

	var/obj/item/tool/sword/katana/spatial_cutter/MyCutter
	density = FALSE
	anchored = TRUE

	var/qdel_timer
	plane = BLACKNESS_PLANE


/atom/movable/SpatialCut/Initialize(mapload, obj/item/tool/sword/katana/spatial_cutter/C, _color = color, _angle, _time)
	. = ..()
	MyCutter = C
	transform = turn(transform, _angle)
	color = _color

	if(_time)
		time2activate = _time
	qdel_timer = QDEL_IN(src, time2activate)

/atom/movable/SpatialCut/proc/Activate(mob/user)
	. = TRUE
	if(istype(MyCutter))
		deltimer(qdel_timer)
		icon_state = "activated"
		alpha = 255
		for(var/atom/movable/M in get_turf(src))
			MyCutter.resolve_attackby(M, user)
	QDEL_IN(src, 2.6)

/atom/movable/SpatialCut/Destroy()
	if(!QDELETED(MyCutter))
		MyCutter.SpatialCuts.Remove(src)
	. = ..()
