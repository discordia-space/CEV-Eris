/obj/item/tool/wrench
	name = "wrench"
	desc = "A wrench with many common uses. Can be usually found in your hand."
	icon_state = "wrench"
	flags = CONDUCT
	melleDamages = list(ARMOR_BLUNT = list(DELEM(BRUTE,12)))
	wieldedMultiplier = 2
	attackDelay = 2
	WieldedattackDelay = 6
	worksound = WORKSOUND_WRENCHING
	throwforce = WEAPON_FORCE_NORMAL
	origin_tech = list(TECH_MATERIAL = 1, TECH_ENGINEERING = 1)
	matter = list(MATERIAL_STEEL = 3)
	attack_verb = list("bashed", "battered", "bludgeoned", "whacked")
	hitsound = 'sound/weapons/melee/blunthit.ogg'
	tool_qualities = list(QUALITY_BOLT_TURNING = 30, QUALITY_HAMMERING = 10)
	rarity_value = 6

/obj/item/tool/wrench/improvised
	name = "sheet spanner"
	desc = "A flat bit of metal with some usefully shaped holes cut into it. Would perform better than a regular wrench with some tool mods investment."
	icon_state = "impro_wrench"
	degradation = 4
	tool_qualities = list(QUALITY_BOLT_TURNING = 20, QUALITY_HAMMERING = 5)
	matter = list(MATERIAL_STEEL = 1)
	maxUpgrades = 5 //all makeshift tools get more mods to make them actually viable for mid-late game
	rarity_value = 3
	spawn_tags = SPAWN_TAG_JUNKTOOL

/obj/item/tool/wrench/big_wrench
	name = "big wrench"
	desc = "If everything else failed - bring a bigger wrench."
	icon_state = "big-wrench"
	volumeClass = ITEM_SIZE_NORMAL
	tool_qualities = list(QUALITY_BOLT_TURNING = 40,QUALITY_HAMMERING = 15)
	matter = list(MATERIAL_STEEL = 4, MATERIAL_PLASTEEL = 1)
	melleDamages = list(ARMOR_BLUNT = list(DELEM(BRUTE,20)))
	wieldedMultiplier = 4
	/// big hit , big delay
	WieldedattackDelay = 23
	armor_divisor = 1.2
	structure_damage_factor = STRUCTURE_DAMAGE_HEAVY
	throwforce = WEAPON_FORCE_PAINFUL
	degradation = 0.7
	maxUpgrades = 4
	rarity_value = 24
	spawn_tags = SPAWN_TAG_TOOL_ADVANCED
