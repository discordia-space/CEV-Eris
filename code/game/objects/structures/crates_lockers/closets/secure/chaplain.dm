/obj/structure/closet/secure_closet/reinforced/chaplain
	name = "preacher's locker"
	req_access = list(access_chapel_office)
	icon_state = "head_preacher"

/obj/structure/closet/secure_closet/reinforced/chaplain/populate_contents()
	if(prob(25))
		new /obj/item/storage/backpack/neotheology(src)
	else if(prob(25))
		new /obj/item/storage/backpack/sport/neotheology(src)
	else
		new /obj/item/storage/backpack/satchel/neotheology(src)
	new /obj/item/clothing/under/rank/preacher(src)
	new /obj/item/clothing/under/rank/preacher(src)
	new /obj/item/storage/pouch/holster/belt/sheath(src)
	new /obj/item/device/radio/headset/church(src)
	new /obj/item/storage/belt/tactical/neotheology(src)
	new /obj/item/clothing/shoes/reinforced(src)
	new /obj/item/clothing/shoes/reinforced(src)
	new /obj/item/clothing/suit/storage/neotheology_jacket(src)
	new /obj/item/clothing/suit/storage/neotheology_jacket(src)
	new /obj/item/clothing/gloves/thick(src)
	new /obj/item/clothing/under/rank/church/sport(src)
	new /obj/item/clothing/suit/storage/neotheosports(src)
	new /obj/item/clothing/gloves/thick(src)
	new /obj/item/storage/fancy/candle_box(src)
	new /obj/item/storage/fancy/candle_box(src)
	new /obj/item/deck/tarot(src)
	new /obj/item/storage/box/headset_church(src)
	new /obj/item/tool/knife/neotritual(src)
	new /obj/item/tool/sword/nt/longsword(src)
	new /obj/item/tool/knife/dagger/nt(src)
	new /obj/item/storage/box/ids(src)

/obj/structure/closet/secure_closet/personal/custodial
	name = "custodial closet"
	desc = "A storage unit for purifying clothes and gear."
	req_access = list(access_nt_custodian)
	icon_state = "custodian"

/obj/structure/closet/secure_closet/personal/custodial/populate_contents()
	if(prob(25))
		new /obj/item/storage/backpack/neotheology(src)
	else if(prob(25))
		new /obj/item/storage/backpack/sport/neotheology(src)
	else
		new /obj/item/storage/backpack/satchel/neotheology(src)
	new /obj/item/clothing/under/rank/church(src)
	new /obj/item/storage/belt/utility/neotheology(src)
	new /obj/item/device/radio/headset/church(src)
	new /obj/item/clothing/gloves/thick(src)
	new /obj/item/clothing/suit/armor/custodian(src)
	new /obj/item/clothing/head/armor/custodian(src)
	//new /obj/item/clothing/head/soft/purple(src)
	//new /obj/item/clothing/head/beret/purple(src)
	new /obj/item/device/lighting/toggleable/flashlight(src)
	new /obj/item/gun/matter/launcher/nt_sprayer(src)
	new /obj/item/caution(src)
	new /obj/item/caution(src)
	new /obj/item/caution(src)
	new /obj/item/caution(src)
	new /obj/item/device/lightreplacer(src)
	new /obj/item/storage/bag/trash(src)
	new /obj/item/clothing/shoes/galoshes(src)
	new /obj/item/mop(src)
	new /obj/item/clothing/under/rank/church/sport(src)
	new /obj/item/clothing/suit/storage/neotheosports(src)
	new /obj/item/soap/nanotrasen(src)
	new /obj/item/storage/pouch/small_generic(src) // Because I feel like poor janitor gets it bad.
	new /obj/item/cell/small/neotheology(src)
	new /obj/item/cell/small/neotheology(src)
	new /obj/item/tool/knife/dagger/nt(src)
	new /obj/item/holyvacuum(src)
	new /obj/item/clothing/shoes/jackboots/neotheology(src)

/obj/structure/closet/secure_closet/personal/acolyte
	name = "acolyte closet"
	desc = "A closet for those that work with the machines of god."
	req_access = list(access_nt_acolyte)
	icon_state = "acolyte"

/obj/structure/closet/secure_closet/personal/acolyte/populate_contents()
	if(prob(25))
		new /obj/item/storage/backpack/neotheology(src)
	else if(prob(25))
		new /obj/item/storage/backpack/sport/neotheology(src)
	else
		new /obj/item/storage/backpack/satchel/neotheology(src)
	new /obj/item/clothing/under/rank/acolyte(src)
	new /obj/item/clothing/suit/storage/neotheology_jacket(src)
	new /obj/item/storage/belt/tactical/neotheology(src)
	new /obj/item/clothing/mask/gas(src)
	new /obj/item/device/radio/headset/church(src)
	new /obj/item/clothing/gloves/thick(src)
	new /obj/item/clothing/under/rank/church/sport(src)
	new /obj/item/clothing/suit/storage/neotheosports(src)
	new /obj/item/clothing/head/armor/acolyte(src)
	new /obj/item/clothing/suit/armor/acolyte(src)
	new /obj/item/cell/small/neotheology(src)
	new /obj/item/storage/pouch/holster/belt/sheath(src)
	new /obj/item/tool/sword/nt/shortsword(src)
	new /obj/item/tool/knife/dagger/nt(src)
	new /obj/item/clothing/shoes/reinforced(src)
