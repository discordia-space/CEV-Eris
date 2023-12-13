/obj/structure/closet/secure_closet/reinforced/chaplain
	name = "preacher's locker"
	req_access = list(access_chapel_office)
	icon_state = "head_preacher"

/obj/structure/closet/secure_closet/reinforced/chaplain/populate_contents()
	var/list/spawnedAtoms = list()

	if(prob(25))
		spawnedAtoms.Add(new  /obj/item/storage/backpack/neotheology(NULL))
	else if(prob(25))
		spawnedAtoms.Add(new  /obj/item/storage/backpack/sport/neotheology(NULL))
	else
		spawnedAtoms.Add(new  /obj/item/storage/backpack/satchel/neotheology(NULL))
	spawnedAtoms.Add(new  /obj/item/clothing/under/rank/preacher(NULL))
	spawnedAtoms.Add(new  /obj/item/clothing/under/rank/preacher(NULL))
	spawnedAtoms.Add(new  /obj/item/storage/pouch/holster/belt/sheath(NULL))
	spawnedAtoms.Add(new  /obj/item/device/radio/headset/church(NULL))
	spawnedAtoms.Add(new  /obj/item/storage/belt/tactical/neotheology(NULL))
	spawnedAtoms.Add(new  /obj/item/clothing/shoes/reinforced(NULL))
	spawnedAtoms.Add(new  /obj/item/clothing/shoes/reinforced(NULL))
	spawnedAtoms.Add(new  /obj/item/clothing/suit/storage/neotheology_jacket(NULL))
	spawnedAtoms.Add(new  /obj/item/clothing/suit/storage/neotheology_jacket(NULL))
	spawnedAtoms.Add(new  /obj/item/clothing/gloves/thick(NULL))
	spawnedAtoms.Add(new  /obj/item/clothing/under/rank/church/sport(NULL))
	spawnedAtoms.Add(new  /obj/item/clothing/suit/storage/neotheosports(NULL))
	spawnedAtoms.Add(new  /obj/item/clothing/gloves/thick(NULL))
	spawnedAtoms.Add(new  /obj/item/storage/fancy/candle_box(NULL))
	spawnedAtoms.Add(new  /obj/item/storage/fancy/candle_box(NULL))
	spawnedAtoms.Add(new  /obj/item/deck/tarot(NULL))
	spawnedAtoms.Add(new  /obj/item/storage/box/headset_church(NULL))
	spawnedAtoms.Add(new  /obj/item/tool/knife/neotritual(NULL))
	spawnedAtoms.Add(new  /obj/item/tool/sword/nt/longsword(NULL))
	spawnedAtoms.Add(new  /obj/item/tool/knife/dagger/nt(NULL))
	spawnedAtoms.Add(new  /obj/item/storage/box/ids(NULL))
	for(var/atom/a in spawnedAtoms)
		a.forceMove(src)


/obj/structure/closet/secure_closet/acolyte
	name = "acolyte closet"
	desc = "A closet for those that work with the machines of god."
	req_access = list(access_nt_acolyte)
	icon_state = "acolyte"

/obj/structure/closet/secure_closet/acolyte/populate_contents()
	var/list/spawnedAtoms = list()

	if(prob(25))
		spawnedAtoms.Add(new  /obj/item/storage/backpack/neotheology(NULL))
	else if(prob(25))
		spawnedAtoms.Add(new  /obj/item/storage/backpack/sport/neotheology(NULL))
	else
		spawnedAtoms.Add(new  /obj/item/storage/backpack/satchel/neotheology(NULL))
	spawnedAtoms.Add(new  /obj/item/clothing/under/rank/acolyte(NULL))
	spawnedAtoms.Add(new  /obj/item/clothing/suit/storage/neotheology_jacket(NULL))
	spawnedAtoms.Add(new  /obj/item/storage/belt/tactical/neotheology(NULL))
	spawnedAtoms.Add(new  /obj/item/clothing/mask/gas(NULL))
	spawnedAtoms.Add(new  /obj/item/device/radio/headset/church(NULL))
	spawnedAtoms.Add(new  /obj/item/clothing/gloves/thick(NULL))
	spawnedAtoms.Add(new  /obj/item/clothing/under/rank/church/sport(NULL))
	spawnedAtoms.Add(new  /obj/item/clothing/suit/storage/neotheosports(NULL))
	spawnedAtoms.Add(new  /obj/item/clothing/head/armor/acolyte(NULL))
	spawnedAtoms.Add(new  /obj/item/clothing/suit/armor/acolyte(NULL))
	spawnedAtoms.Add(new  /obj/item/cell/small/neotheology(NULL))
	spawnedAtoms.Add(new  /obj/item/storage/pouch/holster/belt/sheath(NULL))
	spawnedAtoms.Add(new  /obj/item/tool/sword/nt/shortsword(NULL))
	spawnedAtoms.Add(new  /obj/item/tool/knife/dagger/nt(NULL))
	spawnedAtoms.Add(new  /obj/item/clothing/shoes/reinforced(NULL))
	for(var/atom/a in spawnedAtoms)
		a.forceMove(src)


/obj/structure/closet/secure_closet/custodial
	name = "custodial closet"
	desc = "A storage unit for purifying clothes and gear."
	req_access = list(access_nt_custodian)
	icon_state = "custodian"

