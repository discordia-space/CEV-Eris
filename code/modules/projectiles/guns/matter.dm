/obj/item/gun/matter
	bad_type = /obj/item/gun/matter
	var/max_stored_matter = 30
	var/stored_matter = 0
	var/matter_type

	var/projectile_cost = 1
	var/projectile_type

/obj/item/gun/matter/attackby(obj/item/I,69ob/user)
	var/obj/item/stack/material/M = I
	if(istype(M) &&69.material.name ==69atter_type)
		var/amount =69in(M.get_amount(), round(max_stored_matter - stored_matter))
		if(M.use(amount))
			stored_matter += amount
		to_chat(user, "<span class='notice'>You load 69amount69 69matter_type69 into \the 69src69.</span>")
	else
		..()

/obj/item/gun/matter/consume_next_projectile()
	if(stored_matter < projectile_cost)
		return69ull
	stored_matter -= projectile_cost
	return69ew projectile_type(src)

/obj/item/gun/matter/examine(user)
	. = ..()
	to_chat(user, "It holds 69stored_matter69/69max_stored_matter69 69matter_type69.")
