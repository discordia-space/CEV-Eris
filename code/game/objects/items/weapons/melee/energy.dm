/obj/item/weapon/melee/energy
	var/active = 0
	var/active_force
	var/active_throwforce
	var/active_w_class
	sharp = 0
	edge = 0
	armor_penetration = 50
	flags = NOBLOODY

/obj/item/weapon/melee/energy/proc/activate(mob/living/user)
	anchored = 1
	if(active)
		return
	active = 1
	force = active_force
	throwforce = active_throwforce
	sharp = 1
	edge = 1
	w_class = active_w_class
	playsound(user, 'sound/weapons/saberon.ogg', 50, 1)

/obj/item/weapon/melee/energy/proc/deactivate(mob/living/user)
	anchored = 0
	if(!active)
		return
	playsound(user, 'sound/weapons/saberoff.ogg', 50, 1)
	active = 0
	force = initial(force)
	throwforce = initial(throwforce)
	sharp = initial(sharp)
	edge = initial(edge)
	w_class = initial(w_class)

/obj/item/weapon/melee/energy/attack_self(mob/living/user as mob)
	if (active)
		if ((CLUMSY in user.mutations) && prob(50))
			user.visible_message(SPAN_DANGER("\The [user] accidentally cuts \himself with \the [src]."),\
			SPAN_DANGER("You accidentally cut yourself with \the [src]."))
			user.take_organ_damage(5,5)
		deactivate(user)
	else
		activate(user)

	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		H.update_inv_l_hand()
		H.update_inv_r_hand()

	add_fingerprint(user)
	return

/*
 * Energy Axe
 */
/obj/item/weapon/melee/energy/axe
	name = "energy axe"
	desc = "An energised battle axe."
	icon_state = "axe0"
	//active_force = 150 //holy...
	active_force = 60
	active_throwforce = 35
	active_w_class = ITEM_SIZE_HUGE
	//force = 40
	//throwforce = 25
	force = 20
	throwforce = 10
	throw_speed = 1
	throw_range = 5
	w_class = ITEM_SIZE_NORMAL
	flags = CONDUCT | NOBLOODY
	origin_tech = list(TECH_MAGNET = 3, TECH_COMBAT = 4)
	attack_verb = list("attacked", "chopped", "cleaved", "torn", "cut")
	sharp = 1
	edge = 1

/obj/item/weapon/melee/energy/axe/activate(mob/living/user)
	..()
	icon_state = "axe1"
	user << SPAN_NOTICE("\The [src] is now energised.")

/obj/item/weapon/melee/energy/axe/deactivate(mob/living/user)
	..()
	icon_state = initial(icon_state)
	user << SPAN_NOTICE("\The [src] is de-energised. It's just a regular axe now.")

/*
 * Energy Sword
 */
/obj/item/weapon/melee/energy/sword
	color
	name = "energy sword"
	desc = "May the force be within you."
	icon_state = "sword0"
	active_force = WEAPON_FORCE_LETHAL
	active_throwforce = WEAPON_FORCE_LETHAL
	active_w_class = ITEM_SIZE_LARGE
	force = WEAPON_FORCE_HARMLESS
	throwforce = WEAPON_FORCE_HARMLESS
	throw_speed = 1
	throw_range = 5
	w_class = ITEM_SIZE_SMALL
	flags = NOBLOODY
	origin_tech = list(TECH_MAGNET = 3, TECH_ILLEGAL = 4)
	sharp = 1
	edge = 1
	var/blade_color

/obj/item/weapon/melee/energy/sword/dropped(var/mob/user)
	..()
	if(!istype(loc,/mob))
		deactivate(user)

/obj/item/weapon/melee/energy/sword/New()
	blade_color = pick("red","blue","green","purple")

/obj/item/weapon/melee/energy/sword/green/New()
	blade_color = "green"

/obj/item/weapon/melee/energy/sword/red/New()
	blade_color = "red"

/obj/item/weapon/melee/energy/sword/blue/New()
	blade_color = "blue"

/obj/item/weapon/melee/energy/sword/purple/New()
	blade_color = "purple"

