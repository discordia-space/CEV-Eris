/obj/item/organ/internal/blood_vessel
	name = "blood vessel"
	icon_state = "blood_vessel"
	organ_efficiency = list(OP_BLOOD_VESSEL= 100)
	desc = "Transports blood throughout the human body."
	price_tag = 100
	max_damage = IORGAN_SMALL_HEALTH
	min_bruised_damage = IORGAN_SMALL_BRUISE
	min_broken_damage = IORGAN_SMALL_BREAK
	specific_organ_size = 0.5
	max_blood_storage = 100
	oxygen_req = 2
	nutriment_req = 1

/obj/item/organ/internal/blood_vessel/extensive
	name = "extensive blood vessels"
	icon_state = "blood_vessel_extensive"
	desc = "Now you bleed out twice as fast!"
	organ_efficiency = list(OP_BLOOD_VESSEL = 150)
	specific_organ_size = 0.6
