/obj/item/implant/carrion_spider/talking
	name = "talking spider"
	icon_state = "spiderling_talking"
	spider_price = 30
	var/on_cooldown = FALSE

/obj/item/implant/carrion_spider/talking/activate()
	..()
	if(wearer)
		if(!on_cooldown)
			var/carrion_message = input(owner_mob, "say (text)") as text
			wearer.say(carrion_message)
			log_say("69key_name(owner_mob)69 talked using the talking spider as 69key_name(wearer)69 and said: 69carrion_message69")
			on_cooldown = TRUE
			spawn(2 SECONDS)
				on_cooldown = FALSE
		else
			to_chat(owner_mob, SPAN_WARNING("69src69 is not ready to speak yet"))
	else
		to_chat(owner_mob, SPAN_WARNING("69src69 doesn't have a host"))
