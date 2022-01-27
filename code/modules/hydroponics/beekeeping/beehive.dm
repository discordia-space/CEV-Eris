/obj/machinery/beehive
	name = "beehive"
	icon = 'icons/obj/beekeeping.dmi'
	icon_state = "beehive"
	density = TRUE
	anchored = TRUE

	var/closed = 0
	var/bee_count = 0 // Percent
	var/smoked = 0 // Timer
	var/honeycombs = 0 // Percent
	var/frames = 0
	var/maxFrames = 5

/obj/machinery/beehive/update_icon()
	overlays.Cut()
	icon_state = "beehive"
	if(closed)
		overlays += "lid"
	if(frames)
		overlays += "empty69frames69"
	if(honeycombs >= 100)
		overlays += "full69round(honeycombs / 100)69"
	if(!smoked)
		switch(bee_count)
			if(1 to 40)
				overlays += "bees1"
			if(41 to 80)
				overlays += "bees2"
			if(81 to 100)
				overlays += "bees3"

/obj/machinery/beehive/examine(var/mob/user)
	..()
	if(!closed)
		to_chat(user, "The lid is open.")

/obj/machinery/beehive/attackby(var/obj/item/I,69ar/mob/user)
	if(istype(I, /obj/item/tool/crowbar))
		closed = !closed
		user.visible_message("<span class='notice'>\The 69user69 69closed ? "closes" : "opens"69 \the 69src69.</span>", "<span class='notice'>You 69closed ? "close" : "open"69 \the 69src69.</span>")
		update_icon()
		return
	else if(istype(I, /obj/item/tool/wrench))
		anchored = !anchored
		user.visible_message("<span class='notice'>\The 69user69 69anchored ? "wrenches" : "unwrenches"69 \the 69src69.</span>", "<span class='notice'>You 69anchored ? "wrench" : "unwrench"69 \the 69src69.</span>")
		return
	else if(istype(I, /obj/item/bee_smoker))
		if(closed)
			to_chat(user, SPAN_NOTICE("You need to open \the 69src69 with a crowbar before smoking the bees."))
			return
		user.visible_message(SPAN_NOTICE("\The 69user69 smokes the bees in \the 69src69."), SPAN_NOTICE("You smoke the bees in \the 69src69."))
		smoked = 30
		update_icon()
		return
	else if(istype(I, /obj/item/honey_frame))
		if(closed)
			to_chat(user, SPAN_NOTICE("You need to open \the 69src69 with a crowbar before inserting \the 69I69."))
			return
		if(frames >=69axFrames)
			to_chat(user, SPAN_NOTICE("There is no place for an another frame."))
			return
		var/obj/item/honey_frame/H = I
		if(H.honey)
			to_chat(user, SPAN_NOTICE("\The 69I69 is full with beeswax and honey, empty it in the extractor first."))
			return
		++frames
		user.visible_message(SPAN_NOTICE("\The 69user69 loads \the 69I69 into \the 69src69."), SPAN_NOTICE("You load \the 69I69 into \the 69src69."))
		update_icon()
		user.drop_from_inventory(I)
		qdel(I)
		return
	else if(istype(I, /obj/item/bee_pack))
		var/obj/item/bee_pack/B = I
		if(B.full && bee_count)
			to_chat(user, SPAN_NOTICE("\The 69src69 already has bees inside."))
			return
		if(!B.full && bee_count < 90)
			to_chat(user, SPAN_NOTICE("\The 69src69 is not ready to split."))
			return
		if(!B.full && !smoked)
			to_chat(user, SPAN_NOTICE("Smoke \the 69src69 first!"))
			return
		if(closed)
			to_chat(user, SPAN_NOTICE("You need to open \the 69src69 with a crowbar before69oving the bees."))
			return
		if(B.full)
			user.visible_message(SPAN_NOTICE("\The 69user69 puts the queen and the bees from \the 69I69 into \the 69src69."), SPAN_NOTICE("You put the queen and the bees from \the 69I69 into \the 69src69."))
			bee_count = 20
			B.empty()
		else
			user.visible_message(SPAN_NOTICE("\The 69user69 puts bees and larvae from \the 69src69 into \the 69I69."), SPAN_NOTICE("You put bees and larvae from \the 69src69 into \the 69I69."))
			bee_count /= 2
			B.fill()
		update_icon()
		return
	else if(istype(I, /obj/item/tool/screwdriver))
		if(bee_count)
			to_chat(user, SPAN_NOTICE("You can't dismantle \the 69src69 with these bees inside."))
			return
		to_chat(user, SPAN_NOTICE("You start dismantling \the 69src69..."))
		playsound(loc, 'sound/items/Screwdriver.ogg', 50, 1)
		if(do_after(user, 30, src))
			user.visible_message(SPAN_NOTICE("\The 69user69 dismantles \the 69src69."), SPAN_NOTICE("You dismantle \the 69src69."))
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
		user.visible_message(SPAN_NOTICE("\The 69user69 starts taking the honeycombs out of \the 69src69."), SPAN_NOTICE("You start taking the honeycombs out of \the 69src69..."))
		while(honeycombs >= 100 && do_after(user, 30, src))
			new /obj/item/honey_frame/filled(loc)
			honeycombs -= 100
			--frames
			update_icon()
		if(honeycombs < 100)
			to_chat(user, SPAN_NOTICE("You take all filled honeycombs out."))
		return

