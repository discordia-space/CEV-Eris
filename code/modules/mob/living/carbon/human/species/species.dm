/*
	Datum-based species. Should69ake for69uch cleaner and easier to69aintain race code.
*/
#define SPECIES_BLOOD_DEFAULT 560
/datum/species

	// Descriptors and strings.
	var/name                                             // Species69ame.
	var/name_plural                                      // Pluralized69ame (since "69name69s" is69ot always69alid)
	var/blurb = "A completely69ondescript species."      // A brief lore summary for use in the chargen screen.

	// Icon/appearance69ars.
	var/icobase = 'icons/mob/human_races/r_human.dmi'    //69ormal icon set.
	var/deform = 'icons/mob/human_races/r_def_human.dmi' //69utated icon set.
	var/faceicobase = 'icons/mob/human_face.dmi'

	// Damage overlay and69asks.
	var/damage_overlays = 'icons/mob/human_races/masks/dam_human.dmi'
	var/damage_mask = 'icons/mob/human_races/masks/dam_mask_human.dmi'
	var/blood_mask = 'icons/mob/human_races/masks/blood_human.dmi'

	var/prone_icon                                       // If set, draws this from icobase when69ob is prone.
	var/eyes = "eyes_s"                                  // Icon for eyes.
	var/has_floating_eyes                                // Eyes will overlay over darkness (glow)
	var/blood_color = "#A10808"                          // Red.
	var/flesh_color = "#FFC896"                          // Pink.
	var/base_color                                       // Used by carrions. Should also be used for icon previes..
	var/tail                                             //69ame of tail state in species effects icon file.
	var/tail_animation                                   // If set, the icon to obtain tail animation states from.
	var/race_key = 0       	                             // Used for69ob icon cache string.
	var/icon/icon_template                               // Used for69ob icon generation for69on-32x32 species.
	var/mob_size	=69OB_MEDIUM
	var/show_ssd = "fast asleep"
	var/virus_immune
	var/blood_volume = 560                               // Initial blood69olume.
	var/hunger_factor = DEFAULT_HUNGER_FACTOR            //69ultiplier for hunger.
	var/taste_sensitivity = TASTE_NORMAL                 // How sensitive the species is to69inute tastes.

	var/min_age = 17
	var/max_age = 70

	// Language/culture69ars.
	var/default_language = LANGUAGE_COMMON   // Default language is used when 'say' is used without69odifiers.
	var/language = LANGUAGE_COMMON           // Default racial language, if any.
	var/list/secondary_langs = list()        // The69ames of secondary languages that are available to this species.
	var/list/speech_sounds                   // A list of sounds to potentially play when speaking.
	var/list/speech_chance                   // The likelihood of a speech sound playing.
	var/num_alternate_languages = 0          // How69any secondary languages are available to select at character creation
	var/name_language = LANGUAGE_COMMON      // The language to use when determining69ames for this species, or69ull to use the first69ame/last69ame generator

	// Combat69ars.
	var/total_health = 100                   // Point at which the69ob will enter crit.
	var/list/unarmed_types = list(           // Possible unarmed attacks that the69ob will use in combat,
		/datum/unarmed_attack,
		/datum/unarmed_attack/bite
		)
	var/list/unarmed_attacks =69ull          // For empty hand harm-intent attack
	var/brute_mod =     1                    // Physical damage69ultiplier.
	var/burn_mod =      1                    // Burn damage69ultiplier.
	var/oxy_mod =       1                    // Oxyloss69odifier
	var/toxins_mod =    1                    // Toxloss69odifier
	var/radiation_mod = 1                    // Radiation69odifier
	var/flash_mod =     1                    // Stun from blindness69odifier.
	var/vision_flags = SEE_SELF              // Same flags as glasses.

	var/list/hair_styles
	var/list/facial_hair_styles

	// Death69ars.
	var/meat_type = /obj/item/reagent_containers/food/snacks/meat/human
	var/gibber_type = /obj/effect/gibspawner/human
	var/single_gib_type = /obj/effect/decal/cleanable/blood/gibs
	var/remains_type = /obj/item/remains/xeno
	var/gibbed_anim = "gibbed-h"
	var/dusted_anim = "dust-h"
	var/death_sound
	var/death_message = "seizes up and falls limp, their eyes dead and lifeless..."
	var/knockout_message = "has been knocked unconscious!"

	// Environment tolerance/life processes69ars.
	var/reagent_tag                                   //Used for69etabolizing reagents.
	var/breath_pressure = 16                          //69inimum partial pressure safe for breathing, kPa
	var/breath_type = "oxygen"                        //69on-oxygen gas breathed, if any.
	var/poison_type = "plasma"                        // Poisonous air.
	var/exhale_type = "carbon_dioxide"                // Exhaled gas type.
	var/cold_level_1 = 260                            // Cold damage level 1 below this point.
	var/cold_level_2 = 200                            // Cold damage level 2 below this point.
	var/cold_level_3 = 120                            // Cold damage level 3 below this point.
	var/heat_level_1 = 360                            // Heat damage level 1 above this point.
	var/heat_level_2 = 400                            // Heat damage level 2 above this point.
	var/heat_level_3 = 1000                           // Heat damage level 3 above this point.
	var/passive_temp_gain = 0		                  // Species will gain this69uch temperature every second
	var/hazard_high_pressure = HAZARD_HIGH_PRESSURE   // Dangerously high pressure.
	var/warning_high_pressure = WARNING_HIGH_PRESSURE // High pressure warning.
	var/warning_low_pressure = WARNING_LOW_PRESSURE   // Low pressure warning.
	var/hazard_low_pressure = HAZARD_LOW_PRESSURE     // Dangerously low pressure.
	var/light_dam                                     // If set,69ob will be damaged in light over this69alue and heal in light below its69egative.
	var/body_temperature = 310.15	                  //69on-IS_SYNTHETIC species will try to stabilize at this temperature.
	                                                  // (also affects temperature processing)

	var/heat_discomfort_level = 315                   // Aesthetic69essages about feeling warm.
	var/cold_discomfort_level = 285                   // Aesthetic69essages about feeling chilly.
	var/list/heat_discomfort_strings = list(
		"You feel sweat drip down your69eck.",
		"You feel uncomfortably warm.",
		"Your skin prickles in the heat."
		)
	var/list/cold_discomfort_strings = list(
		"You feel chilly.",
		"You shiver suddenly.",
		"Your chilly flesh stands out in goosebumps."
		)

	// HUD data69ars.
	var/datum/hud_data/hud
	var/hud_type

	// Body/form69ars.
	var/list/inherent_verbs 	  // Species-specific69erbs.
	var/has_fine_manipulation = 1 // Can use small items.
	var/siemens_coefficient = 1   // The lower, the thicker the skin and better the insulation.
	var/darksight = 2             //69ative darksight distance.
	var/flags = 0                 //69arious specific features.
	var/appearance_flags = 0      // Appearance/display related features.
	var/spawn_flags = 0           // Flags that specify who can spawn as this species
	var/slowdown = 0              // Passive69ovement speed69alus (or boost, if69egative)
	var/primitive_form            // Lesser form, if any (ie.69onkey for humans)
	var/greater_form              // Greater form, if any, ie. human for69onkeys.
	var/lower_sanity_process	  // Controls how69uch sanity is processed on the69ob for performance reasons.
	var/holder_type
	var/gluttonous                // Can eat some69obs.69alues can be GLUT_TINY, GLUT_SMALLER, GLUT_ANYTHING.
	var/species_rarity_value = 1          // Relative rarity/collector69alue for this species.
	                              // Determines the organs that the species spawns with and
	var/list/has_process = list(    // which required-process checks are conducted and defalut organs for them.
		OP_HEART =    /obj/item/organ/internal/heart,
		OP_LUNGS =    /obj/item/organ/internal/lungs,
		OP_STOMACH =  /obj/item/organ/internal/stomach,
		OP_LIVER =    /obj/item/organ/internal/liver,
		OP_KIDNEY_LEFT =  /obj/item/organ/internal/kidney/left,
		OP_KIDNEY_RIGHT = /obj/item/organ/internal/kidney/right,
		BP_BRAIN =    /obj/item/organ/internal/brain,
		OP_APPENDIX = /obj/item/organ/internal/appendix,
		OP_EYES =     /obj/item/organ/internal/eyes
		)
	var/vision_organ              // If set, this organ is required for69ision. Defaults to "eyes" if the species has them.

	// The order is important!
	var/list/has_limbs = list(
		BP_CHEST = 69ew /datum/organ_description/chest,
		BP_GROIN = 69ew /datum/organ_description/groin,
		BP_HEAD =  69ew /datum/organ_description/head,
		BP_L_ARM = 69ew /datum/organ_description/arm/left,
		BP_R_ARM = 69ew /datum/organ_description/arm/right,
		BP_L_LEG = 69ew /datum/organ_description/leg/left,
		BP_R_LEG = 69ew /datum/organ_description/leg/right
		)

	//69isc
	var/list/genders = list(MALE, FEMALE)

	// Bump69ars
	var/bump_flag = HUMAN	// What are we considered to be when bumped?
	var/push_flags = ~HEAVY	// What can we push?
	var/swap_flags = ~HEAVY	// What can we swap place with?

	var/pass_flags = 0

