/obj/structure/closet/secure_closet/reinforced/captains
	name = "captain's locker"
	req_access = list(access_captain)
	icon_state = "cap"

/obj/structure/closet/secure_closet/reinforced/captains/populate_contents()
	var/list/spawnedAtoms = list()

	spawnedAtoms.Add(new  /obj/item/storage/backpack/captain(NULL))
	spawnedAtoms.Add(new  /obj/item/storage/backpack/satchel/captain(NULL))
	spawnedAtoms.Add(new  /obj/item/clothing/under/rank/captain(NULL))
	spawnedAtoms.Add(new  /obj/item/clothing/suit/storage/captain(NULL))
	spawnedAtoms.Add(new  /obj/item/clothing/suit/armor/vest(NULL))
	spawnedAtoms.Add(new  /obj/item/clothing/head/armor/helmet(NULL))
	spawnedAtoms.Add(new  /obj/item/clothing/shoes/jackboots(NULL))
	spawnedAtoms.Add(new  /obj/item/device/radio/headset/heads/captain(NULL))
	spawnedAtoms.Add(new  /obj/item/clothing/gloves/captain(NULL))
	spawnedAtoms.Add(new  /obj/item/storage/pouch/holster/belt/sheath(NULL))
	spawnedAtoms.Add(new  /obj/item/tool/sword/saber(NULL))
	spawnedAtoms.Add(new  /obj/item/ammo_magazine/magnum/rubber(NULL))
	spawnedAtoms.Add(new  /obj/item/ammo_magazine/magnum/rubber(NULL))
	spawnedAtoms.Add(new  /obj/item/ammo_magazine/magnum/rubber(NULL))
	spawnedAtoms.Add(new  /obj/item/melee/telebaton(NULL))
	spawnedAtoms.Add(new  /obj/item/storage/pouch/holster(NULL))
	for(var/atom/a in spawnedAtoms)
		a.forcemove(src)

/obj/structure/closet/secure_closet/reinforced/hop
	name = "First Officer's locker"
	req_access = list(access_hop)
	icon_state = "hop"

/obj/structure/closet/secure_closet/reinforced/hop/populate_contents()
	var/list/spawnedAtoms = list()

	spawnedAtoms.Add(new  /obj/item/clothing/glasses/sunglasses(NULL))
	spawnedAtoms.Add(new  /obj/item/clothing/under/rank/first_officer(NULL))
	spawnedAtoms.Add(new  /obj/item/clothing/head/caphat/hop(NULL))
	spawnedAtoms.Add(new  /obj/item/clothing/suit/armor/vest(NULL))
	spawnedAtoms.Add(new  /obj/item/clothing/head/armor/helmet(NULL))
	spawnedAtoms.Add(new  /obj/item/device/radio/headset/heads/hop(NULL))
	spawnedAtoms.Add(new  /obj/item/storage/box/ids(NULL))
	spawnedAtoms.Add(new  /obj/item/storage/box/ids(NULL))
	spawnedAtoms.Add(new  /obj/item/storage/pouch/holster/belt/sheath(NULL))
	spawnedAtoms.Add(new  /obj/item/tool/sword/saber(NULL))
	spawnedAtoms.Add(new  /obj/item/ammo_magazine/magnum/rubber(NULL))
	spawnedAtoms.Add(new  /obj/item/ammo_magazine/magnum/rubber(NULL))
	spawnedAtoms.Add(new  /obj/item/ammo_magazine/magnum/rubber(NULL))
	spawnedAtoms.Add(new  /obj/item/device/flash(NULL))
	spawnedAtoms.Add(new  /obj/item/storage/pouch/holster(NULL))
	for(var/atom/a in spawnedAtoms)
		a.forcemove(src)

/obj/structure/closet/secure_closet/reinforced/hos
	name = "Ironhammer Commander locker"
	req_access = list(access_hos)
	icon_state = "hos"

