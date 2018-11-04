/datum/craft_recipe/tool
	category = "Tools"
	time = 100


/datum/craft_recipe/tool/webtape
	name = "web tape"
	result = /obj/item/weapon/tool/tape_roll/web
	steps = list(
		list(/obj/item/stack/medical/bruise_pack/handmade, 3, "time" = 50),
		list(/obj/effect/spider/stickyweb, 1, time = 30)
	)