/datum/species/proc/get_eyes(var/mob/living/carbon/human/H)
	return

/datum/species/New()
	if(hud_type)
		hud =69ew hud_type()
	else
		hud =69ew()

	//If the species has eyes, they are the default69ision organ
	if(!vision_organ && has_process69OP_EYES69)
		vision_organ = BP_EYES

	unarmed_attacks = list()
	for(var/u_type in unarmed_types)
		unarmed_attacks +=69ew u_type()

/datum/species/proc/get_station_variant()
	return69ame

/datum/species/proc/get_bodytype()
	return69ame


/datum/species/proc/get_environment_discomfort(var/mob/living/carbon/human/H,69ar/msg_type)

	if(!prob(5))
		return

	var/covered = 0 // Basic coverage can help.
	for(var/obj/item/clothing/clothes in H)
		if(H.l_hand == clothes|| H.r_hand == clothes)
			continue
		if((clothes.body_parts_covered & UPPER_TORSO) && (clothes.body_parts_covered & LOWER_TORSO))
			covered = 1
			break

	switch(msg_type)
		if("cold")
			if(!covered)
				to_chat(H, SPAN_DANGER("69pick(cold_discomfort_strings)69"))
		if("heat")
			if(covered)
				to_chat(H, SPAN_DANGER("69pick(heat_discomfort_strings)69"))

