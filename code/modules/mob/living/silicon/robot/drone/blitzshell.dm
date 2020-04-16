/mob/living/silicon/robot/drone/blitzshell
	icon_state = "blitzshell"
	law_type = /datum/ai_laws/blitzshell
	module_type = /obj/item/weapon/robot_module/drone/blitzshell
	hat_x_offset = 1
	hat_y_offset = -12
	can_pull_size = ITEM_SIZE_HUGE
	can_pull_mobs = MOB_PULL_SAME

/mob/living/silicon/robot/drone/blitzshell/updatename()
	real_name = "\"Blitzshell\" assault drone ([rand(100,999)])"
	name = real_name

/mob/living/silicon/robot/drone/blitzshell/is_allowed_vent_crawl_item()
	return TRUE

/mob/living/silicon/robot/drone/blitzshell/New()
	..()
	verbs |= /mob/living/proc/ventcrawl


/obj/item/weapon/robot_module/drone/blitzshell
	networks = list()

/obj/item/weapon/robot_module/drone/blitzshell/New()
	modules += new /obj/item/weapon/gun/energy/laser/mounted/blitz(src)
	modules += new /obj/item/weapon/gun/energy/plasma/mounted/blitz(src)
	modules += new /obj/item/weapon/storage/bsdm/permanent(src)