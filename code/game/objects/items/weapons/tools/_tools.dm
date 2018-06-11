/obj/item/weapon/tool
	name = "tool"
	icon = 'icons/obj/tools.dmi'
	slot_flags = SLOT_BELT
	force = WEAPON_FORCE_NORMAL
	throwforce = WEAPON_FORCE_NORMAL
	w_class = ITEM_SIZE_SMALL

	var/sparks_on_use = FALSE	//Set to TRUE if you want to have sparks on each use of a tool
	var/eye_hazard = FALSE	//Set to TRUE should damage users eyes if they without eye protection

	var/use_power_cost = 0	//For tool system, determinze how much power tool will drain from cells, 0 means no cell needed
	var/obj/item/weapon/cell/cell = null
	var/suitable_cell = null	//Dont forget to edit this for a tool, if you want in to consume cells

	var/use_fuel_cost = 0	//Same, only for fuel. And for the sake of God, DONT USE CELLS AND FUEL SIMULTANEOUSLY.
	var/max_fuel = 0

	var/toggleable = FALSE	//Determinze if it can be switched ON or OFF, for example, if you need a tool that will consume power/fuel upon turning it ON only. Such as welder.
	var/switched_on = FALSE	//Curent status of tool. Dont edit this in subtypes vars, its for procs only.
	var/switched_on_qualities = null	//This var will REPLACE tool_qualities when tool will be toggled on.
	var/switched_off_qualities = null	//This var will REPLACE tool_qualities when tool will be toggled off. So its possible for tool to have diferent qualities both for ON and OFF state.
	var/create_hot_spot = FALSE	//Set this TRUE to ignite plasma on turf with tool upon activation
	var/glow_color = null	//Set color of glow upon activation, or leave it null if you dont want any light

//Cell reload
/obj/item/weapon/tool/MouseDrop(over_object)
	if((src.loc == usr) && istype(over_object, /obj/screen/inventory/hand) && eject_item(cell, usr))
		cell = null
		update_icon()

/obj/item/weapon/tool/attackby(obj/item/C, mob/living/user)
	if(istype(C, suitable_cell) && !cell && insert_item(C, user))
		src.cell = C
		update_icon()

//Turning it on/off
/obj/item/weapon/tool/attack_self(mob/user)
	if(toggleable)
		switched_on = !switched_on
		user << SPAN_NOTICE("You switch the [src] [switched_on ? "on" : "off"].")
		if(switched_on)
			tool_qualities = switched_on_qualities
			if(glow_color)
				set_light(l_range = 1.4, l_power = 1, l_color = glow_color)
		else
			tool_qualities = switched_off_qualities
			if(glow_color)
				set_light(l_range = 0, l_power = 0, l_color = glow_color)
	update_icon()
	..()
	return

//Fuel and cell spawn
/obj/item/weapon/tool/New()
	..()
	if(!cell && suitable_cell)
		cell = new suitable_cell(src)

	if(use_fuel_cost)
		var/datum/reagents/R = new/datum/reagents(max_fuel)
		reagents = R
		R.my_atom = src
		R.add_reagent("fuel", max_fuel)

	update_icon()
	return

//For killing processes like hot spots
/obj/item/weapon/tool/Destroy()
	if (src in SSobj.processing)
		STOP_PROCESSING(SSobj, src)
	return ..()

//Ignite plasma around, if we need it
/obj/item/weapon/tool/Process()
	if(switched_on && create_hot_spot)
		var/turf/location = src.loc
		if(istype(location, /mob/))
			var/mob/M = location
			if(M.l_hand == src || M.r_hand == src)
				location = get_turf(M)
		if (istype(location, /turf))
			location.hotspot_expose(700, 5)

//Power and fuel drain, sparks spawn
/obj/item/weapon/tool/proc/check_tool_effects(mob/living/user)

	if(use_power_cost)
		if(!cell || !cell.checked_use(use_power_cost))
			user << SPAN_WARNING("[src] battery is dead or missing.")
			return FALSE

	if(use_fuel_cost)
		if(get_fuel() >= use_fuel_cost)
			reagents.remove_reagent("fuel", use_fuel_cost)
		else
			user << SPAN_NOTICE("You need more welding fuel to complete this task.")
			return FALSE

	if(eye_hazard)
		eyecheck(user)

	if(sparks_on_use)
		var/datum/effect/effect/system/spark_spread/sparks = new /datum/effect/effect/system/spark_spread()
		sparks.set_up(3, 0, get_turf(src))
		sparks.start()

	update_icon()
	return TRUE

//Returns the amount of fuel in tool
/obj/item/weapon/tool/proc/get_fuel()
	return reagents.get_reagent_amount("fuel")

/obj/item/weapon/tool/examine(mob/user)
	if(!..(user,2))
		return

	if(use_power_cost)
		if(!cell)
			user << SPAN_WARNING("There is no cell inside to power the tool")
		else
			user << "The charge meter reads [round(cell.percent() )]%."

	if(use_fuel_cost)
		user << text("\icon[] [] contains []/[] units of fuel!", src, src.name, get_fuel(),src.max_fuel )


