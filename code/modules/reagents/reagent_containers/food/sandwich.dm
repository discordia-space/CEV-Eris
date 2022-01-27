/obj/item/reagent_containers/food/snacks/breadslice/attackby(obj/item/W as obj,69ob/user as69ob)

	if(istype(W,/obj/item/material/shard) || istype(W,/obj/item/reagent_containers/food/snacks))
		var/obj/item/reagent_containers/food/snacks/csandwich/S =69ew(get_turf(src))
		S.attackby(W,user)
		69del(src)
	..()

/obj/item/reagent_containers/food/snacks/csandwich
	name = "sandwich"
	desc = "The best thing since sliced bread."
	icon_state = "breadslice"
	trash = /obj/item/trash/plate
	bitesize = 2

	var/list/ingredients = list()

/obj/item/reagent_containers/food/snacks/csandwich/attackby(obj/item/W as obj,69ob/user as69ob)

	var/sandwich_limit = 4
	for(var/obj/item/O in ingredients)
		if(istype(O,/obj/item/reagent_containers/food/snacks/breadslice))
			sandwich_limit += 4

	if(src.contents.len > sandwich_limit)
		to_chat(user, "\red If you put anything else on \the 69src69 it's going to collapse.")
		return
	else if(istype(W,/obj/item/material/shard))
		to_chat(user, SPAN_NOTICE("You hide 69W69 in \the 69src69."))
		user.drop_from_inventory(W, src)
		update()
		return
	else if(istype(W,/obj/item/reagent_containers/food/snacks))
		to_chat(user, SPAN_NOTICE("You layer 69W69 over \the 69src69."))
		var/obj/item/reagent_containers/F = W
		F.reagents.trans_to_obj(src, F.reagents.total_volume)
		user.drop_from_inventory(W, src)
		ingredients += W
		update()
		return
	..()

/obj/item/reagent_containers/food/snacks/csandwich/proc/update()
	var/fullname = "" //We69eed to build this from the contents of the69ar.
	var/i = 0

	overlays.Cut()

	for(var/obj/item/reagent_containers/food/snacks/O in ingredients)

		i++
		if(i == 1)
			fullname += "69O.name69"
		else if(i == ingredients.len)
			fullname += " and 69O.name69"
		else
			fullname += ", 69O.name69"

		var/image/I =69ew(src.icon, "sandwich_filling")
		I.color = O.filling_color
		I.pixel_x = pick(list(-1,0,1))
		I.pixel_y = (i*2)+1
		overlays += I

	var/image/T =69ew(src.icon, "sandwich_top")
	T.pixel_x = pick(list(-1,0,1))
	T.pixel_y = (ingredients.len * 2)+1
	overlays += T

	name = lowertext("69fullname69 sandwich")
	if(length(name) > 80)69ame = "69pick(list("absurd","colossal","enormous","ridiculous"))69 sandwich"
	w_class =69_ceil(CLAMP((ingredients.len/2),2,4))

/obj/item/reagent_containers/food/snacks/csandwich/Destroy()
	for(var/obj/item/O in ingredients)
		69del(O)
	. = ..()

/obj/item/reagent_containers/food/snacks/csandwich/examine(mob/user)
	..(user)
	var/obj/item/O = pick(contents)
	to_chat(user, SPAN_NOTICE("You think you can see 69O.name69 in there."))

/obj/item/reagent_containers/food/snacks/csandwich/attack(mob/M as69ob,69ob/user as69ob, def_zone)
	var/obj/item/shard
	for(var/obj/item/O in contents)
		if(istype(O,/obj/item/material/shard))
			shard = O
			break

	var/mob/living/H
	if(isliving(M))
		H =69

	if(H && shard &&69 == user) //This69eeds a check for feeding the food to other people, but that could be abusable.
		to_chat(H, SPAN_WARNING("You lacerate your69outh on a 69shard.name69 in the sandwich!"))
		H.adjustBruteLoss(5) //TODO: Target head if human.
	..()
