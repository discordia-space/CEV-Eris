/obj/item/assembly/shock_kit
	name = "electrohelmet assembly"
	desc = "This appears to be made from both an electropack and a helmet."
	icon_state = "shock_kit"
	var/obj/item/clothing/head/helmet/part1 = null
	var/obj/item/device/radio/electropack/part2 = null
	var/status = 0
	w_class = ITEM_SIZE_HUGE
	flags = CONDUCT

/obj/item/assembly/shock_kit/Destroy()
	qdel(part1)
	qdel(part2)
	. = ..()

/obj/item/assembly/shock_kit/attackby(obj/item/weapon/I, mob/user)
	if(I.get_tool_type(usr, list(QUALITY_BOLT_TURNING)) && !status)
		var/turf/T = loc
		if(ismob(T))
			T = T.loc
		part1.loc = T
		part2.loc = T
		part1.master = null
		part2.master = null
		part1 = null
		part2 = null
		qdel(src)
		return
	if(I.get_tool_type(usr, list(QUALITY_SCREW_DRIVING)))
		status = !status
		user << SPAN_NOTICE("[src] is now [status ? "secured" : "unsecured"]!")
	add_fingerprint(user)
	return

/obj/item/assembly/shock_kit/attack_self(mob/user as mob)
	part1.attack_self(user, status)
	part2.attack_self(user, status)
	add_fingerprint(user)

/obj/item/assembly/shock_kit/receive_signal()
	if(istype(loc, /obj/structure/bed/chair/e_chair))
		var/obj/structure/bed/chair/e_chair/C = loc
		C.shock()
