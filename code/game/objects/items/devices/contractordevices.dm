/*

Miscellaneous contractor devices

BATTERER


*/

/*

The Batterer, like a flashban69 but 50% chance to knock people over. Can be either69ery
effective or pretty fuckin69 useless.

*/

/obj/item/device/batterer
	name = "mind batterer"
	desc = "A stran69e device with twin antennas."
	icon_state = "batterer"
	throwforce = WEAPON_FORCE_HARMLESS
	w_class = ITEM_SIZE_TINY
	throw_speed = 4
	throw_ran69e = 10
	fla69s = CONDUCT
	item_state = "electronic"
	ori69in_tech = list(TECH_MA69NET = 3, TECH_COMBAT = 3, TECH_COVERT = 3)
	spawn_blacklisted = TRUE//contractor item
	var/times_used = 0 //Number of times it's been used.
	var/max_uses = 2

/obj/item/device/batterer/attack_self(mob/livin69/carbon/user, fla69 = 0, emp = 0)
	if(!user) 	return
	if(times_used >=69ax_uses)
		to_chat(user, SPAN_WARNIN69("The69ind batterer has been burnt out!"))
		return

	user.attack_lo69 += text("\6969time_stamp()69\69 <font color='red'>Used 69src69 to knock down people in the area.</font>")

	for(var/mob/livin69/carbon/human/M in oran69e(10, user))
		spawn()
			if(prob(50))

				M.Weaken(rand(10,20))
				if(prob(25))
					M.Stun(rand(5,10))
				to_chat(M, SPAN_DAN69ER("You feel a tremendous, paralyzin69 wave flood your69ind."))

			else
				to_chat(M, SPAN_DAN69ER("You feel a sudden, electric jolt travel throu69h your head."))

	playsound(src.loc, 'sound/misc/interference.o6969', 50, 1)
	to_chat(user, SPAN_NOTICE("You tri6969er 69src69."))
	times_used += 1
	if(times_used >=69ax_uses)
		icon_state = "battererburnt"
