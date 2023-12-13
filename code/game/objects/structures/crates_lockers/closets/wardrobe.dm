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

	spawnedAtoms.Add(new /obj/item/clothing/under/color/pink(NULL))
	spawnedAtoms.Add(new /obj/item/clothing/under/color/pink(NULL))
	spawnedAtoms.Add(new /obj/item/clothing/under/color/pink(NULL))
	spawnedAtoms.Add(new /obj/item/clothing/shoes/color/brown(NULL))
	spawnedAtoms.Add(new /obj/item/clothing/shoes/color/brown(NULL))
	spawnedAtoms.Add(new /obj/item/clothing/shoes/color/brown(NULL))
	for(var/atom/a in spawnedAtoms)
		a.forcemove(src)

/obj/structure/closet/wardrobe/color/black
	name = "black wardrobe"
	icon_door = "black"

/obj/structure/closet/wardrobe/color/black/populate_contents()
	var/list/spawnedAtoms = list()

	spawnedAtoms.Add(new /obj/item/clothing/under/color/black(NULL))
	spawnedAtoms.Add(new /obj/item/clothing/under/color/black(NULL))
	spawnedAtoms.Add(new /obj/item/clothing/under/color/black(NULL))
	spawnedAtoms.Add(new /obj/item/clothing/shoes/color/black(NULL))
	spawnedAtoms.Add(new /obj/item/clothing/shoes/color/black(NULL))
	spawnedAtoms.Add(new /obj/item/clothing/shoes/color/black(NULL))
	spawnedAtoms.Add(new /obj/item/clothing/head/that(NULL))
	spawnedAtoms.Add(new /obj/item/clothing/head/that(NULL))
	spawnedAtoms.Add(new /obj/item/clothing/head/that(NULL))
	spawnedAtoms.Add(new /obj/item/clothing/mask/bandana(NULL))
	spawnedAtoms.Add(new /obj/item/clothing/mask/bandana(NULL))
	spawnedAtoms.Add(new /obj/item/clothing/mask/bandana/skull(NULL))
	for(var/atom/a in spawnedAtoms)
		a.forcemove(src)


/obj/structure/closet/wardrobe/color/green
	name = "green wardrobe"
	icon_door = "green"

/obj/structure/closet/wardrobe/color/green/populate_contents()
	var/list/spawnedAtoms = list()

	spawnedAtoms.Add(new /obj/item/clothing/under/color/green(NULL))
	spawnedAtoms.Add(new /obj/item/clothing/under/color/green(NULL))
	spawnedAtoms.Add(new /obj/item/clothing/under/color/green(NULL))
	spawnedAtoms.Add(new /obj/item/clothing/shoes/color/black(NULL))
	spawnedAtoms.Add(new /obj/item/clothing/shoes/color/black(NULL))
	spawnedAtoms.Add(new /obj/item/clothing/shoes/color/black(NULL))
	spawnedAtoms.Add(new /obj/item/clothing/mask/bandana/green(NULL))
	spawnedAtoms.Add(new /obj/item/clothing/mask/bandana/green(NULL))
	spawnedAtoms.Add(new /obj/item/clothing/mask/bandana/green(NULL))
	for(var/atom/a in spawnedAtoms)
		a.forcemove(src)

/obj/structure/closet/wardrobe/color/orange
	name = "prison wardrobe"
	desc = "A storage unit for regulation prisoner attire."
	icon_door = "orange"

/obj/structure/closet/wardrobe/color/orange/populate_contents()
	var/list/spawnedAtoms = list()

	spawnedAtoms.Add(new /obj/item/clothing/under/color/orange(NULL))
	spawnedAtoms.Add(new /obj/item/clothing/under/color/orange(NULL))
	spawnedAtoms.Add(new /obj/item/clothing/under/color/orange(NULL))
	spawnedAtoms.Add(new /obj/item/clothing/shoes/color/orange(NULL))
	spawnedAtoms.Add(new /obj/item/clothing/shoes/color/orange(NULL))
	spawnedAtoms.Add(new /obj/item/clothing/shoes/color/orange(NULL))
	for(var/atom/a in spawnedAtoms)
		a.forcemove(src)

/obj/structure/closet/wardrobe/color/yellow
	name = "yellow wardrobe"
	icon_door = "yellow"

