//Ripley ====================================

/datum/design/research/item/mechfab/ripley
	category = "Ripley"
	starts_unlocked = TRUE

/datum/design/research/item/mechfab/ripley/chassis
	build_path = /obj/item/mecha_parts/chassis/ripley

/datum/design/research/item/mechfab/ripley/chassis/firefighter
	build_path = /obj/item/mecha_parts/chassis/ripley/firefighter

/datum/design/research/item/mechfab/ripley/torso
	build_path = /obj/item/mecha_parts/part/ripley_torso

/datum/design/research/item/mechfab/ripley/left_arm
	build_path = /obj/item/mecha_parts/part/ripley_left_arm

/datum/design/research/item/mechfab/ripley/right_arm
	build_path = /obj/item/mecha_parts/part/ripley_right_arm

/datum/design/research/item/mechfab/ripley/left_leg
	build_path = /obj/item/mecha_parts/part/ripley_left_leg

/datum/design/research/item/mechfab/ripley/right_leg
	build_path = /obj/item/mecha_parts/part/ripley_right_leg


//Odysseus =====================================================

/datum/design/research/item/mechfab/odysseus
	category = "Odysseus"

/datum/design/research/item/mechfab/odysseus/chassis
	build_path = /obj/item/mecha_parts/chassis/odysseus

/datum/design/research/item/mechfab/odysseus/torso
	build_path = /obj/item/mecha_parts/part/odysseus_torso

/datum/design/research/item/mechfab/odysseus/head
	build_path = /obj/item/mecha_parts/part/odysseus_head

/datum/design/research/item/mechfab/odysseus/left_arm
	build_path = /obj/item/mecha_parts/part/odysseus_left_arm

/datum/design/research/item/mechfab/odysseus/right_arm
	build_path = /obj/item/mecha_parts/part/odysseus_right_arm

/datum/design/research/item/mechfab/odysseus/left_leg
	build_path = /obj/item/mecha_parts/part/odysseus_left_leg

/datum/design/research/item/mechfab/odysseus/right_leg
	build_path = /obj/item/mecha_parts/part/odysseus_right_leg

//Gygax =========================================

/datum/design/research/item/mechfab/gygax
	category = "Gygax"

/datum/design/research/item/mechfab/gygax/chassis
	build_path = /obj/item/mecha_parts/chassis/gygax

/datum/design/research/item/mechfab/gygax/torso
	build_path = /obj/item/mecha_parts/part/gygax_torso

/datum/design/research/item/mechfab/gygax/head
	build_path = /obj/item/mecha_parts/part/gygax_head

/datum/design/research/item/mechfab/gygax/left_arm
	build_path = /obj/item/mecha_parts/part/gygax_left_arm

/datum/design/research/item/mechfab/gygax/right_arm
	build_path = /obj/item/mecha_parts/part/gygax_right_arm

/datum/design/research/item/mechfab/gygax/left_leg
	build_path = /obj/item/mecha_parts/part/gygax_left_leg

/datum/design/research/item/mechfab/gygax/right_leg
	build_path = /obj/item/mecha_parts/part/gygax_right_leg

/datum/design/research/item/mechfab/gygax/armour
	build_path = /obj/item/mecha_parts/part/gygax_armour

//Durand ======================================================================

/datum/design/research/item/mechfab/durand
	category = "Durand"

/datum/design/research/item/mechfab/durand/chassis
	build_path = /obj/item/mecha_parts/chassis/durand

/datum/design/research/item/mechfab/durand/torso
	build_path = /obj/item/mecha_parts/part/durand_torso

/datum/design/research/item/mechfab/durand/head
	build_path = /obj/item/mecha_parts/part/durand_head

/datum/design/research/item/mechfab/durand/left_arm
	build_path = /obj/item/mecha_parts/part/durand_left_arm

/datum/design/research/item/mechfab/durand/right_arm
	build_path = /obj/item/mecha_parts/part/durand_right_arm

/datum/design/research/item/mechfab/durand/left_leg
	build_path = /obj/item/mecha_parts/part/durand_left_leg

/datum/design/research/item/mechfab/durand/right_leg
	build_path = /obj/item/mecha_parts/part/durand_right_leg

/datum/design/research/item/mechfab/durand/armour
	build_path = /obj/item/mecha_parts/part/durand_armour

//Phazon ======================================================================

/datum/design/research/item/mechfab/phazon
	category = "Phazon"

/datum/design/research/item/mechfab/phazon/chassis
	build_path = /obj/item/mecha_parts/chassis/phazon

/datum/design/research/item/mechfab/phazon/torso
	build_path = /obj/item/mecha_parts/part/phazon_torso

/datum/design/research/item/mechfab/phazon/head
	build_path = /obj/item/mecha_parts/part/phazon_head

/datum/design/research/item/mechfab/phazon/left_arm
	build_path = /obj/item/mecha_parts/part/phazon_left_arm

/datum/design/research/item/mechfab/phazon/right_arm
	build_path = /obj/item/mecha_parts/part/phazon_right_arm

/datum/design/research/item/mechfab/phazon/left_leg
	build_path = /obj/item/mecha_parts/part/phazon_left_leg

/datum/design/research/item/mechfab/phazon/right_leg
	build_path = /obj/item/mecha_parts/part/phazon_right_leg

/datum/design/research/item/mechfab/phazon/armour
	build_path = /obj/item/mecha_parts/part/phazon_armor

///////////////////////////////////
////////////Mecha Circuits/////////
///////////////////////////////////

/datum/design/research/circuit/mecha
	name_category = ""
	category = CAT_MECHA

/datum/design/research/circuit/mecha/AssembleDesignDesc()
	if(!desc)
		desc = "Allows for the construction of \a [item_name]."

/datum/design/research/circuit/mecha/main
	build_path = /obj/item/weapon/circuitboard/mecha/main
	sort_string = "NAAAA"

/datum/design/research/circuit/mecha/peripherals
	build_path = /obj/item/weapon/circuitboard/mecha/peripherals
	sort_string = "NAAAB"

/datum/design/research/circuit/mecha/targeting
	build_path = /obj/item/weapon/circuitboard/mecha/targeting
	sort_string = "NAAAÑ"