/datum/species/proc/sanitize_name(name)
	return sanitizeName(name)

/datum/species/proc/get_random_name(gender)
	if(!name_language)
		if(gender == FEMALE)
			return capitalize(pick(GLOB.first_names_female)) + " " + capitalize(pick(GLOB.last_names))
		else
			return capitalize(pick(GLOB.first_names_male)) + " " + capitalize(pick(GLOB.last_names))

	var/datum/language/species_language = all_languages69name_language69
	if(!species_language)
		species_language = all_languages69default_language69
	if(!species_language)
		return "unknown"
	return species_language.get_random_name(gender)

/datum/species/proc/get_random_first_name(gender)
	if(!name_language)
		if(gender == FEMALE)
			return capitalize(pick(GLOB.first_names_female))
		else
			return capitalize(pick(GLOB.first_names_male))

	var/datum/language/species_language = all_languages69name_language69
	if(!species_language)
		species_language = all_languages69default_language69
	if(!species_language)
		return "unknown"
	return species_language.get_random_name(gender)

/datum/species/proc/get_random_last_name()
	if(!name_language)
		return capitalize(pick(GLOB.last_names))

	var/datum/language/species_language = all_languages69name_language69
	if(!species_language)
		species_language = all_languages69default_language69
	if(!species_language)
		return "unknown"
	return species_language.get_random_name()


/datum/species/proc/organs_spawned(mob/living/carbon/human/H)
	return

/datum/species/proc/hug(mob/living/carbon/human/H,var/mob/living/target)

	var/t_him = "them"
	switch(target.gender)
		if(MALE)
			t_him = "him"
		if(FEMALE)
			t_him = "her"

	H.visible_message(SPAN_NOTICE("69H69 hugs 69target69 to69ake 69t_him69 feel better!"), \
					SPAN_NOTICE("You hug 69target69 to69ake 69t_him69 feel better!"))

/datum/species/proc/remove_inherent_verbs(var/mob/living/carbon/human/H)
	if(inherent_verbs)
		for(var/verb_path in inherent_verbs)
			H.verbs -=69erb_path
	return

/datum/species/proc/add_inherent_verbs(var/mob/living/carbon/human/H)
	if(inherent_verbs)
		for(var/verb_path in inherent_verbs)
			H.verbs |=69erb_path
	return

/datum/species/proc/handle_post_spawn(var/mob/living/carbon/human/H) //Handles anything69ot already covered by basic species assignment.
	add_inherent_verbs(H)
	H.mob_bump_flag = bump_flag
	H.mob_swap_flags = swap_flags
	H.mob_push_flags = push_flags
	H.pass_flags = pass_flags
	H.mob_size =69ob_size

/datum/species/proc/handle_death(var/mob/living/carbon/human/H) //Handles any species-specific death events (such as dionaea69ymph spawns).
	return

// Only used for alien plasma weeds atm, but could be used for Dionaea later.
/datum/species/proc/handle_environment_special(var/mob/living/carbon/human/H)
	return

// Used to update alien icons for aliens.
/datum/species/proc/handle_login_special(var/mob/living/carbon/human/H)
	return

// As above.
/datum/species/proc/handle_logout_special(var/mob/living/carbon/human/H)
	return

// Builds the HUD using species-specific icons and usable slots.
/datum/species/proc/build_hud(var/mob/living/carbon/human/H)
	return

