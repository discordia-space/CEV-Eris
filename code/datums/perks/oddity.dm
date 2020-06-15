#define PERK_FAST_WALKER /datum/perk/fast_walker
#define PERK_GUNSLINGER /datum/perk/gunslinger
#define PERK_TERRIBLE_FATE /datum/perk/terrible_fate
#define PERK_UNFINISHED_DELIVERY /datum/perk/unfinished_delivery
#define PERK_LUNGS_OF_IRON /datum/perk/lungs_of_iron
#define PERK_BLOOD_OF_LEAD /datum/perk/blood_of_lead
#define PERK_SPACE_ASSHOLE /datum/perk/space_asshole

/datum/perk/fast_walker
	name = "Fast walker"
	desc = "You general speed is a bit higher."
	icon_state = "fast" // https://game-icons.net/1x1/delapouite/fast-forward-button.html

/datum/perk/fast_walker/assign(mob/living/carbon/human/H)
	..()
	holder.species.slowdown -= 0.3

/datum/perk/fast_walker/remove()
	holder.species.slowdown += 0.3
	..()

/datum/perk/gunslinger
	name = "Gunslinger"
	desc = "You are an expert shooting."
	icon_state = "dual_shot" // https://game-icons.net/1x1/delapouite/bullet-impacts.html

/datum/perk/terrible_fate
	name = "Terrible Fate"
	icon_state = "dual_shot" // https://game-icons.net/1x1/delapouite/bullet-impacts.html

/datum/perk/unfinished_delivery
	name = "Unfinished Delivery"
	desc = "Your goals make you cling to life more than anyone."
	icon_state = "regrowth" // https://game-icons.net/1x1/delapouite/stump-regrowth.html

/datum/perk/lungs_of_iron
	name = "Lungs of Iron"
	desc = "You receive only 50% of oxygen damage."
	icon = "lungs" // https://game-icons.net/1x1/lorc/one-eyed.html

/datum/perk/lungs_of_iron/assign(mob/living/carbon/human/H)
	..()
	holder.species.oxy_mod -= 0.5

/datum/perk/lungs_of_iron/remove()
	holder.species.oxy_mod += 0.5
	..()

/datum/perk/blood_of_lead
	name = "Blood of lead"
	desc = "Toxins provide only 50% of the damage they should."
	icon = "liver"

/datum/perk/blood_of_lead/assign(mob/living/carbon/human/H)
	..()
	holder.species.toxins_mod -= 0.5

/datum/perk/blood_of_lead/remove()
	holder.species.toxins_mod += 0.5
	..()

/datum/perk/space_asshole
	name = "Lungs_of Iron"
	desc = "You receive only 50% of oxygen damage."
	icon = "lungs"

/datum/perk/space_asshole/assign(mob/living/carbon/human/H)
	..()
	holder.species.bomb_defense += 10
	holder.species.falls_mod -= 0.3

/datum/perk/space_asshole/remove()
	holder.species.bomb_defense -= 10
	holder.species.falls_mod += 0.3
	..()