/obj/structure/closet/secure_closet/reinforced/hos/populate_contents()
	var/list/spawnedAtoms = list()

	if(prob(50))
		spawnedAtoms.Add(new  /obj/item/storage/backpack/ironhammer(NULL))
	else
		spawnedAtoms.Add(new  /obj/item/storage/backpack/sport/ironhammer(NULL))
	spawnedAtoms.Add(new  /obj/item/storage/backpack/satchel/ironhammer(NULL))
	spawnedAtoms.Add(new  /obj/item/clothing/head/beret/sec/navy/hos(NULL))
	spawnedAtoms.Add(new  /obj/item/clothing/head/HoS(NULL))
	spawnedAtoms.Add(new  /obj/item/clothing/head/caphat/ihc(NULL))
	spawnedAtoms.Add(new  /obj/item/clothing/mask/gas/ihs(NULL))
	spawnedAtoms.Add(new  /obj/item/clothing/suit/storage/greatcoat/ironhammer(NULL))
	spawnedAtoms.Add(new  /obj/item/clothing/under/rank/ih_commander(NULL))
	spawnedAtoms.Add(new  /obj/item/device/radio/headset/heads/hos(NULL))
	spawnedAtoms.Add(new  /obj/item/clothing/glasses/sunglasses/sechud/tactical(NULL))
	spawnedAtoms.Add(new  /obj/item/storage/belt/tactical/ironhammer(NULL))
	spawnedAtoms.Add(new  /obj/item/clothing/gloves/stungloves(NULL))
	spawnedAtoms.Add(new  /obj/item/cell/medium/high(NULL))
	spawnedAtoms.Add(new  /obj/item/ammo_magazine/magnum/rubber(NULL))
	spawnedAtoms.Add(new  /obj/item/ammo_magazine/magnum/rubber(NULL))
	spawnedAtoms.Add(new  /obj/item/ammo_magazine/magnum/rubber(NULL))
	spawnedAtoms.Add(new  /obj/item/cell/small/high(NULL))
	spawnedAtoms.Add(new  /obj/item/cell/small/high(NULL))
	spawnedAtoms.Add(new  /obj/item/gun/energy/gun/martin(NULL))
	spawnedAtoms.Add(new  /obj/item/clothing/accessory/holster(NULL))
	spawnedAtoms.Add(new  /obj/item/melee/telebaton(NULL))
	spawnedAtoms.Add(new  /obj/item/clothing/accessory/badge/commander(NULL))
	spawnedAtoms.Add(new  /obj/item/storage/pouch/holster(NULL))
	spawnedAtoms.Add(new  /obj/item/storage/pouch/holster/baton(NULL))
	spawnedAtoms.Add(new  /obj/item/flame/lighter/zippo/syndicate(NULL))
	for(var/atom/a in spawnedAtoms)
		a.forcemove(src)

/obj/structure/closet/secure_closet/warden
	name = "Gunnery Sergeant's locker"
	req_access = list(access_armory)
	icon_state = "warden"

