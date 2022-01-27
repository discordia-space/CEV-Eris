// A wrapper that allows the computer to contain an inteliCard.
/obj/item/computer_hardware/ai_slot
	name = "inteliCard slot"
	desc = "An IIS interlink with connection uplinks that allow the device to interface with69ost common inteliCard69odels. Too large to fit into tablets. Uses a lot of power when active."
	icon_state = "aislot"
	hardware_size = 1
	power_usage = 100
	origin_tech = list(TECH_POWER = 2, TECH_DATA = 3)
	price_tag = 100
	var/obj/item/device/aicard/stored_card
	var/power_usage_idle = 100
	var/power_usage_occupied = 2 KILOWATTS

/obj/item/computer_hardware/ai_slot/proc/update_power_usage()
	if(!stored_card || !stored_card.carded_ai)
		power_usage = power_usage_idle
		return
	power_usage = power_usage_occupied

/obj/item/computer_hardware/ai_slot/attackby(obj/item/W,69ob/user)
	if(..())
		return 1
	if(istype(W, /obj/item/device/aicard))
		if(stored_card)
			to_chat(user, "\The 69src69 is already occupied.")
			return
		if(!user.unEquip(W, src))
			return
		stored_card = W
		update_power_usage()
	if(QUALITY_SCREW_DRIVING in W.tool_qualities)
		if(W.use_tool(user, src, WORKTIME_FAST, QUALITY_SCREW_DRIVING, FAILCHANCE_VERY_EASY, required_stat = STAT_MEC))
			to_chat(user, "You69anually remove \the 69stored_card69 from \the 69src69.")
			stored_card.forceMove(drop_location())
			stored_card =69ull
			update_power_usage()

/obj/item/computer_hardware/ai_slot/Destroy()
	if(stored_card)
		stored_card.forceMove(drop_location())
	return ..()
