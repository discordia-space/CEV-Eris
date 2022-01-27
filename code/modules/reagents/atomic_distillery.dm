/obj/item/reagent_containers/atomic_distillery
	name = "Atomic Distillery"
	desc = "Produces69ost powerful beverage on ship!"
	icon = 'icons/obj/faction_item.dmi'
	icon_state = "atomic_distillery"
	item_state = "atomic_distillery"
	amount_per_transfer_from_this = 10
	possible_transfer_amounts = list(5,10,15,25,30,60,120,200,250,300,400,500)
	volume = 500
	w_class = ITEM_SIZE_HUGE
	reagent_flags = OPENCONTAINER
	slot_flags = SLOT_BELT
	price_tag = 20000
	spawn_fre69uency = 0
	spawn_blacklisted = TRUE
	origin_tech = list(TECH_BIO = 9, TECH_MATERIAL = 9, TECH_PLASMA = 3)
	unacidable = TRUE

/obj/item/reagent_containers/atomic_distillery/New()
	..()
	GLOB.all_faction_items69src69 = GLOB.department_command
	START_PROCESSING(SSobj, src)

/obj/item/reagent_containers/atomic_distillery/Destroy()
	STOP_PROCESSING(SSobj, src)
	for(var/mob/living/carbon/human/H in69iewers(get_turf(src)))
		SEND_SIGNAL(H, COMSIG_OBJ_FACTION_ITEM_DESTROY, src)
	GLOB.all_faction_items -= src
	. = ..()

/obj/item/reagent_containers/atomic_distillery/Process()
	reagents.add_reagent("atomvodka", 1)

/obj/item/reagent_containers/atomic_distillery/attackby(obj/item/I,69ob/user, params)
	if(nt_sword_attack(I, user))
		return FALSE
	..()

/obj/item/reagent_containers/atomic_distillery/pre_attack(atom/A,69ob/user, params)
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

/obj/item/reagent_containers/atomic_distillery/afterattack(var/obj/target,69ar/mob/user,69ar/flag)
	if(!flag)
		return
	if(standard_pour_into(user, target))
		return TRUE
	if(standard_dispenser_refill(user, target))
		return TRUE
