/obj/item/am_containment
	name = "antimatter containment jar"
	desc = "A jar built for antimatter containment."
	icon = 'icons/obj/machines/antimatter.dmi'
	icon_state = "jar"
	density = FALSE
	anchored = FALSE
	force = 8
	throwforce = 10
	throw_speed = 1
	throw_range = 2

	var/fuel = 10000
	var/fuel_max = 10000//Lets try this for now
	var/stability = 100//TODO: add all the stability things to this so its not very safe if you keep hitting in on things

/obj/item/am_containment/explosion_act(target_power, explosion_handler/handle)
	take_damage(target_power)
	return 0

/obj/item/am_containment/take_damage(damage)
	if(health - damage < 0)
		explosion(get_turf(src), 1500, 100)
	else
		..()
		stability -= 60 - (60 * health / maxHealth)


/obj/item/am_containment/proc/usefuel(var/wanted)
	if(fuel < wanted)
		wanted = fuel
	fuel -= wanted
	return wanted
