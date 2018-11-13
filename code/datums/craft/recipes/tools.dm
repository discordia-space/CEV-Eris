/datum/craft_recipe/tool
	category = "Tools"
	time = 100


/datum/craft_recipe/tool/webtape
	name = "web tape"
	result = /obj/item/weapon/tool/tape_roll/web
	steps = list(
		list(/obj/item/stack/medical/bruise_pack/handmade, 3, "time" = 50),
		list(/obj/effect/spider/stickyweb, 1, "time" = 30)
	)

//A shard of glass wrapped in tape makes a crude sort of knife
/datum/craft_recipe/tool/shiv
	name = "shiv"
	result = /obj/item/weapon/tool/shiv
	steps = list(
		list(/obj/item/weapon/material/shard, 1, "time" = 30),
		list(QUALITY_ADHESIVE, 15, 70)
	)

//A rod wrapped in tape makes a crude screwthing
/datum/craft_recipe/tool/screwpusher
	name = "screwpusher"
	result = /obj/item/weapon/tool/screwdriver/improvised
	steps = list(
		list(/obj/item/stack/rods, 1, "time" = 30),
		list(QUALITY_ADHESIVE, 15, 70)
	)

//Rods bent into wierd shapes and held together with a screw
/datum/craft_recipe/tool/wiremanglers
	name = "wiremanglers"
	result = /obj/item/weapon/tool/wirecutters/improvised
	steps = list(
		list(/obj/item/stack/rods, 1, "time" = 30),
		list(QUALITY_PRYING, 10, 70),
		list(/obj/item/stack/rods, 1, "time" = 30),
		list(QUALITY_PRYING, 10, 70),
		list(QUALITY_SCREW_DRIVING, 10, 70),
	)


//A pair of rods laboriously twisted into a useful shape
/datum/craft_recipe/tool/rebar
	name = "rebar"
	result = /obj/item/weapon/tool/crowbar/improvised
	steps = list(
		list(/obj/item/stack/rods, 2, "time" = 300)
	)


//A metal sheet with some holes cut in it
/datum/craft_recipe/tool/sheetspanner
	name = "sheet spanner"
	result = /obj/item/weapon/tool/wrench/improvised
	steps = list(
		list(CRAFT_MATERIAL, 1, MATERIAL_STEEL),
		list(QUALITY_SAWING, 10, 70)
	)


//A rod and a sheet bound together with ducks
/datum/craft_recipe/tool/junkshovel
	name = "junk shovel"
	result = /obj/item/weapon/tool/shovel/improvised
	steps = list(
		list(CRAFT_MATERIAL, 1, MATERIAL_STEEL),
		list(/obj/item/stack/rods, 1, 30),
		list(QUALITY_ADHESIVE, 15, 150)
	)


//A rod with bits of pointy shrapnel stuck to it. Good weapon
/datum/craft_recipe/tool/choppa
	name = "choppa"
	result = /obj/item/weapon/tool/saw/improvised
	steps = list(
		list(/obj/item/stack/rods, 1, 30),
		list(/obj/item/weapon/material/shard/shrapnel, 1, "time" = 30),
		list(/obj/item/weapon/material/shard/shrapnel, 1, "time" = 30),
		list(QUALITY_ADHESIVE, 15, 150)
	)

//Some pipes duct taped together, attached to a tank and an igniter
/datum/craft_recipe/tool/jurytorch
	name = "jury-rigged torch"
	result = /obj/item/weapon/tool/weldingtool/improvised
	steps = list(
		list(/obj/item/pipe, 1, "time" = 60),
		list(/obj/item/pipe, 1, "time" = 60),
		list(QUALITY_ADHESIVE, 15, 150),
		list(/obj/item/device/assembly/igniter, 1),
		list(/obj/item/weapon/tank/emergency_oxygen, 1)
	)