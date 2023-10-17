/obj/item/reagent_containers/glass/beaker
	name = "beaker"
	desc = "A beaker."
	description_info = "Can be heated using a lighter."
	description_antag = "You can spill reagents onto people with this. Spilling acid melts clothes off, provided it's in high enough doses."
	icon_state = "beaker"
	item_state = "beaker"
	label_icon_state = "label_beaker"
	filling_states = "20;40;60;80;100"
	spawn_tags = SPAWN_TAG_JUNK
	rarity_value = 20

/obj/item/reagent_containers/glass/beaker/Initialize()
	. = ..()
	desc += " Can hold up to [volume] units."
	if(preloaded_reagents)
		if(!has_lid())
			toggle_lid()

/obj/item/reagent_containers/glass/beaker/pickup(mob/user)
	..()
	playsound(src,'sound/items/Glass_Fragment_take.ogg',50,1)

/obj/item/reagent_containers/glass/beaker/dropped(mob/user)
	..()
	playsound(src,'sound/items/Glass_Fragment_drop.ogg',50,1)

/obj/item/reagent_containers/glass/beaker/update_icon()
	cut_overlays()

	if(reagents?.total_volume)
		var/mutable_appearance/filling = mutable_appearance('icons/obj/reagentfillings.dmi', "[icon_state]-[get_filling_state()]")
		filling.color = reagents.get_color()
		add_overlay(filling)

	if(has_lid())
		var/lid_icon = lid_icon_state ? lid_icon_state : "lid_[icon_state]"
		var/mutable_appearance/lid = mutable_appearance(icon, lid_icon)
		add_overlay(lid)

	if(label_text || (preloaded_reagents && display_label))
		var/label_icon = label_icon_state ? label_icon_state : "label_[icon_state]"
		var/mutable_appearance/label = mutable_appearance(icon, label_icon)
		add_overlay(label)

//// Subtypes ////

/obj/item/reagent_containers/glass/beaker/large
	name = "large beaker"
	desc = "A large beaker."
	icon_state = "beakerlarge"
	label_icon_state = "label_beakerlarge"
	matter = list(MATERIAL_GLASS = 2)
	volume = 120
	amount_per_transfer_from_this = 10
	possible_transfer_amounts = list(5,10,15,25,30,60,120)
	rarity_value = 40

/obj/item/reagent_containers/glass/beaker/noreact
	name = "cryostasis beaker"
	desc = "A cryostasis beaker that allows for chemical storage without reactions."
	icon_state = "beakernoreact"
	matter = list(MATERIAL_GLASS = 1, MATERIAL_STEEL = 2)
	volume = 60
	amount_per_transfer_from_this = 10
	reagent_flags = OPENCONTAINER | NO_REACT
	spawn_blacklisted = TRUE

/obj/item/reagent_containers/glass/beaker/bluespace
	name = "bluespace beaker"
	desc = "A bluespace beaker, powered by experimental bluespace technology."
	icon_state = "beakerbluespace"
	label_icon_state = "label_beakerbluespace"
	matter = list(MATERIAL_STEEL = 4, MATERIAL_PLASMA = 1)
	volume = 300
	amount_per_transfer_from_this = 10
	possible_transfer_amounts = list(5,10,15,25,30,60,120,300)
	lid_icon_state = "lid_beakerbluespace"
	spawn_blacklisted = TRUE
	price_tag = 300

//// Preloaded beakers ////

/obj/item/reagent_containers/glass/beaker/hivemind
	preloaded_reagents = list("nanites" = 30, "uncap nanites" = 30)
	desc = "A beaker. Contains a mix of nanites."
	spawn_blacklisted = TRUE

/obj/item/reagent_containers/glass/beaker/cryoxadone
	preloaded_reagents = list("cryoxadone" = 30)
	desc = "A beaker. Contains pure cryoxadone, meant to be used in cryo cells."
	spawn_blacklisted = TRUE

/obj/item/reagent_containers/glass/beaker/sulphuric
	desc = "A beaker. Contains dangerous sulphuric acid."
	preloaded_reagents = list("sacid" = 60)

//// Vial(s) ////

