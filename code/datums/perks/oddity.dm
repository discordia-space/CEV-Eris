/datum/perk/oddity/fast_walker
	name = "Fast walker"
	desc = "You general speed is a bit higher."
	icon_state = "fast" // https://game-icons.net/1x1/delapouite/fast-forward-button.html

/datum/perk/oddity/fast_walker/assign(mob/living/carbon/human/H)
	..()
	holder.species.slowdown -= 0.5

/datum/perk/oddity/fast_walker/remove()
	holder.species.slowdown += 0.5
	..()

/datum/perk/oddity/gunslinger
	name = "Gunslinger"
	desc = "You are an expert shooting."
	icon_state = "dual_shot" // https://game-icons.net/1x1/delapouite/bullet-impacts.html

/datum/perk/oddity/terrible_fate
	name = "Terrible Fate"
	icon_state = "murder" // https://game-icons.net/1x1/delapouite/chalk-outline-murder.html

/datum/perk/oddity/unfinished_delivery
	name = "Unfinished Delivery"
	desc = "Your goals make you cling to life more than anyone."
	icon_state = "regrowth" // https://game-icons.net/1x1/delapouite/stump-regrowth.html

/datum/perk/oddity/lungs_of_iron
	name = "Lungs of Iron"
	desc = "You receive only 50% of oxygen damage."
	icon_state = "lungs" // https://game-icons.net/1x1/lorc/one-eyed.html

/datum/perk/oddity/lungs_of_iron/assign(mob/living/carbon/human/H)
	..()
	holder.species.oxy_mod -= 0.5

/datum/perk/oddity/lungs_of_iron/remove()
	holder.species.oxy_mod += 0.5
	..()

/datum/perk/oddity/blood_of_lead
	name = "Blood of lead"
	desc = "Toxins provide only 50% of the damage they should."
	icon_state = "liver" // https://game-icons.net

/datum/perk/oddity/blood_of_lead/assign(mob/living/carbon/human/H)
	..()
	holder.species.toxins_mod -= 0.5

/datum/perk/oddity/blood_of_lead/remove()
	holder.species.toxins_mod += 0.5
	..()

/datum/perk/oddity/space_asshole
	name = "Space asshole"
	desc = "You have some basic protection from explosives, as well as fall damage."
	icon_state = "bomb" // https://game-icons.net

/datum/perk/oddity/space_asshole/assign(mob/living/carbon/human/H)
	..()
	holder.species.bomb_defense += 25
	holder.species.falls_mod -= 0.4

/datum/perk/oddity/space_asshole/remove()
	holder.species.bomb_defense -= 25
	holder.species.falls_mod += 0.4
	..()

/datum/perk/oddity/parkour
	name = "Parkour"
	desc = "You are faster climbing ladders and tables."
	icon_state = "parkour" //https://game-icons.net/1x1/delapouite/jump-across.html

/datum/perk/oddity/parkour/assign(mob/living/carbon/human/H)
	..()
	holder.mod_climb_delay -= -0.8

/datum/perk/oddity/parkour/remove()
	holder.mod_climb_delay += 0.8
	..()

/datum/perk/oddity/charming_personality
	name = "Charming personality"
	desc = "You improve the sanity of everyone around you."
	icon_state = "flowers" // https://game-icons.net/1x1/lorc/flowers.html

/datum/perk/oddity/charming_personality/assign(mob/living/carbon/human/H)
	..()
	holder.sanity_damage -= 2

/datum/perk/oddity/charming_personality/remove()
	holder.sanity_damage += 2
	..()

/datum/perk/oddity/horrible_deeds
	name = "Horrible Deeds"
	desc = "You lower the sanity of everyone around you."
	icon_state = "bad_breath" // https://game-icons.net

/datum/perk/oddity/horrible_deeds/assign(mob/living/carbon/human/H)
	..()
	holder.sanity_damage += 2

/datum/perk/oddity/horrible_deeds/remove()
	holder.sanity_damage -= 2
	..()

/datum/perk/oddity/chaingun_smoker
	name = "Chaingun smoker"
	desc = "Nicotine does not only helps your sanity now, it also a painkiller and weak antitoxin for you."
	icon_state = "cigarette" // https://game-icons.net

/datum/perk/oddity/nightcrawler
	name = "Nightcrawler"
	desc = "Dark does not slow you down, you actually move faster in it."
	icon_state = "night" // https://game-icons.net/1x1/lorc/night-sky.html

/datum/perk/oddity/fast_fingers
	name = "Fast fingers"
	desc = "When you remove items from people, or emptying their pockets, it does not provides a message in the chat."
	icon_state = "robber_hand" // https://game-icons.net/1x1/darkzaitzev/robber-hand.html

/datum/perk/oddity/quiet_as_mouse
	name = "Quiet as mouse"
	desc = "your footsteps son más silenciosos.."
	icon_state = "footsteps" // https://game-icons.net

/datum/perk/oddity/quiet_as_mouse/assign(mob/living/carbon/human/H)
	..()
	holder.noise_coeff -= 0.5

/datum/perk/oddity/quiet_as_mouse/remove()
	holder.noise_coeff += 0.5
	..()

/datum/perk/oddity/ear_of_quicksilver
	name = "Ear of quicksilver"
	desc = "You can pick up voices from more distant ranges."
	icon_state = "ear" // https://game-icons.net

/datum/perk/oddity/balls_of_plasteel
	name = "Balls of plasteel"
	desc = "You need to receive additional 20 points of pain to drop into pain crit."
	icon_state = "golem" // https://game-icons.net

/datum/perk/oddity/junkborn
	name = "Junkborn"
	desc = "You have 20% chance to spawn somewhat rare item on clearing the junkpile."
	icon_state = "treasure" // https://game-icons.net

/datum/perk/oddity/ass_of_concrete
	name = "Ass of concrete"
	desc = "Others cannot push you while walking, and gravitation will not drop you."
	icon_state = "muscular" // https://game-icons.net

/datum/perk/oddity/ass_of_concrete/assign(mob/living/carbon/human/H)
	..()
	holder.mob_bump_flag = HEAVY

/datum/perk/oddity/ass_of_concrete/remove()
	holder.mob_bump_flag = ~HEAVY
	..()

/datum/perk/oddity/toxic_revenger
	name = "Toxic Revenger"
	desc = "This ship did something to you, and now you are danger for everyone around."
	icon_state = "Hazmat" // https://game-icons.net

/datum/perk/oddity/absolute_grab
	name = "Absolute grab"
	desc = "You can grab people with +1 radius"
	icon_state = "grab" // https://game-icons.net

/datum/perk/oddity/sure_step
	name = "Sure step"
	desc = " You receive additional chance to avoid trap"
	icon_state = "mantrap"
