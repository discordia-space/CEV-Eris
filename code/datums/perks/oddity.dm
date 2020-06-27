/datum/perk/oddity/fast_walker
	name = "Fast Walker"
	desc = "Slow and steady wins the race. Prove them wrong."
	icon_state = "fast" // https://game-icons.net/1x1/delapouite/fast-forward-button.html

/datum/perk/oddity/fast_walker/assign(mob/living/carbon/human/H)
	..()
	holder.species.slowdown -= 0.5

/datum/perk/oddity/fast_walker/remove()
	holder.species.slowdown += 0.5
	..()

/datum/perk/oddity/ear_of_quicksilver
	name = "Ear of Quicksilver"
	desc = "Secrets do not escape your ears. Beware, loud noises are especially dangerous to you."
	icon_state = "ear" // https://game-icons.net

/datum/perk/oddity/gunslinger
	name = "Gunslinger"
	desc = "Point, shoot, aim, shoot again. Pistols are the best!"
	icon_state = "dual_shot" // https://game-icons.net/1x1/delapouite/bullet-impacts.html

/datum/perk/oddity/terrible_fate
	name = "Terrible Fate"
	desc = "You realize the painful truth of death. You don't want to die, and despise death - dying is a unmistakable horror to you."
	icon_state = "murder" // https://game-icons.net/1x1/delapouite/chalk-outline-murder.html

/datum/perk/oddity/terrible_fate/assign(mob/living/carbon/human/H)
	..()
	holder.species.death_message = "his inert body emits a strange sensation and a cold invades your body. His screams before dying recount in your mind."

/datum/perk/oddity/terrible_fate/remove()
	holder.species.death_message = initial(holder.species.death_message)
	..()

/datum/perk/oddity/unfinished_delivery
	name = "Unfinished Delivery"
	desc = "It..it's not over? But I have no Cruciform, do I? How...why do I feel such a strong grip on life?"
	icon_state = "regrowth" // https://game-icons.net/1x1/delapouite/stump-regrowth.html

/datum/perk/oddity/lungs_of_iron
	name = "Lungs of Iron"
	desc = "Why am I in space, when I could win a swimming contest with such mighty breathing?"
	icon_state = "lungs" // https://game-icons.net/1x1/lorc/one-eyed.html

/datum/perk/oddity/lungs_of_iron/assign(mob/living/carbon/human/H)
	..()
	holder.species.oxy_mod -= 0.5

/datum/perk/oddity/lungs_of_iron/remove()
	holder.species.oxy_mod += 0.5
	..()

/datum/perk/oddity/blood_of_lead
	name = "Blood of Lead"
	desc = "Rotten food, disgusting garbage, poisons - all is less harmful to you now."
	icon_state = "liver" // https://game-icons.net

/datum/perk/oddity/blood_of_lead/assign(mob/living/carbon/human/H)
	..()
	holder.species.toxins_mod -= 0.5

/datum/perk/oddity/blood_of_lead/remove()
	holder.species.toxins_mod += 0.5
	..()

/datum/perk/oddity/space_asshole
	name = "Space Asshole"
	desc = "Bombs, holes, falling in holes, being hit with bombs, I'm just used to it by now."
	icon_state = "bomb" // https://game-icons.net

/datum/perk/oddity/space_asshole/assign(mob/living/carbon/human/H)
	..()
	holder.mob_bomb_defense += 25
	holder.falls_mod -= 0.4

/datum/perk/oddity/space_asshole/remove()
	holder.mob_bomb_defense -= 25
	holder.falls_mod += 0.4
	..()

/datum/perk/oddity/parkour
	name = "Parkour"
	desc = "Jump, climb, flip! It's fun to be an acrobat! "
	icon_state = "parkour" //https://game-icons.net/1x1/delapouite/jump-across.html

/datum/perk/oddity/parkour/assign(mob/living/carbon/human/H)
	..()
	holder.mod_climb_delay -= -0.5

/datum/perk/oddity/parkour/remove()
	holder.mod_climb_delay += 0.5
	..()

/datum/perk/oddity/charming_personality
	name = "Charming Personality"
	desc = "A little wink and a confident smile goes far in this place. People are more comfortable with your company."
	icon_state = "flowers" // https://game-icons.net/1x1/lorc/flowers.html

/datum/perk/oddity/charming_personality/assign(mob/living/carbon/human/H)
	..()
	holder.sanity_damage -= 2

/datum/perk/oddity/charming_personality/remove()
	holder.sanity_damage += 2
	..()

/datum/perk/oddity/horrible_deeds
	name = "Horrible Deeds"
	desc = " The twitch. The blood. They see the truth in your actions and are horrified."
	icon_state = "bad_breath" // https://game-icons.net

/datum/perk/oddity/horrible_deeds/assign(mob/living/carbon/human/H)
	..()
	holder.sanity_damage += 2

/datum/perk/oddity/horrible_deeds/remove()
	holder.sanity_damage -= 2
	..()

/datum/perk/oddity/chaingun_smoker
	name = "Chaingun smoker"
	desc = "The cigarette is a way of life. Literally - it makes you feel less sick and tougher when you chomp on cigars."
	icon_state = "cigarette" // https://game-icons.net

/datum/perk/oddity/nightcrawler
	name = "Nightcrawler"
	desc = "You are faster in the darkness."
	icon_state = "night" // https://game-icons.net/1x1/lorc/night-sky.html

/datum/perk/oddity/fast_fingers
	name = "Fast fingers"
	desc = "Pockets, ears, hands...just not the clothes! My legerdemain is legendary!"
	icon_state = "robber_hand" // https://game-icons.net/1x1/darkzaitzev/robber-hand.html

/datum/perk/oddity/quiet_as_mouse
	name = "Quiet as mouse"
	desc = "Being deadly, easy. Silent? Even easier now."
	icon_state = "footsteps" // https://game-icons.net

/datum/perk/oddity/quiet_as_mouse/assign(mob/living/carbon/human/H)
	..()
	holder.noise_coeff -= 0.5

/datum/perk/oddity/quiet_as_mouse/remove()
	holder.noise_coeff += 0.5
	..()

/datum/perk/oddity/balls_of_plasteel
	name = "Balls of plasteel"
	desc = "Pain comes and goes. Better to have less of it."
	icon_state = "golem" // https://game-icons.net

/datum/perk/oddity/junkborn
	name = "Junkborn"
	desc = "Some called you paranoid. Those people are now dead from ancient landmines. Avoiding danger is easier now."
	icon_state = "treasure" // https://game-icons.net

/datum/perk/oddity/ass_of_concrete
	name = "Ass of Concrete"
	desc = "I can't take it anymore! What..how did I land on my feet?! I feel immovable! No one can push me around anymore!"
	icon_state = "muscular" // https://game-icons.net

/datum/perk/oddity/ass_of_concrete/assign(mob/living/carbon/human/H)
	..()
	holder.mob_bump_flag = HEAVY

/datum/perk/oddity/ass_of_concrete/remove()
	holder.mob_bump_flag = ~HEAVY
	..()

/datum/perk/oddity/toxic_revenger
	name = "Toxic Revenger"
	desc = "A heart of gold does not matter when blood is toxic. Those who breathe your air, share your fate."
	icon_state = "Hazmat" // https://game-icons.net

/datum/perk/oddity/absolute_grab
	name = "Absolute Grab"
	desc = "It pays to be a predator. You don't grab, You lunge."
	icon_state = "grab" // https://game-icons.net

/datum/perk/oddity/sure_step
	name = "Sure step"
	desc = " You receive additional chance to avoid trap"
	icon_state = "mantrap"
