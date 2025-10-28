/obj/machinery/beehive
	name = "beehive"
	icon = 'icons/obj/beekeeping.dmi'
	icon_state = "beehive"
	density = TRUE
	anchored = TRUE

	var/closed = FALSE
	var/bee_count = 0 // Percent
	var/smoked = null // Timer
	var/honeycombs = 0 // Percent
	var/frames = 0
	var/maxFrames = 5

/obj/machinery/beehive/update_icon()
	overlays.Cut()
	icon_state = "beehive"
	if(closed)
		overlays += "lid"
	if(frames)
		overlays += "empty[frames]"
	if(honeycombs >= 100)
		overlays += "full[round(honeycombs / 100)]"
	if(!smoked)
		switch(bee_count)
			if(1 to 40)
				overlays += "bees1"
			if(41 to 80)
				overlays += "bees2"
			if(81 to 100)
				overlays += "bees3"

/obj/machinery/beehive/examine(mob/user, extra_description = "")
	if(!closed)
		extra_description += "The lid is open."
	..(user, extra_description)

/obj/machinery/beehive/attackby(var/obj/item/I, var/mob/user)
	if(istype(I, /obj/item/tool/crowbar))
		closed = !closed
		user.visible_message("<span class='notice'>\The [user] [closed ? "closes" : "opens"] \the [src].</span>", "<span class='notice'>You [closed ? "close" : "open"] \the [src].</span>")
		update_icon()
		return
	else if(istype(I, /obj/item/tool/wrench))
		anchored = !anchored
		user.visible_message("<span class='notice'>\The [user] [anchored ? "wrenches" : "unwrenches"] \the [src].</span>", "<span class='notice'>You [anchored ? "wrench" : "unwrench"] \the [src].</span>")
		return
	else if(istype(I, /obj/item/bee_smoker))
		if(closed)
			to_chat(user, SPAN_NOTICE("You need to open \the [src] with a crowbar before smoking the bees."))
			return
		user.visible_message(SPAN_NOTICE("\The [user] smokes the bees in \the [src]."), SPAN_NOTICE("You smoke the bees in \the [src]."))
		smoked = addtimer(CALLBACK(PROC_REF(desmoke)), 1 MINUTE, TIMER_STOPPABLE)
		update_icon()
		return
	else if(istype(I, /obj/item/reagent_containers/honey_frame))
		if(closed)
			to_chat(user, SPAN_NOTICE("You need to open \the [src] with a crowbar before inserting \the [I]."))
			return
		if(frames >= maxFrames)
			to_chat(user, SPAN_NOTICE("There is no place for an another frame."))
			return
		var/obj/item/reagent_containers/honey_frame/H = I
		if(H.reagents.total_volume)
			to_chat(user, SPAN_NOTICE("\The [I] is full with beeswax and honey, empty it in the extractor first."))
			return
		++frames
		user.visible_message(SPAN_NOTICE("\The [user] loads \the [I] into \the [src]."), SPAN_NOTICE("You load \the [I] into \the [src]."))
		update_icon()
		user.drop_from_inventory(I)
		qdel(I)
		return
	else if(istype(I, /obj/item/bee_pack))
		var/obj/item/bee_pack/B = I
		if(B.full && bee_count)
			to_chat(user, SPAN_NOTICE("\The [src] already has bees inside."))
			return
		if(!B.full && bee_count < 90)
			to_chat(user, SPAN_NOTICE("\The [src] is not ready to split."))
			return
		if(!B.full && !smoked)
			to_chat(user, SPAN_NOTICE("Smoke \the [src] first!"))
			return
		if(closed)
			to_chat(user, SPAN_NOTICE("You need to open \the [src] with a crowbar before moving the bees."))
			return
		if(B.full)
			user.visible_message(SPAN_NOTICE("\The [user] puts the queen and the bees from \the [I] into \the [src]."), SPAN_NOTICE("You put the queen and the bees from \the [I] into \the [src]."))
			bee_count = 20
			B.empty()
		else
			user.visible_message(SPAN_NOTICE("\The [user] puts bees and larvae from \the [src] into \the [I]."), SPAN_NOTICE("You put bees and larvae from \the [src] into \the [I]."))
			bee_count /= 2
			B.fill()
		update_icon()
		return
	else if(istype(I, /obj/item/tool/screwdriver))
		if(bee_count)
			to_chat(user, SPAN_NOTICE("You can't dismantle \the [src] with these bees inside."))
			return
		to_chat(user, SPAN_NOTICE("You start dismantling \the [src]..."))
		playsound(loc, 'sound/items/Screwdriver.ogg', 50, 1)
		if(do_after(user, 30, src))
			user.visible_message(SPAN_NOTICE("\The [user] dismantles \the [src]."), SPAN_NOTICE("You dismantle \the [src]."))
			new /obj/item/beehive_assembly(loc)
			qdel(src)
		return

