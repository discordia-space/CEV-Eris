#define MODIFICATION_ORGANIC 1
#define MODIFICATION_SILICON 2
#define MODIFICATION_REMOVED 3

var/global/list/body_modifications = list()
var/global/list/modifications_types = list(
	BP_CHEST = "",  "chest2" = "", BP_HEAD = "",   BP_GROIN = "",
	BP_L_ARM  = "", BP_R_ARM  = "", BP_L_HAND = "", BP_R_HAND = "",
	BP_L_LEG  = "", BP_R_LEG  = "", BP_L_FOOT = "", BP_R_FOOT = "",
	O_HEART  = "", O_LUNGS  = "", O_LIVER  = "", O_EYES   = ""
)

/proc/generate_body_modification_lists()
	for(var/mod_type in typesof(/datum/body_modification))
		var/datum/body_modification/BM = new mod_type()
		if(!BM.id) continue
		body_modifications[BM.id] = BM
		var/class = ""
		if(BM.allowed_species && BM.allowed_species.len)
			class = " limited [BM.allowed_species.Join(" ")]"
		for(var/part in BM.body_parts)
			modifications_types[part] += "<div onclick=\"set('body_modification', '[BM.id]');\" class='block[class]'><b>[BM.name]</b><br>[BM.desc]</div>"

/proc/get_default_modificaton(var/nature = MODIFICATION_ORGANIC)
	switch(nature)
		if(MODIFICATION_ORGANIC) return body_modifications["nothing"]
		if(MODIFICATION_SILICON) return body_modifications["prosthesis_basic"]
		if(MODIFICATION_REMOVED) return body_modifications["amputated"]

/datum/body_modification
	var/name = ""
	var/short_name = ""
	var/id = ""								// For savefile. Must be unique.
	var/desc = ""							// Description.
	var/list/body_parts = list(				// For sorting'n'selection optimization.
		BP_CHEST, "chest2", BP_HEAD, BP_GROIN, BP_L_ARM, BP_R_ARM, BP_L_HAND, BP_R_HAND, BP_L_LEG, BP_R_LEG,\
		BP_L_FOOT, BP_R_FOOT, O_HEART, O_LUNGS, O_LIVER, O_BRAIN, O_EYES)
	var/list/allowed_species = list("Human")// Species restriction.
	var/replace_limb = null					// To draw usual limb or not.
	var/mob_icon = ""
	var/icon/icon = 'icons/mob/human_races/body_modification.dmi'
	var/nature = MODIFICATION_ORGANIC

	proc/get_mob_icon(organ, body_build = "", color="#ffffff", gender = MALE, species)	//Use in setup character only
		return new/icon('icons/mob/human.dmi', "blank")

	proc/is_allowed(var/organ = "", datum/preferences/P)
		if(!organ || !(organ in body_parts))
			usr << "[name] isn't useable for [organ_tag_to_name[organ]]"
			return 0
		/*if(allowed_species && !(P.species in allowed_species))
			usr << "[name] isn't allowed for [P.species]"
			return 0*/
		var/list/organ_data = organ_structure[organ]
		if(organ_data)
			var/parent_organ = organ_data["parent"]
			if(parent_organ)
				var/datum/body_modification/parent = P.get_modification(parent_organ)
				if(parent.nature > nature)
					usr << "[name] can't be attached to [parent.name]"
					return 0
		return 1

	proc/create_organ(var/mob/living/carbon/holder, var/organ, var/color)
		return null

/datum/body_modification/none
	name = "Unmodified organ"
	id = "nothing"
	short_name = "nothing"
	desc = "Normal organ."
	allowed_species = null

	create_organ(var/mob/living/carbon/holder, var/datum/organ_description/OD, var/color)
		if(istype(OD))
			return OD.create_organ(holder,OD)
		else if(ispath(OD))
			return new OD(holder)
		else
			return null


