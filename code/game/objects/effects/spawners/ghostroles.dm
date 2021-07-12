//Prisoner containment sleeper: Ghosts become escaped prisoners and are advised to find a way out of the mess they've gotten themselves into.
/obj/effect/mob_spawn/human/prisoner_transport
	name = "prisoner containment sleeper"
	desc = "A sleeper designed to put its occupant into a deep coma, unbreakable until the sleeper turns off. This one's glass is cracked and you can see a pale, sleeping face staring out."
	mob_name = "an escaped prisoner"
	icon = 'icons/obj/Cryogenic2.dmi'
	icon_state = "sleeper_1"
	outfit = /decl/hierarchy/outfit/escapedprisoner
	short_desc = "You're a prisoner, sentenced to hard work in one of Nanotrasen's labor camps, but it seems as \
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
	L.fully_replace_character_name(null,"NTP #LL-0[rand(111,999)]") //Nanotrasen Prisoner #Lavaland-(numbers)

/obj/effect/mob_spawn/human/prisoner_transport/Initialize(mapload)
	. = ..()
	var/list/crimes = list("murder", "larceny", "embezzlement", "unionization", "dereliction of duty", "kidnapping", "gross incompetence", "grand theft", \
	"worship of a forbidden deity", "interspecies relations", "mutiny")
	flavour_text += "[pick(crimes)]. but regardless of that, it seems like your crime doesn't matter now. You don't know where you are, but you know that it's out to kill you, and you're not going \
	to lose this opportunity. Find a way to get out of this mess and back to where you rightfully belong - your [pick("house", "apartment", "spaceship", "station")]."

/decl/hierarchy/outfit/escapedprisoner
	name = "Escaped Prisoner"
	uniform = /obj/item/clothing/under/color/orange
	mask = /obj/item/clothing/mask/breath
	shoes = /obj/item/clothing/shoes/color/orange
	r_pocket = /obj/item/weapon/tank/emergency_oxygen
	back = /obj/item/weapon/storage/backpack/sport/orange

/decl/hierarchy/outfit/escapedprisoner/hobo
	belt = /obj/item/weapon/gun/projectile/revolver/handmade
	l_pocket = /obj/item/ammo_casing/magnum/scrap/prespawned

/obj/effect/mob_spawn/human/prisoner_transport/hobo
	outfit = /decl/hierarchy/outfit/escapedprisoner/hobo

/obj/effect/mob_spawn/human/scavenger
	name = "long storage sleeper"
	desc = "An old sleeper, with an unconscious body inside. The occupant seems to be covered in armor."
	mob_name = "a scavenger"
	icon = 'icons/obj/Cryogenic2.dmi'
	icon_state = "sleeper_1"
	outfit = /decl/hierarchy/outfit/scavenger
	short_desc = "You're a scavenger, who barely even owns the clothes on your back and the rifle in your hands."
	flavour_text = "It seems you've arrived. You're here to get the good stuff and skedaddle with your life intact. \
	There may be others to cooperate with, but don't count on it. There aren't any cops this far out, and laws don't carry much truck around here."
	assignedrole = "Scavenger"
	title = "Asters Comission Scavenger"

/decl/hierarchy/outfit/scavenger
	name = "Scavenger"
	uniform = /obj/item/clothing/under/genericb
	head = /obj/item/clothing/head/armor/steelpot
	shoes = /obj/item/clothing/shoes/color/black
	suit = /obj/item/clothing/suit/armor/flak/green
	suit_store = /obj/item/weapon/gun/projectile/boltgun/serbian
	back = /obj/item/weapon/storage/backpack/satchel
	r_pocket = /obj/item/ammo_magazine/sllrifle
	id_slot = slot_wear_id
	id_type = /obj/item/weapon/card/id