/obj/machinery/beehive/attack_hand(var/mob/user)
	if(!closed)
		if(honeycombs < 100)
			to_chat(user, SPAN_NOTICE("There are no filled honeycombs."))
			return
		if(!smoked && bee_count)
			to_chat(user, SPAN_NOTICE("The bees won't let you take the honeycombs out like this, smoke them first."))
			return
		user.visible_message(SPAN_NOTICE("\The [user] starts taking the honeycombs out of \the [src]."), SPAN_NOTICE("You start taking the honeycombs out of \the [src]..."))
		while(honeycombs >= 100 && do_after(user, 30, src))
			var/obj/item/reagent_containers/frame = new /obj/item/reagent_containers/honey_frame(loc)
			frame.reagents.add_reagent("honey", 20)
			honeycombs -= 100
			--frames
			update_icon()
		if(honeycombs < 100)
			to_chat(user, SPAN_NOTICE("You take all filled honeycombs out."))
		return

/obj/machinery/beehive/proc/desmoke()
	deltimer(smoked)
	smoked = null

/obj/machinery/beehive/Process()
	if(!smoked && bee_count)
		if(closed)
			pollinate_flowers()
		bee_count = min(bee_count * 1.005, 100)
		update_icon()

/obj/machinery/beehive/proc/pollinate_flowers()
	var/coef = bee_count / 100
	var/trays = 0
	for(var/obj/machinery/portable_atmospherics/hydroponics/H in view(7, src))
		if(H.seed && !H.dead)
			H.health += 0.05 * coef
			H.yield_mod += 0.005 * coef
			++trays
	honeycombs = min(honeycombs + 0.1 * coef * min(trays, 5), frames * 100)

/obj/machinery/honey_extractor
	name = "honey extractor"
	desc = "A machine used to turn honeycombs on the frame into honey and wax."
	density = TRUE
	anchored = TRUE
	icon = 'icons/obj/virology.dmi'
	icon_state = "centrifuge"
	circuit = /obj/item/electronics/circuitboard/honey_extractor

	var/obj/item/reagent_containers/honey_frame/processing
	var/datum/reagents/honey

/obj/machinery/honey_extractor/Initialize()
	honey = new(500, src) // slightly less than a Bidon

/obj/machinery/honey_extractor/attackby(var/obj/item/I, var/mob/user)
	if(default_deconstruction(I, user))
		return
	if(processing)
		to_chat(user, SPAN_NOTICE("\The [src] is currently spinning, wait until it's finished."))
		return
	else if(istype(I, /obj/item/reagent_containers/honey_frame))
		if(honey.total_volume >= honey.maximum_volume)
			to_chat(user, SPAN_NOTICE("\The [src] is full and \the [src] cannot extract further honey."))
			return
		var/obj/item/reagent_containers/honey_frame/H = I
		if(!H.reagents.total_volume)
			to_chat(user, SPAN_NOTICE("\The [H] is empty, put it into a beehive."))
			return
		user.visible_message(SPAN_NOTICE("\The [user] loads \the [H] into \the [src] and turns it on."), SPAN_NOTICE("You load \the [H] into \the [src] and turn it on."))
		processing = H
		H.forceMove(src)
		icon_state = "centrifuge_moving"
		addtimer(CALLBACK(src, PROC_REF(finish)), 50, TIMER_UNIQUE)
	else if(istype(I, /obj/item/reagent_containers/glass))
		if(!honey.total_volume)
			to_chat(user, SPAN_NOTICE("There is no honey in \the [src]."))
			return
		var/obj/item/reagent_containers/glass/G = I
		var/transferred = honey.trans_to_holder(G.reagents, honey.total_volume)
		user.visible_message(SPAN_NOTICE("\The [user] collects honey from \the [src] into \the [G]."), SPAN_NOTICE("You collect [transferred] units of honey from \the [src] into \the [G]."))
		return 1

