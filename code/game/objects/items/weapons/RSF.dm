/*
CONTAINS:
RSF

*/

/obj/item/rsf
	name = "\improper Rapid-Service-Fabricator"
	desc = "A device used to rapidly deploy service items."
	icon = 'icons/obj/items.dmi'
	icon_state = "rcd"
	opacity = 0
	density = FALSE
	anchored = FALSE
	var/max_stored_matter = 30
	var/stored_matter = 30
	var/mode = 1
	w_class = ITEM_SIZE_NORMAL

/obj/item/rsf/examine(mob/user)
	if(..(user, 0))
		to_chat(user, "It currently holds 69stored_matter69/30 Compressed69atter.")

/obj/item/rsf/attackby(obj/item/W as obj,69ob/user as69ob)
	var/obj/item/stack/material/M = W
	if(istype(M) &&69.material.name ==69ATERIAL_COMPRESSED)
		var/amount =69in(M.get_amount(), round(max_stored_matter - stored_matter))
		if(M.use(amount) && stored_matter <69ax_stored_matter)
			stored_matter += amount
			playsound(src.loc, 'sound/machines/click.ogg', 10, 1)
			to_chat(user, "<span class='notice'>You load 69amount69 Compressed69atter into \the 69src69</span>.")
	else
		..()
/obj/item/rsf/attack_self(mob/user as69ob)
	playsound(src.loc, 'sound/effects/pop.ogg', 50, 0)
	if (mode == 1)
		mode = 2
		to_chat(user, "Changed dispensing69ode to 'Drinking Glass'")
		return
	if (mode == 2)
		mode = 3
		to_chat(user, "Changed dispensing69ode to 'Paper'")
		return
	if (mode == 3)
		mode = 4
		to_chat(user, "Changed dispensing69ode to 'Pen'")
		return
	if (mode == 4)
		mode = 5
		to_chat(user, "Changed dispensing69ode to 'Dice Pack'")
		return
	if (mode == 5)
		mode = 1
		to_chat(user, "Changed dispensing69ode to 'Cigarette'")
		return

/obj/item/rsf/afterattack(atom/A,69ob/user as69ob, proximity)

	if(!proximity) return

	if(isrobot(user))
		var/mob/living/silicon/robot/R = user
		if(R.stat || !R.cell || R.cell.is_empty())
			return
	else
		if(stored_matter <= 0)
			return

	if(!istype(A, /obj/structure/table) && !istype(A, /turf/simulated/floor))
		return

	playsound(src.loc, 'sound/machines/click.ogg', 10, 1)
	var/used_energy = 0
	var/obj/product

	switch(mode)
		if(1)
			product = new /obj/item/clothing/mask/smokable/cigarette()
			used_energy = 10
		if(2)
			product = new /obj/item/reagent_containers/food/drinks/drinkingglass()
			used_energy = 50
		if(3)
			product = new /obj/item/paper()
			used_energy = 10
		if(4)
			product = new /obj/item/pen()
			used_energy = 50
		if(5)
			product = new /obj/item/storage/pill_bottle/dice()
			used_energy = 200

	to_chat(user, "Dispensing 69product ? product : "product"69...")
	product.loc = get_turf(A)

	if(isrobot(user))
		var/mob/living/silicon/robot/R = user
		if(R.cell)
			R.cell.use(used_energy)
	else
		stored_matter--
		to_chat(user, "The RSF now holds 69stored_matter69/30 fabrication-units.")
