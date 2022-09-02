/obj/item/organ/internal/heart
	name = "heart"
	icon_state = "heart-on"
	organ_efficiency = list(OP_HEART = 100)
	parent_organ_base = BP_CHEST
	dead_icon = "heart-off"
	desc = "A vital organ which pumps blood through the blood vessels of the circulatory system. "
	description_info = "Increases the efficiency of reagent metabolization in blood"
	price_tag = 1000
	specific_organ_size = 2
	oxygen_req = 10
	nutriment_req = 10
	var/open

/obj/item/organ/internal/heart/open
	open = 1
/obj/item/organ/internal/heart/proc/is_working()
	if(!is_usable())
		return FALSE

	return owner.pulse > PULSE_NONE || BP_IS_ROBOTIC(src) || (owner.status_flags & FAKEDEATH)

/obj/item/organ/internal/heart/huge
	name = "five chamber heart"
	icon_state = "heart_huge"
	desc = "Can\'t pump the brakes now!"
	organ_efficiency = list(OP_HEART = 150)
	specific_organ_size = 2.3
	max_blood_storage = 100
	nutriment_req = 15
	dead_icon = "heart_huge"
