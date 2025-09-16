/obj/structure/table/standard
	icon_state = "plain_preview"
	color = "#EEEEEE"

/obj/structure/table/standard/New()
	material = get_material_by_name(MATERIAL_PLASTIC)
	..()

/obj/structure/table/steel
	icon_state = "plain_preview"
	color = "#666666"

/obj/structure/table/steel/New()
	material = get_material_by_name(MATERIAL_STEEL)
	..()

/obj/structure/table/marble
	icon_state = "stone_preview"
	color = "#CCCCCC"

/obj/structure/table/marble/New()
	material = get_material_by_name(MATERIAL_MARBLE)
	..()

/obj/structure/table/reinforced
	icon_state = "reinf_preview"
	color = "#EEEEEE"

/obj/structure/table/reinforced/New()
	material = get_material_by_name(MATERIAL_PLASTIC)
	reinforced = get_material_by_name(MATERIAL_STEEL)
	..()

/obj/structure/table/steel_reinforced
	icon_state = "reinf_preview"
	color = "#666666"

/obj/structure/table/steel_reinforced/New()
	material = get_material_by_name(MATERIAL_STEEL)
	reinforced = get_material_by_name(MATERIAL_STEEL)
	..()

/obj/structure/table/holosteel_reinforced
	icon_state = "holo_preview"
	color = "#666666"

/obj/structure/table/holosteel_reinforced/New()
	material = get_material_by_name("holo[MATERIAL_STEEL]")
	reinforced = get_material_by_name("holo[MATERIAL_STEEL]")
	..()

/obj/structure/table/woodentable
	icon_state = "plain_preview"
	color = "#824B28"

/obj/structure/table/woodentable/New()
	material = get_material_by_name(MATERIAL_WOOD)
	..()

/obj/structure/table/gamblingtable
	icon_state = "gamble_preview"

/obj/structure/table/gamblingtable/New()
	material = get_material_by_name(MATERIAL_WOOD)
	custom_appearance = custom_table_appearance["Gambling"] // gambling carpet
	..()

/obj/structure/table/glass
	icon_state = "plain_preview"
	color = "#00E1FF"
	alpha = 77 // 0.3 * 255

/obj/structure/table/glass/New()
	material = get_material_by_name(MATERIAL_GLASS)
	..()

/obj/structure/table/plasmaglass
	icon_state = "plain_preview"
	color = "#FC2BC5"
	alpha = 77 // 0.3 * 255

/obj/structure/table/plasmaglass/New()
	material = get_material_by_name(MATERIAL_PLASMAGLASS)
	..()

/obj/structure/table/holotable
	icon_state = "holo_preview"
	color = "#EEEEEE"

/obj/structure/table/holotable/New()
	material = get_material_by_name("holo[MATERIAL_PLASTIC]")
	..()

/obj/structure/table/holo_woodentable
	icon_state = "holo_preview"

/obj/structure/table/holo_woodentable/New()
	material = get_material_by_name("holowood")
	..()

/obj/structure/table/bar_special
	icon_state = "bar_table_preview"

/obj/structure/table/bar_special/New()
	material = get_material_by_name(MATERIAL_STEEL)
	custom_appearance = custom_table_appearance["Bar - special"] // bar table
	reinforced = get_material_by_name(MATERIAL_STEEL)
	..()

/obj/structure/table/holobar_special
	icon_state = "bar_table_preview"

/obj/structure/table/holobar_special/New()
	material = get_material_by_name("holo[MATERIAL_STEEL]")
	custom_appearance = custom_table_appearance["Bar - special"] //bar table
	reinforced = get_material_by_name("holo[MATERIAL_STEEL]")
	..()

/obj/structure/table/onestar
	icon_state = "onestar_preview"

/obj/structure/table/onestar/New()
	material = get_material_by_name(MATERIAL_STEEL)
	custom_appearance = custom_table_appearance["OneStar"] //one star table
	reinforced = get_material_by_name(MATERIAL_STEEL)
	name = "one star table"
	..()
