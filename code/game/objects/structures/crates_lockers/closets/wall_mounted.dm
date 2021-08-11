/obj/structure/closet/wall_mounted
	name = "wall locker"
	desc = "A wall mounted storage locker."
	icon = 'icons/obj/wall_mounted.dmi'
	icon_state = "wall-locker"
	anchored = TRUE
	wall_mounted = TRUE //This handles density in closets.dm


/obj/structure/closet/wall_mounted/emcloset
	name = "emergency locker"
	desc = "A wall mounted locker with emergency supplies."
	icon_state = "emerg"

/obj/structure/closet/wall_mounted/emcloset/populate_contents()
	new /obj/item/tank/emergency_oxygen(src)
	new /obj/item/clothing/mask/breath(src)
	new /obj/item/tank/emergency_oxygen(src)
	new /obj/item/clothing/mask/breath(src)
	new /obj/item/tool/crowbar(src)
	if(prob(10))
		switch(pick(list("liquor" = 35, "drugs" = 30, "guns" = 20, "data" = 15)))
			if("liquor")
				new /obj/spawner/booze(src)
				new /obj/spawner/booze(src)
				new /obj/item/tool/broken_bottle(src)
				new /obj/item/storage/fancy/cigarettes/dromedaryco(src)
			if("drugs")
				new /obj/item/reagent_containers/syringe/drugs_recreational(src)
				new /obj/item/reagent_containers/syringe/drugs_recreational(src)
				new /obj/item/reagent_containers/hypospray/autoinjector/hyperzine(src)
			if("guns")
				new /obj/spawner/gun/cheap(src)
				new /obj/spawner/gun_parts(src)
				new /obj/spawner/ammo/lowcost(src)
			if("data")
				new /obj/spawner/credits/c1000(src)
				new /obj/spawner/credits/c500(src)
				new /obj/spawner/lathe_disk(src)
				new /obj/spawner/lathe_disk(src)

/obj/structure/closet/wall_mounted/emcloset/escape_pods
	icon_state = "emerg-escape"


/obj/structure/closet/wall_mounted/firecloset
	name = "fire-safety closet"
	desc = "It's a storage unit for fire-fighting supplies."
	icon_state = "hydrant"

/obj/structure/closet/wall_mounted/firecloset/populate_contents()
	new /obj/item/inflatable/door(src)
	new /obj/item/inflatable/door(src)
	new /obj/item/stack/medical/advanced/ointment(src)
	new /obj/item/stack/medical/advanced/ointment(src)
	new /obj/item/clothing/head/hardhat/red(src)
	new /obj/item/clothing/mask/gas(src)
	new /obj/item/clothing/gloves/thick(src)
	new /obj/item/clothing/suit/fire(src)
	new /obj/item/tank/oxygen/red(src)
	new /obj/item/extinguisher(src)
	new /obj/item/extinguisher(src)
	if(prob(10))
		switch(pick(list("liquor" = 35, "drugs" = 30, "guns" = 20, "data" = 15)))
			if("liquor")
				new /obj/spawner/booze(src)
				new /obj/spawner/booze(src)
				new /obj/item/tool/broken_bottle(src)
				new /obj/item/storage/fancy/cigarettes/dromedaryco(src)
			if("drugs")
				new /obj/item/reagent_containers/syringe/drugs_recreational(src)
				new /obj/item/reagent_containers/syringe/drugs_recreational(src)
				new /obj/item/reagent_containers/hypospray/autoinjector/hyperzine(src)
			if("guns")
				new /obj/spawner/gun/cheap(src)
				new /obj/spawner/gun_parts(src)
				new /obj/spawner/ammo/lowcost(src)
			if("data")
				new /obj/spawner/credits/c1000(src)
				new /obj/spawner/credits/c500(src)
				new /obj/spawner/lathe_disk(src)
				new /obj/spawner/lathe_disk(src)
