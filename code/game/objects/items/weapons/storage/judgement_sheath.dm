/obj/item/storage/belt/sheath/judgement
	icon_state = "sheath_judgement"
	name = "katana sheath"
	desc = "Made to store katanas. It has a patterned gold head on it's bottom part."
	can_hold = list(
		/obj/item/tool/sword/katana
	)
	spawn_blacklisted = TRUE

	force = 15

	var/tmp/next_rift = 0
	var/RiftCooldown = 5 MINUTES
	var/turf/RiftTarget

	var/list/ChargeNarrative = list(
		"blue smoke that is absorbing in %self",
		"blue fog that is absorbing in %self",
		"faint blue clouds absorbing into %self",
		"that %self is almost charged",
		null
		)
	examine(mob/user, distance = -1, infix, suffix)
		. = ..()
		if(length(ChargeNarrative))
			var/mistake_radius = max(3 - round(user.stats.getStat(STAT_COG)/20), 0)
			var/charge = clamp((6 - CEILING((next_rift - world.time) / RiftCooldown * 5, 1)) + rand(-mistake_radius, mistake_radius), 1, length(ChargeNarrative))
			if(ChargeNarrative[charge])
				to_chat(user, SPAN_NOTICE(replacetext("You can see [ChargeNarrative[charge]].", "%self", name)))

/obj/item/storage/belt/sheath/judgement/handle_item_insertion(obj/item/W, prevent_warning = 0, mob/user)
	. = ..()
	if(. && istype(W, /obj/item/tool/sword/katana/spatial_cutter))
		var/obj/item/tool/sword/katana/spatial_cutter/cutter = W
		cutter.ActivateSpatialCuts(src, user)
/obj/item/storage/belt/sheath/judgement/afterattack(atom/target, mob/user, proximity_flag, params)
	. = ..()
	var/turf/T = get_turf(target)
	if(RiftTarget)
		if(proximity_flag && world.time >= next_rift)
			
			var/spatialCutsCount = 0
			var/cutcolor = "#ffffff"
			for(var/atom/movable/SpatialCut/C in T)
				spatialCutsCount++
				cutcolor = C.color
				qdel(C)
			if(!spatialCutsCount)
				RiftTarget = null
			else if(spatialCutsCount == 2)
				playsound(T, 'sound/effects/portal_open.ogg', 100, extrarange = 3, ignore_walls = FALSE, use_pressure = FALSE)
				var/obj/effect/portal/P = new/obj/effect/portal/single_use{
					icon = 'icons/obj/spatial_cut.dmi';
					icon_state = "rift";
					mask = "rift_mask";
					SpawnAnimationState = "rift_spawn";
					DespawnAnimationState = "rift_dissolve";
					DespawnAnimationTime = 9
					}(T, 1 MINUTE)
				P.color = cutcolor
				P.set_target(RiftTarget)
				next_rift = world.time + RiftCooldown
		else
			RiftTarget = null
	else if(!T.density)
		RiftTarget = get_turf(target)
		to_chat(user, "\The [src] shines.")


/obj/item/storage/belt/sheath/judgement/withKatana/New()
	new/obj/item/tool/sword/katana/spatial_cutter/yamato(src)
	. = ..()

/* I NEED MORE POWER
/obj/item/storage/belt/sheath/judgement/attackby(obj/item/I, mob/living/user, params)
	if(nt_sword_attack(I, user))
		return
	. = ..()
*/
/obj/item/tool/sword/katana/spatial_cutter
	desc = "This is a strange katana that leaves an afterimage of it as you swing it in the air."
	spawn_blacklisted = TRUE
	var/LifeTimeOfSpatialCuts = 5 SECONDS

	var/list/SpatialCuts = list()
	var/SpatialCutsColor = "#ffffff"
	var/SpatialCutsType = /atom/movable/SpatialCut

	var/tmp/next_spatial_cut = 0

	var/SpatialCutCooldown = 0.5 SECOND

	embed_mult = 0

	afterattack(atom/target, mob/user, proximity_flag, params)
		. = ..()
		if(proximity_flag && world.time >= next_spatial_cut)
			var/turf/T = get_turf(target)
			SpatialCuts.Add(new SpatialCutsType(T, src, SpatialCutsColor, rand(0, 36) * 10, LifeTimeOfSpatialCuts))
			playsound(T, 'sound/weapons/rapidslice.ogg', 100)
			next_spatial_cut = world.time + SpatialCutCooldown
	proc/ActivateSpatialCuts(obj/item/storage/belt/sheath/judgement/sheath, mob/user)
		. = length(SpatialCuts)
		spawn(0)
			for(var/atom/movable/SpatialCut/C in SpatialCuts)
				C.Activate(user)
/obj/item/tool/sword/katana/spatial_cutter/yamato
	name = "yamato"
	desc = "This is a strange katana that leaves an afterimage of it as you swing it in the air. When you look at it you almost hear a male voice whispering something into your head, but can't understand what exactly."
	icon_state = "yamato"
	SpatialCutsColor = "#88ccdd"
	ActivateSpatialCuts(obj/item/storage/belt/sheath/judgement/sheath)
		. = ..()
		if(.)
			var/quote = "<b>Voice from somewhere</b> says, \"[pick("Too slow.", "You are finished!", "It's over!")]\""
			audible_message(quote, "You almost can hear someone's voice.", 3)

/obj/item/tool/sword/katana/spatial_cutter/yamato/New()
	. = ..()
	GLOB.all_faction_items[src] = GLOB.department_engineering

/obj/item/tool/sword/katana/spatial_cutter/yamato/Destroy()
	for(var/mob/living/carbon/human/H in viewers(get_turf(src)))
		SEND_SIGNAL(H, COMSIG_OBJ_FACTION_ITEM_DESTROY, src)
	GLOB.all_faction_items -= src
	GLOB.technomancer_faction_item_loss++
	. = ..()

/obj/item/tool/sword/katana/spatial_cutter/yamato/attackby(obj/item/I, mob/user, params)
	if(nt_sword_attack(I, user))
		return
	. = ..()
//I NEED MORE POWER
/obj/item/tool/sword/nt_sword/attackby(obj/item/I, mob/user, params)
	. = ..()
	if(istype(I, /obj/item/tool/sword/katana/spatial_cutter/yamato) || istype(I, /obj/item/storage/belt/sheath/judgement))
		qdel(src)

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
		var/turf/T = get_turf(src)
		icon_state = "activated"
		alpha = 255
		playsound(src, 'sound/weapons/rapidslice.ogg', 75)
		for(var/atom/movable/M in T)
			if(!istype(M, /atom/movable/SpatialCut) && !istype(M, /obj/item/storage))
				MyCutter.resolve_attackby(M, user)
		bluespace_entropy(0.5, T)
	QDEL_IN(src, 2.6)

/atom/movable/SpatialCut/Destroy()
	if(!QDELETED(MyCutter))
		MyCutter.SpatialCuts.Remove(src)
	. = ..()
