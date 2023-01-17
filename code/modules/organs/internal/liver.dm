/obj/item/organ/internal/liver
	name = "liver"
	icon_state = "liver"
	organ_efficiency = list(OP_LIVER = 100)
	desc = "A vital organ that detoxifies metabolites. Among other things."
	description_info = "Increases the metabolization rate of chemicals in both the stomach and bloodstream"
	parent_organ_base = BP_GROIN
	price_tag = 900
	blood_req = 5
	max_blood_storage = 25
	oxygen_req = 7
	nutriment_req = 5

/obj/item/organ/internal/liver/big
	name = "gargantuan liver"
	icon_state = "liver_big"
	organ_efficiency = list(OP_LIVER = 150)
	specific_organ_size = 1.2
	desc = "You will need twice the amount of booze for this one to fail."

//We got it covered in Process with more detailed thing
/obj/item/organ/internal/liver/handle_regeneration()
	return
