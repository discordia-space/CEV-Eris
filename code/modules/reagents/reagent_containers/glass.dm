
////////////////////////////////////////////////////////////////////////////////
/// (Mixing)Glass.
////////////////////////////////////////////////////////////////////////////////
/obj/item/reagent_containers/glass
	name = " "
	var/base_name = " "
	desc = ""
	icon = 'icons/obj/chemical.dmi'
	icon_state = "null"
	item_state = "null"
	amount_per_transfer_from_this = 10
	possible_transfer_amounts = list(5,10,15,25,30,60)
	volume = 60
	w_class = ITEM_SIZE_SMALL
	reagent_flags = OPENCONTAINER
	unacidable = 1 //glass doesn't dissolve in acid
	matter = list(MATERIAL_GLASS = 1)
	bad_type = /obj/item/reagent_containers/glass
	var/label_icon_state
	var/lid_icon_state

	var/label_text = ""

	var/list/can_be_placed_into = list(
		/obj/machinery/chem_master/,
		/obj/machinery/chemical_dispenser,
		/obj/machinery/reagentgrinder,
		/obj/structure/table,
		/obj/structure/closet,
		/obj/structure/sink,
		/obj/item/storage,
		/obj/machinery/atmospherics/unary/cryo_cell,
		/obj/machinery/dna_scannernew,
		/obj/item/grenade/chem_grenade,
		/mob/living/bot/medbot,
		/obj/item/storage/secure/safe,
		/obj/structure/medical_stand,
		/obj/machinery/disease2/incubator,
		/obj/machinery/disposal,
		/mob/living/simple_animal/cow,
		/mob/living/simple_animal/hostile/retaliate/goat,
		/obj/machinery/sleeper,
		/obj/machinery/smartfridge/,
		/obj/machinery/biogenerator,
		/obj/machinery/constructable_frame,
		/obj/machinery/radiocarbon_spectrometer,
		/obj/machinery/centrifuge,
		/obj/machinery/electrolyzer
		)

/obj/item/reagent_containers/glass/Initialize()
	. = ..()
	base_name =69ame

/obj/item/reagent_containers/glass/proc/has_lid()
	return !is_open_container()

/obj/item/reagent_containers/glass/proc/toggle_lid()
	// Switch it from REFILLABLE | DRAINABLE to INJECTABLE | DRAWABLE, or the other way around.
	// This way, you can still use syringes through the lid.
	reagent_flags ^= REFILLABLE | DRAINABLE | INJECTABLE | DRAWABLE

	update_icon()
	return TRUE

/obj/item/reagent_containers/glass/is_closed_message(mob/user)
	if(has_lid())
		to_chat(user, SPAN_NOTICE("You69eed to take the lid off 69src69 first!"))

/obj/item/reagent_containers/glass/self_feed_message(var/mob/user)
	to_chat(user, SPAN_NOTICE("You swallow a gulp from \the 69src69."))

/obj/item/reagent_containers/glass/feed_sound(var/mob/user)
	playsound(user.loc, 'sound/items/drink.ogg', rand(10, 50), 1)

/obj/item/reagent_containers/glass/examine(mob/user)
	if(!..(user, 2))
		return
	if(has_lid())
		to_chat(user, SPAN_NOTICE("Airtight lid seals it completely."))

/obj/item/reagent_containers/glass/attack_self(mob/user)
	..()
	if(toggle_lid())
		playsound(src,'sound/effects/Lid_Removal_Bottle_mono.ogg',50,1)
		if(has_lid())
			to_chat(user, SPAN_NOTICE("You put the lid on \the 69src69."))
		else
			to_chat(user, SPAN_NOTICE("You take the lid off \the 69src69."))

/obj/item/reagent_containers/glass/pre_attack(atom/A,69ob/user, params)
	if(user.a_intent == I_HURT)
		user.investigate_log("splashed 69src69 filled with 69reagents.log_list()69 onto 69A69", "chemistry")
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

/obj/item/reagent_containers/glass/attack(mob/M as69ob,69ob/user as69ob, def_zone)
	if(force && !(flags &69OBLUDGEON) && user.a_intent == I_HURT)
		return ..()

	if(standard_feed_mob(user,69))
		return

	return 0

/obj/item/reagent_containers/glass/afterattack(var/obj/target,69ar/mob/user,69ar/flag)
	if(!flag)
		return
	for(var/type in can_be_placed_into)
		if(istype(target, type))
			return
	if(standard_pour_into(user, target))
		return 1
	if(standard_dispenser_refill(user, target))
		return 1

/obj/item/reagent_containers/glass/attackby(obj/item/I,69ob/user)
	if(istype(I, /obj/item/pen) || istype(I, /obj/item/device/lighting/toggleable/flashlight/pen))
		var/tmp_label = sanitizeSafe(input(user, "Enter a label for 69name69", "Label", label_text),69AX_NAME_LEN)
		if(length(tmp_label) > 10)
			to_chat(user, SPAN_NOTICE("The label can be at69ost 10 characters long."))
		else
			to_chat(user, SPAN_NOTICE("You set the label to \"69tmp_label69\"."))
			label_text = tmp_label
			update_name_label()
			update_icon()

	var/hotness = I.is_hot()
	if(hotness && reagents)
		reagents.expose_temperature(hotness)
		to_chat(user, SPAN_NOTICE("You heat 69name69 with 69I69!"))

	..()

/obj/item/reagent_containers/glass/proc/update_name_label()
	playsound(src,'sound/effects/PEN_Ball_Point_Pen_Circling_01_mono.ogg',40,1)
	if(label_text == "")
		name = base_name
	else
		name = "69base_name69 (69label_text69)"

/obj/item/reagent_containers/glass/MouseDrop(obj/over_object,src_location,over_location)
	. = ..()
	if(istype(over_object, /obj/structure/reagent_dispensers))
		reagents.trans_to(over_object, amount_per_transfer_from_this, ignore_isinjectable = 1)
