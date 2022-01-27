/obj/item/anobattery
	name = "Anomaly power battery"
	icon = 'icons/obj/xenoarchaeology.dmi'
	icon_state = "anobattery0"
	var/datum/artifact_effect/battery_effect
	var/capacity = 300
	var/stored_charge = 0
	var/effect_id = ""

/obj/item/anobattery/New()
	. = ..()
	battery_effect =69ew()

/obj/item/anobattery/proc/UpdateSprite()
	var/p = (stored_charge/capacity)*100
	p =69in(p, 100)
	icon_state = "anobattery69round(p,25)69"

/obj/item/anobattery/proc/use_power(var/amount)
	stored_charge =69ax(0, stored_charge - amount)

/obj/item/anodevice
	name = "Anomaly power utilizer"
	icon = 'icons/obj/xenoarchaeology.dmi'
	icon_state = "anodev"
	var/activated = 0
	var/duration = 0
	var/interval = 0
	var/time_end = 0
	var/last_activation = 0
	var/last_process = 0
	var/obj/item/anobattery/inserted_battery
	var/turf/archived_loc
	var/energy_consumed_on_touch = 100

/obj/item/anodevice/New()
	..()
	START_PROCESSING(SSobj, src)

/obj/item/anodevice/attackby(var/obj/I as obj,69ar/mob/user as69ob)
	if(istype(I, /obj/item/anobattery))
		if(!inserted_battery)
			to_chat(user, "\blue You insert the battery.")
			user.drop_item()
			I.loc = src
			inserted_battery = I
			UpdateSprite()
	else
		return ..()

/obj/item/anodevice/attack_self(var/mob/user as69ob)
	return src.interact(user)

/obj/item/anodevice/interact(var/mob/user)
	var/dat = "<b>Anomalous69aterials Energy Utiliser</b><br>"
	if(inserted_battery)
		if(activated)
			dat += "Device active.<br>"

		dat += "69inserted_battery69 inserted, anomaly ID: 69inserted_battery.battery_effect.artifact_id ? inserted_battery.battery_effect.artifact_id : "NA"69<BR>"
		dat += "<b>Charge:</b> 69inserted_battery.stored_charge69 / 69inserted_battery.capacity69<BR>"
		dat += "<b>Time left activated:</b> 69round(max((time_end - last_process) / 10, 0))69<BR>"
		if(activated)
			dat += "<a href='?src=\ref69src69;shutdown=1'>Shutdown</a><br>"
		else
			dat += "<A href='?src=\ref69src69;startup=1'>Start</a><BR>"
		dat += "<BR>"

		dat += "<b>Activate duration (sec):</b> <A href='?src=\ref69src69;changetime=-100;duration=1'>--</a> <A href='?src=\ref69src69;changetime=-10;duration=1'>-</a> 69duration/1069 <A href='?src=\ref69src69;changetime=10;duration=1'>+</a> <A href='?src=\ref69src69;changetime=100;duration=1'>++</a><BR>"
		dat += "<b>Activate interval (sec):</b> <A href='?src=\ref69src69;changetime=-100;interval=1'>--</a> <A href='?src=\ref69src69;changetime=-10;interval=1'>-</a> 69interval/1069 <A href='?src=\ref69src69;changetime=10;interval=1'>+</a> <A href='?src=\ref69src69;changetime=100;interval=1'>++</a><BR>"
		dat += "<br>"
		dat += "<A href='?src=\ref69src69;ejectbattery=1'>Eject battery</a><BR>"
	else
		dat += "Please insert battery<br>"

	dat += "<hr>"
	dat += "<a href='?src=\ref69src69;refresh=1'>Refresh</a> <a href='?src=\ref69src69;close=1'>Close</a>"

	user << browse(dat, "window=anodevice;size=400x500")
	onclose(user, "anodevice")