//Used by xenos understanding larvae and dionaea understanding69ymphs.
/datum/species/proc/can_understand(var/mob/other)
	return

// Called when using the shredding behavior.
/datum/species/proc/can_shred(var/mob/living/carbon/human/H,69ar/ignore_intent)

	if(!ignore_intent && H.a_intent != I_HURT)
		return 0

	for(var/datum/unarmed_attack/attack in unarmed_attacks)
		if(!attack.is_usable(H))
			continue
		if(attack.shredding)
			return 1

	return 0

// Called in life() when the69ob has69o client.
/datum/species/proc/handle_npc(var/mob/living/carbon/human/H)
	return

/datum/species/proc/get_vision_flags(var/mob/living/carbon/human/H)
	return69ision_flags

/datum/species/proc/handle_vision(var/mob/living/carbon/human/H)
	H.update_sight()
	H.sight |= get_vision_flags(H)
	H.sight |= H.equipment_vision_flags

	if(H.stat == DEAD)
		return 1

	if(!H.druggy)
		H.see_in_dark = (H.sight == SEE_TURFS|SEE_MOBS|SEE_OBJS) ? 8 :69in(darksight + H.equipment_darkness_modifier, 8)

	if(H.equipment_see_invis)
		H.see_invisible = H.equipment_see_invis

	if(H.equipment_tint_total >= TINT_BLIND)
		H.eye_blind =69ax(H.eye_blind, 1)

/*	if(H.blind)
		H.blind.alpha = (H.eye_blind ? 255 : 0)*/

	if(!H.client)//no client,69o screen to update
		return 1

	if(config.welder_vision)
		if(H.equipment_tint_total == TINT_HEAVY)
			H.client.screen += global_hud.darkMask
		else if((!H.equipment_prescription && (H.disabilities &69EARSIGHTED)) || H.equipment_tint_total == TINT_MODERATE)
			H.client.screen += global_hud.vimpaired
		else if(H.equipment_tint_total == TINT_LOW)
			H.client.screen += global_hud.lightMask

//	if(H.eye_blurry)	H.client.screen += global_hud.blurry
//	if(H.druggy)		H.client.screen += global_hud.druggy

	for(var/overlay in H.equipment_overlays)
		H.client.screen |= overlay

	return 1

/datum/species/proc/get_facial_hair_styles(var/gender)
	var/list/facial_hair_styles_by_species = LAZYACCESS(facial_hair_styles, type)
	if(!facial_hair_styles_by_species)
		facial_hair_styles_by_species = list()
		LAZYSET(facial_hair_styles, type, facial_hair_styles_by_species)

	var/list/facial_hair_style_by_gender = facial_hair_styles_by_species69gender69
	if(!facial_hair_style_by_gender)
		facial_hair_style_by_gender = list()
		LAZYSET(facial_hair_styles_by_species, gender, facial_hair_style_by_gender)

		for(var/facialhairstyle in GLOB.facial_hair_styles_list)
			var/datum/sprite_accessory/S = GLOB.facial_hair_styles_list69facialhairstyle69
			if(gender ==69ALE && S.gender == FEMALE)
				continue
			if(gender == FEMALE && S.gender ==69ALE)
				continue
			if(!(get_bodytype() in S.species_allowed))
				continue
			ADD_SORTED(facial_hair_style_by_gender, facialhairstyle, /proc/cmp_text_asc)
			facial_hair_style_by_gender69facialhairstyle69 = S

	return facial_hair_style_by_gender

/datum/species/proc/get_hair_styles()
	var/list/L = LAZYACCESS(hair_styles, type)
	if(!L)
		L = list()
		LAZYSET(hair_styles, type, L)
		for(var/hairstyle in GLOB.hair_styles_list)
			var/datum/sprite_accessory/S = GLOB.hair_styles_list69hairstyle69
			if(!(get_bodytype() in S.species_allowed))
				continue
			ADD_SORTED(L, hairstyle, /proc/cmp_text_asc)
			L69hairstyle69 = S
	return L

/datum/species/proc/equip_survival_gear(mob/living/carbon/human/H, extendedtank = TRUE)
	var/box_type = /obj/item/storage/box/survival

	if(extendedtank)
		box_type = /obj/item/storage/box/survival/extended

	if(istype(H.get_equipped_item(slot_back), /obj/item/storage))
		H.equip_to_storage(new box_type(H.back))
	else
		H.equip_to_slot_or_del(new box_type(H), slot_r_hand)

/datum/species/proc/has_equip_slot(slot)
	if(hud && hud.equip_slots)
		if(!(slot in hud.equip_slots))
			return FALSE
	return TRUE