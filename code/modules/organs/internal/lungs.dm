/obj/item/organ/internal/lungs
	name = "lungs"
	icon_state = "lungs"
	gender = PLURAL
	organ_efficiency = list(OP_LUNGS = 100)
	parent_organ_base = BP_CHEST
	specific_organ_size = 2
	price_tag = 300
	blood_req = 10
	max_blood_storage = 50
	nutriment_req = 10
	var/breath_modulo = 2

/obj/item/organ/internal/lungs/long
	name = "long lungs"
	icon_state = "long_lungs"
	organ_efficiency = list(OP_LUNGS = 150)
	specific_organ_size = 2.3
	breath_modulo = 8

/obj/item/organ/internal/heart/huge
	name = "huge heart"
	organ_efficiency = list(OP_HEART = 150)
	specific_organ_size = 2.3
	max_blood_storage = 100
	nutriment_req = 15

/obj/item/organ/internal/liver/big
	name = "big liver"
	organ_efficiency = list(OP_LIVER = 150)
	specific_organ_size = 1.2

/obj/item/organ/internal/muscle/super_muscle
	name = "super muscle"
	organ_efficiency = list(OP_MUSCLE = 150)
	specific_organ_size = 0.6

/obj/item/organ/internal/nerve/sensitive_nerve
	name = "sensitive nerves"
	organ_efficiency = list(OP_NERVE = 150)
	specific_organ_size = 0.6

/obj/item/organ/internal/blood_vessel/extensive
	name = "extensive blood vessels"
	organ_efficiency = list(OP_BLOOD_VESSEL = 150)

