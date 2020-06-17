/datum/perk/fast_walker
	name = "Fast walker"
	desc = "You general speed is a bit higher."
	icon_state = "fast" // https://game-icons.net/1x1/delapouite/fast-forward-button.html

/datum/perk/fast_walker/assign(mob/living/carbon/human/H)
	..()
	holder.species.slowdown -= 0.5

/datum/perk/fast_walker/remove()
	holder.species.slowdown += 0.5
	..()

/datum/perk/gunslinger
	name = "Gunslinger"
	desc = "You are an expert shooting."
	icon_state = "dual_shot" // https://game-icons.net/1x1/delapouite/bullet-impacts.html

/datum/perk/terrible_fate
	name = "Terrible Fate"
	icon_state = "murder" // https://game-icons.net/1x1/delapouite/chalk-outline-murder.html

/datum/perk/unfinished_delivery
	name = "Unfinished Delivery"
	desc = "Your goals make you cling to life more than anyone."
	icon_state = "regrowth" // https://game-icons.net/1x1/delapouite/stump-regrowth.html

/datum/perk/lungs_of_iron
	name = "Lungs of Iron"
	desc = "You receive only 50% of oxygen damage."
	icon_state = "lungs" // https://game-icons.net/1x1/lorc/one-eyed.html

/datum/perk/lungs_of_iron/assign(mob/living/carbon/human/H)
	..()
	holder.species.oxy_mod -= 0.5

/datum/perk/lungs_of_iron/remove()
	holder.species.oxy_mod += 0.5
	..()

/datum/perk/blood_of_lead
	name = "Blood of lead"
	desc = "Toxins provide only 50% of the damage they should."
	icon_state = "liver"

/datum/perk/blood_of_lead/assign(mob/living/carbon/human/H)
	..()
	holder.species.toxins_mod -= 0.5

/datum/perk/blood_of_lead/remove()
	holder.species.toxins_mod += 0.5
	..()

/datum/perk/space_asshole
	name = "Space asshole"
	desc = "You have some basic protection from explosives, as well as fall damage."
	icon_state = "lungs"

/datum/perk/space_asshole/assign(mob/living/carbon/human/H)
	..()
	holder.species.bomb_defense += 10
	holder.species.falls_mod -= 0.4

/datum/perk/space_asshole/remove()
	holder.species.bomb_defense -= 10
	holder.species.falls_mod += 0.4
	..()

/datum/perk/parkour
	name = "Parkour"
	desc = "You are faster climbing ladders and tables."
	icon_state = "lungs"

/datum/perk/parkour/assign(mob/living/carbon/human/H)
	..()
	holder.mod_climb_delay -= -0.8

/datum/perk/parkour/remove()
	holder.mod_climb_delay += 0.8
	..()

/datum/perk/charming_personality
	name = "Charming personality"
	desc = "You are faster climbing ladders and tables."
	icon_state = "flowers" // https://game-icons.net/1x1/lorc/flowers.html

/datum/perk/charming_personality/assign(mob/living/carbon/human/H)
	..()
	holder.sanity_damage -= 2

/datum/perk/charming_personality/remove()
	holder.sanity_damage += 2
	..()

/datum/perk/horrible_deeds
	name = "Horrible Deeds"
	desc = "You are faster climbing ladders and tables."
	icon_state = "lungs" // https://game-icons.net

/datum/perk/horrible_deeds/assign(mob/living/carbon/human/H)
	..()
	holder.sanity_damage += 2

/datum/perk/horrible_deeds/remove()
	holder.sanity_damage -= 2
	..()

/datum/perk/chaingun_smoker
	name = "Chaingun smoker"
	desc = "Nicotine does not only helps your sanity now, it also a painkiller and weak antitoxin for you."
	icon_state = "lungs" // https://game-icons.net

/datum/perk/nightcrawler
	name = "Nightcrawler"
	desc = "Dark does not slow you down, you actually move faster in it."
	icon_state = "nightcrawler" // https://game-icons.net

/datum/perk/fast_fingers
	name = "Fast fingers"
	desc = "Dark does not slow you down, you actually move faster in it."
	icon_state = "nightcrawler" // https://game-icons.net

/datum/perk/quiet_as_mouse
	name = "Quiet as mouse"
	desc = "your footsteps are totally silent."
	icon_state = "nightcrawler" // https://game-icons.net

/datum/perk/ear_of_quicksilver
	name = "Ear of quicksilver"
	desc = "You can pick up voices from more distant ranges"
	icon_state = "ear" // https://game-icons.net

/datum/perk/balls_of_plasteel
	name = "Balls of plasteel"
	desc = "You need to receive additional 20 points of pain to drop into pain cri"
	icon_state = "ball"

/datum/perk/junkborn
	name = "Junkborn"
	desc = "You have 20% chance to spawn somewhat rare item on clearing the junkpile."
	icon_state = "junkborn"

/datum/perk/ass_of_concrete
	name = "Ass of concrete"

/datum/perk/ass_of_concrete/assign(mob/living/carbon/human/H)
	..()
	holder.mob_bump_flag = HEAVY

/datum/perk/ass_of_concrete/remove(mob/living/carbon/human/H)
	holder.mob_bump_flag = ~HEAVY
	..()

/datum/perk/toxic_revenger
	name = "Toxic Revenger"
	desc = "This ship did something to you, and now you are danger for everyone around."
	icon_state = "toxic_revenger"

/datum/perk/absolute_grab
	name = "Absolute grab"