/obj/structure/closet/secure_closet/custodial/populate_contents()
	var/list/spawnedAtoms = list()

	if(prob(25))
		spawnedAtoms.Add(new  /obj/item/storage/backpack/neotheology(NULL))
	else if(prob(25))
		spawnedAtoms.Add(new  /obj/item/storage/backpack/sport/neotheology(NULL))
	else
		spawnedAtoms.Add(new  /obj/item/storage/backpack/satchel/neotheology(NULL))
	spawnedAtoms.Add(new  /obj/item/clothing/under/rank/church(NULL))
	spawnedAtoms.Add(new  /obj/item/storage/belt/utility/neotheology(NULL))
	spawnedAtoms.Add(new  /obj/item/device/radio/headset/church(NULL))
	spawnedAtoms.Add(new  /obj/item/clothing/gloves/thick(NULL))
	spawnedAtoms.Add(new  /obj/item/clothing/suit/armor/custodian(NULL))
	spawnedAtoms.Add(new  /obj/item/clothing/head/armor/custodian(NULL))
	//spawnedAtoms.Add(new  /obj/item/clothing/head/soft/purple(NULL))
	//spawnedAtoms.Add(new  /obj/item/clothing/head/beret/purple(NULL))
	spawnedAtoms.Add(new  /obj/item/device/lighting/toggleable/flashlight(NULL))
	spawnedAtoms.Add(new  /obj/item/gun/matter/launcher/nt_sprayer(NULL))
	spawnedAtoms.Add(new  /obj/item/caution(NULL))
	spawnedAtoms.Add(new  /obj/item/caution(NULL))
	spawnedAtoms.Add(new  /obj/item/caution(NULL))
	spawnedAtoms.Add(new  /obj/item/caution(NULL))
	spawnedAtoms.Add(new  /obj/item/device/lightreplacer(NULL))
	spawnedAtoms.Add(new  /obj/item/storage/bag/trash(NULL))
	spawnedAtoms.Add(new  /obj/item/clothing/shoes/galoshes(NULL))
	spawnedAtoms.Add(new  /obj/item/mop(NULL))
	spawnedAtoms.Add(new  /obj/item/clothing/under/rank/church/sport(NULL))
	spawnedAtoms.Add(new  /obj/item/clothing/suit/storage/neotheosports(NULL))
	spawnedAtoms.Add(new  /obj/item/soap/nanotrasen(NULL))
	spawnedAtoms.Add(new  /obj/item/storage/pouch/small_generic(NULL)) // Because I feel like poor janitor gets it bad.
	spawnedAtoms.Add(new  /obj/item/cell/small/neotheology(NULL))
	spawnedAtoms.Add(new  /obj/item/cell/small/neotheology(NULL))
	spawnedAtoms.Add(new  /obj/item/tool/knife/dagger/nt(NULL))
	spawnedAtoms.Add(new  /obj/item/holyvacuum(NULL))
	spawnedAtoms.Add(new  /obj/item/clothing/shoes/jackboots/neotheology(NULL))
	for(var/atom/a in spawnedAtoms)
		a.forceMove(src)


/obj/structure/closet/secure_closet/agrolyte
	name = "agrolyte's locker"
	req_access = list(access_hydroponics)
	icon_state = "agrolyte"

/obj/structure/closet/secure_closet/agrolyte/populate_contents()
	var/list/spawnedAtoms = list()

	if(prob(25))
		spawnedAtoms.Add(new  /obj/item/storage/backpack/neotheology(NULL))
	else if(prob(25))
		spawnedAtoms.Add(new  /obj/item/storage/backpack/sport/neotheology(NULL))
	else
		spawnedAtoms.Add(new  /obj/item/storage/backpack/satchel/neotheology(NULL))
	spawnedAtoms.Add(new  /obj/item/clothing/suit/apron(NULL))
	spawnedAtoms.Add(new  /obj/item/storage/belt/utility/neotheology(NULL))
	spawnedAtoms.Add(new  /obj/item/storage/bag/produce(NULL))
	spawnedAtoms.Add(new  /obj/item/clothing/under/rank/hydroponics(NULL))
	spawnedAtoms.Add(new  /obj/item/device/scanner/plant(NULL))
	spawnedAtoms.Add(new  /obj/item/device/radio/headset/church(NULL))
	spawnedAtoms.Add(new  /obj/item/clothing/mask/bandana/botany(NULL))
	spawnedAtoms.Add(new  /obj/item/tool/minihoe(NULL))
	spawnedAtoms.Add(new  /obj/item/tool/hatchet(NULL))
	spawnedAtoms.Add(new  /obj/item/tool/wirecutters(NULL))
	spawnedAtoms.Add(new  /obj/item/clothing/under/rank/church/sport(NULL))
	spawnedAtoms.Add(new  /obj/item/clothing/suit/storage/neotheosports(NULL))
	spawnedAtoms.Add(new  /obj/item/reagent_containers/spray/plantbgone(NULL))
	spawnedAtoms.Add(new  /obj/item/clothing/suit/armor/agrolyte(NULL))
	spawnedAtoms.Add(new  /obj/item/clothing/head/armor/agrolyte(NULL))
	spawnedAtoms.Add(new  /obj/item/clothing/gloves/botanic_leather(NULL))
	spawnedAtoms.Add(new  /obj/item/clothing/shoes/reinforced(NULL))
	for(var/atom/a in spawnedAtoms)
		a.forceMove(src)