//Recharge the fuel at fueltank, also explode if switched on
/obj/item/weapon/tool/afterattack(obj/O, mob/user, proximity)
	if(use_fuel_cost)
		if(!proximity) return
		if ((istype(O, /obj/structure/reagent_dispensers/fueltank) || istype(O, /obj/item/weapon/weldpack)) && get_dist(src,O) <= 1 && !switched_on)
			O.reagents.trans_to_obj(src, max_fuel)
			user << SPAN_NOTICE("[src] refueled")
			playsound(src.loc, 'sound/effects/refill.ogg', 50, 1, -6)
			return
		else if ((istype(O, /obj/structure/reagent_dispensers/fueltank) || istype(O, /obj/item/weapon/weldpack)) && get_dist(src,O) <= 1 && switched_on)
			message_admins("[key_name_admin(user)] triggered a fueltank explosion with a welding tool.")
			log_game("[key_name(user)] triggered a fueltank explosion with a welding tool.")
			user << SPAN_DANGER("You begin welding on the [O] and with a moment of lucidity you realize, this might not have been the smartest thing you've ever done.")
			var/obj/structure/reagent_dispensers/fueltank/tank = O
			tank.explode()
			return
		if (switched_on)
			var/turf/location = get_turf(user)
			if(isliving(O))
				var/mob/living/L = O
				L.IgniteMob()
			if (istype(location, /turf))
				location.hotspot_expose(700, 50, 1)
	return

//Decides whether or not to damage a player's eyes based on what they're wearing as protection
//Note: This should probably be moved to mob
/obj/item/weapon/tool/proc/eyecheck(mob/user as mob)
	if(!iscarbon(user))
		return TRUE
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		var/obj/item/organ/internal/eyes/E = H.internal_organs_by_name[O_EYES]
		if(!E)
			return
		var/safety = H.eyecheck()
		switch(safety)
			if(FLASH_PROTECTION_MODERATE)
				H << SPAN_WARNING("Your eyes sting a little.")
				E.damage += rand(1, 2)
				if(E.damage > 12)
					H.eye_blurry += rand(3,6)
			if(FLASH_PROTECTION_NONE)
				H << SPAN_WARNING("Your eyes burn.")
				E.damage += rand(2, 4)
				if(E.damage > 10)
					E.damage += rand(4,10)
			if(FLASH_PROTECTION_REDUCED)
				H << SPAN_DANGER("Your equipment intensify the welder's glow. Your eyes itch and burn severely.")
				H.eye_blurry += rand(12,20)
				E.damage += rand(12, 16)
		if(safety<FLASH_PROTECTION_MAJOR)
			if(E.damage > 10)
				user << SPAN_WARNING("Your eyes are really starting to hurt. This can't be good for you!")

			if (E.damage >= E.min_broken_damage)
				H << SPAN_DANGER("You go blind!")
				H.sdisabilities |= BLIND
			else if (E.damage >= E.min_bruised_damage)
				H << SPAN_DANGER("You go blind!")
				H.eye_blind = 5
				H.eye_blurry = 5
				H.disabilities |= NEARSIGHTED
				spawn(100)
					H.disabilities &= ~NEARSIGHTED

//Prosthetic repair
/obj/item/weapon/tool/attack(var/mob/living/carbon/human/H, var/mob/living/user)

	if(get_tool_type(user, list(QUALITY_WELDING)))
		if(ishuman(H))
			var/obj/item/organ/external/S = H.organs_by_name[user.targeted_organ]

			if(!S)
				return
			if(S.robotic < ORGAN_ROBOT || user.a_intent != I_HELP)
				return ..()

			if(S.brute_dam)
				if(S.brute_dam < ROBOLIMB_SELF_REPAIR_CAP)
					if(use_tool(user, H, WORKTIME_FAST, QUALITY_WELDING, FAILCHANCE_NORMAL, required_stat = STAT_PRD))
						S.heal_damage(15,0,0,1)
						user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
						user.visible_message(
							SPAN_NOTICE("\The [user] patches some dents on \the [H]'s [S.name] with \the [src].")
						)
				else if(S.open != 2)
					user << SPAN_DANGER("The damage is far too severe to patch over externally.")
			else if(S.open != 2) // For surgery.
				user << SPAN_NOTICE("Nothing to fix!")

	else
		return ..()

/obj/item/weapon/tool/update_icon()
	overlays.Cut()

	if(switched_on && toggleable)
		overlays += "[icon_state]_on"

	if(use_power_cost)
		var/ratio = 0
		//make sure that rounding down will not give us the empty state even if we have charge for a shot left.
		if(cell && cell.charge >= use_power_cost)
			ratio = cell.charge / cell.maxcharge
			ratio = max(round(ratio, 0.25) * 100, 25)
			overlays += "[icon_state]-[ratio]"

	if(use_fuel_cost)
		var/ratio = 0
		//make sure that rounding down will not give us the empty state even if we have charge for a shot left.
		if(get_fuel() >= use_fuel_cost)
			ratio = get_fuel() / max_fuel
			ratio = max(round(ratio, 0.25) * 100, 25)
			overlays += "[icon_state]-[ratio]"

/obj/item/weapon/tool/admin_debug
	name = "Electric Boogaloo 3000"
	icon_state = "omnitool"
	item_state = "omnitool"
	tool_qualities = list(QUALITY_BOLT_TURNING = 100,
							QUALITY_PRYING = 100,
							QUALITY_WELDING = 100,
							QUALITY_SCREW_DRIVING = 100,
							QUALITY_CLAMPING = 100,
							QUALITY_CAUTERIZING = 100,
							QUALITY_WIRE_CUTTING = 100,
							QUALITY_RETRACTING = 100,
							QUALITY_DRILLING = 100,
							QUALITY_SAWING = 100,
							QUALITY_VEIN_FIXING = 100,
							QUALITY_BONE_SETTING = 100,
							QUALITY_BONE_FIXING = 100,
							QUALITY_SHOVELING = 100,
							QUALITY_DIGGING = 100,
							QUALITY_EXCAVATION = 100,
							QUALITY_CUTTING = 100)
