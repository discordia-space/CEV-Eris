/obj/random/medical
	name = "random medicine"
	icon_state = "meds-green"

/obj/random/medical/item_to_spawn()
	return pick(prob(4);/obj/item/stack/medical/bruise_pack,\
				prob(4);/obj/item/stack/medical/ointment,\
				prob(2);/obj/item/stack/medical/advanced/bruise_pack,\
				prob(2);/obj/item/stack/medical/advanced/ointment,\
				prob(1);/obj/item/stack/medical/splint,\
				prob(2);/obj/item/bodybag,\
				prob(1);/obj/item/bodybag/cryobag,\
				prob(2);/obj/item/weapon/storage/pill_bottle/kelotane,\
				prob(2);/obj/item/weapon/storage/pill_bottle/antitox,\
				prob(2);/obj/item/weapon/storage/pill_bottle/tramadol,\
				prob(2);/obj/item/weapon/reagent_containers/syringe/antitoxin,\
				prob(1);/obj/item/weapon/reagent_containers/syringe/antiviral,\
				prob(2);/obj/item/weapon/reagent_containers/syringe/inaprovaline,\
				prob(1);/obj/item/stack/nanopaste)

/obj/random/medical/low_chance
	name = "low chance random medicine"
	icon_state = "meds-green-low"
	spawn_nothing_percentage = 60

/obj/random/medical_lowcost
	name = "random low tier medicine"
	icon_state = "meds-grey"

/obj/random/medical_lowcost/item_to_spawn()
	return pick(prob(4);/obj/item/stack/medical/bruise_pack,\
				prob(4);/obj/item/stack/medical/ointment,\
				prob(2);/obj/item/weapon/reagent_containers/syringe/antitoxin,\
				prob(2);/obj/item/weapon/reagent_containers/syringe/inaprovaline)

/obj/random/medical_lowcost/low_chance
	name = "low chance random low tier medicine"
	icon_state = "meds-grey-low"
	spawn_nothing_percentage = 60

/obj/random/firstaid
	name = "random first aid kit"
	icon_state = "meds-red"

/obj/random/firstaid/item_to_spawn()
	return pick(prob(3);/obj/item/weapon/storage/firstaid/regular,\
				prob(2);/obj/item/weapon/storage/firstaid/toxin,\
				prob(2);/obj/item/weapon/storage/firstaid/o2,\
				prob(1);/obj/item/weapon/storage/firstaid/adv,\
				prob(2);/obj/item/weapon/storage/firstaid/fire)

/obj/random/firstaid/low_chance
	name = "low chance random first aid kit"
	icon_state = "meds-red-low"
	spawn_nothing_percentage = 60
