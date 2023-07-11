/obj/item/grenade/smokebomb
	name = "FS SG \"Reynolds\""
	desc = "Smoke grenade, used to create a cloud of smoke providing cover and hiding movement."
	icon_state = "smokegrenade"
	item_state = "smokegrenade"
	det_time = 20
	matter = list(MATERIAL_STEEL = 3, MATERIAL_SILVER = 1)
	var/datum/effect/effect/system/smoke_spread/bad/smoke

/obj/item/grenade/smokebomb/New()
	..()
	smoke = new
	smoke.attach(src)

/obj/item/grenade/smokebomb/Destroy()
	qdel(smoke)
	smoke = null
	return ..()

/obj/item/grenade/smokebomb/proc/used_up()
	icon_state = initial(icon_state) + "_off"
	desc = "[initial(desc)] It has already been used."

/obj/item/grenade/smokebomb/prime()
	playsound(loc, 'sound/effects/smoke.ogg', 50, 1, -3)
	// If this is >9 byond shits itself and crashes
	smoke.set_up(10, 0, get_turf(loc))
	addtimer(CALLBACK(smoke, TYPE_PROC_REF(/datum/effect/effect/system/smoke_spread/bad, start)), 1 SECOND)
	addtimer(CALLBACK(smoke, TYPE_PROC_REF(/datum/effect/effect/system/smoke_spread/bad, start)), 2 SECOND)
	addtimer(CALLBACK(smoke, TYPE_PROC_REF(/datum/effect/effect/system/smoke_spread/bad, start)), 3 SECOND)
	addtimer(CALLBACK(smoke, TYPE_PROC_REF(/datum/effect/effect/system/smoke_spread/bad, start)), 4 SECOND)
	for(var/obj/effect/blob/B in view(8,src))
		var/damage = round(30/(get_dist(B,src)+1))
		B.health -= damage
		B.update_icon()

	addtimer(CALLBACK(src, PROC_REF(used_up)), 8 SECOND)
	return



/obj/item/grenade/smokebomb/nt
	name = "NT SG \"Holy Fog\""
	desc = "Smoke grenade, used to create a cloud of smoke providing cover and hiding movement."
	icon_state = "smokegrenade_nt"
	item_state = "smokegrenade_nt"
	matter = list(MATERIAL_BIOMATTER = 10)
