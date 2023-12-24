/obj/structure/closet/secure_closet/reinforced/chaplain
	name = "preacher's locker"
	req_access = list(access_chapel_office)
	icon_state = "head_preacher"

/obj/structure/closet/secure_closet/reinforced/chaplain/populate_contents()
	var/list/spawnedAtoms = list()

	if(prob(25))
		spawnedAtoms.Add(new  /obj/item/storage/backpack/neotheology(NULLSPACE))
	else if(prob(25))
		spawnedAtoms.Add(new  /obj/item/storage/backpack/sport/neotheology(NULLSPACE))
	else
		spawnedAtoms.Add(new  /obj/item/storage/backpack/satchel/neotheology(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/clothing/under/rank/preacher(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/clothing/under/rank/preacher(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/storage/pouch/holster/belt/sheath(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/device/radio/headset/church(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/storage/belt/tactical/neotheology(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/clothing/shoes/reinforced(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/clothing/shoes/reinforced(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/clothing/suit/storage/neotheology_jacket(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/clothing/suit/storage/neotheology_jacket(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/clothing/gloves/thick(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/clothing/under/rank/church/sport(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/clothing/suit/storage/neotheosports(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/clothing/gloves/thick(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/storage/fancy/candle_box(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/storage/fancy/candle_box(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/deck/tarot(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/storage/box/headset_church(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/tool/knife/neotritual(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/tool/sword/nt/longsword(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/tool/knife/dagger/nt(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/storage/box/ids(NULLSPACE))
	for(var/atom/movable/a in spawnedAtoms)
		a.forceMove(src)


/obj/structure/closet/secure_closet/acolyte
	name = "acolyte closet"
	desc = "A closet for those that work with the machines of god."
	req_access = list(access_nt_acolyte)
	icon_state = "acolyte"

/obj/structure/closet/secure_closet/acolyte/populate_contents()
	var/list/spawnedAtoms = list()

	if(prob(25))
		spawnedAtoms.Add(new  /obj/item/storage/backpack/neotheology(NULLSPACE))
	else if(prob(25))
		spawnedAtoms.Add(new  /obj/item/storage/backpack/sport/neotheology(NULLSPACE))
	else
		spawnedAtoms.Add(new  /obj/item/storage/backpack/satchel/neotheology(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/clothing/under/rank/acolyte(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/clothing/suit/storage/neotheology_jacket(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/storage/belt/tactical/neotheology(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/clothing/mask/gas(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/device/radio/headset/church(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/clothing/gloves/thick(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/clothing/under/rank/church/sport(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/clothing/suit/storage/neotheosports(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/clothing/head/armor/acolyte(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/clothing/suit/armor/acolyte(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/cell/small/neotheology(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/storage/pouch/holster/belt/sheath(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/tool/sword/nt/shortsword(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/tool/knife/dagger/nt(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/clothing/shoes/reinforced(NULLSPACE))
	for(var/atom/movable/a in spawnedAtoms)
		a.forceMove(src)


/obj/structure/closet/secure_closet/custodial
	name = "custodial closet"
	desc = "A storage unit for purifying clothes and gear."
	req_access = list(access_nt_custodian)
	icon_state = "custodian"

/obj/structure/closet/secure_closet/custodial/populate_contents()
	var/list/spawnedAtoms = list()

	if(prob(25))
		spawnedAtoms.Add(new  /obj/item/storage/backpack/neotheology(NULLSPACE))
	else if(prob(25))
		spawnedAtoms.Add(new  /obj/item/storage/backpack/sport/neotheology(NULLSPACE))
	else
		spawnedAtoms.Add(new  /obj/item/storage/backpack/satchel/neotheology(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/clothing/under/rank/church(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/storage/belt/utility/neotheology(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/device/radio/headset/church(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/clothing/gloves/thick(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/clothing/suit/armor/custodian(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/clothing/head/armor/custodian(NULLSPACE))
	//spawnedAtoms.Add(new  /obj/item/clothing/head/soft/purple(NULLSPACE))
	//spawnedAtoms.Add(new  /obj/item/clothing/head/beret/purple(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/device/lighting/toggleable/flashlight(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/gun/matter/launcher/nt_sprayer(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/caution(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/caution(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/caution(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/caution(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/device/lightreplacer(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/storage/bag/trash(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/clothing/shoes/galoshes(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/mop(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/clothing/under/rank/church/sport(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/clothing/suit/storage/neotheosports(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/soap/nanotrasen(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/storage/pouch/small_generic(NULLSPACE)) // Because I feel like poor janitor gets it bad.
	spawnedAtoms.Add(new  /obj/item/cell/small/neotheology(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/cell/small/neotheology(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/tool/knife/dagger/nt(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/holyvacuum(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/clothing/shoes/jackboots/neotheology(NULLSPACE))
	for(var/atom/movable/a in spawnedAtoms)
		a.forceMove(src)


/obj/structure/closet/secure_closet/agrolyte
	name = "agrolyte's locker"
	req_access = list(access_hydroponics)
	icon_state = "agrolyte"

/obj/structure/closet/secure_closet/agrolyte/populate_contents()
	var/list/spawnedAtoms = list()

	if(prob(25))
		spawnedAtoms.Add(new  /obj/item/storage/backpack/neotheology(NULLSPACE))
	else if(prob(25))
		spawnedAtoms.Add(new  /obj/item/storage/backpack/sport/neotheology(NULLSPACE))
	else
		spawnedAtoms.Add(new  /obj/item/storage/backpack/satchel/neotheology(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/clothing/suit/apron(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/storage/belt/utility/neotheology(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/storage/bag/produce(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/clothing/under/rank/hydroponics(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/device/scanner/plant(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/device/radio/headset/church(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/clothing/mask/bandana/botany(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/tool/minihoe(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/tool/hatchet(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/tool/wirecutters(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/clothing/under/rank/church/sport(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/clothing/suit/storage/neotheosports(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/reagent_containers/spray/plantbgone(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/clothing/suit/armor/agrolyte(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/clothing/head/armor/agrolyte(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/clothing/gloves/botanic_leather(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/clothing/shoes/reinforced(NULLSPACE))
	for(var/atom/movable/a in spawnedAtoms)
		a.forceMove(src)
