/obj/item/device/kit
	icon_state = "modkit"
	icon = 'icons/obj/device.dmi'
	bad_type = /obj/item/device/kit
	var/new_name = "exosuit"    //What is the variant called?
	var/new_desc = "An exosuit." //How is the new exosuit described?
	var/new_icon = "ripley"  //What base icon will the new exosuit use?
	var/new_icon_file
	var/uses = 1        // Uses before the kit deletes itself.

/obj/item/device/kit/examine(user, afterDesc)
	. = ..(user, afterDesc = "[afterDesc] \n It has [uses] use\s left.")

/obj/item/device/kit/proc/use(var/amt, var/mob/user)
	uses -= amt
	playsound(get_turf(user), 'sound/items/Screwdriver.ogg', 50, 1)
	if(uses<1)
		qdel(src)

// Root hardsuit kit defines.
// Icons for modified hardsuits need to be in the proper .dmis because suit cyclers may cock them up.
/obj/item/device/kit/suit
	name = "voidsuit modification kit"
	desc = "A kit for modifying a voidsuit."
	uses = 2
	bad_type = /obj/item/device/kit/suit
	var/new_light_overlay
	var/new_mob_icon_file

/obj/item/clothing/head/space/void
	bad_type = /obj/item/clothing/head/space/void
	spawn_tags = null

/obj/item/clothing/head/space/void/attackby(var/obj/item/O, var/mob/user)
	if(istype(O,/obj/item/device/kit/suit))
		var/obj/item/device/kit/suit/kit = O
		SetName("[kit.new_name] suit helmet")
		desc = kit.new_desc
		icon_state = "[kit.new_icon]_helmet"
		item_state = "[kit.new_icon]_helmet"
		if(kit.new_icon_file)		icon = kit.new_icon_file
		if(kit.new_mob_icon_file)	icon_override = kit.new_mob_icon_file
		if(kit.new_light_overlay)	light_overlay = kit.new_light_overlay
		to_chat(user, "You set about modifying the helmet into [src].")
		var/mob/living/carbon/human/H = user
		if(istype(H))				species_restricted = list(H.species.get_bodytype(H))
		kit.use(1,user)
		return 1
	return ..()

/obj/item/clothing/suit/space/void/attackby(var/obj/item/O, var/mob/user)
	if(istype(O,/obj/item/device/kit/suit))
		var/obj/item/device/kit/suit/kit = O
		SetName("[kit.new_name] voidsuit")
		desc = kit.new_desc
		icon_state = "[kit.new_icon]_suit"
		item_state = "[kit.new_icon]_suit"
		if(kit.new_icon_file)
			icon = kit.new_icon_file
		if(kit.new_mob_icon_file)
			icon_override = kit.new_mob_icon_file
		to_chat(user, "You set about modifying the suit into [src].")
		var/mob/living/carbon/human/H = user
		if(istype(H))
			species_restricted = list(H.species.get_bodytype(H))
		kit.use(1,user)
		return 1
	return ..()

// Mechs are handled in their attackby (mech_interaction.dm).
/obj/item/device/kit/paint
	name = "exosuit customisation kit"
	desc = "A kit containing all the needed tools and parts to repaint a exosuit."
	bad_type = /obj/item/device/kit/paint
	var/removable

/obj/item/device/kit/paint/examine(mob/user)
	. = ..(user, afterDesc = "This kit will add a '[new_name]' decal to a exosuit'.")

// exosuit kits.
/obj/item/device/kit/paint/powerloader
	bad_type = /obj/item/device/kit/paint/powerloader

/obj/item/device/kit/paint/powerloader/flames_red
	name = "\"Firestarter\" exosuit customisation kit"
	new_name = "red flames"
	new_icon = "flames_red"

/obj/item/device/kit/paint/powerloader/flames_blue
	name = "\"Burning Chrome\" exosuit customisation kit"
	new_name = "blue flames"
	new_icon = "flames_blue"

/*
//Ripley APLU kits.
/obj/item/device/kit/paint/ripley
	name = "\"Classic\" APLU customisation kit"
	new_name = "APLU \"Classic\""
	new_desc = "A very retro APLU unit; didn't they retire these back in 2543?"
	new_icon = "ripley-old"
	allowed_types = list("ripley")

/obj/item/device/kit/paint/ripley/death
	name = "\"Reaper\" APLU customisation kit"
	new_name = "APLU \"Reaper\""
	new_desc = "A terrifying, grim power loader. Why do those clamps have spikes?"
	new_icon = "deathripley"
	allowed_types = list("ripley","firefighter")

/obj/item/device/kit/paint/ripley/flames_red
	name = "\"Firestarter\" APLU customisation kit"
	new_name = "APLU \"Firestarter\""
	new_desc = "A standard APLU exosuit with stylish orange flame decals."
	new_icon = "ripley_flames_red"

/obj/item/device/kit/paint/ripley/flames_blue
	name = "\"Burning Chrome\" APLU customisation kit"
	new_name = "APLU \"Burning Chrome\""
	new_desc = "A standard APLU exosuit with stylish blue flame decals."
	new_icon = "ripley_flames_blue"

/obj/item/device/kit/paint/ripley/syndieripley
	name = "\"Syndie\" APLU customisation kit"
	new_name = "Syndicate APLU"
	new_desc = "A painted in red APLU exosuit."
	new_icon = "syndieripley"

/obj/item/device/kit/paint/ripley/titan
	name = "\"Titan\" APLU customisation kit"
	new_name = "\"Titan\" APLU"
	new_desc = "A standard APLU exosuit decorated with skull decal and Firefighter arm."
	new_icon = "titan"


// Durand kits.
/obj/item/device/kit/paint/durand
	name = "\"Classic\" Durand customisation kit"
	new_name = "Durand \"Classic\""
	new_desc = "An older model of Durand combat exosuit. This model was retired for rotating a pilot's torso 180 degrees."
	new_icon = "old_durand"
	allowed_types = list("durand")

/obj/item/device/kit/paint/durand/seraph
	name = "\"Cherubim\" Durand customisation kit"
	new_name = "Durand \"Cherubim\""
	new_desc = "A Durand combat exosuit modelled after ancient Earth entertainment. Your heart goes doki-doki just looking at it."
	new_icon = "old_durand"

/obj/item/device/kit/paint/durand/phazon
	name = "\"Sypher\" Durand customisation kit"
	new_name = "Durand \"Sypher\""
	new_desc = "A Durand combat exosuit with some very stylish neons and decals. Seems to blur slightly at the edges; probably an optical illusion."
	new_icon = "phazon"

// Gygax kits.
/obj/item/device/kit/paint/gygax
	name = "\"Jester\" Gygax customisation kit"
	new_name = "Gygax \"Jester\""
	new_desc = "A Gygax exosuit modelled after the infamous combat-troubadors of Earth's distant past. Terrifying to behold."
	new_icon = "honker"
	allowed_types = list("gygax")

/obj/item/device/kit/paint/gygax/darkgygax
	name = "\"Silhouette\" Gygax customisation kit"
	new_name = "Gygax \"Silhouette\""
	new_desc = "An ominous Gygax exosuit modelled after the fictional corporate 'death squads' that were popular in pulp action-thrillers back in 2554."
	new_icon = "darkgygax"

/obj/item/device/kit/paint/gygax/recitence
	name = "\"Gaoler\" Gygax customisation kit"
	new_name = "Durand \"Gaoler\""
	new_desc = "A bulky silver Gygax exosuit. The extra armour appears to be painted on, but it's very shiny."
	new_icon = "recitence"
*/
