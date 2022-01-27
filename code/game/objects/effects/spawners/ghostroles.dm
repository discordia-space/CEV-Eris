//Prisoner containment sleeper: Ghosts become escaped prisoners and are advised to find a way out of the69ess they've gotten themselves into.
/obj/effect/mob_spawn/human/prisoner_transport
	name = "prisoner containment sleeper"
	desc = "A sleeper designed to put its occupant into a deep coma, unbreakable until the sleeper turns off. This one's glass is cracked and you can see a pale, sleeping face staring out."
	mob_name = "an escaped prisoner"
	icon = 'icons/obj/Cryogenic2.dmi'
	icon_state = "sleeper_1"
	outfit = /decl/hierarchy/outfit/escapedprisoner
	short_desc = "You're a prisoner, sentenced to hard work in one of Ironhammer's labor camps, but it seems as \
	though fate has other plans for you."
	flavour_text = "Good. It seems as though your ship crashed. You remember that you were convicted of "
	assignedrole = "Escaped Prisoner"
	stat_modifiers = list(
		STAT_ROB = 16,
		STAT_TGH = 16,
		STAT_BIO = 8,
		STAT_MEC = 8,
		STAT_VIG = 8,
		STAT_COG = 8
	)

/obj/effect/mob_spawn/human/prisoner_transport/special(mob/living/L)
	L.fully_replace_character_name(null,"IHP #PH-069rand(111,999)69") //Ironhammer Prisoner #Prison Hulk-(numbers)

/obj/effect/mob_spawn/human/prisoner_transport/Initialize(mapload)
	. = ..()
	var/list/crimes = list("murder", "larceny", "embezzlement", "unionization", "dereliction of duty", "kidnapping", "gross incompetence", "grand theft", \
	"worship of a forbidden deity", "interspecies relations", "mutiny")
	flavour_text += "69pick(crimes)69. but regardless of that, it seems like your crime doesn't69atter now. You don't know where you are, but you know that it's out to kill you, and you're not going \
	to lose this opportunity. Find a way to get out of this69ess and back to where you rightfully belong - your 69pick("house", "apartment", "spaceship", "station")69. There should be a teleporter somewhere, if it's still intact."

/decl/hierarchy/outfit/escapedprisoner
	name = "Escaped Prisoner"
	uniform = /obj/item/clothing/under/color/orange
	mask = /obj/item/clothing/mask/breath
	shoes = /obj/item/clothing/shoes/color/orange
	r_pocket = /obj/item/tank/emergency_oxygen
	back = /obj/item/storage/backpack/sport/orange

/obj/effect/mob_spawn/human/scavenger
	name = "long storage sleeper"
	desc = "An old sleeper, with an unconscious body inside. The occupant seems to be covered in armor."
	mob_name = "a scavenger"
	icon = 'icons/obj/Cryogenic2.dmi'
	icon_state = "sleeper_1"
	outfit = /decl/hierarchy/outfit/scavenger
	short_desc = "You're a scavenger, who barely even owns the clothes on your back and the rifle in your hands."
	flavour_text = "It seems you've arrived. You're here to get the good stuff and skedaddle with your life intact. \
	There69ay be others to cooperate with, but don't count on it. There aren't any cops this far out, and laws don't carry69uch truck around here."
	assignedrole = "Scavenger"
	title = "Asters Comission Scavenger"

/decl/hierarchy/outfit/scavenger
	name = "Scavenger"
	uniform = /obj/item/clothing/under/genericb
	head = /obj/item/clothing/head/armor/steelpot
	shoes = /obj/item/clothing/shoes/color/black
	suit = /obj/item/clothing/suit/armor/flak/green
	suit_store = /obj/item/gun/projectile/boltgun/serbian
	back = /obj/item/storage/backpack/satchel
	r_pocket = /obj/item/ammo_magazine/sllrifle
	id_slot = slot_wear_id
	id_type = /obj/item/card/id

/obj/effect/mob_spawn/human/hermit
	name = "modified storage sleeper"
	desc = "An old sleeper, with a sleeping body inside. The sleeper seems to have been gutted and padded into a bed."
	mob_name = "a hermit"
	icon = 'icons/obj/Cryogenic2.dmi'
	icon_state = "sleeper_1"
	outfit = /decl/hierarchy/outfit/hermit
	short_desc = "You're a castaway, stuck on this rock looking for a way out."
	flavour_text = "Once upon a time, you were free in the stars. Now you are stuck in this junkyard. \
	The crash last night held promise, but now all these beasts are running around."
	assignedrole = "Hermit"
	title = "MHS Geary Amputator 3rd Class"
	stat_modifiers = list(
		STAT_ROB = 12,
		STAT_TGH = 24,
		STAT_BIO = 8,
		STAT_MEC = 12,
		STAT_VIG = 16,
		STAT_COG = 8
	)

/decl/hierarchy/outfit/hermit
	name = "hermit"
	suit = /obj/item/clothing/suit/storage/ass_jacket
	uniform = /obj/item/clothing/under/rank/assistant
	l_ear = /obj/item/device/radio/headset
	shoes = /obj/item/clothing/shoes/color/black
	id_slot = slot_wear_id
	id_type = /obj/item/card/id
	suit_store = /obj/item/gun/projectile/revolver/handmade
	l_pocket = /obj/item/ammo_casing/magnum/scrap/prespawned
	r_pocket = /obj/item/device/lighting/toggleable/flashlight
