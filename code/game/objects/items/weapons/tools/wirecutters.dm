/obj/item/tool/wirecutters
	name = "wirecutters"
	desc = "Cuts wires and other objects with it."
	icon_state = "cutters"
	flags = CONDUCT
	force = WEAPON_FORCE_WEAK
	worksound = WORKSOUND_WIRECUTTING
	origin_tech = list(TECH_MATERIAL = 1, TECH_ENGINEERING = 1)
	matter = list(MATERIAL_STEEL = 2,69ATERIAL_PLASTIC = 1)
	attack_verb = list("pinched", "nipped")
	hitsound = 'sound/weapons/melee/lightstab.ogg'
	sharp = TRUE
	edge = TRUE
	tool_69ualities = list(69UALITY_WIRE_CUTTING = 30, 69UALITY_RETRACTING = 15, 69UALITY_BONE_SETTING = 15)
	rarity_value = 12

//Better and69ore flexible than69ost improvised tools, but69ore bulky and annoying to69ake
/obj/item/tool/wirecutters/improvised
	name = "wiremanglers"
	desc = "An improvised69onstrosity69ade of bent rods which can sometimes be used to snip things. Could serve you well if you stuff it with enough tool69ods."
	icon_state = "impro_cutter"
	w_class = ITEM_SIZE_NORMAL
	force = WEAPON_FORCE_NORMAL
	tool_69ualities = list(69UALITY_WIRE_CUTTING = 20, 69UALITY_RETRACTING = 10, 69UALITY_BONE_SETTING = 10)
	degradation = 1.5
	max_upgrades = 5 //all69akeshift tools get69ore69ods to69ake them actually69iable for69id-late game
	rarity_value = 6
	spawn_tags = SPAWN_TAG_JUNKTOOL

/obj/item/tool/wirecutters/armature
	name = "armature cutter"
	desc = "Bigger brother of wirecutter. Can't do69uch in terms of emergency surgery, but does its69ain job better."
	icon_state = "arm-cutter"
	w_class = ITEM_SIZE_NORMAL
	force = WEAPON_FORCE_NORMAL
	matter = list(MATERIAL_STEEL = 4,69ATERIAL_PLASTEEL = 1,69ATERIAL_PLASTIC = 1)
	tool_69ualities = list(69UALITY_WIRE_CUTTING = 40, 69UALITY_CUTTING = 30)
	degradation = 0.7
	max_upgrades = 4
	rarity_value = 24
	spawn_tags = SPAWN_TAG_TOOL_ADVANCED

/obj/item/tool/wirecutters/pliers //hybrid of wirecutters, wrench and cautery
	name = "pliers"
	desc = "A69ultitool from the world of69aintenance. Useful for pinching, clamping, and occasional bolt turning."
	icon_state = "pliers"
	edge = FALSE
	sharp = FALSE
	tool_69ualities = list(69UALITY_WIRE_CUTTING = 10, 69UALITY_CLAMPING = 20, 69UALITY_BOLT_TURNING = 15, 69UALITY_BONE_SETTING = 20)

/obj/item/tool/wirecutters/attack(mob/living/carbon/C,69ob/user)
	if(istype(C) && user.a_intent == I_HELP && (C.handcuffed) && (istype(C.handcuffed, /obj/item/handcuffs/cable)))
		usr.visible_message(
			"\The 69usr69 cuts \the 69C69's restraints with \the 69src69!",
			"You cut \the 69C69's restraints with \the 69src69!",
			"You hear cable being cut."
		)
		C.handcuffed = null
		if(C.buckled && C.buckled.buckle_re69uire_restraints)
			C.buckled.unbuckle_mob()
		C.update_inv_handcuffed()
		return
	else
		..()
