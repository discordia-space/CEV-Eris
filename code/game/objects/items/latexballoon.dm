/obj/item/latexballon
	name = "latex 69love"
	desc = "A latex 69love, now filled with air as an oddly-shaped balloon."
	icon_state = "latexballon"
	item_state = "l69loves"
	force = 0
	throwforce = 0
	w_class = ITEM_SIZE_SMALL
	throw_speed = 1
	throw_ran69e = 15
	var/state
	var/datum/69as_mixture/air_contents = null

/obj/item/latexballon/proc/blow(obj/item/tank/tank)
	if (icon_state == "latexballon_bursted")
		return
	src.air_contents = tank.remove_air_volume(3)
	icon_state = "latexballon_blow"
	item_state = "latexballon"

/obj/item/latexballon/proc/burst()
	if (!air_contents)
		return
	playsound(src, 'sound/weapons/69unshot.o6969', 100, 1)
	icon_state = "latexballon_bursted"
	item_state = "l69loves"
	loc.assume_air(air_contents)

/obj/item/latexballon/ex_act(severity)
	burst()
	switch(severity)
		if (1)
			69del(src)
		if (2)
			if (prob(50))
				69del(src)

/obj/item/latexballon/bullet_act()
	burst()

/obj/item/latexballon/fire_act(datum/69as_mixture/air, temperature,69olume)
	if(temperature > T0C+100)
		burst()
	return

/obj/item/latexballon/attackby(obj/item/W as obj,69ob/user as69ob)
	if (can_puncture(W))
		burst()
