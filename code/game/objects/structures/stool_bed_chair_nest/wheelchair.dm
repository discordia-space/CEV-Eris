/obj/structure/bed/chair/wheelchair
	name = "wheelchair"
	desc = "Now we're getting somewhere."
	icon_state = "wheelchair"
	anchored = FALSE

	var/bloodiness

/obj/structure/bed/chair/wheelchair/Initialize()
	. = ..()
	AddComponent(/datum/component/buckling, buckleFlags = BUCKLE_FORCE_STAND | BUCKLE_MOB_ONLY | BUCKLE_REQUIRE_NOT_BUCKLED | BUCKLE_MOVE_RELAY | BUCKLE_FORCE_DIR | BUCKLE_BREAK_ON_FALL, moveProc = PROC_REF(onMoveAttempt))

/obj/structure/bed/chair/wheelchair/proc/onMoveAttempt(mob/living/trier, direction)
	. = COMSIG_CANCEL_MOVE
	if(!istype(trier))
		return
	if(trier.incapacitated(INCAPACITATION_CANT_ACT))
		return
	if(trier.next_click > world.time)
		return
	trier.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
	step(src, direction)
	if(bloodiness)
		create_track()
	trier.dir = src.dir

/obj/structure/bed/chair/wheelchair/update_icon()
	return

/obj/structure/bed/chair/wheelchair/set_dir()
	..()
	overlays.Cut()
	var/image/O = image(icon = 'icons/obj/furniture.dmi', icon_state = "w_overlay", dir = src.dir)
	O.layer = ABOVE_MOB_LAYER
	overlays += O

/obj/structure/bed/chair/wheelchair/attackby(obj/item/I, mob/living/user)
	if((QUALITY_BOLT_TURNING in I.tool_qualities) || (QUALITY_WIRE_CUTTING in I.tool_qualities) || istype(I, /obj/item/stack))
		return
	..()

/obj/structure/bed/chair/wheelchair/proc/create_track()
	var/obj/effect/decal/cleanable/blood/tracks/B = new(loc)
	var/newdir = get_dir(get_step(loc, dir), loc)
	if(newdir == dir)
		B.set_dir(newdir)
	else
		newdir = newdir | dir
		if(newdir == 3)
			newdir = 1
		else if(newdir == 12)
			newdir = 4
		B.set_dir(newdir)
	bloodiness--

/proc/equip_wheelchair(mob/living/carbon/human/H) //Proc for spawning in a wheelchair if a new character has no legs. Used in new_player.dm
	var/obj/structure/bed/chair/wheelchair/W = new(H.loc)
	var/datum/component/buckling/buckle = W.GetComponent(/datum/component/buckling)
	if(buckle && !buckle.buckled)
		buckle.buckle(H)

/obj/item/wheelchair
	name = "wheelchair"
	desc = "A folded wheelchair that can be carried around."
	icon = 'icons/obj/furniture.dmi'
	icon_state = "wheelchair_folded"
	volumeClass = ITEM_SIZE_HUGE
	var/obj/structure/bed/chair/wheelchair/unfolded

/obj/item/wheelchair/attack_self(mob/user)
	if(unfolded)
		unfolded.forceMove(get_turf(src))
	else
		new/obj/structure/bed/chair/wheelchair(get_turf(src))
	qdel(src)

/obj/structure/bed/chair/wheelchair/MouseDrop(over_object, src_location, over_location)
	..()
	if(over_object == usr && Adjacent(usr))
		if(!ishuman(usr) || usr.incapacitated())
			return
		var/datum/component/buckling/buckle = GetComponent(/datum/component/buckling)
		if(buckle.buckled)
			return 0
		visible_message("[usr] collapses \the [src.name].")
		var/obj/item/wheelchair/R = new/obj/item/wheelchair(get_turf(src))
		R.name = src.name
		R.color = src.color
		R.unfolded = src
		src.forceMove(R)
		return
