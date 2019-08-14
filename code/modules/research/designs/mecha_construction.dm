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
	starts_unlocked = TRUE

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
	starts_unlocked = TRUE

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

//Phazon ======================================================================

/datum/design/research/item/mechfab/phazon
	category = "Phazon"
	starts_unlocked = TRUE

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

//Durand ======================================================================

/datum/design/research/item/mechfab/durand
	category = "Durand"
	starts_unlocked = TRUE

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


///////////////////////////////////
////////////Mecha Modules//////////
///////////////////////////////////

/datum/design/research/circuit/mecha
	name_category = ""
	category = CAT_MECHA

//Ripley ==============================================

/datum/design/research/circuit/mecha/ripley_main
	build_path = /obj/item/weapon/circuitboard/mecha/ripley/main
	sort_string = "NAAAA"

/datum/design/research/circuit/mecha/ripley_peri
	build_path = /obj/item/weapon/circuitboard/mecha/ripley/peripherals
	sort_string = "NAAAB"

//Odysseus ==============================================

/datum/design/research/circuit/mecha/odysseus_main
	build_path = /obj/item/weapon/circuitboard/mecha/odysseus/main
	sort_string = "NAABA"

/datum/design/research/circuit/mecha/odysseus_peri
	build_path = /obj/item/weapon/circuitboard/mecha/odysseus/peripherals
	sort_string = "NAABB"

//Gygax ==============================================

/datum/design/research/circuit/mecha/gygax_main
	build_path = /obj/item/weapon/circuitboard/mecha/gygax/main
	sort_string = "NAACA"

/datum/design/research/circuit/mecha/gygax_peri
	build_path = /obj/item/weapon/circuitboard/mecha/gygax/peripherals
	sort_string = "NAACB"

/datum/design/research/circuit/mecha/gygax_targ
	build_path = /obj/item/weapon/circuitboard/mecha/gygax/targeting
	sort_string = "NAACC"

//Durand ==============================================

/datum/design/research/circuit/mecha/durand_main
	build_path = /obj/item/weapon/circuitboard/mecha/durand/main
	sort_string = "NAADA"

/datum/design/research/circuit/mecha/durand_peri
	build_path = /obj/item/weapon/circuitboard/mecha/durand/peripherals
	sort_string = "NAADB"

/datum/design/research/circuit/mecha/durand_targ
	build_path = /obj/item/weapon/circuitboard/mecha/durand/targeting
	sort_string = "NAADC"

//Phazon ==============================================

/datum/design/research/circuit/mecha/phazon_main
	build_path = /obj/item/weapon/circuitboard/mecha/phazon/main
	sort_string = "NAAEA"

/datum/design/research/circuit/mecha/phazon_peri
	build_path = /obj/item/weapon/circuitboard/mecha/phazon/peripherals
	sort_string = "NAAEB"

/datum/design/research/circuit/mecha/phazon_targ
	build_path = /obj/item/weapon/circuitboard/mecha/phazon/targeting
	sort_string = "NAAEC"
