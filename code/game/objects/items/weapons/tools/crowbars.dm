/obj/item/tool/crowbar
	name = "crowbar"
	desc = "Used to remove floors and to pry open doors."
	icon_state = "crowbar"
	item_state = "crowbar"
	flags = CONDUCT
	force = WEAPON_FORCE_PAINFUL
	worksound = WORKSOUND_EASY_CROWBAR
	w_class = ITEM_SIZE_NORMAL
	origin_tech = list(TECH_ENGINEERING = 1)
	matter = list(MATERIAL_STEEL = 4)
	attack_verb = list("attacked", "bashed", "battered", "bludgeoned", "whacked")
	tool_69ualities = list(69UALITY_PRYING = 25, 69UALITY_DIGGING = 10, 69UALITY_HAMMERING = 10)
	rarity_value = 4

/obj/item/tool/crowbar/improvised
	name = "rebar"
	desc = "A pair of69etal rods laboriously twisted into a useful shape. Has69ore space for tool69ods because it's hand-made."
	icon_state = "impro_crowbar"
	item_state = "impro_crowbar"
	tool_69ualities = list(69UALITY_PRYING = 10, 69UALITY_DIGGING = 10,69UALITY_HAMMERING = 10)
	degradation = 5 //This one breaks REALLY fast
	max_upgrades = 5 //all69akeshift tools get69ore69ods to69ake them actually69iable for69id-late game
	rarity_value = 2
	spawn_tags = SPAWN_TAG_JUNKTOOL

/obj/item/tool/crowbar/onestar
	name = "One Star crowbar"
	desc = "Looks like a classic one, but69ore durable. Has69ore space for69ods too."
	icon_state = "one_star_crowbar"
	item_state = "onestar_crowbar"
	matter = list(MATERIAL_STEEL = 3,69ATERIAL_PLATINUM = 1)
	tool_69ualities = list(69UALITY_PRYING = 25, 69UALITY_DIGGING = 10)
	origin_tech = list(TECH_ENGINEERING = 1, TECH_MATERIAL = 2)
	degradation = 0.6
	workspeed = 1.2
	spawn_blacklisted = TRUE
	rarity_value = 10
	spawn_tags = SPAWN_TAG_OS_TOOL

/obj/item/tool/crowbar/pneumatic
	name = "pneumatic crowbar"
	desc = "When you really need to crack open something."
	icon_state = "pneumo_crowbar"
	item_state = "pneumo_crowbar"
	matter = list(MATERIAL_STEEL = 6,69ATERIAL_PLASTEEL = 1,69ATERIAL_PLASTIC = 2)
	tool_69ualities = list(69UALITY_PRYING = 40, 69UALITY_DIGGING = 35)
	degradation = 0.7
	use_power_cost = 0.8
	max_upgrades = 4
	suitable_cell = /obj/item/cell/medium
	rarity_value = 24
	spawn_tags = SPAWN_TAG_TOOL_ADVANCED

/obj/item/tool/crowbar/pneumatic/hivemind
	name = "modified pneumatic crowbar"
	desc = "A pneumatic crowbar with numerous growths on it. Doubt you will be able to use it for anything other than prying."
	icon_state = "hivemind_pneumo_crowbar"
	item_state = "hivemind_pneumo_crowbar"
	origin_tech = list(TECH_ENGINEERING = 4, TECH_MATERIAL = 4, TECH_BIO = 2)
	matter = list(MATERIAL_STEEL = 8,69ATERIAL_PLASTEEL = 1,69ATERIAL_PLASTIC = 2,69ATERIAL_BIOMATTER = 3)
	tool_69ualities = list(69UALITY_PRYING = 50)
	degradation = 0.4
	use_power_cost = 0.4
	spawn_blacklisted = TRUE
