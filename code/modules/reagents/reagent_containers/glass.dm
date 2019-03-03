
////////////////////////////////////////////////////////////////////////////////
/// (Mixing)Glass.
////////////////////////////////////////////////////////////////////////////////
/obj/item/weapon/reagent_containers/glass
	name = " "
	var/base_name = " "
	desc = " "
	icon = 'icons/obj/chemical.dmi'
	icon_state = "null"
	item_state = "null"
	amount_per_transfer_from_this = 10
	possible_transfer_amounts = list(5,10,15,25,30,60)
	volume = 60
	w_class = ITEM_SIZE_SMALL
	reagent_flags = OPENCONTAINER
	unacidable = 1 //glass doesn't dissolve in acid

	var/label_text = ""

	var/list/can_be_placed_into = list(
		/obj/machinery/chem_master/,
		/obj/machinery/chemical_dispenser,
		/obj/machinery/reagentgrinder,
		/obj/structure/table,
		/obj/structure/closet,
		/obj/structure/sink,
		/obj/item/weapon/storage,
		/obj/machinery/atmospherics/unary/cryo_cell,
		/obj/machinery/dna_scannernew,
		/obj/item/weapon/grenade/chem_grenade,
		/mob/living/bot/medbot,
		/obj/item/weapon/storage/secure/safe,
		/obj/structure/medical_stand,
		/obj/machinery/disease2/incubator,
		/obj/machinery/disposal,
		/mob/living/simple_animal/cow,
		/mob/living/simple_animal/hostile/retaliate/goat,
		/obj/machinery/computer/centrifuge,
		/obj/machinery/sleeper,
		/obj/machinery/smartfridge/,
		/obj/machinery/biogenerator,
		/obj/machinery/constructable_frame,
		/obj/machinery/radiocarbon_spectrometer
		)

/obj/item/weapon/reagent_containers/glass/New()
	..()
	base_name = name

/obj/item/weapon/reagent_containers/glass/proc/has_lid()
	return !is_open_container()

/obj/item/weapon/reagent_containers/glass/proc/toggle_lid()
	// Switch it from REFILLABLE | DRAINABLE to INJECTABLE | DRAWABLE, or the other way around.
	// This way, you can still use syringes through the lid.
	reagent_flags ^= REFILLABLE | DRAINABLE | INJECTABLE | DRAWABLE

	update_icon()
	return TRUE


/obj/item/weapon/reagent_containers/glass/examine(mob/user)
	if(!..(user, 2))
		return
	if(has_lid())
		user << SPAN_NOTICE("Airtight lid seals it completely.")

/obj/item/weapon/reagent_containers/glass/attack_self(mob/user)
	..()
	if(!toggle_lid())
		return

	if(has_lid())
		playsound(src,'sound/effects/Lid_Removal_Bottle_mono.ogg',50,1)
		user << SPAN_NOTICE("You put the lid on \the [src].")
	else
		user << SPAN_NOTICE("You take the lid off \the [src].")


/obj/item/weapon/reagent_containers/glass/afterattack(var/obj/target, var/mob/user, var/flag)
	if(!is_open_container() || !flag)
		return
	for(var/type in can_be_placed_into)
		if(istype(target, type))
			return
	if(standard_dispenser_refill(user, target))
		return 1
	if(standard_pour_into(user, target))
		return 1

/obj/item/weapon/reagent_containers/glass/attackby(obj/item/weapon/W, mob/user)
	if(istype(W, /obj/item/weapon/pen) || istype(W, /obj/item/device/lighting/toggleable/flashlight/pen))
		var/tmp_label = sanitizeSafe(input(user, "Enter a label for [name]", "Label", label_text), MAX_NAME_LEN)
		if(length(tmp_label) > 10)
			user << SPAN_NOTICE("The label can be at most 10 characters long.")
		else
			user << "<span class='notice'>You set the label to \"[tmp_label]\".</span>"
			label_text = tmp_label
			update_name_label()

/obj/item/weapon/reagent_containers/glass/proc/update_name_label()
	playsound(src,'sound/effects/PEN_Ball_Point_Pen_Circling_01_mono.ogg',40,1)
	if(label_text == "")
		name = base_name
	else
		name = "[base_name] ([label_text])"

/obj/item/weapon/reagent_containers/glass/beaker/pre_attack(atom/A, mob/user, params)
	if(user.a_intent == I_HURT)
		if(standard_splash_mob(user, A))
			return TRUE
		if(is_drainable() && reagents.total_volume)
			if(istype(A, /obj/structure/sink))
				user << SPAN_NOTICE("You pour the solution into [A].")
				reagents.remove_any(reagents.total_volume)
			else
				playsound(src,'sound/effects/Splash_Small_01_mono.ogg',50,1)
				user << SPAN_NOTICE("You splash the solution onto [A].")
				reagents.splash(A, reagents.total_volume)
			return TRUE
	return ..()

/obj/item/weapon/reagent_containers/glass/beaker
	name = "beaker"
	desc = "A beaker."
	icon = 'icons/obj/chemical.dmi'
	icon_state = "beaker"
	item_state = "beaker"
	matter = list(MATERIAL_GLASS = 1)

/obj/item/weapon/reagent_containers/glass/beaker/Initialize()
	. = ..()
	desc += " Can hold up to [volume] units."

/obj/item/weapon/reagent_containers/glass/beaker/on_reagent_change()
	update_icon()

/obj/item/weapon/reagent_containers/glass/beaker/pickup(mob/user)
	..()
	playsound(src,'sound/items/Glass_Fragment_take.ogg',50,1)

/obj/item/weapon/reagent_containers/glass/beaker/dropped(mob/user)
	..()
	playsound(src,'sound/items/Glass_Fragment_drop.ogg',50,1)

/obj/item/weapon/reagent_containers/glass/beaker/update_icon()
	overlays.Cut()

	if(reagents.total_volume)
		var/image/filling = image('icons/obj/reagentfillings.dmi', src, "[icon_state]10")

		var/percent = round((reagents.total_volume / volume) * 100)
		switch(percent)
			if(0 to 9)		filling.icon_state = "[icon_state]-10"
			if(10 to 24) 	filling.icon_state = "[icon_state]10"
			if(25 to 49)	filling.icon_state = "[icon_state]25"
			if(50 to 74)	filling.icon_state = "[icon_state]50"
			if(75 to 79)	filling.icon_state = "[icon_state]75"
			if(80 to 90)	filling.icon_state = "[icon_state]80"
			if(91 to INFINITY)	filling.icon_state = "[icon_state]100"

		filling.color = reagents.get_color()
		overlays += filling

	if(has_lid())
		var/image/lid = image(icon, src, "lid_[initial(icon_state)]")
		overlays += lid