/obj/machinery/beehive/Process()
	if(closed && !smoked && bee_count)
		pollinate_flowers()
		update_icon()
	smoked =69ax(0, smoked - 1)
	if(!smoked && bee_count)
		bee_count =69in(bee_count * 1.005, 100)
		update_icon()

/obj/machinery/beehive/proc/pollinate_flowers()
	var/coef = bee_count / 100
	var/trays = 0
	for(var/obj/machinery/portable_atmospherics/hydroponics/H in69iew(7, src))
		if(H.seed && !H.dead)
			H.health += 0.05 * coef
			H.yield_mod += 0.005 * coef
			++trays
	honeycombs =69in(honeycombs + 0.1 * coef *69in(trays, 5), frames * 100)

/obj/machinery/honey_extractor
	name = "honey extractor"
	desc = "A69achine used to turn honeycombs on the frame into honey and wax."
	density = TRUE
	anchored = TRUE
	icon = 'icons/obj/virology.dmi'
	icon_state = "centrifuge"
	circuit = /obj/item/electronics/circuitboard/honey_extractor

	var/processing = 0
	var/honey = 0

/obj/machinery/honey_extractor/attackby(var/obj/item/I,69ar/mob/user)
	if(default_deconstruction(I, user))
		return
	if(processing)
		to_chat(user, SPAN_NOTICE("\The 69src69 is currently spinning, wait until it's finished."))
		return
	else if(istype(I, /obj/item/honey_frame))
		var/obj/item/honey_frame/H = I
		if(!H.honey)
			to_chat(user, SPAN_NOTICE("\The 69H69 is empty, put it into a beehive."))
			return
		user.visible_message(SPAN_NOTICE("\The 69user69 loads \the 69H69 into \the 69src69 and turns it on."), SPAN_NOTICE("You load \the 69H69 into \the 69src69 and turn it on."))
		processing = H.honey
		icon_state = "centrifuge_moving"
		qdel(H)
		spawn(50)
			new /obj/item/honey_frame(loc)
			new /obj/item/stack/wax(loc)
			honey += processing
			processing = 0
			icon_state = "centrifuge"
	else if(istype(I, /obj/item/reagent_containers/glass))
		if(!honey)
			to_chat(user, SPAN_NOTICE("There is no honey in \the 69src69."))
			return
		var/obj/item/reagent_containers/glass/G = I
		var/transferred =69in(G.reagents.maximum_volume - G.reagents.total_volume, honey)
		G.reagents.add_reagent("honey", transferred)
		honey -= transferred
		user.visible_message(SPAN_NOTICE("\The 69user69 collects honey from \the 69src69 into \the 69G69."), SPAN_NOTICE("You collect 69transferred69 units of honey from \the 69src69 into \the 69G69."))
		return 1

/obj/item/bee_smoker
	name = "bee smoker"
	desc = "A device used to calm down bees before harvesting honey."
	icon = 'icons/obj/device.dmi'
	icon_state = "battererburnt"
	w_class = ITEM_SIZE_SMALL

/obj/item/honey_frame
	name = "beehive frame"
	desc = "A frame for the beehive that the bees will fill with honeycombs."
	icon = 'icons/obj/beekeeping.dmi'
	icon_state = "honeyframe"
	w_class = ITEM_SIZE_SMALL

	var/honey = 0

/obj/item/honey_frame/filled
	name = "filled beehive frame"
	desc = "A frame for the beehive that the bees have filled with honeycombs."
	honey = 20

/obj/item/honey_frame/filled/New()
	..()
	overlays += "honeycomb"

/obj/item/beehive_assembly
	name = "beehive assembly"
	desc = "Contains everything you need to build a beehive."
	icon = 'icons/obj/beekeeping.dmi'
	icon_state = "apiary"

/obj/item/beehive_assembly/attack_self(var/mob/user)
	to_chat(user, SPAN_NOTICE("You start assembling \the 69src69..."))
	if(do_after(user, 30, src))
		user.visible_message(SPAN_NOTICE("\The 69user69 constructs a beehive."), SPAN_NOTICE("You construct a beehive."))
		new /obj/machinery/beehive(get_turf(user))
		user.drop_from_inventory(src)
		qdel(src)
	return

/obj/item/stack/wax
	name = "wax"
	singular_name = "wax piece"
	desc = "Soft substance produced by bees. Used to69ake candles."
	icon = 'icons/obj/beekeeping.dmi'
	icon_state = "wax"

/obj/item/stack/wax/New()
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
	var/full = 1

/obj/item/bee_pack/New()
	..()
	overlays += "beepack-full"

/obj/item/bee_pack/proc/empty()
	full = 0
	name = "empty bee pack"
	desc = "A stasis pack for69oving bees. It's empty."
	overlays.Cut()
	overlays += "beepack-empty"

/obj/item/bee_pack/proc/fill()
	full = initial(full)
	name = initial(name)
	desc = initial(desc)
	overlays.Cut()
	overlays += "beepack-full"