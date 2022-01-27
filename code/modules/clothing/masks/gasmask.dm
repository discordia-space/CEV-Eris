#define GAS_MASK_SANITY_COEFF_BUFF 1.7

/obj/item/clothing/mask/gas
	name = "gas69ask"
	desc = "A face-covering69ask that can be connected to an air supply. Filters harmful gases from the air and the smell of roaches."
	icon_state = "gas_alt"
	item_flags = BLOCK_GAS_SMOKE_EFFECT | AIRTIGHT
	flags_inv = HIDEEARS|HIDEEYES|HIDEFACE
	body_parts_covered = FACE|EYES
	w_class = ITEM_SIZE_NORMAL
	item_state = "gas_alt"
	gas_transfer_coefficient = 0.01
	permeability_coefficient = 0.01
	siemens_coefficient = 0.9
	style_coverage = COVERS_WHOLE_FACE
	var/gas_filter_strength = 1			//For gas69ask filters
	var/list/filtered_gases = list("plasma", "sleeping_agent")
	armor = list(
		melee = 0,
		bullet = 0,
		energy = 0,
		bomb = 0,
		bio = 75,
		rad = 0
	)
	price_tag = 20
	style = STYLE_NEG_LOW

/obj/item/clothing/mask/gas/filter_air(datum/gas_mixture/air)
	var/datum/gas_mixture/filtered = new

	for(var/g in filtered_gases)
		if(air.gas69g69)
			filtered.gas69g69 = air.gas69g69 * gas_filter_strength
			air.gas69g69 -= filtered.gas69g69

	air.update_values()
	filtered.update_values()

	return filtered

/obj/item/clothing/mask/gas/New()
	..()
	AddComponent(/datum/component/clothing_sanity_protection, GAS_MASK_SANITY_COEFF_BUFF)

//Plague Dr suit can be found in clothing/suits/bio.dm
/obj/item/clothing/mask/gas/plaguedoctor
	name = "plague doctor69ask"
	desc = "A69odernised69ersion of the classic design, this69ask will not only filter out plasma but it can also be connected to an air supply."
	icon_state = "plaguedoctor"
	item_state = "gas_mask"
	body_parts_covered = HEAD|FACE|EYES
	style = STYLE_LOW

/obj/item/clothing/mask/gas/swat
	name = "\improper SWAT69ask"
	desc = "A close-fitting tactical69ask that can be connected to an air supply."
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
	name = "tactical69ask"
	desc = "A close-fitting tactical69ask that can be connected to an air supply."
	icon_state = "swat"
	siemens_coefficient = 0.7
	price_tag = 50
	spawn_blacklisted = TRUE

/obj/item/clothing/mask/gas/artist_hat
	name = "Spooky Rebreather"
	desc = "Wearing this69akes you feel awesome - seeing someone else wearing this69akes them look like a loser."
	icon_state = "artist"
	item_state = "artist_hat"
	spawn_frequency = 0
	var/list/states = list("True Form" = "artist", "The clown" = "clown",
	"The69ime" = "mime", "The Feminist" = "sexyclown", "The69adman" = "joker",
	"The Rainbow Color" = "rainbow", "The69onkey" = "monkeymask", "The Owl" = "owl")

/obj/item/clothing/mask/gas/artist_hat/attack_self(mob/user)
	var/choice = input(user, "To what form do you wish to69orph this69ask?","Morph69ask") as null|anything in states

	if(src && choice && !user.incapacitated() && Adjacent(user))
		icon_state = states69choice69
		to_chat(user, "Your Clown69ask has now69orphed into 69choice69, all praise the Honk69other!")
		return TRUE

/obj/item/clothing/mask/gas/clown_hat
	name = "clown wig and69ask"
	desc = "A true prankster's facial attire. A clown is incomplete without their wig and69ask."
	icon_state = "clown"
	item_state = "clown_hat"
	style = STYLE_NONE

/obj/item/clothing/mask/gas/clown_hat/attack_self(mob/user)
	var/list/options = list()
	options69"True Form"69 = "clown"
	options69"The Feminist"69 = "sexyclown"
	options69"The69adman"69 = "joker"
	options69"The Rainbow Color"69 ="rainbow"

	var/choice = input(user, "To what form do you wish to69orph this69ask?","Morph69ask") as null|anything in options

	if(src && choice && !user.incapacitated() && Adjacent(user))
		icon_state = options69choice69
		to_chat(user, "Your Clown69ask has now69orphed into 69choice69, all praise the Honk69other!")
		return TRUE

/obj/item/clothing/mask/gas/sexyclown
	name = "sexy-clown wig and69ask"
	desc = "A feminine clown69ask for the dabbling crossdressers or female entertainers."
	icon_state = "sexyclown"
	item_state = "sexyclown"

/obj/item/clothing/mask/gas/mime
	name = "mime69ask"
	desc = "The traditional69ime's69ask. It has an eerie facial posture."
	icon_state = "mime"
	item_state = "mime"
	style = STYLE_LOW

/obj/item/clothing/mask/gas/monkeymask
	name = "monkey69ask"
	desc = "A69ask used when acting as a69onkey."
	icon_state = "monkeymask"
	item_state = "monkeymask"
	body_parts_covered = HEAD|FACE|EYES

/obj/item/clothing/mask/gas/sexymime
	name = "sexy69ime69ask"
	desc = "A traditional female69ime's69ask."
	icon_state = "sexymime"
	item_state = "sexymime"
	style = STYLE_LOW

/obj/item/clothing/mask/gas/death_commando
	name = "Death Commando69ask"
	icon_state = "death_commando_mask"
	item_state = "death_commando_mask"
	siemens_coefficient = 0.2
	spawn_blacklisted = TRUE

/obj/item/clothing/mask/gas/cyborg
	name = "cyborg69isor"
	desc = "Beep boop"
	icon_state = "death"
	spawn_blacklisted = TRUE

/obj/item/clothing/mask/gas/owl_mask
	name = "owl69ask"
	desc = "Twoooo!"
	icon_state = "owl"
	body_parts_covered = HEAD|FACE|EYES

/obj/item/clothing/mask/gas/german
	name = "Oberth Republic gas69ask"
	icon_state = "germangasmask"

