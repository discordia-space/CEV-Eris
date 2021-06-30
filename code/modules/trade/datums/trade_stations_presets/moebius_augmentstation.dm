/datum/trade_station/augmentstation
	name_pool = list("HAATB 'Asocles'" = "Hansa Alliance Augmentations Trade Beacon 'Asocles'. They're sending a message. \"Hello there, we are from <whoknows>. We, are here trying to offer our most recent products to anyone willing to pay the correct price! We have one of the best specialized laboratory for augmentations, don't be afraid to come aboard and get some augmentations!\".")
	icon_states = "moe_cruiser"

	assortiment = list(
		"Moebius Base Prosthetics" = list(
			/obj/item/organ/external/robotic/moebius/l_arm = custom_good_name("Moebius left arm"), 
			/obj/item/organ/external/robotic/moebius/r_arm = custom_good_name("Moebius right arm"), 
			/obj/item/organ/external/robotic/moebius/l_leg = custom_good_name("Moebius left leg"), 
			/obj/item/organ/external/robotic/moebius/r_leg = custom_good_name("Moebius right leg"), 
			/obj/item/organ/external/robotic/moebius/groin = custom_good_name("Moebius groin")
		),
		"Technomancers" = list(
			/obj/item/organ/external/robotic/technomancer/l_arm,
			/obj/item/organ/external/robotic/technomancer/r_arm,
			/obj/item/organ/external/robotic/technomancer/l_leg,
			/obj/item/organ/external/robotic/technomancer/r_leg
		),
		"Frozen Star" = list(
			/obj/item/organ/external/robotic/frozen_star/l_arm,
			/obj/item/organ/external/robotic/frozen_star/r_arm,
			/obj/item/organ/external/robotic/frozen_star/l_leg,
			/obj/item/organ/external/robotic/frozen_star/r_leg
		),
		"Implants and Augmentations" = list(
			/obj/item/organ_module/active/simple/surgical,
			/obj/item/organ_module/active/multitool,
			/obj/item/organ_module/active/multitool/miner,
			/obj/item/organ_module/active/simple/armshield,
			/obj/item/organ_module/active/simple/wolverine
		),
	)
	
	offer_types = list(
	)


	//todo: ADVANCED TOOLS STATION, ROPAS QUE FALTAN, NOMBRES A OBJETOS. estacion que compre objetos ilegales/departamentales.