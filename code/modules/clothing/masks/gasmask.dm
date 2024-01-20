#define GAS_MASK_SANITY_COEFF_BUFF 1.7

/obj/item/clothing/mask/gas
	name = "gas mask"
	desc = "A face-covering mask that can be connected to an air supply. Filters harmful gases and the smell of roaches from the air."
	icon_state = "gas_alt"
	item_flags = BLOCK_GAS_SMOKE_EFFECT | AIRTIGHT
	flags_inv = HIDEEARS|HIDEEYES|HIDEFACE
	body_parts_covered = FACE|EYES
	volumeClass = ITEM_SIZE_NORMAL
	item_state = "gas_alt"
	gas_transfer_coefficient = 0.01
	permeability_coefficient = 0.01
	siemens_coefficient = 0.9
	style_coverage = COVERS_WHOLE_FACE
	var/gas_filter_strength = 1			//For gas mask filters
	var/list/filtered_gases = list("plasma", "sleeping_agent")
	armor = list(
		ARMOR_BLUNT = 0,
		ARMOR_BULLET = 0,
		ARMOR_ENERGY = 0,
		ARMOR_BOMB =0,
		ARMOR_BIO =75,
		ARMOR_RAD =40
	)
	price_tag = 20
	style = STYLE_NEG_LOW
	matter = list(MATERIAL_PLASTIC = 2)
	muffle_voice = TRUE

/obj/item/clothing/mask/gas/filter_air(datum/gas_mixture/air)
	var/datum/gas_mixture/filtered = new

	for(var/g in filtered_gases)
		if(air.gas[g])
			filtered.gas[g] = air.gas[g] * gas_filter_strength
			air.gas[g] -= filtered.gas[g]

	air.update_values()
	filtered.update_values()

	return filtered

/obj/item/clothing/mask/gas/New()
	..()
	AddComponent(/datum/component/clothing_sanity_protection, GAS_MASK_SANITY_COEFF_BUFF)

//Plague Dr suit can be found in clothing/suits/bio.dm
/obj/item/clothing/mask/gas/plaguedoctor
	name = "plague doctor mask"
	desc = "A modernised version of the classic design, this mask will not only filter out plasma but it can also be connected to an air supply."
	icon_state = "plaguedoctor"
	item_state = "gas_mask"
	body_parts_covered = HEAD|FACE|EYES
	style = STYLE_LOW

/obj/item/clothing/mask/gas/swat
	name = "\improper SWAT mask"
	desc = "A close-fitting tactical mask that can be connected to an air supply."
	icon_state = "swat"
	siemens_coefficient = 0.7
	body_parts_covered = FACE|EYES
	price_tag = 50

/obj/item/clothing/mask/gas/ihs
	name = "Ironhammer gasmask"
	icon_state = "IHSgasmask"
	siemens_coefficient = 0.7
	body_parts_covered = FACE|EYES
	price_tag = 40

/obj/item/clothing/mask/gas/syndicate
	name = "tactical mask"
	desc = "A close-fitting tactical mask that can be connected to an air supply."
	icon_state = "swat"
	siemens_coefficient = 0.7
	price_tag = 50
	spawn_blacklisted = TRUE

/obj/item/clothing/mask/gas/artist_hat
	name = "Spooky Rebreather"
	desc = "Wearing this makes you feel awesome - seeing someone else wearing this makes them look like a loser."
	icon_state = "artist"
	item_state = "artist_hat"
	spawn_frequency = 0
	var/list/states = list("True Form" = "artist", "The clown" = "clown",
	"The mime" = "mime", "The Feminist" = "sexyclown", "The Madman" = "joker",
	"The Rainbow Color" = "rainbow", "The monkey" = "monkeymask", "The Owl" = "owl")
	flags_inv = HIDEEARS|HIDEFACE
	body_parts_covered = HEAD|FACE
	muffle_voice = FALSE

/obj/item/clothing/mask/gas/artist_hat/attack_self(mob/user)
	var/choice = input(user, "To what form do you wish to Morph this mask?","Morph Mask") as null|anything in states

	if(src && choice && !user.incapacitated() && Adjacent(user))
		icon_state = states[choice]
		to_chat(user, "Your Clown Mask has now morphed into [choice], all praise the Honk Mother!")
		return TRUE

/obj/item/clothing/mask/gas/clown_hat
	name = "clown wig and mask"
	desc = "A true prankster's facial attire. A clown is incomplete without their wig and mask."
	icon_state = "clown"
	item_state = "clown_hat"
	style = STYLE_NONE
	muffle_voice = FALSE

/obj/item/clothing/mask/gas/clown_hat/attack_self(mob/user)
	var/list/options = list()
	options["True Form"] = "clown"
	options["The Feminist"] = "sexyclown"
	options["The Madman"] = "joker"
	options["The Rainbow Color"] ="rainbow"

	var/choice = input(user, "To what form do you wish to Morph this mask?","Morph Mask") as null|anything in options

	if(src && choice && !user.incapacitated() && Adjacent(user))
		icon_state = options[choice]
		to_chat(user, "Your Clown Mask has now morphed into [choice], all praise the Honk Mother!")
		return TRUE

/obj/item/clothing/mask/gas/sexyclown
	name = "sexy-clown wig and mask"
	desc = "A feminine clown mask for the dabbling crossdressers or female entertainers."
	icon_state = "sexyclown"
	item_state = "sexyclown"
	muffle_voice = FALSE

/obj/item/clothing/mask/gas/mime
	name = "mime mask"
	desc = "The traditional mime's mask. It has an eerie facial posture."
	icon_state = "mime"
	item_state = "mime"
	style = STYLE_LOW
	muffle_voice = FALSE

/obj/item/clothing/mask/gas/monkeymask
	name = "monkey mask"
	desc = "A mask used when acting as a monkey."
	icon_state = "monkeymask"
	item_state = "monkeymask"
	body_parts_covered = HEAD|FACE|EYES
	muffle_voice = FALSE

/obj/item/clothing/mask/gas/sexymime
	name = "sexy mime mask"
	desc = "A traditional female mime's mask."
	icon_state = "sexymime"
	item_state = "sexymime"
	style = STYLE_LOW
	muffle_voice = FALSE

/obj/item/clothing/mask/gas/death_commando
	name = "Death Commando Mask"
	icon_state = "death_commando_mask"
	item_state = "death_commando_mask"
	siemens_coefficient = 0.2
	spawn_blacklisted = TRUE

/obj/item/clothing/mask/gas/cyborg
	name = "cyborg visor"
	desc = "Beep boop"
	icon_state = "death"
	spawn_blacklisted = TRUE

/obj/item/clothing/mask/gas/owl_mask
	name = "owl mask"
	desc = "Twoooo!"
	icon_state = "owl"
	body_parts_covered = HEAD|FACE|EYES
	muffle_voice = FALSE

/obj/item/clothing/mask/gas/german
	name = "Oberth Republic gas mask"
	icon_state = "germangasmask"

/obj/item/clothing/mask/gas/joker_19
	name = "clown wig and mask"
	desc = "You get what you fucking deserve!"
	icon_state = "joker_19"
	item_state = "joker_19"
	spawn_frequency = 0