/datum/body_modification/limb
	create_organ(var/mob/living/carbon/holder, var/datum/organ_description/OD, var/color)
		if(replace_limb)
			return new replace_limb(holder,OD)
		else
			return new OD.default_type(holder,OD)

/datum/body_modification/limb/amputation
	name = "Amputated"
	short_name = "Amputated"
	id = "amputated"
	desc = "Organ was removed."
	body_parts = list(BP_L_ARM, BP_R_ARM, BP_L_HAND, BP_R_HAND, BP_L_LEG, BP_R_LEG, BP_L_FOOT, BP_R_FOOT)
	replace_limb = 1
	nature = MODIFICATION_REMOVED
	create_organ()
		return null

/datum/body_modification/limb/tattoo
	name = "Abstract"
	desc = "Simple tattoo (use flavor)."
	id = "abstract"
	//allowed_species = list("Human", "Skrell", "Tajara", "Unathi", "Vox")
	body_parts = list(
		BP_HEAD, BP_CHEST, BP_GROIN, BP_L_ARM, BP_R_ARM,
		BP_L_HAND, BP_R_HAND, BP_L_LEG, BP_R_LEG, BP_L_FOOT, BP_R_FOOT
	)
	icon = 'icons/mob/tattoo.dmi'
	mob_icon = "abstract"

	New()
		if(!short_name) short_name = "T: [name]"
		name = "Tattoo: [name]"

	get_mob_icon(organ, body_build = "", color = "#ffffff")
		var/icon/I = new/icon(icon, "[organ]_[mob_icon][body_build]")
		I.Blend(color, ICON_ADD)
		return I

	create_organ(var/mob/living/carbon/holder, var/O, var/color)
		var/obj/item/organ/external/E = ..(holder, O, color)
		E.tattoo = mob_icon
		E.tattoo_color = iscolor(color) ? color : "#000000"
		return E

/datum/body_modification/limb/tattoo/venom
	name = "Venom"
	id = "venom"
	body_parts = list(BP_CHEST, "chest2", BP_L_ARM, BP_R_ARM, BP_L_LEG, BP_R_LEG)
	mob_icon = "venom"

/datum/body_modification/limb/tattoo/scar_left
	name = "Scar (left eye)"
	short_name = "T: scar (l)"
	id = "scar_left"
	body_parts = list(BP_HEAD)
	mob_icon = "scar_l"

/datum/body_modification/limb/tattoo/scar_right
	name = "Scar (right eye)"
	short_name = "T: scar (r)"
	id = "scar_right"
	body_parts = list(BP_HEAD)
	mob_icon = "scar_r"

/datum/body_modification/limb/tattoo/stripes
	name = "Stripes"
	id = "stripes"
	body_parts = list(BP_R_ARM)
	mob_icon = "stripes"

/datum/body_modification/limb/tattoo/cross
	name = "Cross"
	id = "cross"
	body_parts = list(BP_CHEST)
	mob_icon = "cross"

/datum/body_modification/limb/tattoo/skull
	name = "Skull"
	id = "skull"
	body_parts = list(BP_CHEST)
	mob_icon = "skull"

/datum/body_modification/limb/tattoo/diamonds
	name = "Spades"
	id = "diamonds"
	body_parts = list(BP_CHEST)
	mob_icon = "diamonds"

/*/datum/body_modification/limb/tattoo/tajara_stripes
	name = "Tiger Stripes"
	short_name = "T: Tiger"
	desc = "A great camouflage to hide in long grass."
	id = "stripes"
	body_parts = list(BP_HEAD, BP_CHEST)
	mob_icon = "tajara"
	allowed_species = list("Tajara")

/datum/body_modification/limb/tattoo/tribal_markings
	name = "Unathi Tribal Markings"
	short_name = "T: Tribal"
	desc = "A specific identification and beautification marks designed on the face or body."
	id = "tribal"
	body_parts = list(BP_HEAD, BP_CHEST)
	mob_icon = "unathi"
	allowed_species = list("Unathi")
*/

