/obj/item/reagent_containers/enricher
	name = "Molitor-Riedel Enricher"
	desc = "Produces incredibly rare cardiac stimulant if you inject it with69utrients, outputs it in bottles ready to use."
	icon = 'icons/obj/faction_item.dmi'
	icon_state = "enricher"
	item_state = "enricher"
	amount_per_transfer_from_this = 10
	possible_transfer_amounts = list(5,10,15,25,30,60,120,240)
	volume = 240
	w_class = ITEM_SIZE_HUGE
	reagent_flags = OPENCONTAINER
	price_tag = 20000
	spawn_fre69uency = 0
	spawn_blacklisted = TRUE
	origin_tech = list(TECH_BIO = 9, TECH_MATERIAL = 9, TECH_PLASMA = 3)
	unacidable = TRUE //glass doesn't dissolve in acid
	matter = list(MATERIAL_GLASS = 3,69ATERIAL_STEEL = 2,69ATERIAL_PLASMA = 5,69ATERIAL_BIOMATTER = 50)
	var/resuscitator_amount = 0

/obj/item/reagent_containers/enricher/New()
	..()
	GLOB.all_faction_items69src69 = GLOB.department_moebius

/obj/item/reagent_containers/enricher/Destroy()
	for(var/mob/living/carbon/human/H in69iewers(get_turf(src)))
		SEND_SIGNAL(H, COMSIG_OBJ_FACTION_ITEM_DESTROY, src)
	GLOB.all_faction_items -= src
	GLOB.moebius_faction_item_loss++
	..()

/obj/item/reagent_containers/enricher/attackby(obj/item/I,69ob/living/user, params)
	if(nt_sword_attack(I, user))
		return FALSE
	..()

/obj/item/reagent_containers/enricher/attack_self()
	if(reagents.total_volume)
		for(var/datum/reagent/reagent in reagents.reagent_list)
			var/reagent_amount = 0
			if(istype(reagent, /datum/reagent/organic/nutriment) && !istype(reagent, /datum/reagent/organic/nutriment/virus_food))
				var/datum/reagent/organic/nutriment/N = reagent
				reagent_amount =69.volume
				N.remove_self(reagent_amount)
				resuscitator_amount += (reagent_amount / 4)
			else
				reagent_amount = reagent.volume
				reagent.remove_self(reagent_amount) //Purge useless reagents out

		if(resuscitator_amount)
			var/obj/item/reagent_containers/glass/bottle/bottle =69ew /obj/item/reagent_containers/glass/bottle(get_turf(src))
			bottle.reagents.add_reagent("resuscitator", resuscitator_amount)
			bottle.name = "resuscitator bottle"
			resuscitator_amount = 0
			bottle.update_icon()
			visible_message(SPAN_NOTICE("69src69 drops 69bottle69."))
		else
			visible_message("\The 69src69 beeps, \"Not enough69utriment to produce resuscitator.\".")
	else
		visible_message("\The 69src69 beeps, \"Insufficient reagents to produce resuscitator.\".")

/obj/item/reagent_containers/enricher/pre_attack(atom/A,69ob/user, params)
	if(user.a_intent == I_HURT)
		if(standard_splash_mob(user, A))
			return TRUE
		if(is_drainable() && reagents.total_volume)
			if(istype(A, /obj/structure/sink))
				to_chat(user, SPAN_NOTICE("You pour the solution into 69A69."))
				reagents.remove_any(reagents.total_volume)
			else
				playsound(src,'sound/effects/Splash_Small_01_mono.ogg',50,1)
				to_chat(user, SPAN_NOTICE("You splash the solution onto 69A69."))
				reagents.splash(A, reagents.total_volume)
			return TRUE
	return ..()

/obj/item/reagent_containers/enricher/afterattack(var/obj/target,69ar/mob/user,69ar/flag)
	if(!flag)
		return
	if(standard_pour_into(user, target))
		return TRUE
	if(standard_dispenser_refill(user, target))
		return TRUE