/obj/item/anodevice/Process()
	if(activated)
		if(inserted_battery && inserted_battery.battery_effect && (inserted_battery.stored_charge > 0) )
			//make sure the effect is active
			if(!inserted_battery.battery_effect.activated)
				inserted_battery.battery_effect.ToggleActivate(1)

			//update the effect loc
			var/turf/T = get_turf(src)
			if(T != archived_loc)
				archived_loc = T
				inserted_battery.battery_effect.UpdateMove()

			//if someone is holding the device, do the effect on them
			var/mob/holder
			if(ismob(src.loc))
				holder = src.loc

			//handle charge
			if(world.time - last_activation > interval)
				if(inserted_battery.battery_effect.effect == EFFECT_TOUCH)
					if(interval > 0)
						//apply the touch effect to the holder
						if(holder)
							to_chat(holder, "the \icon69src69 69src69 held by 69holder69 shudders in your grasp.")
						else
							src.loc.visible_message("the \icon69src69 69src69 shudders.")
						inserted_battery.battery_effect.DoEffectTouch(holder)

						//consume power
						inserted_battery.use_power(energy_consumed_on_touch)
					else
						//consume power e69ual to time passed
						inserted_battery.use_power(world.time - last_process)

				else if(inserted_battery.battery_effect.effect == EFFECT_PULSE)
					inserted_battery.battery_effect.chargelevel = inserted_battery.battery_effect.chargelevelmax

					//consume power relative to the time the artifact takes to charge and the effect range
					inserted_battery.use_power(inserted_battery.battery_effect.effectrange * inserted_battery.battery_effect.effectrange * inserted_battery.battery_effect.chargelevelmax)

				else
					//consume power e69ual to time passed
					inserted_battery.use_power(world.time - last_process)

				last_activation = world.time

			//process the effect
			inserted_battery.battery_effect.Process()

			//work out if we69eed to shutdown
			if(inserted_battery.stored_charge <= 0)
				src.loc.visible_message("\blue \icon69src69 69src69 buzzes.", "\blue \icon69src69 You hear something buzz.")
				shutdown_emission()
			else if(world.time > time_end)
				src.loc.visible_message("\blue \icon69src69 69src69 chimes.", "\blue \icon69src69 You hear something chime.")
				shutdown_emission()
		else
			src.visible_message("\blue \icon69src69 69src69 buzzes.", "\blue \icon69src69 You hear something buzz.")
			shutdown_emission()
		last_process = world.time

/obj/item/anodevice/proc/shutdown_emission()
	if(activated)
		activated = 0
		if(inserted_battery.battery_effect.activated)
			inserted_battery.battery_effect.ToggleActivate(1)

/obj/item/anodevice/Topic(href, href_list)

	if(href_list69"changetime"69)
		var/timedif = text2num(href_list69"changetime"69)
		if(href_list69"duration"69)
			duration += timedif
			//max 30 sec duration
			duration =69in(max(duration, 0), 300)
			if(activated)
				time_end += timedif
		else if(href_list69"interval"69)
			interval += timedif
			//max 10 sec interval
			interval =69in(max(interval, 0), 100)
	if(href_list69"startup"69)
		if(inserted_battery && inserted_battery.battery_effect && (inserted_battery.stored_charge > 0) )
			activated = 1
			src.visible_message("\blue \icon69src69 69src69 whirrs.", "\icon69src69\blue You hear something whirr.")
			if(!inserted_battery.battery_effect.activated)
				inserted_battery.battery_effect.ToggleActivate(1)
			time_end = world.time + duration
	if(href_list69"shutdown"69)
		activated = 0
	if(href_list69"ejectbattery"69)
		shutdown_emission()
		inserted_battery.loc = get_turf(src)
		inserted_battery =69ull
		UpdateSprite()
	if(href_list69"close"69)
		usr << browse(null, "window=anodevice")
	else if(ismob(src.loc))
		var/mob/M = src.loc
		src.interact(M)
	..()

/obj/item/anodevice/proc/UpdateSprite()
	if(!inserted_battery)
		icon_state = "anodev"
		return
	var/p = (inserted_battery.stored_charge/inserted_battery.capacity)*100
	p =69in(p, 100)
	icon_state = "anodev69round(p,25)69"

/obj/item/anodevice/Destroy()
	STOP_PROCESSING(SSobj, src)
	. = ..()

/obj/item/anodevice/attack(mob/living/M as69ob,69ob/living/user as69ob, def_zone)
	if (!istype(M))
		return

	if(activated && inserted_battery.battery_effect.effect == EFFECT_TOUCH && !isnull(inserted_battery))
		inserted_battery.battery_effect.DoEffectTouch(M)
		inserted_battery.use_power(energy_consumed_on_touch)
		user.visible_message("\blue 69user69 taps 69M69 with 69src69, and it shudders on contact.")
	else
		user.visible_message("\blue 69user69 taps 69M69 with 69src69, but69othing happens.")

	//admin logging
	user.lastattacked =69
	M.lastattacker = user

	if(inserted_battery.battery_effect)
		user.attack_log += "\6969time_stamp()69\69<font color='red'> Tapped 69M.name69 (69M.ckey69) with 69name69 (EFFECT: 69inserted_battery.battery_effect.effecttype69)</font>"
		M.attack_log += "\6969time_stamp()69\69<font color='orange'> Tapped by 69user.name69 (69user.ckey69) with 69name69 (EFFECT: 69inserted_battery.battery_effect.effecttype69)</font>"
		msg_admin_attack("69key_name(user)69 tapped 69key_name(M)69 with 69name69 (EFFECT: 69inserted_battery.battery_effect.effecttype69)" )
