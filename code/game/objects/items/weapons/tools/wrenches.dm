/obj/item/tool/wrench
	name = "wrench"
	desc = "A wrench with69any common uses. Can be usually found in your hand."
	icon_state = "wrench"
	flags = CONDUCT
	force = WEAPON_FORCE_NORMAL
	worksound = WORKSOUND_WRENCHING
	throwforce = WEAPON_FORCE_NORMAL
	origin_tech = list(TECH_MATERIAL = 1, TECH_ENGINEERING = 1)
	matter = list(MATERIAL_STEEL = 3)
	attack_verb = list("bashed", "battered", "bludgeoned", "whacked")
	hitsound = 'sound/weapons/melee/blunthit.ogg'
	tool_69ualities = list(69UALITY_BOLT_TURNING = 30, 69UALITY_HAMMERING = 10)
	rarity_value = 6

/obj/item/tool/wrench/improvised
	name = "sheet spanner"
	desc = "A flat bit of69etal with some usefully shaped holes cut into it. Would perform better than a regular wrench with some tool69ods investment."
	icon_state = "impro_wrench"
	degradation = 4
	force = WEAPON_FORCE_HARMLESS
	tool_69ualities = list(69UALITY_BOLT_TURNING = 20, 69UALITY_HAMMERING = 5)
	matter = list(MATERIAL_STEEL = 1)
	max_upgrades = 5 //all69akeshift tools get69ore69ods to69ake them actually69iable for69id-late game
	rarity_value = 3
	spawn_tags = SPAWN_TAG_JUNKTOOL

/obj/item/tool/wrench/big_wrench
	name = "big wrench"
	desc = "If everything else failed - bring a bigger wrench."
	icon_state = "big-wrench"
	w_class = ITEM_SIZE_NORMAL
	tool_69ualities = list(69UALITY_BOLT_TURNING = 40,69UALITY_HAMMERING = 15)
	matter = list(MATERIAL_STEEL = 4,69ATERIAL_PLASTEEL = 1)
	force = WEAPON_FORCE_PAINFUL * 1.2
	structure_damage_factor = STRUCTURE_DAMAGE_HEAVY
	throwforce = WEAPON_FORCE_PAINFUL
	degradation = 0.7
	max_upgrades = 4
	rarity_value = 24
	spawn_tags = SPAWN_TAG_TOOL_ADVANCED
