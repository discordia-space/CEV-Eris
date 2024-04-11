//Cheap parts are as basic as you can get. Designed for utility use and cheap production.
/mob/living/exosuit/premade/powerloader
	name = "S.E.U. \"Ripley\"" //Space Excavation Unit
	desc = "A cheap utility exosuit. An old Nanotrasen design, now used just about everywhere due to post-Fall data leaks."

	rarity_value = 15
	material = MATERIAL_STEEL
	exosuit_color = "#ffbc37"
	arms = /obj/item/mech_component/manipulators/cheap
	legs = /obj/item/mech_component/propulsion/cheap
	head = /obj/item/mech_component/sensors/cheap
	body = /obj/item/mech_component/chassis/cheap
	installed_software_boards = list(
		/obj/item/electronics/circuitboard/exosystem/utility,
		/obj/item/electronics/circuitboard/exosystem/engineering
	)
	installed_systems = list(
		HARDPOINT_LEFT_HAND = /obj/item/mech_equipment/drill,
		HARDPOINT_RIGHT_HAND = /obj/item/mech_equipment/clamp,
		HARDPOINT_HEAD = /obj/item/mech_equipment/light,
	)

/mob/living/exosuit/premade/powerloader/flames_red
	name = "S.E.U. \"Firestarter\""
	desc = "An old but well-liked utility exosuit. This one has cool red flames."
	decal = "flames_red"

/mob/living/exosuit/premade/powerloader/flames_blue
	name = "S.E.U. \"Burning Chrome\""
	desc = "An old but well-liked utility exosuit. This one has cool blue flames."
	decal = "flames_blue"

/mob/living/exosuit/premade/powerloader/firefighter
	name = "S.E.U. \"Firefighter\""
	desc = "A refitted industrial exosuit designed to fight fires. The chassis has been replaced to protect the pilot, and the armor is reinforced with plasteel for fireproofing."

	rarity_value = 20
	material = MATERIAL_PLASTEEL // Reinforced with plasteel to fireproof the chassis
	body = /obj/item/mech_component/chassis/heavy
	exosuit_color = "#819a73"
	installed_systems = list(
		HARDPOINT_LEFT_HAND = /obj/item/mech_equipment/drill,
		HARDPOINT_RIGHT_HAND = /obj/item/mech_equipment/mounted_system/extinguisher,
		HARDPOINT_HEAD = /obj/item/mech_equipment/light,
	)

/mob/living/exosuit/premade/forklift
	name = "Aster's Guild \"Forklift\""
	desc = "A modernized forklift for usage on space-ships. Are you ready to lift?"
	rarity_value = 40
	material = MATERIAL_PLASTIC
	exosuit_color = "#c6c37b"
	body = /obj/item/mech_component/chassis/forklift
	legs = /obj/item/mech_component/propulsion/wheels
	arms = null
	head = null
	installed_software_boards = list(
		/obj/item/electronics/circuitboard/exosystem/utility
	)
	installed_systems = list(
		HARDPOINT_FRONT = /obj/item/mech_equipment/forklifting_system
	)

/mob/living/exosuit/premade/walker
	name = "OR \"Walker\""
	desc = "A walker exosuit. Is heavily armoured but trades this off for only covering the pilot from frontal attacks."
	rarity_value = 50
	material = MATERIAL_PLASTEEL
	body = /obj/item/mech_component/chassis/walker
	legs = /obj/item/mech_component/propulsion/heavy
	arms = null
	head = null
	installed_software_boards = list(
		/obj/item/electronics/circuitboard/exosystem/weapons
	)
	installed_systems = list(
		HARDPOINT_LEFT_HAND = /obj/item/mech_equipment/mounted_system/ballistic/shotgun,
		HARDPOINT_RIGHT_HAND = /obj/item/mech_equipment/mounted_system/baton
	)