/obj/structure/closet/wardrobe/color/yellow/populate_contents()
	var/list/spawnedAtoms = list()

	spawnedAtoms.Add(new /obj/item/clothing/under/color/yellow(NULL))
	spawnedAtoms.Add(new /obj/item/clothing/under/color/yellow(NULL))
	spawnedAtoms.Add(new /obj/item/clothing/under/color/yellow(NULL))
	spawnedAtoms.Add(new /obj/item/clothing/shoes/color/orange(NULL))
	spawnedAtoms.Add(new /obj/item/clothing/shoes/color/orange(NULL))
	spawnedAtoms.Add(new /obj/item/clothing/shoes/color/orange(NULL))
	spawnedAtoms.Add(new /obj/item/clothing/mask/bandana/orange(NULL))
	spawnedAtoms.Add(new /obj/item/clothing/mask/bandana/orange(NULL))
	spawnedAtoms.Add(new /obj/item/clothing/mask/bandana/orange(NULL))
	for(var/atom/a in spawnedAtoms)
		a.forcemove(src)


/obj/structure/closet/wardrobe/color/white
	name = "white wardrobe"
	icon_door = "white"

/obj/structure/closet/wardrobe/color/white/populate_contents()
	var/list/spawnedAtoms = list()

	spawnedAtoms.Add(new /obj/item/clothing/under/color/white(NULL))
	spawnedAtoms.Add(new /obj/item/clothing/under/color/white(NULL))
	spawnedAtoms.Add(new /obj/item/clothing/under/color/white(NULL))
	spawnedAtoms.Add(new /obj/item/clothing/shoes/color/white(NULL))
	spawnedAtoms.Add(new /obj/item/clothing/shoes/color/white(NULL))
	spawnedAtoms.Add(new /obj/item/clothing/shoes/color/white(NULL))
	spawnedAtoms.Add(new /obj/item/storage/backpack/sport/white(NULL))
	for(var/atom/a in spawnedAtoms)
		a.forcemove(src)

/obj/structure/closet/wardrobe/color/grey
	name = "grey wardrobe"
	icon_door = "grey"

/obj/structure/closet/wardrobe/color/grey/populate_contents()
	var/list/spawnedAtoms = list()

	spawnedAtoms.Add(new /obj/item/clothing/under/color/grey(NULL))
	spawnedAtoms.Add(new /obj/item/clothing/under/color/grey(NULL))
	spawnedAtoms.Add(new /obj/item/clothing/under/color/grey(NULL))
	spawnedAtoms.Add(new /obj/item/clothing/shoes/color/black(NULL))
	spawnedAtoms.Add(new /obj/item/clothing/shoes/color/black(NULL))
	spawnedAtoms.Add(new /obj/item/clothing/shoes/color/black(NULL))
	spawnedAtoms.Add(new /obj/item/clothing/head/soft/grey(NULL))
	spawnedAtoms.Add(new /obj/item/clothing/head/soft/grey(NULL))
	spawnedAtoms.Add(new /obj/item/clothing/head/soft/grey(NULL))
	spawnedAtoms.Add(new /obj/item/storage/backpack/sport(NULL))
	for(var/atom/a in spawnedAtoms)
		a.forcemove(src)

/obj/structure/closet/wardrobe/color/mixed
	name = "mixed wardrobe"
	icon_door = "mixed"

/obj/structure/closet/wardrobe/color/mixed/populate_contents()
	var/list/spawnedAtoms = list()

	spawnedAtoms.Add(new /obj/item/clothing/under/color/blue(NULL))
	spawnedAtoms.Add(new /obj/item/clothing/under/color/yellow(NULL))
	spawnedAtoms.Add(new /obj/item/clothing/under/color/green(NULL))
	spawnedAtoms.Add(new /obj/item/clothing/under/color/orange(NULL))
	spawnedAtoms.Add(new /obj/item/clothing/under/color/pink(NULL))
	spawnedAtoms.Add(new /obj/item/clothing/shoes/color/blue(NULL))
	spawnedAtoms.Add(new /obj/item/clothing/shoes/color/yellow(NULL))
	spawnedAtoms.Add(new /obj/item/clothing/shoes/color/green(NULL))
	spawnedAtoms.Add(new /obj/item/clothing/shoes/color/orange(NULL))
	spawnedAtoms.Add(new /obj/item/clothing/shoes/color/purple(NULL))
	spawnedAtoms.Add(new /obj/item/clothing/shoes/color/red(NULL))
	spawnedAtoms.Add(new /obj/item/clothing/shoes/leather(NULL))
	spawnedAtoms.Add(new /obj/item/clothing/mask/bandana/orange(NULL))
	spawnedAtoms.Add(new /obj/item/clothing/mask/bandana/blue(NULL))
	spawnedAtoms.Add(new /obj/item/clothing/mask/bandana/red(NULL))
	spawnedAtoms.Add(new /obj/item/clothing/mask/bandana/green(NULL))
	spawnedAtoms.Add(new /obj/item/clothing/mask/bandana/gold(NULL))
	spawnedAtoms.Add(new /obj/item/clothing/mask/bandana/purple(NULL))
	spawnedAtoms.Add(new /obj/item/clothing/mask/bandana/camo(NULL))
	spawnedAtoms.Add(new /obj/item/storage/backpack/sport/purple(NULL))
	spawnedAtoms.Add(new /obj/item/storage/backpack/sport/green(NULL))
	spawnedAtoms.Add(new /obj/item/storage/backpack/sport/blue(NULL))
	spawnedAtoms.Add(new /obj/item/storage/backpack/sport/orange(NULL))

	for(var/atom/a in spawnedAtoms)
		a.forcemove(src)