/obj/structure/closet/secure_closet/warden/populate_contents()
	var/list/spawnedAtoms = list()

	if(prob(50))
		spawnedAtoms.Add(new  /obj/item/storage/backpack/ironhammer(NULL))
	else
		spawnedAtoms.Add(new  /obj/item/storage/backpack/sport/ironhammer(NULL))
	spawnedAtoms.Add(new  /obj/item/storage/backpack/satchel/ironhammer(NULL))
	spawnedAtoms.Add(new  /obj/item/clothing/under/rank/warden(NULL))
	spawnedAtoms.Add(new  /obj/item/clothing/head/beret/sec/navy/warden(NULL))
	spawnedAtoms.Add(new  /obj/item/device/radio/headset/headset_sec(NULL))
	spawnedAtoms.Add(new  /obj/item/clothing/glasses/sunglasses/sechud/tactical(NULL))
	spawnedAtoms.Add(new  /obj/item/storage/belt/tactical/ironhammer(NULL))
	spawnedAtoms.Add(new  /obj/item/clothing/suit/storage/vest/ironhammer(NULL))
	spawnedAtoms.Add(new  /obj/item/clothing/suit/armor/vest/warden/ironhammer(NULL))
	spawnedAtoms.Add(new  /obj/item/clothing/under/rank/security/turtleneck(NULL))
	spawnedAtoms.Add(new  /obj/item/clothing/mask/gas/ihs(NULL))
	spawnedAtoms.Add(new  /obj/item/storage/box/teargas(NULL))
	spawnedAtoms.Add(new  /obj/item/storage/box/flashbangs(NULL))
	spawnedAtoms.Add(new  /obj/item/ammo_magazine/pistol/rubber(NULL))
	spawnedAtoms.Add(new  /obj/item/ammo_magazine/pistol/rubber(NULL))
	spawnedAtoms.Add(new 	/obj/item/gun/projectile/paco(NULL))
	spawnedAtoms.Add(new  /obj/item/ammo_magazine/ihclrifle/rubber(NULL))
	spawnedAtoms.Add(new  /obj/item/ammo_magazine/ihclrifle/rubber(NULL))
	spawnedAtoms.Add(new  /obj/item/gun/projectile/automatic/sol(NULL))
	spawnedAtoms.Add(new  /obj/item/storage/box/holobadge(NULL))
	spawnedAtoms.Add(new  /obj/item/clothing/accessory/badge/holo/sergeant(NULL))
	spawnedAtoms.Add(new  /obj/item/storage/pouch/holster(NULL))
	spawnedAtoms.Add(new  /obj/item/storage/pouch/holster/baton(NULL))
	spawnedAtoms.Add(new  /obj/item/clothing/suit/armor/vest/ironhammer(NULL))
	for(var/atom/a in spawnedAtoms)
		a.forcemove(src)

/obj/structure/closet/secure_closet/personal/security
	name = "Ironhammer Operative locker"
	req_access = list(access_hos)
	access_occupy = list(access_brig)
	icon_state = "sec"

/obj/structure/closet/secure_closet/personal/security/populate_contents()
	var/list/spawnedAtoms = list()

	if(prob(50))
		spawnedAtoms.Add(new  /obj/item/storage/backpack/ironhammer(NULL))
	else
		spawnedAtoms.Add(new  /obj/item/storage/backpack/sport/ironhammer(NULL))
	spawnedAtoms.Add(new  /obj/item/storage/backpack/satchel/ironhammer(NULL))
	spawnedAtoms.Add(new  /obj/item/device/radio/headset/headset_sec(NULL))
	spawnedAtoms.Add(new  /obj/item/storage/belt/tactical/ironhammer(NULL))
	spawnedAtoms.Add(new  /obj/item/clothing/suit/storage/vest/ironhammer(NULL))
	spawnedAtoms.Add(new  /obj/item/clothing/under/rank/security/turtleneck(NULL))
	spawnedAtoms.Add(new  /obj/item/clothing/mask/gas/ihs(NULL))
	spawnedAtoms.Add(new  /obj/item/clothing/glasses/sunglasses/sechud/tactical(NULL))
	spawnedAtoms.Add(new  /obj/item/ammo_magazine/ihclrifle/rubber(NULL))
	spawnedAtoms.Add(new  /obj/item/ammo_magazine/ihclrifle/rubber(NULL))
	spawnedAtoms.Add(new  /obj/item/gun/projectile/automatic/sol(NULL))
	spawnedAtoms.Add(new  /obj/item/ammo_magazine/pistol/rubber(NULL))
	spawnedAtoms.Add(new  /obj/item/ammo_magazine/pistol/rubber(NULL))
	spawnedAtoms.Add(new 	/obj/item/gun/projectile/paco(NULL))
	spawnedAtoms.Add(new  /obj/item/storage/pouch/holster(NULL))
	spawnedAtoms.Add(new  /obj/item/storage/pouch/holster/baton(NULL))
	spawnedAtoms.Add(new  /obj/item/storage/ration_pack/ihr(NULL))
	for(var/atom/a in spawnedAtoms)
		a.forcemove(src)

