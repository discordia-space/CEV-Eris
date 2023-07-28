/obj/item/organ/internal/vital/lungs
	name = "lungs"
	icon_state = "lungs"
	gender = PLURAL
	organ_efficiency = list(OP_LUNGS = 100)
	parent_organ_base = BP_CHEST
	specific_organ_size = 2
	desc = "A vital respiratory organ."
	price_tag = 300
	blood_req = 10
	max_blood_storage = 50
	nutriment_req = 10
	var/breath_modulo = 2

/obj/item/organ/internal/vital/lungs/long
	name = "long lungs"
	icon_state = "long_lungs"
	desc = "Breathe in... Breathe in... You are still breathing in?!"
	organ_efficiency = list(OP_LUNGS = 150)
	specific_organ_size = 2.3
	breath_modulo = 8
