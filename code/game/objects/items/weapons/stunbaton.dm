//replaces our stun baton code with /tg/station's code
/obj/item/weapon/melee/baton
	name = "stunbaton"
	desc = "A stun baton for incapacitating people with."
	icon_state = "stunbaton"
	item_state = "baton"
	slot_flags = SLOT_BELT
	force = WEAPON_FORCE_PAINFUL
	sharp = 0
	edge = 0
	throwforce = WEAPON_FORCE_PAINFUL
	w_class = ITEM_SIZE_NORMAL
	origin_tech = list(TECH_COMBAT = 2)
	attack_verb = list("beaten")
	price_tag = 500
	var/stunforce = 10
	var/agonyforce = 30
	var/status = FALSE		//whether the thing is on or not
	var/hitcost = 100
	var/obj/item/weapon/cell/cell = null
	var/suitable_cell = /obj/item/weapon/cell/medium
	structure_damage_factor = STRUCTURE_DAMAGE_BLUNT

/obj/item/weapon/melee/baton/Initialize()
	. = ..()
	if(!cell && suitable_cell)
		cell = new suitable_cell(src)
	update_icon()

/obj/item/weapon/melee/baton/Destroy()
	QDEL_NULL(cell)
	return ..()

/obj/item/weapon/melee/baton/get_cell()
	return cell

/obj/item/weapon/melee/baton/handle_atom_del(atom/A)
	..()
	if(A == cell)
		cell = null
		update_icon()

/obj/item/weapon/melee/baton/proc/deductcharge(var/power_drain)
	if(cell)
		if(cell.checked_use(power_drain))
			return TRUE
		else
			status = FALSE
			update_icon()
			return FALSE

/obj/item/weapon/melee/baton/update_icon()
	if(status)
		icon_state = "[initial(name)]_active"
	else if(!cell)
		icon_state = "[initial(name)]_nocell"
	else
		icon_state = "[initial(name)]"

	if(icon_state == "[initial(name)]_active")
		set_light(1.5, 1, COLOR_LIGHTING_ORANGE_BRIGHT)
	else
		set_light(0)

/obj/item/weapon/melee/baton/examine(mob/user)
	if(!..(user, 1))
		return

	if(cell)
		to_chat(user, SPAN_NOTICE("The baton is [round(cell.percent())]% charged."))
	if(!cell)
		to_chat(user, SPAN_WARNING("The baton does not have a power source installed."))

/obj/item/weapon/melee/baton/attack_self(mob/user)
	if(cell && cell.charge > hitcost)
		status = !status
		to_chat(user, SPAN_NOTICE("[src] is now [status ? "on" : "off"]."))
		tool_qualities = status ? list(QUALITY_PULSING = 1) : null
		playsound(loc, "sparks", 75, 1, -1)
		update_icon()
	else
		status = FALSE
		if(!cell)
			to_chat(user, SPAN_WARNING("[src] does not have a power source!"))
		else
			to_chat(user, SPAN_WARNING("[src] is out of charge."))
	add_fingerprint(user)

/obj/item/weapon/melee/baton/attack(mob/M, mob/user)
	if(status && (CLUMSY in user.mutations) && prob(50))
		to_chat(user, SPAN_DANGER("You accidentally hit yourself with the [src]!"))
		user.Weaken(30)
		deductcharge(hitcost)
		return
	return ..()

/obj/item/weapon/melee/baton/apply_hit_effect(mob/living/target, mob/living/user, var/hit_zone)
	if(isrobot(target))
		return ..()

	var/agony = agonyforce
	var/stun = stunforce
	var/obj/item/organ/external/affecting = null
	if(ishuman(target))
		var/mob/living/carbon/human/H = target
		affecting = H.get_organ(hit_zone)

	if(user.a_intent == I_HURT)
		. = ..()
		if (!.)	//item/attack() does it's own messaging and logs
			return 0	// item/attack() will return 1 if they hit, 0 if they missed.

		//whacking someone causes a much poorer electrical contact than deliberately prodding them.
		stun *= 0.5
		if(status)		//Checks to see if the stunbaton is on.
			agony *= 0.5	//whacking someone causes a much poorer contact than prodding them.
		else
			agony = 0	//Shouldn't really stun if it's off, should it?
		//we can't really extract the actual hit zone from ..(), unfortunately. Just act like they attacked the area they intended to.
	else if(!status)
		if(affecting)
			target.visible_message(SPAN_WARNING("[target] has been prodded in the [affecting.name] with [src] by [user]. Luckily it was off."))
		else
			target.visible_message(SPAN_WARNING("[target] has been prodded with [src] by [user]. Luckily it was off."))
	else
		if(affecting)
			target.visible_message(SPAN_DANGER("[target] has been prodded in the [affecting.name] with [src] by [user]!"))
		else
			target.visible_message(SPAN_DANGER("[target] has been prodded with [src] by [user]!"))
		playsound(loc, 'sound/weapons/Egloves.ogg', 50, 1, -1)

	//stun effects
	if(status)
		target.stun_effect_act(stun, agony, hit_zone, src)
		msg_admin_attack("[key_name(user)] stunned [key_name(target)] with the [src].")

		deductcharge(hitcost)

		if(ishuman(target))
			var/mob/living/carbon/human/H = target
			H.forcesay(hit_appends)

/obj/item/weapon/melee/baton/emp_act(severity)
	if(cell)
		cell.emp_act(severity)	//let's not duplicate code everywhere if we don't have to please.
	..()

//secborg stun baton module
/obj/item/weapon/melee/baton/robot/attack_self(mob/user)
	//try to find our power cell
	var/mob/living/silicon/robot/R = loc
	if (istype(R))
		cell = R.cell
	return ..()

/obj/item/weapon/melee/baton/robot/attackby(obj/item/weapon/W, mob/user)
	return

/obj/item/weapon/melee/baton/MouseDrop(over_object)
	if((src.loc == usr) && istype(over_object, /obj/screen/inventory/hand) && eject_item(cell, usr))
		cell = null

/obj/item/weapon/melee/baton/attackby(obj/item/C, mob/living/user)
	if(istype(C, suitable_cell) && !cell && insert_item(C, user))
		src.cell = C

//Makeshift stun baton. Replacement for stun gloves.
/obj/item/weapon/melee/baton/cattleprod
	name = "stunprod"
	desc = "An improvised stun baton."
	icon_state = "stunprod_nocell"
	item_state = "prod"
	force = WEAPON_FORCE_NORMAL
	throwforce = WEAPON_FORCE_NORMAL
	stunforce = 0
	agonyforce = 60	//same force as a stunbaton, but uses way more charge.
	hitcost = 150
	attack_verb = list("poked")
	slot_flags = null
	structure_damage_factor = STRUCTURE_DAMAGE_NORMAL
