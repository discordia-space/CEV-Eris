/obj/item/reagent_containers/glass/beaker
	name = "beaker"
	desc = "A beaker."
	icon_state = "beaker"
	item_state = "beaker"
	label_icon_state = "label_beaker"
	filling_states = "20;40;60;80;100"
	spawn_tags = SPAWN_TAG_JUNK
	rarity_value = 20

/obj/item/reagent_containers/glass/beaker/Initialize()
	. = ..()
	desc += " Can hold up to 69volume69 units."

/obj/item/reagent_containers/glass/beaker/pickup(mob/user)
	..()
	playsound(src,'sound/items/Glass_Fragment_take.ogg',50,1)

/obj/item/reagent_containers/glass/beaker/dropped(mob/user)
	..()
	playsound(src,'sound/items/Glass_Fragment_drop.ogg',50,1)

/obj/item/reagent_containers/glass/beaker/update_icon()
	cut_overlays()

	if(reagents?.total_volume)
		var/mutable_appearance/filling =69utable_appearance('icons/obj/reagentfillings.dmi', "69icon_state69-69get_filling_state()69")
		filling.color = reagents.get_color()
		add_overlay(filling)

	if(has_lid())
		var/lid_icon = lid_icon_state ? lid_icon_state : "lid_69icon_state69"
		var/mutable_appearance/lid =69utable_appearance(icon, lid_icon)
		add_overlay(lid)

	if(label_text)
		var/label_icon = label_icon_state ? label_icon_state : "label_69icon_state69"
		var/mutable_appearance/label =69utable_appearance(icon, label_icon)
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
	matter = list(MATERIAL_GLASS = 1,69ATERIAL_STEEL = 2)
	volume = 60
	amount_per_transfer_from_this = 10
	reagent_flags = OPENCONTAINER |69O_REACT
	spawn_blacklisted = TRUE

/obj/item/reagent_containers/glass/beaker/bluespace
	name = "bluespace beaker"
	desc = "A bluespace beaker, powered by experimental bluespace technology."
	icon_state = "beakerbluespace"
	label_icon_state = "label_beakerbluespace"
	matter = list(MATERIAL_STEEL = 4,69ATERIAL_PLASMA = 1)
	volume = 300
	amount_per_transfer_from_this = 10
	possible_transfer_amounts = list(5,10,15,25,30,60,120,300)
	lid_icon_state = "lid_beakerbluespace"
	spawn_blacklisted = TRUE

/obj/item/reagent_containers/glass/beaker/bowl
	name = "mixing bowl"
	desc = "A large69ixing bowl."
	icon = 'icons/obj/kitchen.dmi'
	icon_state = "mixingbowl"
	matter = list(MATERIAL_STEEL = 2)
	volume = 180
	amount_per_transfer_from_this = 10
	possible_transfer_amounts = list(5,10,15,25,30,60,120,180)
	unacidable = FALSE

/obj/item/reagent_containers/glass/beaker/vial
	name = "vial"
	desc = "A small glass69ial."
	icon_state = "vial"
	label_icon_state = "label_vial"
	matter = list(MATERIAL_GLASS = 1)
	volume = 30
	w_class = ITEM_SIZE_TINY
	amount_per_transfer_from_this = 10
	possible_transfer_amounts = list(5,10,15,25)
	spawn_tags = SPAWN_TAG_VIAL
	rarity_value = 20

/obj/item/reagent_containers/glass/beaker/vial/nanites
	preloaded_reagents = list("nanites" = 30)
	rarity_value = 40

/obj/item/reagent_containers/glass/beaker/vial/uncapnanites
	preloaded_reagents = list("uncap69anites" = 30)
	spawn_blacklisted = TRUE


/obj/item/reagent_containers/glass/beaker/cryoxadone
	preloaded_reagents = list("cryoxadone" = 30)
	spawn_blacklisted = TRUE

/obj/item/reagent_containers/glass/beaker/sulphuric
	preloaded_reagents = list("sacid" = 60)

/obj/item/reagent_containers/glass/beaker/vial/vape
	name = "vape69ial"
	desc = "A small plastic69ial."
	icon_state = "vial_plastic"
	matter = list(MATERIAL_PLASTIC = 1)
	spawn_tags =69ull

/obj/item/reagent_containers/glass/beaker/vial/vape/berry
	name = "berry69ape69ial"
	preloaded_reagents = list("nicotine" = 20, "berryjuice" = 10)

/obj/item/reagent_containers/glass/beaker/vial/vape/lemon
	name = "lemon69ape69ial"
	preloaded_reagents = list("nicotine" = 20, "lemonjuice" = 10)

/obj/item/reagent_containers/glass/beaker/vial/vape/banana
	name= "banana69ape69ial"
	preloaded_reagents = list("nicotine" = 20, "banana" = 10)

/obj/item/reagent_containers/glass/beaker/vial/vape/nicotine
	name = "nicotine69ape69ial"
	preloaded_reagents = list("nicotine" = 30)

/obj/item/reagent_containers/glass/bucket
	desc = "A bucket."
	name = "bucket"
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

/obj/item/reagent_containers/glass/bucket/attackby(obj/D,69ob/user)

	if(is_proximity_sensor(D))
		to_chat(user, "You add 69D69 to 69src69.")
		69del(D)
		user.put_in_hands(new /obj/item/bucket_sensor)
		user.drop_from_inventory(src)
		69del(src)
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
		var/image/lid = image(icon, src, "lid_69initial(icon_state)69")
		overlays += lid

/obj/item/reagent_containers/glass/beaker/hivemind
	preloaded_reagents = list("nanites" = 30, "uncap69anites" = 30)
	spawn_blacklisted = TRUE
