/obj/random/medical
	name = "random medicine"
	icon_state = "meds-green"

/obj/random/medical/item_to_spawn()
	return pickweight(list(/obj/item/stack/medical/bruise_pack = 5,\
				/obj/item/stack/medical/ointment = 5,\
				/obj/item/stack/medical/advanced/bruise_pack = 3,\
				/obj/item/stack/medical/advanced/ointment = 3,\
				/obj/item/stack/medical/splint = 2,\
				/obj/item/bodybag = 3,\
				/obj/item/bodybag/cryobag = 2,\
				/obj/item/weapon/storage/pill_bottle/kelotane = 2,\
				/obj/item/weapon/storage/pill_bottle/antitox = 2,\
				/obj/item/weapon/storage/pill_bottle/tramadol = 2,\
				/obj/item/weapon/storage/pill_bottle/happy = 1,\
				/obj/item/weapon/storage/pill_bottle/zoom = 1,\
				/obj/item/weapon/storage/pill_bottle/bicaridine = 1,\
				/obj/item/weapon/storage/pill_bottle/dexalin_plus = 1,\
				/obj/item/weapon/storage/pill_bottle/dexalin = 2,\
				/obj/item/weapon/storage/pill_bottle/dermaline = 2,\
				/obj/item/weapon/storage/pill_bottle/dylovene = 2,\
				/obj/item/weapon/storage/pill_bottle/inaprovaline = 2,\
				/obj/item/weapon/storage/pill_bottle/spaceacillin = 2,\
				/obj/item/weapon/storage/pill_bottle/citalopram = 2,\
				/obj/item/weapon/reagent_containers/glass/bottle/stoxin = 2,\
				/obj/item/weapon/reagent_containers/glass/bottle/toxin = 2,\
				/obj/item/weapon/reagent_containers/glass/bottle/cyanide = 0.5,\
				/obj/item/weapon/reagent_containers/glass/bottle/mutagen = 0.5,\
				/obj/item/weapon/reagent_containers/glass/bottle/ammonia = 2,\
				/obj/item/weapon/reagent_containers/glass/bottle/pacid = 0.5,\
				/obj/item/weapon/reagent_containers/glass/bottle/inaprovaline = 3,\
				/obj/item/weapon/reagent_containers/syringe = 5,\
				/obj/item/weapon/reagent_containers/syringe/antitoxin = 2,\
				/obj/item/weapon/reagent_containers/syringe/antiviral = 1,\
				/obj/item/weapon/reagent_containers/syringe/inaprovaline = 2,\
				/obj/item/stack/nanopaste = 1))

/obj/random/medical/low_chance
	name = "low chance random medicine"
	icon_state = "meds-green-low"
	spawn_nothing_percentage = 60

/obj/random/medical_lowcost
	name = "random low tier medicine"
	icon_state = "meds-grey"

/obj/random/medical_lowcost/item_to_spawn()
	return pickweight(list(/obj/item/stack/medical/bruise_pack = 4,\
				/obj/item/stack/medical/ointment = 4,\
				/obj/item/weapon/reagent_containers/syringe/antitoxin = 2,\
				/obj/item/weapon/reagent_containers/syringe/inaprovaline = 2))

/obj/random/medical_lowcost/low_chance
	name = "low chance random low tier medicine"
	icon_state = "meds-grey-low"
	spawn_nothing_percentage = 60

/obj/random/firstaid
	name = "random first aid kit"
	icon_state = "meds-red"

/obj/random/firstaid/item_to_spawn()
	return pickweight(list(/obj/item/weapon/storage/firstaid/regular = 3,\
				/obj/item/weapon/storage/firstaid/toxin = 2,\
				/obj/item/weapon/storage/firstaid/o2 = 2,\
				/obj/item/weapon/storage/firstaid/adv = 1,\
				/obj/item/weapon/storage/firstaid/fire = 2))

/obj/random/firstaid/low_chance
	name = "low chance random first aid kit"
	icon_state = "meds-red-low"
	spawn_nothing_percentage = 60