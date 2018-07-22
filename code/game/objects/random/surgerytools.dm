/obj/random/surgery_tool
	name = "random surgery tool"
	icon_state = "meds-blue"

/obj/random/surgery_tool/item_to_spawn()
	return pick(/obj/item/weapon/tool/bonesetter,\
				/obj/item/weapon/tool/scalpel,\
				/obj/item/weapon/tool/scalpel/advanced,\
				/obj/item/weapon/tool/scalpel/laser,\
				/obj/item/weapon/tool/surgicaldrill,\
				/obj/item/weapon/tool/cautery,\
				/obj/item/weapon/tool/retractor,\
				/obj/item/weapon/tool/saw/circular,\
				/obj/item/weapon/tool/hemostat)

/obj/random/surgery_tool/low_chance
	name = "low chance random surgery tool"
	icon_state = "meds-blue-low"
	spawn_nothing_percentage = 60