/datum/body_modification/limb/prosthesis
	name = "Unbranded"
	id = "prosthesis_basic"
	desc = "Simple, brutal and reliable prosthesis"
	body_parts = list(BP_L_ARM, BP_R_ARM, BP_L_HAND, BP_R_HAND, \
		BP_L_LEG, BP_R_LEG, BP_L_FOOT, BP_R_FOOT)
	replace_limb = /obj/item/organ/external/robotic
	icon = 'icons/mob/human_races/robotic.dmi'
	//allowed_species = list("Human","Tajaran","Unathi","Skrell")
	nature = MODIFICATION_SILICON

	New()
		var/obj/item/organ/external/robotic/R = replace_limb
		name = initial(R.name)
		icon = initial(R.force_icon)
		desc = initial(R.desc)
		short_name = "P: [name]"
		name = "Prosthesis: [name]"

	get_mob_icon(organ, body_build, color, gender, species)
		return new/icon(icon, "[organ][gender == FEMALE ? "_f" : "_m"][body_build]")

/datum/body_modification/limb/prosthesis/bishop
	id = "prosthesis_bishop"
	replace_limb = /obj/item/organ/external/robotic/bishop
	icon = 'icons/mob/human_races/cyberlimbs/bishop.dmi'

/datum/body_modification/limb/prosthesis/hesphaistos
	id = "prosthesis_hesphaistos"
	replace_limb = /obj/item/organ/external/robotic/hesphaistos
	icon = 'icons/mob/human_races/cyberlimbs/hesphaistos.dmi'

/datum/body_modification/limb/prosthesis/zenghu
	id = "prosthesis_zenghu"
	replace_limb = /obj/item/organ/external/robotic/zenghu
	icon = 'icons/mob/human_races/cyberlimbs/zenghu.dmi'

/datum/body_modification/limb/prosthesis/xion
	id = "prosthesis_xion"
	replace_limb = /obj/item/organ/external/robotic/xion
	icon = 'icons/mob/human_races/cyberlimbs/xion.dmi'

/*/datum/body_modification/limb/prosthesis/cyber
	id = "prosthesis_enforcer"								//NO SPRITES
	replace_limb = /obj/item/organ/external/robotic/cyber
	icon = 'icons/mob/human_races/cyberlimbs/cyber.dmi'*/


/datum/body_modification/limb/mutation
	New()
		short_name = "M: [name]"
		name = "Mutation: [name]"

/*/datum/body_modification/limb/mutation/exoskeleton				//NEED SPRITES
	name = "Exoskeleton"
	id = "mutation_exoskeleton"
	desc = "Your limb covered with bony shell (act as shield)."
	body_parts = list(BP_HEAD, BP_CHEST, BP_GROIN, BP_L_ARM, BP_R_ARM,\
		BP_L_HAND, BP_R_HAND, BP_L_LEG, BP_R_LEG, BP_L_FOOT, BP_R_FOOT)
	icon = 'icons/mob/human_races/cyberlimbs/exo.dmi'
	mob_icon = "exo"

	create_organ(var/mob/living/carbon/holder, var/O, var/color)
		var/obj/item/organ/external/E = ..(holder, O, color)
		E.force_icon = icon
		E.model = "exo"
		E.gendered_icon = 0
		E.brute_mod = 0.8
		return E

	get_mob_icon(organ, body_build = "", color="#ffffff", gender = MALE)
		if(organ in list(BP_HEAD, BP_CHEST, BP_GROIN))
			return new/icon(icon, "[organ]_[gender==FEMALE?"f":"m"][body_build]")
		else
			return new/icon(icon, "[organ][body_build]")*/

////Internals////

/datum/body_modification/organ
	allowed_species = list("Human", "Skrell", "Tajara", "Unathi", "Vox")
	create_organ(var/mob/living/carbon/holder, var/organ, var/color)
		if(replace_limb)
			return new replace_limb(holder)
		else
			return new organ(holder)

