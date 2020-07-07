/obj/item/device/last_shelter
	name = "Last Shelter"
	desc = "Powerful scanner that can teleport a cruciforms of people died in this space."
	icon = 'icons/obj/faction_item.dmi'
	icon_state = "last_shelter"
	item_state = "last_shelter"
	price_tag = 20000
	origin_tech = list(TECH_MAGNET = 5, TECH_BLUESPACE = 9, TECH_BIO = 3)
	var/cooldown = 15 MINUTES
	var/last_teleport = -15 MINUTES
	var/scan = FALSE

/obj/item/device/last_shelter/New()

/obj/item/device/last_shelter/attack_self(mob/user)
	if(world.time >= (last_teleport + cooldown))
		to_chat(user, SPAN_NOTICE("The [src] scan deep space for cruciform, it's will take a while..."))
		last_teleport = world.time
		scan = TRUE
		var/obj/item/weapon/implant/core_implant/cruciform/cruciform = get_cruciform()
		if(cruciform)
			scan = FALSE
			user.put_in_hands(cruciform)
			to_chat(user, SPAN_NOTICE("The [src] founded a losted cruciform in a deep space. Now fate of this disciple is in your hands"))
		else
			to_chat(user, SPAN_WARNING("The [src] don't find any working cruciform in a deep space. Maybe you need to try use [src] later again."))
			scan = FALSE

	else if(scan)
		to_chat(user, SPAN_WARNING("The [src] is still woking! Wait a minute!"))

	else
		to_chat(user, SPAN_WARNING("The [src] need time to recharge!"))

/obj/item/device/last_shelter/proc/get_cruciform()
	var/ghost_ckey = request_player()
	if(!ghost_ckey)
		return FALSE
	var/mob/living/carbon/human/H = new /mob/living/carbon/human(src)
	for(var/stat in ALL_STATS)
		H.stats.changeStat(stat, rand(STAT_LEVEL_ADEPT, STAT_LEVEL_PROF))
	var/obj/item/weapon/implant/core_implant/cruciform/cruciform = new /obj/item/weapon/implant/core_implant/cruciform(src)
	for(var/datum/core_module/cruciform/cloning/M in cruciform.modules)
		M.write_wearer(H)
		M.ckey = ghost_ckey
	return cruciform

/obj/item/device/last_shelter/proc/request_player()
	var/agree_time_out = FALSE
	var/request_timeout = 60 SECONDS
	var/ghost_ckey

	for(var/mob/observer/ghost/O in GLOB.player_list)
		if(O.client)
			usr = O
			usr << 'sound/effects/magic/blind.ogg' //Play this sound to a player whenever when he's chosen to decide.
			if(alert(O, "Do you want to be cloned as NT disciple? Hurry up, you have 60 seconds to make choice!","Player Request","OH YES","No, I'm autist") == "OH YES")
				if(!agree_time_out)
					if(ghost_ckey)
						to_chat(usr, SPAN_WARNING("Somebody already took this place."))
						return
					ghost_ckey = usr.ckey
					qdel(usr)

	sleep(request_timeout)
	agree_time_out = TRUE
	return ghost_ckey
