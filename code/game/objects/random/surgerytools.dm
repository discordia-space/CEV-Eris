/obj/random/surgery_tool
	name = "random surgery tool"
	icon_state = "meds-blue"
	
/obj/random/surgery_tool/item_to_spawn()
	return pick(/obj/item/weapon/bonegel,\
				/obj/item/weapon/FixOVein,\
				/obj/item/weapon/bonesetter,\
				/obj/item/weapon/scalpel,\
				/obj/item/weapon/surgicaldrill,\
				/obj/item/weapon/cautery,\
				/obj/item/weapon/retractor,\
				/obj/item/weapon/circular_saw,\
				/obj/item/weapon/hemostat)

/obj/random/surgery_tool/low_chance
	name = "low chance random surgery tool"
	icon_state = "meds-blue-low"
	spawn_nothing_percentage = 60