/obj/structure/closet/secure_closet/medspec
	name = "Ironhammer Medical Specialist locker"
	req_access = list(access_medspec)
	icon_state = "sec"

/obj/structure/closet/secure_closet/medspec/populate_contents()
	var/list/spawnedAtoms = list()

	spawnedAtoms.Add(new  /obj/item/clothing/glasses/sunglasses/sechud/tactical(NULL))
	spawnedAtoms.Add(new  /obj/item/clothing/mask/gas/ihs(NULL))
	spawnedAtoms.Add(new  /obj/item/taperoll/police(NULL))
	spawnedAtoms.Add(new  /obj/item/clothing/under/rank/medspec(NULL))
	spawnedAtoms.Add(new  /obj/item/device/radio/headset/headset_sec(NULL))
	spawnedAtoms.Add(new  /obj/item/storage/belt/tactical/ironhammer(NULL))
	spawnedAtoms.Add(new  /obj/item/clothing/shoes/reinforced/ironhammer(NULL))
	spawnedAtoms.Add(new  /obj/item/clothing/gloves/stungloves(NULL))
	spawnedAtoms.Add(new  /obj/item/cell/medium/high(NULL))
	spawnedAtoms.Add(new  /obj/item/clothing/suit/storage/toggle/labcoat/medspec(NULL))
	spawnedAtoms.Add(new  /obj/item/ammo_magazine/smg/rubber(NULL))
	spawnedAtoms.Add(new  /obj/item/gun/projectile/automatic/molly(NULL))
	spawnedAtoms.Add(new  /obj/item/clothing/accessory/badge/holo/specialist(NULL))
	spawnedAtoms.Add(new  /obj/item/storage/pouch/holster(NULL))
	spawnedAtoms.Add(new  /obj/item/storage/briefcase/crimekit(NULL))
	for(var/atom/a in spawnedAtoms)
		a.forcemove(src)

/obj/structure/closet/secure_closet/detective
	name = "Ironhammer Inspector locker"
	req_access = list(access_forensics_lockers)
	icon_state = "cabinetdetective"

