
/datum/reagent/mbr
	name = "Machine binding ritual"
	id = "machine binding ritual"
	description = ""
	taste_description = "bitterness"
	reagent_state = LIQUID
	color = "#5f95e2"
	overdose = REAGENTS_OVERDOSE
	metabolism = REM * 0.3
	scannable = 1
	addiction_chance = 20
	NSA = 15


/datum/reagent/mbr/on_mob_add(mob/living/L)
	return


/datum/reagent/mbr/on_mob_delete(mob/living/L)
	return

/datum/reagent/mbr/overdose(var/mob/living/carbon/M, var/alien) // Overdose effect. Doesn't happen instantly.
	M.adjustToxLoss(REM)
	return

/datum/reagent/mbr/addiction_end(mob/living/carbon/M)
	to_chat(M, SPAN_NOTICE("You feel like you've gotten over your need for [name]."))

/datum/reagent/mbr/withdrawal_start(mob/living/carbon/M)
	return

/datum/reagent/mbr/withdrawal_end(mob/living/carbon/M)
	return

/datum/reagent/cherrydrops
	name = "Cherry drops"
	id = "cherry drops"
	description = ""
	taste_description = "bitterness"
	reagent_state = LIQUID
	color = "#9bd70f"
	overdose = REAGENTS_OVERDOSE + 5
	metabolism = REM * 0.3
	scannable = 1
	NSA = 20
	addiction_chance = 30

/datum/reagent/proSurgeon
	name = "ProSurgeon"
	id = "prosurgeon"
	description = ""
	taste_description = "bitterness"
	reagent_state = LIQUID
	color = "#2d867a"
	overdose = REAGENTS_OVERDOSE
	metabolism = REM * 0.3
	scannable = 1
	NSA = 20
	addiction_chance = 20

/datum/reagent/violence
	name = "Violence"
	id = "violence"
	description = ""
	taste_description = "bitterness"
	reagent_state = LIQUID
	color = "#75aea5"
	overdose = REAGENTS_OVERDOSE - 10
	metabolism = REM * 0.3
	scannable = 1
	NSA = 30
	addiction_chance = 30

/datum/reagent/bouncer
	name = "Bouncer"
	id = "bouncer"
	description = ""
	taste_description = "bitterness"
	reagent_state = LIQUID
	color = "#682f93"
	overdose = REAGENTS_OVERDOSE
	metabolism = REM * 0.3
	scannable = 1
	NSA = 10
	addiction_chance = 20

/datum/reagent/steady
	name = "Steady"
	id = "steady"
	description = ""
	taste_description = "bitterness"
	reagent_state = LIQUID
	color = "#334183"
	overdose = REAGENTS_OVERDOSE - 10
	metabolism = REM * 0.3
	scannable = 1
	NSA = 20
	addiction_chance = 20

/datum/reagent/machineSpirit
	name = "Machine Spirit"
	id = "machine spirit"
	description = ""
	taste_description = "bitterness"
	reagent_state = LIQUID
	color = "#9eb236"
	overdose = REAGENTS_OVERDOSE - 12
	metabolism = REM * 0.3
	scannable = 1
	NSA = 30
	addiction_chance = 30

/datum/reagent/grapeDrops
	name = "Grape Drops"
	id = "grape drops"
	description = ""
	taste_description = "bitterness"
	reagent_state = LIQUID
	color = "#eb5783"
	overdose = REAGENTS_OVERDOSE - 5
	metabolism = REM * 0.3
	scannable = 1
	NSA = 30
	addiction_chance = 40

/datum/reagent/ultraSurgeon
	name = "UltraSurgeon"
	id = "ultrasurgeon"
	description = ""
	taste_description = "bitterness"
	reagent_state = LIQUID
	color = "#0c07c4"
	overdose = REAGENTS_OVERDOSE - 13
	metabolism = REM * 0.3
	scannable = 1
	NSA = 30
	addiction_chance = 30

/datum/reagent/violenceUltra
	name = "Violence Ultra"
	id = "violence ultra"
	description = ""
	taste_description = "bitterness"
	reagent_state = LIQUID
	color = "#3d3362"
	overdose = REAGENTS_OVERDOSE - 19
	metabolism = REM * 0.3
	scannable = 1
	NSA = 60
	addiction_chance = 40

/datum/reagent/boxer
	name = "Boxer"
	id = "boxer"
	description = ""
	taste_description = "bitterness"
	reagent_state = LIQUID
	color = "#0ed750"
	overdose = REAGENTS_OVERDOSE/2
	metabolism = REM * 0.3
	scannable = 1
	NSA = 50
	addiction_chance = 30


/datum/reagent/partyDrops
	name = "Party drops"
	id = "party drops"
	description = ""
	taste_description = "bitterness"
	reagent_state = LIQUID
	color = "#ffb3b7"
	overdose = REAGENTS_OVERDOSE - 18
	metabolism = REM * 0.3
	scannable = 1
	NSA = 70
	addiction_chance = 50


/datum/reagent/menace
	name = "MENACE"
	id = "menace"
	description = ""
	taste_description = "bitterness"
	reagent_state = LIQUID
	color = "#ffb3b7"
	overdose = REAGENTS_OVERDOSE - 21
	metabolism = REM * 0.3
	scannable = 1
	NSA = 90
	addiction_chance = 70