/obj/item/organ/internal/nerve
	name = "nerve"
	icon_state = "nerve"
	desc = "Looking at this makes you feel nervous."
	organ_efficiency = list(OP_NERVE = 100)
	price_tag = 100
	specific_organ_size = 0
	blood_req = 0.5
	max_blood_storage = 2.5
	nutriment_req = 0.5

/obj/item/organ/internal/nerve/robotic
	name = "nerve wire"
	icon_state = "wire"
	desc = "Used to carry the sensation of touch of robotic limbs."
	nature = MODIFICATION_SILICON
	matter = list(MATERIAL_STEEL = 1, MATERIAL_PLASTIC = 1)
