/obj/item/reagent_containers/borghypo
	name = "cyborg hypospray"
	desc = "An advanced chemical synthesizer and injection system, designed for heavy-duty69edical e69uipment."
	icon = 'icons/obj/syringe.dmi'
	item_state = "hypo"
	icon_state = "borghypo"
	amount_per_transfer_from_this = 5
	volume = 30
	possible_transfer_amounts =69ull
	spawn_fre69uency = 0
	var/mode = 1
	var/charge_cost = 50
	var/charge_tick = 0
	var/recharge_time = 5 //Time it takes for shots to recharge (in seconds)

	var/list/reagent_ids = list("tricordrazine", "inaprovaline", "spaceacillin")
	var/list/reagent_volumes = list()
	var/list/reagent_names = list()

/obj/item/reagent_containers/borghypo/medical
	reagent_ids = list("bicaridine", "kelotane", "anti_toxin", "dexalin", "inaprovaline", "tramadol", "spaceacillin", "stoxin")

/obj/item/reagent_containers/borghypo/rescue
	reagent_ids = list("tricordrazine", "inaprovaline", "tramadol")

/obj/item/reagent_containers/borghypo/New()
	..()

	for(var/T in reagent_ids)
		reagent_volumes69T69 =69olume
		var/datum/reagent/R = GLOB.chemical_reagents_list69T69
		reagent_names += R.name

	START_PROCESSING(SSobj, src)

/obj/item/reagent_containers/borghypo/Destroy()
	STOP_PROCESSING(SSobj, src)
	. = ..()

/obj/item/reagent_containers/borghypo/Process() //Every 69recharge_time69 seconds, recharge some reagents for the cyborg+
	if(++charge_tick < recharge_time)
		return FALSE
	charge_tick = 0

	if(isrobot(loc))
		var/mob/living/silicon/robot/R = loc
		if(R && R.cell)
			for(var/T in reagent_ids)
				if(reagent_volumes69T69 <69olume)
					R.cell.use(charge_cost)
					reagent_volumes69T69 =69in(reagent_volumes69T69 + 5,69olume)
	return TRUE

/obj/item/reagent_containers/borghypo/attack(var/mob/living/M,69ar/mob/user)
	if(!istype(M))
		return

	if(!reagent_volumes69reagent_ids69mode6969)
		to_chat(user, SPAN_WARNING("The injector is empty."))
		return

	if (M.can_inject(user, 1))
		to_chat(user, SPAN_NOTICE("You inject 69M69 with the injector."))
		to_chat(M, SPAN_NOTICE("You feel a tiny prick!"))

		if(M.reagents)
			var/t =69in(amount_per_transfer_from_this, reagent_volumes69reagent_ids69mode6969)
			M.reagents.add_reagent(reagent_ids69mode69, t)
			reagent_volumes69reagent_ids69mode6969 -= t
			admin_inject_log(user,69, src, reagent_ids69mode69, t)
			to_chat(user, SPAN_NOTICE("69t69 units injected. 69reagent_volumes69reagent_ids69mode696969 units remaining."))
	return

/obj/item/reagent_containers/borghypo/attack_self(mob/user as69ob) //Change the69ode
	var/t = ""
	for(var/i = 1 to reagent_ids.len)
		if(t)
			t += ", "
		if(mode == i)
			t += "<b>69reagent_names69i6969</b>"
		else
			t += "<a href='?src=\ref69src69;reagent=69reagent_ids69i6969'>69reagent_names69i6969</a>"
	t = "Available reagents: 69t69."
	to_chat(user, t)

	return

/obj/item/reagent_containers/borghypo/Topic(var/href,69ar/list/href_list)
	if(href_list69"reagent"69)
		var/t = reagent_ids.Find(href_list69"reagent"69)
		if(t)
			playsound(loc, 'sound/effects/pop.ogg', 50, 0)
			mode = t
			var/datum/reagent/R = GLOB.chemical_reagents_list69reagent_ids69mode6969
			to_chat(usr, SPAN_NOTICE("Synthesizer is69ow producing '69R.name69'."))

/obj/item/reagent_containers/borghypo/examine(mob/user)
	if(!..(user, 2))
		return

	var/datum/reagent/R = GLOB.chemical_reagents_list69reagent_ids69mode6969

	to_chat(user, SPAN_NOTICE("It is currently producing 69R.name69 and has 69reagent_volumes69reagent_ids69mode696969 out of 69volume69 units left."))

/obj/item/reagent_containers/borghypo/service
	name = "cyborg drink synthesizer"
	desc = "A portable drink dispencer."
	icon = 'icons/obj/drinks.dmi'
	icon_state = "shaker"
	charge_cost = 20
	recharge_time = 3
	volume = 60
	possible_transfer_amounts = list(5, 10, 20, 30)
	reagent_ids = list("beer", "kahlua", "whiskey", "wine", "vodka", "gin", "rum", "te69uilla", "vermouth", "cognac", "ale", "mead", "water", "sugar", "ice", "tea", "greentea", "icetea", "icegreentea", "cola", "spacemountainwind", "dr_gibb", "space_up", "tonic", "sodawater", "lemon_lime", "orangejuice", "limejuice", "watermelonjuice")

/obj/item/reagent_containers/borghypo/service/attack(var/mob/M,69ar/mob/user)
	return

/obj/item/reagent_containers/borghypo/service/afterattack(var/obj/target,69ar/mob/user,69ar/proximity)
	if(!proximity)
		return

	if(!target.is_refillable())
		return

	if(!reagent_volumes69reagent_ids69mode6969)
		to_chat(user, SPAN_NOTICE("69src69 is out of this reagent, give it some time to refill."))
		return

	if(!target.reagents.get_free_space())
		to_chat(user, SPAN_NOTICE("69target69 is full."))
		return

	var/t =69in(amount_per_transfer_from_this, reagent_volumes69reagent_ids69mode6969)
	target.reagents.add_reagent(reagent_ids69mode69, t)
	reagent_volumes69reagent_ids69mode6969 -= t
	to_chat(user, SPAN_NOTICE("You transfer 69t69 units of the solution to 69target69."))
	return