/obj/structure/closet/wardrobe/pjs
	name = "pajama wardrobe"
	icon_door = "white"
	spawn_blacklisted = FALSE

/obj/structure/closet/wardrobe/pjs/populate_contents()
	var/list/spawnedAtoms = list()

	spawnedAtoms.Add(new /obj/item/clothing/under/pj/red(NULL))
	spawnedAtoms.Add(new /obj/item/clothing/under/pj/red(NULL))
	spawnedAtoms.Add(new /obj/item/clothing/under/pj/blue(NULL))
	spawnedAtoms.Add(new /obj/item/clothing/under/pj/blue(NULL))
	spawnedAtoms.Add(new /obj/item/clothing/shoes/color/white(NULL))
	spawnedAtoms.Add(new /obj/item/clothing/shoes/color/white(NULL))
	spawnedAtoms.Add(new /obj/item/clothing/shoes/slippers(NULL))
	spawnedAtoms.Add(new /obj/item/clothing/shoes/slippers(NULL))

	for(var/atom/a in spawnedAtoms)
		a.forcemove(src)

/obj/structure/closet/wardrobe/tactical
	name = "tactical equipment"
	icon_door = "black"

/obj/structure/closet/wardrobe/tactical/populate_contents()
	var/list/spawnedAtoms = list()

	spawnedAtoms.Add(new /obj/item/clothing/under/syndicate(NULL))
	spawnedAtoms.Add(new /obj/item/clothing/suit/armor/heavy(NULL))
	spawnedAtoms.Add(new /obj/item/clothing/mask/balaclava/tactical(NULL))
	spawnedAtoms.Add(new /obj/item/clothing/glasses/sunglasses/sechud/tactical(NULL))
	spawnedAtoms.Add(new /obj/item/storage/belt/tactical(NULL))
	spawnedAtoms.Add(new /obj/item/clothing/shoes/jackboots(NULL))
	spawnedAtoms.Add(new /obj/item/clothing/gloves/thick(NULL))

	for(var/atom/a in spawnedAtoms)
		a.forcemove(src)

/obj/structure/closet/wardrobe/sec
	name = "security wardrobe"
	icon_door = "blue"

/obj/structure/closet/wardrobe/sec/populate_contents()

	var/list/spawnedAtoms = list()

	spawnedAtoms.Add(new /obj/item/clothing/under/rank/security(NULL))
	spawnedAtoms.Add(new /obj/item/clothing/under/rank/security(NULL))
	spawnedAtoms.Add(new /obj/item/clothing/under/rank/security(NULL))
	spawnedAtoms.Add(new /obj/item/clothing/shoes/jackboots/ironhammer(NULL))
	spawnedAtoms.Add(new /obj/item/clothing/shoes/jackboots/ironhammer(NULL))
	spawnedAtoms.Add(new /obj/item/clothing/shoes/jackboots/ironhammer(NULL))
	spawnedAtoms.Add(new /obj/item/clothing/head/beret/sec/navy/officer(NULL))
	spawnedAtoms.Add(new /obj/item/clothing/head/beret/sec/navy/officer(NULL))
	spawnedAtoms.Add(new /obj/item/clothing/head/beret/sec/navy/officer(NULL))
	spawnedAtoms.Add(new /obj/item/clothing/gloves/security/ironhammer(NULL))
	spawnedAtoms.Add(new /obj/item/clothing/gloves/security/ironhammer(NULL))
	spawnedAtoms.Add(new /obj/item/clothing/gloves/security/ironhammer(NULL))

	for(var/atom/a in spawnedAtoms)
		a.forcemove(src)

/obj/structure/closet/wardrobe/science_white
	name = "science wardrobe"
	icon_door = "mixed"
	spawn_blacklisted = TRUE

