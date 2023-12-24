/obj/structure/closet/wardrobe
	name = "wardrobe"
	desc = "A storage unit for standard-issue attire."
	icon_state = "generic"
	spawn_blacklisted = TRUE
	spawn_tags = SPAWN_TAG_WARDROBE

/obj/structure/closet/wardrobe/color
	bad_type = /obj/structure/closet/wardrobe/color
	spawn_blacklisted = FALSE

/obj/structure/closet/wardrobe/color/pink
	name = "pink wardrobe"
	icon_door = "pink"

/obj/structure/closet/wardrobe/color/pink/populate_contents()
	var/list/spawnedAtoms = list()

	spawnedAtoms.Add(new /obj/item/clothing/under/color/pink(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/clothing/under/color/pink(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/clothing/under/color/pink(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/clothing/shoes/color/brown(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/clothing/shoes/color/brown(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/clothing/shoes/color/brown(NULLSPACE))
	for(var/atom/movable/a in spawnedAtoms)
		a.forceMove(src)

/obj/structure/closet/wardrobe/color/black
	name = "black wardrobe"
	icon_door = "black"

/obj/structure/closet/wardrobe/color/black/populate_contents()
	var/list/spawnedAtoms = list()

	spawnedAtoms.Add(new /obj/item/clothing/under/color/black(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/clothing/under/color/black(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/clothing/under/color/black(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/clothing/shoes/color/black(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/clothing/shoes/color/black(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/clothing/shoes/color/black(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/clothing/head/that(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/clothing/head/that(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/clothing/head/that(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/clothing/mask/bandana(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/clothing/mask/bandana(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/clothing/mask/bandana/skull(NULLSPACE))
	for(var/atom/movable/a in spawnedAtoms)
		a.forceMove(src)


/obj/structure/closet/wardrobe/color/green
	name = "green wardrobe"
	icon_door = "green"

/obj/structure/closet/wardrobe/color/green/populate_contents()
	var/list/spawnedAtoms = list()

	spawnedAtoms.Add(new /obj/item/clothing/under/color/green(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/clothing/under/color/green(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/clothing/under/color/green(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/clothing/shoes/color/black(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/clothing/shoes/color/black(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/clothing/shoes/color/black(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/clothing/mask/bandana/green(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/clothing/mask/bandana/green(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/clothing/mask/bandana/green(NULLSPACE))
	for(var/atom/movable/a in spawnedAtoms)
		a.forceMove(src)

/obj/structure/closet/wardrobe/color/orange
	name = "prison wardrobe"
	desc = "A storage unit for regulation prisoner attire."
	icon_door = "orange"

/obj/structure/closet/wardrobe/color/orange/populate_contents()
	var/list/spawnedAtoms = list()

	spawnedAtoms.Add(new /obj/item/clothing/under/color/orange(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/clothing/under/color/orange(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/clothing/under/color/orange(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/clothing/shoes/color/orange(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/clothing/shoes/color/orange(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/clothing/shoes/color/orange(NULLSPACE))
	for(var/atom/movable/a in spawnedAtoms)
		a.forceMove(src)

/obj/structure/closet/wardrobe/color/yellow
	name = "yellow wardrobe"
	icon_door = "yellow"

/obj/structure/closet/wardrobe/color/yellow/populate_contents()
	var/list/spawnedAtoms = list()

	spawnedAtoms.Add(new /obj/item/clothing/under/color/yellow(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/clothing/under/color/yellow(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/clothing/under/color/yellow(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/clothing/shoes/color/orange(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/clothing/shoes/color/orange(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/clothing/shoes/color/orange(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/clothing/mask/bandana/orange(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/clothing/mask/bandana/orange(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/clothing/mask/bandana/orange(NULLSPACE))
	for(var/atom/movable/a in spawnedAtoms)
		a.forceMove(src)


/obj/structure/closet/wardrobe/color/white
	name = "white wardrobe"
	icon_door = "white"

/obj/structure/closet/wardrobe/color/white/populate_contents()
	var/list/spawnedAtoms = list()

	spawnedAtoms.Add(new /obj/item/clothing/under/color/white(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/clothing/under/color/white(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/clothing/under/color/white(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/clothing/shoes/color/white(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/clothing/shoes/color/white(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/clothing/shoes/color/white(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/storage/backpack/sport/white(NULLSPACE))
	for(var/atom/movable/a in spawnedAtoms)
		a.forceMove(src)

/obj/structure/closet/wardrobe/color/grey
	name = "grey wardrobe"
	icon_door = "grey"

/obj/structure/closet/wardrobe/color/grey/populate_contents()
	var/list/spawnedAtoms = list()

	spawnedAtoms.Add(new /obj/item/clothing/under/color/grey(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/clothing/under/color/grey(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/clothing/under/color/grey(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/clothing/shoes/color/black(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/clothing/shoes/color/black(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/clothing/shoes/color/black(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/clothing/head/soft/grey(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/clothing/head/soft/grey(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/clothing/head/soft/grey(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/storage/backpack/sport(NULLSPACE))
	for(var/atom/movable/a in spawnedAtoms)
		a.forceMove(src)

/obj/structure/closet/wardrobe/color/mixed
	name = "mixed wardrobe"
	icon_door = "mixed"

/obj/structure/closet/wardrobe/color/mixed/populate_contents()
	var/list/spawnedAtoms = list()

	spawnedAtoms.Add(new /obj/item/clothing/under/color/blue(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/clothing/under/color/yellow(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/clothing/under/color/green(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/clothing/under/color/orange(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/clothing/under/color/pink(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/clothing/shoes/color/blue(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/clothing/shoes/color/yellow(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/clothing/shoes/color/green(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/clothing/shoes/color/orange(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/clothing/shoes/color/purple(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/clothing/shoes/color/red(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/clothing/shoes/leather(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/clothing/mask/bandana/orange(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/clothing/mask/bandana/blue(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/clothing/mask/bandana/red(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/clothing/mask/bandana/green(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/clothing/mask/bandana/gold(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/clothing/mask/bandana/purple(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/clothing/mask/bandana/camo(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/storage/backpack/sport/purple(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/storage/backpack/sport/green(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/storage/backpack/sport/blue(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/storage/backpack/sport/orange(NULLSPACE))

	for(var/atom/movable/a in spawnedAtoms)
		a.forceMove(src)

/obj/structure/closet/wardrobe/pjs
	name = "pajama wardrobe"
	icon_door = "white"
	spawn_blacklisted = FALSE

/obj/structure/closet/wardrobe/pjs/populate_contents()
	var/list/spawnedAtoms = list()

	spawnedAtoms.Add(new /obj/item/clothing/under/pj/red(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/clothing/under/pj/red(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/clothing/under/pj/blue(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/clothing/under/pj/blue(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/clothing/shoes/color/white(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/clothing/shoes/color/white(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/clothing/shoes/slippers(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/clothing/shoes/slippers(NULLSPACE))

	for(var/atom/movable/a in spawnedAtoms)
		a.forceMove(src)

/obj/structure/closet/wardrobe/tactical
	name = "tactical equipment"
	icon_door = "black"

/obj/structure/closet/wardrobe/tactical/populate_contents()
	var/list/spawnedAtoms = list()

	spawnedAtoms.Add(new /obj/item/clothing/under/syndicate(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/clothing/suit/armor/heavy(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/clothing/mask/balaclava/tactical(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/clothing/glasses/sunglasses/sechud/tactical(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/storage/belt/tactical(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/clothing/shoes/jackboots(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/clothing/gloves/thick(NULLSPACE))

	for(var/atom/movable/a in spawnedAtoms)
		a.forceMove(src)

/obj/structure/closet/wardrobe/sec
	name = "security wardrobe"
	icon_door = "blue"

/obj/structure/closet/wardrobe/sec/populate_contents()

	var/list/spawnedAtoms = list()

	spawnedAtoms.Add(new /obj/item/clothing/under/rank/security(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/clothing/under/rank/security(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/clothing/under/rank/security(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/clothing/shoes/jackboots/ironhammer(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/clothing/shoes/jackboots/ironhammer(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/clothing/shoes/jackboots/ironhammer(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/clothing/head/beret/sec/navy/officer(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/clothing/head/beret/sec/navy/officer(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/clothing/head/beret/sec/navy/officer(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/clothing/gloves/security/ironhammer(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/clothing/gloves/security/ironhammer(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/clothing/gloves/security/ironhammer(NULLSPACE))

	for(var/atom/movable/a in spawnedAtoms)
		a.forceMove(src)

/obj/structure/closet/wardrobe/science_white
	name = "science wardrobe"
	icon_door = "mixed"
	spawn_blacklisted = TRUE

/obj/structure/closet/wardrobe/science_white/populate_contents()
	var/list/spawnedAtoms = list()

	spawnedAtoms.Add(new /obj/item/clothing/under/rank/scientist(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/clothing/under/rank/scientist(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/clothing/under/rank/scientist(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/clothing/suit/storage/toggle/labcoat(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/clothing/suit/storage/toggle/labcoat(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/clothing/suit/storage/toggle/labcoat(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/clothing/shoes/color/white(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/clothing/shoes/color/white(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/clothing/shoes/color/white(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/clothing/shoes/slippers(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/clothing/shoes/slippers(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/clothing/shoes/slippers(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/clothing/glasses/regular/goggles/clear(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/clothing/glasses/regular/goggles/clear(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/clothing/glasses/regular/goggles/clear(NULLSPACE))
	for(var/atom/movable/a in spawnedAtoms)
		a.forceMove(src)

/obj/structure/closet/wardrobe/robotics_black
	name = "robotics wardrobe"
	icon_door = "black"

/obj/structure/closet/wardrobe/robotics_black/populate_contents()
	var/list/spawnedAtoms = list()

	spawnedAtoms.Add(new /obj/item/clothing/under/rank/roboticist(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/clothing/under/rank/roboticist(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/clothing/suit/storage/robotech_jacket(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/clothing/suit/storage/robotech_jacket(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/clothing/shoes/color/black(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/clothing/shoes/color/black(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/clothing/gloves/thick(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/clothing/gloves/thick(NULLSPACE))
	for(var/atom/movable/a in spawnedAtoms)
		a.forceMove(src)

/obj/structure/closet/wardrobe/chemistry_white
	name = "chemistry wardrobe"
	icon_door = "white"

/obj/structure/closet/wardrobe/chemistry_white/populate_contents()
	var/list/spawnedAtoms = list()

	spawnedAtoms.Add(new /obj/item/clothing/under/rank/chemist(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/clothing/under/rank/chemist(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/clothing/shoes/color/white(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/clothing/shoes/color/white(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/clothing/suit/storage/toggle/labcoat/chemist(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/clothing/suit/storage/toggle/labcoat/chemist(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/clothing/glasses/regular/goggles/clear(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/clothing/glasses/regular/goggles/clear(NULLSPACE))
	for(var/atom/movable/a in spawnedAtoms)
		a.forceMove(src)

/obj/structure/closet/wardrobe/virology_white
	name = "virology wardrobe"
	icon_door = "white"

/obj/structure/closet/wardrobe/virology_white/populate_contents()
	var/list/spawnedAtoms = list()

	spawnedAtoms.Add(new /obj/item/clothing/under/rank/virologist(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/clothing/under/rank/virologist(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/clothing/shoes/color/white(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/clothing/shoes/color/white(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/clothing/suit/storage/toggle/labcoat/virologist(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/clothing/suit/storage/toggle/labcoat/virologist(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/clothing/mask/surgical(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/clothing/mask/surgical(NULLSPACE))
	for(var/atom/movable/a in spawnedAtoms)
		a.forceMove(src)

/obj/structure/closet/wardrobe/medic_white
	name = "medical wardrobe"
	icon_door = "white"

/obj/structure/closet/wardrobe/medic_white/populate_contents()
	var/list/spawnedAtoms = list()

	spawnedAtoms.Add(new /obj/item/clothing/under/rank/medical(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/clothing/under/rank/medical(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/clothing/under/rank/medical/green(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/clothing/shoes/color/white(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/clothing/shoes/color/white(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/clothing/shoes/reinforced(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/clothing/shoes/reinforced(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/clothing/suit/storage/toggle/labcoat(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/clothing/suit/storage/toggle/labcoat(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/clothing/mask/surgical(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/clothing/mask/surgical(NULLSPACE))
	for(var/atom/movable/a in spawnedAtoms)
		a.forceMove(src)

/obj/structure/closet/wardrobe/chaplain_black
	name = "chapel wardrobe"
	desc = "A storage unit for approved religious attire."
	icon_door = "black"

/obj/structure/closet/wardrobe/chaplain_black/populate_contents()
	var/list/spawnedAtoms = list()

	spawnedAtoms.Add(new /obj/item/clothing/under/color/black(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/clothing/shoes/color/black(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/clothing/suit/nun(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/clothing/head/nun_hood(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/clothing/suit/storage/neotheology_jacket(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/clothing/head/chaplain_hood(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/clothing/under/bride_white(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/storage/fancy/candle_box(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/storage/fancy/candle_box(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/deck/tarot(NULLSPACE))
	for(var/atom/movable/a in spawnedAtoms)
		a.forceMove(src)

/obj/structure/closet/wardrobe/engineering_yellow
	name = "engineering wardrobe"
	icon_door = "yellow"

/obj/structure/closet/wardrobe/engineering_yellow/populate_contents()
	var/list/spawnedAtoms = list()

	spawnedAtoms.Add(new /obj/item/clothing/under/rank/engineer(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/clothing/under/rank/engineer(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/clothing/under/rank/engineer(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/clothing/shoes/jackboots(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/clothing/shoes/jackboots(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/clothing/shoes/jackboots(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/clothing/head/hardhat(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/clothing/head/hardhat(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/clothing/head/hardhat(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/clothing/head/beret/engineering(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/clothing/head/beret/engineering(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/clothing/head/beret/engineering(NULLSPACE))
	for(var/atom/movable/a in spawnedAtoms)
		a.forceMove(src)