/datum/body_modification/organ/assisted
	name = "Assisted organ"
	short_name = "P: assisted"
	id = "assisted"
	desc = "Assisted organ."
	body_parts = list(O_HEART, O_LUNGS, O_LIVER, O_EYES)

	create_organ(var/mob/living/carbon/holder, var/O, var/color)
		var/obj/item/organ/I = ..(holder,O,color)
		I.status = ORGAN_ASSISTED
		I.robotic = ORGAN_ASSISTED
		I.min_bruised_damage = 15
		I.min_broken_damage = 35
		return I

/datum/body_modification/organ/robotize_organ
	name = "Robotic organ"
	short_name = "P: prosthesis"
	id = "robotize_organ"
	desc = "Robotic organ."
	body_parts = list(O_HEART, O_LUNGS, O_LIVER, O_EYES)

	create_organ(var/mob/living/carbon/holder, O, color)
		var/obj/item/organ/I = ..(holder,O,color)
		I.status = ORGAN_ROBOT
		if(istype(I, /obj/item/organ/eyes))
			var/obj/item/organ/eyes/E = I
			E.robo_color = iscolor(color) ? color : "#FFFFFF"
		return I

////Eyes////
/*
/datum/body_modification/organ/eyecam
	name = "Eye cam"
	short_name = "P: Eye cam"
	id = "prosthesis_eye_cam"
	desc = "One of your eyes replaced with portable cam. Do not lose it."
	body_parts = list(O_EYES)
	allowed_species = list("Human")

	get_mob_icon(organ, body_build, color, gender, species)
		var/datum/species/S = all_species[species]
		var/icon/I = new/icon(S.icobase, "left_eye_[body_build]")
		I.Blend("#C0C0C0", ICON_ADD)
		return I

	create_organ()
		return new /obj/item/organ/internal/eyes/mechanic/cam(null)
*/

/datum/body_modification/organ/oneeye
	name = "One eye (left)"
	short_name = "M: One eye (l)"
	id = "missed_eye"
	desc = "One of your eyes was missed."
	body_parts = list(O_EYES)
	replace_limb = /obj/item/organ/eyes/oneeye

	get_mob_icon(organ, body_build, color, gender, species)
		world << "[src] icon get [organ] [body_build] [color] [gender] [species]"
		var/datum/species/S = all_species[species]
		var/icon/I = new/icon(S.faceicobase, "eye_l[body_build]")
		I.Blend(color, ICON_ADD)
		return I

	create_organ(var/mob/living/carbon/human/holder, var/organ, var/color)
		var/obj/item/organ/eyes/E = ..(holder,organ,color)
		E.eyes_color = color
		return E

/datum/body_modification/organ/oneeye/right
	name = "One eye (right)"
	short_name = "M: One eye (r)"
	id = "missed_eye_right"
	replace_limb = /obj/item/organ/eyes/oneeye/right

	get_mob_icon(organ, body_build, color, gender, species)
		world << "[src] icon get [organ] [body_build] [color] [gender] [species]"
		var/datum/species/S = all_species[species]
		var/icon/I = new/icon(S.faceicobase, "eye_r[body_build]")
		I.Blend(color, ICON_ADD)
		return I

/datum/body_modification/organ/heterochromia
	name = "Heterochromia"
	short_name = "M: Heterochromia"
	id = "mutation_heterochromia"
	desc = "Special color for left eye."
	body_parts = list(O_EYES)

	get_mob_icon(organ, body_build, color, gender, species)
		world << "[src] icon get [organ] [body_build] [color] [gender] [species]"
		var/datum/species/S = all_species[species]
		var/icon/I = new/icon(S.faceicobase, "eye_l[body_build]")
		I.Blend(color, ICON_ADD)
		return I

	create_organ(var/mob/living/carbon/holder, organ_type, color)
		var/obj/item/organ/eyes/heterohromia/E = new(holder,organ_type,color)
		E.second_color = color
		return E

#undef MODIFICATION_REMOVED
#undef MODIFICATION_ORGANIC
#undef MODIFICATION_SILICON
