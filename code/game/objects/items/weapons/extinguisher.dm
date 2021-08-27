/obj/item/extinguisher
	name = "fire extinguisher"
	desc = "A traditional red fire extinguisher."
	icon = 'icons/obj/items.dmi'
	icon_state = "fire_extinguisher0"
	item_state = "fire_extinguisher"
	hitsound = 'sound/weapons/smash.ogg'
	flags = CONDUCT
	reagent_flags = AMOUNT_VISIBLE
	throwforce = WEAPON_FORCE_DANGEROUS
	w_class = ITEM_SIZE_NORMAL
	throw_speed = 2
	throw_range = 10
	force = WEAPON_FORCE_DANGEROUS
	matter = list(MATERIAL_STEEL = 3)
	attack_verb = list("slammed", "whacked", "bashed", "thunked", "battered", "bludgeoned", "thrashed")
	rarity_value = 10
	spawn_tags = SPAWN_TAG_ITEM_UTILITY
	structure_damage_factor = STRUCTURE_DAMAGE_HEAVY
	var/spray_particles = 3
	var/spray_amount = 9	//units of liquid per particle
	var/max_water = 300
	var/last_use = 1
	var/safety = 1
	var/sprite_name = "fire_extinguisher"
	var/list/overlaylist = list("fire_extinguisherO1","fire_extinguisherO2","fire_extinguisherO3","fire_extinguisherO4","fire_extinguisherO5","fire_extinguisherO6")


/obj/item/extinguisher/mini
	name = "fire extinguisher"
	desc = "A light and compact fibreglass-framed model fire extinguisher."
	icon_state = "miniFE0"
	item_state = "miniFE"
	hitsound = null	//it is much lighter, after all.
	throwforce = WEAPON_FORCE_NORMAL
	w_class = ITEM_SIZE_SMALL
	force = WEAPON_FORCE_NORMAL
	max_water = 150
	spray_particles = 3
	sprite_name = "miniFE"
	overlaylist = list()

/obj/item/extinguisher/Initialize()
	. = ..()
	if(overlaylist.len)
		var/icon/temp = new /icon('icons/obj/items.dmi', overlaylist[rand(1,overlaylist.len)])
		add_overlays(temp)
	create_reagents(max_water)
	reagents.add_reagent("water", max_water)


/obj/item/extinguisher/attack_self(mob/user as mob)
	safety = !safety
	src.icon_state = "[sprite_name][!safety]"
	src.desc = "The safety is [safety ? "on" : "off"]."
	to_chat(user, "The safety is [safety ? "on" : "off"].")
	return

/obj/item/extinguisher/proc/propel_object(var/obj/O, mob/user, movementdirection)
	if(O.anchored) return

	var/obj/structure/bed/chair/C
	if(istype(O, /obj/structure/bed/chair))
		C = O

	var/list/move_speed = list(1, 1, 1, 2, 2, 3)
	for(var/i in 1 to 6)
		if(C) C.propelled = (6-i)
		O.Move(get_step(user,movementdirection), movementdirection)
		sleep(move_speed[i])

	//additional movement
	for(var/i in 1 to 3)
		O.Move(get_step(user,movementdirection), movementdirection)
		sleep(3)

/obj/item/extinguisher/afterattack(var/atom/target, var/mob/user, var/flag)
	//TODO; Add support for reagents in water.

	if( istype(target, /obj/structure/reagent_dispensers/watertank) && flag)
		var/obj/o = target
		var/amount = o.reagents.trans_to_obj(src, 50)
		to_chat(user, SPAN_NOTICE("You fill [src] with [amount] units of the contents of [target]."))
		playsound(src.loc, 'sound/effects/refill.ogg', 50, 1, -6)
		return

	if (!safety)
		if (src.reagents.total_volume < 1)
			to_chat(usr, SPAN_NOTICE("\The [src] is empty."))
			return

		if (world.time < src.last_use + 20)
			return

		src.last_use = world.time

		playsound(src.loc, 'sound/effects/extinguish.ogg', 75, 1, -3)

		var/direction = get_dir(src,target)

		if(user.buckled && isobj(user.buckled))
			spawn(0)
				propel_object(user.buckled, user, turn(direction,180))

		var/turf/T = get_turf(target)
		var/turf/T1 = get_step(T,turn(direction, 90))
		var/turf/T2 = get_step(T,turn(direction, -90))

		var/list/the_targets = list(T,T1,T2)

		for(var/a = 1 to spray_particles)
			spawn(0)
				if(!src || !reagents.total_volume) return

				var/obj/effect/effect/water/W = new(get_turf(src))
				var/turf/my_target
				if(a <= the_targets.len)
					my_target = the_targets[a]
				else
					my_target = pick(the_targets)
				W.create_reagents(spray_amount)
				reagents.trans_to_obj(W, spray_amount)
				W.set_color()
				W.set_up(my_target)

		if((istype(usr.loc, /turf/space)) || (usr.lastarea.has_gravity == 0))
			user.inertia_dir = get_dir(target, user)
			step(user, user.inertia_dir)
	else
		return ..()
	return