/obj/structure/closet/wardrobe/science_white/populate_contents()
	var/list/spawnedAtoms = list()

	spawnedAtoms.Add(new /obj/item/clothing/under/rank/scientist(NULL))
	spawnedAtoms.Add(new /obj/item/clothing/under/rank/scientist(NULL))
	spawnedAtoms.Add(new /obj/item/clothing/under/rank/scientist(NULL))
	spawnedAtoms.Add(new /obj/item/clothing/suit/storage/toggle/labcoat(NULL))
	spawnedAtoms.Add(new /obj/item/clothing/suit/storage/toggle/labcoat(NULL))
	spawnedAtoms.Add(new /obj/item/clothing/suit/storage/toggle/labcoat(NULL))
	spawnedAtoms.Add(new /obj/item/clothing/shoes/color/white(NULL))
	spawnedAtoms.Add(new /obj/item/clothing/shoes/color/white(NULL))
	spawnedAtoms.Add(new /obj/item/clothing/shoes/color/white(NULL))
	spawnedAtoms.Add(new /obj/item/clothing/shoes/slippers(NULL))
	spawnedAtoms.Add(new /obj/item/clothing/shoes/slippers(NULL))
	spawnedAtoms.Add(new /obj/item/clothing/shoes/slippers(NULL))
	spawnedAtoms.Add(new /obj/item/clothing/glasses/regular/goggles/clear(NULL))
	spawnedAtoms.Add(new /obj/item/clothing/glasses/regular/goggles/clear(NULL))
	spawnedAtoms.Add(new /obj/item/clothing/glasses/regular/goggles/clear(NULL))
	for(var/atom/a in spawnedAtoms)
		a.forcemove(src)

/obj/structure/closet/wardrobe/robotics_black
	name = "robotics wardrobe"
	icon_door = "black"

/obj/structure/closet/wardrobe/robotics_black/populate_contents()
	var/list/spawnedAtoms = list()

	spawnedAtoms.Add(new /obj/item/clothing/under/rank/roboticist(NULL))
	spawnedAtoms.Add(new /obj/item/clothing/under/rank/roboticist(NULL))
	spawnedAtoms.Add(new /obj/item/clothing/suit/storage/robotech_jacket(NULL))
	spawnedAtoms.Add(new /obj/item/clothing/suit/storage/robotech_jacket(NULL))
	spawnedAtoms.Add(new /obj/item/clothing/shoes/color/black(NULL))
	spawnedAtoms.Add(new /obj/item/clothing/shoes/color/black(NULL))
	spawnedAtoms.Add(new /obj/item/clothing/gloves/thick(NULL))
	spawnedAtoms.Add(new /obj/item/clothing/gloves/thick(NULL))
	for(var/atom/a in spawnedAtoms)
		a.forcemove(src)

/obj/structure/closet/wardrobe/chemistry_white
	name = "chemistry wardrobe"
	icon_door = "white"

/obj/structure/closet/wardrobe/chemistry_white/populate_contents()
	var/list/spawnedAtoms = list()

	spawnedAtoms.Add(new /obj/item/clothing/under/rank/chemist(NULL))
	spawnedAtoms.Add(new /obj/item/clothing/under/rank/chemist(NULL))
	spawnedAtoms.Add(new /obj/item/clothing/shoes/color/white(NULL))
	spawnedAtoms.Add(new /obj/item/clothing/shoes/color/white(NULL))
	spawnedAtoms.Add(new /obj/item/clothing/suit/storage/toggle/labcoat/chemist(NULL))
	spawnedAtoms.Add(new /obj/item/clothing/suit/storage/toggle/labcoat/chemist(NULL))
	spawnedAtoms.Add(new /obj/item/clothing/glasses/regular/goggles/clear(NULL))
	spawnedAtoms.Add(new /obj/item/clothing/glasses/regular/goggles/clear(NULL))
	for(var/atom/a in spawnedAtoms)
		a.forcemove(src)

/obj/structure/closet/wardrobe/virology_white
	name = "virology wardrobe"
	icon_door = "white"

/obj/structure/closet/wardrobe/virology_white/populate_contents()
	var/list/spawnedAtoms = list()

	spawnedAtoms.Add(new /obj/item/clothing/under/rank/virologist(NULL))
	spawnedAtoms.Add(new /obj/item/clothing/under/rank/virologist(NULL))
	spawnedAtoms.Add(new /obj/item/clothing/shoes/color/white(NULL))
	spawnedAtoms.Add(new /obj/item/clothing/shoes/color/white(NULL))
	spawnedAtoms.Add(new /obj/item/clothing/suit/storage/toggle/labcoat/virologist(NULL))
	spawnedAtoms.Add(new /obj/item/clothing/suit/storage/toggle/labcoat/virologist(NULL))
	spawnedAtoms.Add(new /obj/item/clothing/mask/surgical(NULL))
	spawnedAtoms.Add(new /obj/item/clothing/mask/surgical(NULL))
	for(var/atom/a in spawnedAtoms)
		a.forcemove(src)

