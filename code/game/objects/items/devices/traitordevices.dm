/*

Miscellaneous traitor devices

BATTERER


*/

/*

The Batterer, like a flashbang but 50% chance to knock people over. Can be either very
effective or pretty fucking useless.

*/

/obj/item/device/batterer
	name = "mind batterer"
	desc = "A strange device with twin antennas."
	icon_state = "batterer"
	throwforce = WEAPON_FORCE_HARMLESS
	w_class = ITEM_SIZE_TINY
	throw_speed = 4
	throw_range = 10
	flags = CONDUCT
	item_state = "electronic"
	origin_tech = list(TECH_MAGNET = 3, TECH_COMBAT = 3, TECH_COVERT = 3)
	spawn_blacklisted = TRUE//traitor item
	var/times_used = 0 //Number of times it's been used.
	var/max_uses = 2

/obj/item/device/batterer/attack_self(mob/living/carbon/user, flag = 0, emp = 0)
	if(!user) 	return
	if(times_used >= max_uses)
		to_chat(user, SPAN_WARNING("The mind batterer has been burnt out!"))
		return

	user.attack_log += text("\[[time_stamp()]\] <font color='red'>Used [src] to knock down people in the area.</font>")

	for(var/mob/living/carbon/human/M in orange(10, user))
		spawn()
			if(prob(50))

				M.Weaken(rand(10,20))
				if(prob(25))
					M.Stun(rand(5,10))
				to_chat(M, SPAN_DANGER("You feel a tremendous, paralyzing wave flood your mind."))

			else
				to_chat(M, SPAN_DANGER("You feel a sudden, electric jolt travel through your head."))

	playsound(src.loc, 'sound/misc/interference.ogg', 50, 1)
	to_chat(user, SPAN_NOTICE("You trigger [src]."))
	times_used += 1
	if(times_used >= max_uses)
		icon_state = "battererburnt"