/obj/item/weapon/melee/energy/sword/activate(mob/living/user)
	if(!active)
		user << SPAN_NOTICE("\The [src] is now energised.")
	..()
	attack_verb = list("attacked", "slashed", "stabbed", "sliced", "torn", "ripped", "diced", "cut")
	tool_qualities = list(QUALITY_CUTTING = 30,  QUALITY_WIRE_CUTTING = 20, QUALITY_LASER_CUTTING = 20, QUALITY_WELDING = 10, QUALITY_CAUTERIZING = 10)
	icon_state = "sword[blade_color]"

/obj/item/weapon/melee/energy/sword/deactivate(mob/living/user)
	if(active)
		user << SPAN_NOTICE("\The [src] deactivates!")
	..()
	attack_verb = list()
	tool_qualities = initial(tool_qualities)
	icon_state = initial(icon_state)

/obj/item/weapon/melee/energy/sword/handle_shield(mob/user, var/damage, atom/damage_source = null, mob/attacker = null, var/def_zone = null, var/attack_text = "the attack")
	if(active && default_parry_check(user, attacker, damage_source) && prob(50))
		user.visible_message(SPAN_DANGER("\The [user] parries [attack_text] with \the [src]!"))

		var/datum/effect/effect/system/spark_spread/spark_system = new /datum/effect/effect/system/spark_spread()
		spark_system.set_up(5, 0, user.loc)
		spark_system.start()
		playsound(user.loc, 'sound/weapons/blade1.ogg', 50, 1)
		return 1
	return 0

/obj/item/weapon/melee/energy/sword/pirate
	name = "energy cutlass"
	desc = "Arrrr matey."
	icon_state = "cutlass0"

/obj/item/weapon/melee/energy/sword/pirate/activate(mob/living/user)
	..()
	icon_state = "cutlass1"

/*
 *Energy Blade
 */

//Can't be activated or deactivated, so no reason to be a subtype of energy
/obj/item/weapon/melee/energy/blade
	name = "energy blade"
	desc = "A concentrated beam of energy in the shape of a blade. Very stylish... and lethal."
	icon_state = "blade"
	force = WEAPON_FORCE_LETHAL //Normal attacks deal very high damage - about the same as wielded fire axe
	armor_penetration = 100
	sharp = 1
	edge = 1
	anchored = 1    // Never spawned outside of inventory, should be fine.
	throwforce = 1  //Throwing or dropping the item deletes it.
	throw_speed = 1
	throw_range = 1
	w_class = ITEM_SIZE_LARGE//So you can't hide it in your pocket or some such.
	flags = NOBLOODY
	attack_verb = list("attacked", "slashed", "stabbed", "sliced", "torn", "ripped", "diced", "cut")
	var/mob/living/creator
	var/datum/effect/effect/system/spark_spread/spark_system

/obj/item/weapon/melee/energy/blade/New()

	spark_system = new /datum/effect/effect/system/spark_spread()
	spark_system.set_up(5, 0, src)
	spark_system.attach(src)

	START_PROCESSING(SSobj, src)

/obj/item/weapon/melee/energy/blade/Destroy()
	STOP_PROCESSING(SSobj, src)
	. = ..()

/obj/item/weapon/melee/energy/blade/attack_self(mob/user as mob)
	user.drop_from_inventory(src)
	spawn(1) if(src) qdel(src)

/obj/item/weapon/melee/energy/blade/dropped()
	spawn(1) if(src) qdel(src)

/obj/item/weapon/melee/energy/blade/Process()
	if(!creator || loc != creator || (creator.l_hand != src && creator.r_hand != src))
		// Tidy up a bit.
		if(isliving(loc))
			var/mob/living/carbon/human/host = loc
			if(istype(host))
				for(var/obj/item/organ/external/organ in host.organs)
					for(var/obj/item/O in organ.implants)
						if(O == src)
							organ.implants -= src
			host.pinned -= src
			host.embedded -= src
			host.drop_from_inventory(src)
		spawn(1) if(src) qdel(src)