/obj/structure/closet/wardrobe/medic_white
	name = "medical wardrobe"
	icon_door = "white"

/obj/structure/closet/wardrobe/medic_white/populate_contents()
	var/list/spawnedAtoms = list()

	spawnedAtoms.Add(new /obj/item/clothing/under/rank/medical(NULL))
	spawnedAtoms.Add(new /obj/item/clothing/under/rank/medical(NULL))
	spawnedAtoms.Add(new /obj/item/clothing/under/rank/medical/green(NULL))
	spawnedAtoms.Add(new /obj/item/clothing/shoes/color/white(NULL))
	spawnedAtoms.Add(new /obj/item/clothing/shoes/color/white(NULL))
	spawnedAtoms.Add(new /obj/item/clothing/shoes/reinforced(NULL))
	spawnedAtoms.Add(new /obj/item/clothing/shoes/reinforced(NULL))
	spawnedAtoms.Add(new /obj/item/clothing/suit/storage/toggle/labcoat(NULL))
	spawnedAtoms.Add(new /obj/item/clothing/suit/storage/toggle/labcoat(NULL))
	spawnedAtoms.Add(new /obj/item/clothing/mask/surgical(NULL))
	spawnedAtoms.Add(new /obj/item/clothing/mask/surgical(NULL))
	for(var/atom/a in spawnedAtoms)
		a.forcemove(src)

/obj/structure/closet/wardrobe/chaplain_black
	name = "chapel wardrobe"
	desc = "A storage unit for approved religious attire."
	icon_door = "black"

/obj/structure/closet/wardrobe/chaplain_black/populate_contents()
	var/list/spawnedAtoms = list()

	spawnedAtoms.Add(new /obj/item/clothing/under/color/black(NULL))
	spawnedAtoms.Add(new /obj/item/clothing/shoes/color/black(NULL))
	spawnedAtoms.Add(new /obj/item/clothing/suit/nun(NULL))
	spawnedAtoms.Add(new /obj/item/clothing/head/nun_hood(NULL))
	spawnedAtoms.Add(new /obj/item/clothing/suit/storage/neotheology_jacket(NULL))
	spawnedAtoms.Add(new /obj/item/clothing/head/chaplain_hood(NULL))
	spawnedAtoms.Add(new /obj/item/clothing/under/bride_white(NULL))
	spawnedAtoms.Add(new /obj/item/storage/fancy/candle_box(NULL))
	spawnedAtoms.Add(new /obj/item/storage/fancy/candle_box(NULL))
	spawnedAtoms.Add(new /obj/item/deck/tarot(NULL))
	for(var/atom/a in spawnedAtoms)
		a.forcemove(src)

/obj/structure/closet/wardrobe/engineering_yellow
	name = "engineering wardrobe"
	icon_door = "yellow"

/obj/structure/closet/wardrobe/engineering_yellow/populate_contents()
	var/list/spawnedAtoms = list()

	spawnedAtoms.Add(new /obj/item/clothing/under/rank/engineer(NULL))
	spawnedAtoms.Add(new /obj/item/clothing/under/rank/engineer(NULL))
	spawnedAtoms.Add(new /obj/item/clothing/under/rank/engineer(NULL))
	spawnedAtoms.Add(new /obj/item/clothing/shoes/jackboots(NULL))
	spawnedAtoms.Add(new /obj/item/clothing/shoes/jackboots(NULL))
	spawnedAtoms.Add(new /obj/item/clothing/shoes/jackboots(NULL))
	spawnedAtoms.Add(new /obj/item/clothing/head/hardhat(NULL))
	spawnedAtoms.Add(new /obj/item/clothing/head/hardhat(NULL))
	spawnedAtoms.Add(new /obj/item/clothing/head/hardhat(NULL))
	spawnedAtoms.Add(new /obj/item/clothing/head/beret/engineering(NULL))
	spawnedAtoms.Add(new /obj/item/clothing/head/beret/engineering(NULL))
	spawnedAtoms.Add(new /obj/item/clothing/head/beret/engineering(NULL))
	for(var/atom/a in spawnedAtoms)
		a.forcemove(src)
