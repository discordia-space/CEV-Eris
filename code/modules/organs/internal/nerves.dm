/obj/item/organ/internal/nerve
	name = "nerve"
	icon_state = "nerve"
	desc = "Looking at this makes you feel nervous."
	description_info = "Increases limb sensitivity, making you more susceptible to pain, but also more precise with tools"
	organ_efficiency = list(OP_NERVE = 100)
	price_tag = 100
	max_damage = 50
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

/obj/item/organ/internal/nerve/sensitive_nerve
	name = "sensitive nerves"
	icon_state = "nerve_sensitive"
	desc = "Looking at this makes you feel both nervous and sensitive!"
	organ_efficiency = list(OP_NERVE = 150)
	specific_organ_size = 0.1
