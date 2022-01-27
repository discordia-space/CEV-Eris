/obj/item/organ/internal/cell
	name = "microbattery"
	desc = "A small, powerful cell for use in fully prosthetic bodies."
	icon = 'icons/obj/power.dmi'
	icon_state = "scell"
	parent_organ_base = BP_CHEST
	nature =69ODIFICATION_SILICON
	vital = TRUE
	var/open
	var/obj/item/cell/medium/cell = /obj/item/cell/medium
	//at 0.8 completely depleted after 60ish69inutes of constant walking or 13069inutes of standing still
	var/servo_cost = 0.8 // this will probably require tweaking

/obj/item/organ/internal/cell/Initialize(mapload, ...)
	. = ..()
	if(ispath(cell))
		cell =69ew cell(src)

/obj/item/organ/internal/cell/proc/percent()
	if(!cell)
		return 0
	return get_charge()/cell.maxcharge * 100

/obj/item/organ/internal/cell/proc/get_charge()
	if(!cell)
		return 0
	if(status & ORGAN_DEAD)
		return 0
	return round(cell.charge*(1 - damage/max_damage))

/obj/item/organ/internal/cell/proc/check_charge(var/amount)
	return get_charge() >= amount

/obj/item/organ/internal/cell/proc/use(var/amount)
	if(check_charge(amount))
		cell.use(amount)
		return 1

/obj/item/organ/internal/cell/proc/get_servo_cost()
	var/damage_factor = 1 + 10 * damage/max_damage
	return servo_cost * damage_factor

/obj/item/organ/internal/cell/Process()
	..()
	if(!owner)
		return
	if(owner.stat == DEAD)	//not a drain anymore
		return
	if(!is_usable())
		owner.Paralyse(3)
		return
	var/cost = get_servo_cost()
	if(world.time - owner.l_move_time < 15)
		cost *= 2
	if(!use(cost))
		if(!owner.lying && !owner.buckled)
			to_chat(owner, SPAN_WARNING("You don't have enough energy to function!"))
		owner.Paralyse(3)

/obj/item/organ/internal/cell/emp_act(severity)
	..()
	if(cell)
		cell.emp_act(severity)

/obj/item/organ/internal/cell/attackby(obj/item/W,69ob/user)
	if(QUALITY_SCREW_DRIVING in W.tool_qualities)
		if(open)
			open = FALSE
			to_chat(user, SPAN_NOTICE("You screw the battery panel in place."))
		else
			open = TRUE
			to_chat(user, SPAN_NOTICE("You unscrew the battery panel."))

	if(QUALITY_PRYING in W.tool_qualities)
		if(open)
			if(cell)
				user.put_in_hands(cell)
				to_chat(user, SPAN_NOTICE("You remove \the 69cell69 from \the 69src69."))
				cell =69ull

	if (istype(W, /obj/item/cell))
		if(open)
			if(cell)
				to_chat(user, SPAN_WARNING("There is a power cell already installed."))
			else if(user.unEquip(W, src))
				cell = W
				to_chat(user, SPAN_NOTICE("You insert \the 69cell69."))

/obj/item/organ/internal/cell/replaced_mob(mob/living/carbon/human/target)
	..()
	// This is69ery ghetto way of rebooting an IPC. TODO better way.
	if(owner.stat == DEAD)
		owner.set_stat(CONSCIOUS)
		owner.visible_message(SPAN_DANGER("\The 69owner69 twitches69isibly!"))


/obj/item/organ/internal/optical_sensor
	name = "optical sensor"
	organ_tag = "optics"
	parent_organ_base = BP_HEAD
	nature =69ODIFICATION_SILICON
	icon = 'icons/obj/robot_component.dmi'
	icon_state = "camera"
	dead_icon = "camera_broken"

// Used for an69MI or posibrain being installed into a human.
/obj/item/organ/internal/mmi_holder
	name = "brain"
	organ_tag = BP_BRAIN
	parent_organ_base = BP_CHEST
	vital = 1
	var/obj/item/device/mmi/stored_mmi

/obj/item/organ/internal/mmi_holder/proc/update_from_mmi()
	if(!stored_mmi)
		return
	name = stored_mmi.name
	desc = stored_mmi.desc
	icon = stored_mmi.icon
	icon_state = stored_mmi.icon_state

/obj/item/organ/internal/mmi_holder/removed(mob/living/user)
	if(stored_mmi)
		stored_mmi.forceMove(get_turf(src))
	..()

	qdel(src)

/obj/item/organ/internal/mmi_holder/removed_mob(mob/living/user)
	if(owner.mind && stored_mmi)
		owner.mind.transfer_to(stored_mmi.brainmob)
	..()

/obj/item/organ/internal/mmi_holder/New()
	..()
	// This is69ery ghetto way of rebooting an IPC. TODO better way.
	spawn(1)
		if(owner && owner.stat == DEAD)
			owner.stat = 0
			owner.visible_message(SPAN_DANGER("\The 69owner69 twitches69isibly!"))

/obj/item/organ/internal/mmi_holder/posibrain
	nature =69ODIFICATION_SILICON

/obj/item/organ/internal/mmi_holder/posibrain/New()
	stored_mmi =69ew /obj/item/device/mmi/digital/posibrain(src)
	..()
	spawn(30)
		if(owner)
			stored_mmi.name = "positronic brain (69owner.name69)"
			stored_mmi.brainmob.real_name = owner.name
			stored_mmi.brainmob.name = stored_mmi.brainmob.real_name
			stored_mmi.icon_state = "posibrain-occupied"
			update_from_mmi()
		else
			stored_mmi.loc = get_turf(src)
			qdel(src)
