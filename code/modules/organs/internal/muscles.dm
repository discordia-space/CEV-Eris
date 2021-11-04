/obj/item/organ/internal/muscle
	name = "muscle"
	icon_state = "human_muscle"
	desc = "Rip and tear"
	organ_efficiency = list(OP_MUSCLE = 100)
	price_tag = 100
	max_damage = 50
	specific_organ_size = 0.5
	blood_req = 0.5
	max_blood_storage = 2.5
	nutriment_req = 0.5

/obj/item/organ/internal/muscle/robotic
	name = "hydraulic"
	icon_state = "robotic_muscle"
	desc = "Expand and contract"
	nature = MODIFICATION_SILICON
	matter = list(MATERIAL_STEEL = 1)

/obj/item/organ/internal/muscle/super_muscle
	name = "super muscle"
	icon_state = "human_muscle_super"
	organ_efficiency = list(OP_MUSCLE = 150)
	specific_organ_size = 0.6
