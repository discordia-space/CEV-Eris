/obj/item/storage/box/bloodpacks
	name = "blood packs bags"
	desc = "This box contains blood packs."
	icon_state = "sterile"
	rarity_value = 10
	prespawned_content_amount = 7
	prespawned_content_type = /obj/item/reagent_containers/blood

/obj/item/reagent_containers/blood
	name = "blood pack"
	desc = "Contains blood used for transfusion."
	icon = 'icons/obj/bloodpack.dmi'
	icon_state = "bloodpack"
	volume = 200
	reagent_flags = OPENCONTAINER
	filling_states = "25;50;75;100"
	bad_type = /obj/item/reagent_containers/blood
	var/blood_type

/obj/item/reagent_containers/blood/Initialize()
	. = ..()
	if(blood_type)
		reagents.add_reagent("blood", 200, list("donor"=null,"viruses"=null,"blood_DNA"=null,"blood_type"=blood_type,"resistances"=null,"trace_chem"=null))


/obj/item/reagent_containers/blood/on_reagent_change()
	..()
	update_name()


/obj/item/reagent_containers/blood/update_icon()
	cut_overlays()

	if(!reagents || !reagents.total_volume)
		return

	var/has_blood
	for(var/datum/reagent/current in reagents.reagent_list)
		if(current.id == "blood")
			has_blood = TRUE

	if(!has_blood)
		var/mutable_appearance/filling = mutable_appearance(icon, "[icon_state][get_filling_state()]")
		filling.color = reagents.get_color()
		add_overlay(filling)
	else
		var/mutable_appearance/filling = mutable_appearance(icon, "[icon_state]-blood[get_filling_state()]")
		add_overlay(filling)

/obj/item/reagent_containers/blood/proc/update_name()
	var/list/data = reagents.get_data("blood")
	if(data)
		blood_type = data["blood_type"]
		name = "blood pack ([blood_type])"
	else
		name = "blood pack"

#define bloodtypeandpackname(bloodtype) name = "blood pack ("+bloodtype+")"; blood_type = bloodtype;
/obj/item/reagent_containers/blood/APlus
	bloodtypeandpackname("A+")

/obj/item/reagent_containers/blood/AMinus
	bloodtypeandpackname("A-")

/obj/item/reagent_containers/blood/BPlus
	bloodtypeandpackname("B+")

/obj/item/reagent_containers/blood/BMinus
	bloodtypeandpackname("B-")

/obj/item/reagent_containers/blood/OPlus
	bloodtypeandpackname("O+")

/obj/item/reagent_containers/blood/OMinus
	bloodtypeandpackname("O-")

/obj/item/reagent_containers/blood/empty
	spawn_tags = SPAWN_TAG_JUNK
	rarity_value = 20