/obj/structure/closet/secure_closet/detective/populate_contents()
	var/list/spawnedAtoms = list()

	spawnedAtoms.Add(new  /obj/item/clothing/under/rank/det(NULL))
	spawnedAtoms.Add(new  /obj/item/clothing/under/rank/det/black(NULL))
	spawnedAtoms.Add(new  /obj/item/clothing/under/rank/inspector(NULL))
	spawnedAtoms.Add(new  /obj/item/clothing/suit/storage/detective(NULL))
	spawnedAtoms.Add(new  /obj/item/clothing/suit/storage/detective/brown(NULL))
	spawnedAtoms.Add(new  /obj/item/clothing/suit/storage/detective/black(NULL))
	spawnedAtoms.Add(new  /obj/item/clothing/mask/gas/ihs(NULL))
	spawnedAtoms.Add(new  /obj/item/clothing/gloves/thick(NULL))
	spawnedAtoms.Add(new  /obj/item/clothing/head/detective(NULL))
	spawnedAtoms.Add(new  /obj/item/clothing/head/detective/grey(NULL))
	spawnedAtoms.Add(new  /obj/item/clothing/head/detective/black(NULL))
	spawnedAtoms.Add(new  /obj/item/clothing/shoes/reinforced/ironhammer(NULL))
	spawnedAtoms.Add(new  /obj/item/storage/box/evidence(NULL))
	spawnedAtoms.Add(new  /obj/item/device/radio/headset/headset_sec(NULL))
	spawnedAtoms.Add(new  /obj/item/storage/belt/tactical/ironhammer(NULL))
	spawnedAtoms.Add(new  /obj/item/clothing/suit/armor/vest/detective(NULL))
	spawnedAtoms.Add(new  /obj/item/taperoll/police(NULL))
	spawnedAtoms.Add(new  /obj/item/clothing/glasses/sunglasses/sechud/tactical(NULL))
	spawnedAtoms.Add(new  /obj/item/cell/small/high(NULL))
	spawnedAtoms.Add(new  /obj/item/cell/small/high(NULL))
	spawnedAtoms.Add(new  /obj/item/device/taperecorder(NULL))
	spawnedAtoms.Add(new  /obj/item/gun/projectile/revolver/consul(NULL))
	spawnedAtoms.Add(new  /obj/item/clothing/accessory/holster(NULL))
	spawnedAtoms.Add(new  /obj/item/ammo_magazine/slmagnum/rubber(NULL))
	spawnedAtoms.Add(new  /obj/item/ammo_magazine/slmagnum/rubber(NULL))
	spawnedAtoms.Add(new  /obj/item/ammo_magazine/slmagnum/rubber(NULL))
	spawnedAtoms.Add(new  /obj/item/storage/pouch/holster(NULL))
	spawnedAtoms.Add(new  /obj/item/clothing/accessory/badge/inspector(NULL))
	spawnedAtoms.Add(new  /obj/item/storage/briefcase/crimekit(NULL))
	spawnedAtoms.Add(new  /obj/item/storage/box/syndie_kit/spy(NULL))
	for(var/atom/a in spawnedAtoms)
		a.forcemove(src)

/obj/structure/closet/secure_closet/injection
	name = "lethal injections locker"
	req_access = list(access_captain)
	icon_state = "secure"

/obj/structure/closet/secure_closet/injection/populate_contents()
	var/list/spawnedAtoms = list()

	spawnedAtoms.Add(new  /obj/item/reagent_containers/syringe/ld50_syringe/chlorine(NULL))
	spawnedAtoms.Add(new  /obj/item/reagent_containers/syringe/ld50_syringe/chlorine(NULL))
	for(var/atom/a in spawnedAtoms)
		a.forcemove(src)

/obj/structure/closet/secure_closet/brig
	name = "brig locker"
	req_access = list(access_brig)
	anchored = TRUE
	icon_state = "secure"
	var/id

/obj/structure/closet/secure_closet/brig/populate_contents()
	var/list/spawnedAtoms = list()

	spawnedAtoms.Add(new  /obj/item/clothing/under/color/orange(NULL))
	spawnedAtoms.Add(new  /obj/item/clothing/shoes/color/orange(NULL))
	for(var/atom/a in spawnedAtoms)
		a.forcemove(src)

/obj/structure/closet/secure_closet/courtroom
	name = "courtroom locker"
	req_access = list(access_security)
	icon_state = "sec"

/obj/structure/closet/secure_closet/courtroom/populate_contents()
	var/list/spawnedAtoms = list()

	spawnedAtoms.Add(new  /obj/item/clothing/shoes/color/brown(NULL))
	spawnedAtoms.Add(new  /obj/item/paper/court(NULL))
	spawnedAtoms.Add(new  /obj/item/paper/court(NULL))
	spawnedAtoms.Add(new  /obj/item/paper/court(NULL))
	spawnedAtoms.Add(new  /obj/item/pen(NULL))
	spawnedAtoms.Add(new  /obj/item/clothing/suit/judgerobe(NULL))
	spawnedAtoms.Add(new  /obj/item/clothing/head/powdered_wig(NULL))
	spawnedAtoms.Add(new  /obj/item/storage/briefcase(NULL))
	for(var/atom/a in spawnedAtoms)
		a.forcemove(src)