/obj/item/reagent_containers/glass/beaker/vial
	name = "vial"
	desc = "A small glass vial."
	icon_state = "vial"
	label_icon_state = "label_vial"
	lid_icon_state = "lid_vial"
	matter = list(MATERIAL_GLASS = 1)
	volume = 30
	w_class = ITEM_SIZE_TINY
	amount_per_transfer_from_this = 10
	possible_transfer_amounts = list(5,10,15,25)
	spawn_tags = SPAWN_TAG_VIAL
	rarity_value = 20

//// Preloaded vials ////

/obj/item/reagent_containers/glass/beaker/vial/nanites
	preloaded_reagents = list("nanites" = 30)
	desc = "A small glass vial. Contains raw industrial nanobots."
	rarity_value = 40

/obj/item/reagent_containers/glass/beaker/vial/uncapnanites
	preloaded_reagents = list("uncap nanites" = 30)
	spawn_blacklisted = TRUE
	display_label = FALSE

/obj/item/reagent_containers/glass/beaker/vial/kognim
	preloaded_reagents = list("kognim" = 30)
	spawn_blacklisted = TRUE
	display_label = FALSE

/obj/item/reagent_containers/glass/beaker/vial/psilocybin
	preloaded_reagents = list("psilocybin" = 30)
	desc = "A small glass vial. Contains Psilocybin."
	spawn_frequency = 5
	rarity_value = 30


/obj/item/reagent_containers/glass/beaker/vial/vape
	name = "vape vial"
	matter = list(MATERIAL_PLASTIC = 1)
	spawn_tags = null
	bad_type = /obj/item/reagent_containers/glass/beaker/vial/vape

/obj/item/reagent_containers/glass/beaker/vial/vape/berry
	name = "berry vape vial"
	preloaded_reagents = list("nicotine" = 20, "berryjuice" = 10)

/obj/item/reagent_containers/glass/beaker/vial/vape/lemon
	name = "lemon vape vial"
	preloaded_reagents = list("nicotine" = 20, "lemonjuice" = 10)

/obj/item/reagent_containers/glass/beaker/vial/vape/banana
	name= "banana vape vial"
	preloaded_reagents = list("nicotine" = 20, "banana" = 10)

/obj/item/reagent_containers/glass/beaker/vial/vape/nicotine
	name = "nicotine vape vial"
	preloaded_reagents = list("nicotine" = 30)


/obj/item/reagent_containers/glass/beaker/vial/random
	rarity_value = 30
	var/list/random_reagent_list = list(list("water" = 15) = 1, list("cleaner" = 15) = 1)

/obj/item/reagent_containers/glass/beaker/vial/random/toxin
	rarity_value = 30
	random_reagent_list = list(
		list("amatoxin" = 10, "potassium_chloride" = 20)	= 3,
		list("carpotoxin" = 15)							= 2,
		list("impedrezene" = 15)						= 2,
		list("zombiepowder" = 10)						= 1)

/obj/item/reagent_containers/glass/beaker/vial/random/Initialize()
	. = ..()

	var/list/picked_reagents = pickweight(random_reagent_list)
	for(var/reagent in picked_reagents)
		reagents.add_reagent(reagent, picked_reagents[reagent])

	var/list/names = new
	for(var/datum/reagent/R in reagents.reagent_list)
		names += R.name

	if(!has_lid())
		toggle_lid()


//// Other ////

/obj/item/reagent_containers/glass/bucket
	name = "bucket"
	desc = "A bucket."
	icon = 'icons/obj/janitor.dmi'
	icon_state = "bucket"
	item_state = "bucket"
	matter = list(MATERIAL_PLASTIC = 2)
	w_class = ITEM_SIZE_NORMAL
	amount_per_transfer_from_this = 20
	possible_transfer_amounts = list(10,20,30,60,120,200)
	volume = 200
	unacidable = 0
	spawn_tags = SPAWN_TAG_JUNK
	rarity_value = 20

/obj/item/reagent_containers/glass/bucket/attackby(obj/D, mob/user)

	if(isproxsensor(D))
		to_chat(user, "You add [D] to [src].")
		qdel(D)
		user.put_in_hands(new /obj/item/bucket_sensor)
		user.drop_from_inventory(src)
		qdel(src)
		return
	else if(istype(D, /obj/item/mop))
		return
	else
		return ..()

/obj/item/reagent_containers/glass/bucket/update_icon()
	cut_overlays()
	if(reagents.total_volume >= 1)
		overlays += "water_bucket"
	if(has_lid())
		var/image/lid = image(icon, src, "lid_[initial(icon_state)]")
		overlays += lid