/obj/machinery/honey_extractor/proc/finish()
	new /obj/item/stack/material/wax(loc)
	processing.reagents.trans_to_holder(honey, processing.reagents.total_volume)
	processing.forceMove(loc)
	processing = null
	icon_state = "centrifuge"

/obj/item/bee_smoker
	name = "bee smoker"
	desc = "A device used to calm down bees before harvesting honey."
	icon = 'icons/obj/device.dmi'
	icon_state = "battererburnt"
	w_class = ITEM_SIZE_SMALL

/obj/item/reagent_containers/honey_frame
	name = "beehive frame"
	desc = "A frame for the beehive that the bees can fill with honeycombs."
	icon = 'icons/obj/beekeeping.dmi'
	icon_state = "honeyframe"
	w_class = ITEM_SIZE_SMALL
	volume = 20 // honey capacity 20
	reagent_flags = AMOUNT_VISIBLE // you can see how full it is
	filling_states = "15;50;75;100"
	matter = list(MATERIAL_WOOD = 1)

/obj/item/reagent_containers/honey_frame/update_icon()
	cut_overlays()
	if(reagents.total_volume)
		overlays.Add("honeycomb_[get_filling_state()]")

/obj/item/reagent_containers/honey_frame/get_matter()
	. = ..()
	. |= list(MATERIAL_WAX = reagents.total_volume/20)

/obj/item/beehive_assembly
	name = "beehive assembly"
	desc = "Contains everything you need to build a beehive."
	icon = 'icons/obj/beekeeping.dmi'
	icon_state = "apiary"

/obj/item/beehive_assembly/attack_self(var/mob/user)
	to_chat(user, SPAN_NOTICE("You start assembling \the [src]..."))
	if(do_after(user, 30, src))
		user.visible_message(SPAN_NOTICE("\The [user] constructs a beehive."), SPAN_NOTICE("You construct a beehive."))
		new /obj/machinery/beehive(get_turf(user))
		user.drop_from_inventory(src)
		qdel(src)
	return

/obj/item/stack/material/wax
	name = "wax"
	singular_name = "wax piece"
	desc = "Soft substance produced by bees. Used to make candles."
	icon = 'icons/obj/stack/material.dmi'
	icon_state = "sheet-wax"
	novariants = FALSE
	default_type = MATERIAL_WAX

/obj/item/stack/material/wax/New()
	..()
	recipes = wax_recipes

var/global/list/datum/stack_recipe/wax_recipes = list( \
	new/datum/stack_recipe("candle", /obj/item/flame/candle) \
)

/obj/item/bee_pack
	name = "bee pack"
	desc = "Contains a queen bee and some worker bees. Everything you'll need to start a hive!"
	icon = 'icons/obj/beekeeping.dmi'
	icon_state = "beepack"
	var/full = TRUE
	matter = list(MATERIAL_STEEL = 5, MATERIAL_DIAMOND = 0.1, MATERIAL_SILVER = 0.2, MATERIAL_BIOMATTER = 1)

/obj/item/bee_pack/New()
	..()
	overlays += "beepack-full"

/obj/item/bee_pack/proc/empty()
	full = FALSE
	name = "empty bee pack"
	desc = "A stasis pack for moving bees. It's empty."
	overlays.Cut()
	overlays += "beepack-empty"
	matter.Remove(MATERIAL_BIOMATTER)

/obj/item/bee_pack/proc/fill()
	full = initial(full)
	name = initial(name)
	desc = initial(desc)
	overlays.Cut()
	overlays += "beepack-full"
	matter[MATERIAL_BIOMATTER] = 1