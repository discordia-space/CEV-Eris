/obj/structure/closet/secure_closet/reinforced/captains
	name = "captain's locker"
	req_access = list(access_captain)
	icon_state = "cap"

/obj/structure/closet/secure_closet/reinforced/captains/populate_contents()
	var/list/spawnedAtoms = list()

	spawnedAtoms.Add(new  /obj/item/storage/backpack/captain(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/storage/backpack/satchel/captain(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/clothing/under/rank/captain(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/clothing/suit/storage/captain(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/clothing/suit/armor/vest(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/clothing/head/armor/helmet(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/clothing/shoes/jackboots(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/device/radio/headset/heads/captain(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/clothing/gloves/captain(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/storage/pouch/holster/belt/sheath(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/tool/sword/saber(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/ammo_magazine/magnum/rubber(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/ammo_magazine/magnum/rubber(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/ammo_magazine/magnum/rubber(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/melee/telebaton(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/storage/pouch/holster(NULLSPACE))
	for(var/atom/movable/a in spawnedAtoms)
		a.forceMove(src)

/obj/structure/closet/secure_closet/reinforced/hop
	name = "First Officer's locker"
	req_access = list(access_hop)
	icon_state = "hop"

/obj/structure/closet/secure_closet/reinforced/hop/populate_contents()
	var/list/spawnedAtoms = list()

	spawnedAtoms.Add(new  /obj/item/clothing/glasses/sunglasses(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/clothing/under/rank/first_officer(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/clothing/head/caphat/hop(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/clothing/suit/armor/vest(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/clothing/head/armor/helmet(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/device/radio/headset/heads/hop(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/storage/box/ids(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/storage/box/ids(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/storage/pouch/holster/belt/sheath(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/tool/sword/saber(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/ammo_magazine/magnum/rubber(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/ammo_magazine/magnum/rubber(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/ammo_magazine/magnum/rubber(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/device/flash(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/storage/pouch/holster(NULLSPACE))
	for(var/atom/movable/a in spawnedAtoms)
		a.forceMove(src)

/obj/structure/closet/secure_closet/reinforced/hos
	name = "Ironhammer Commander locker"
	req_access = list(access_hos)
	icon_state = "hos"

/obj/structure/closet/secure_closet/reinforced/hos/populate_contents()
	var/list/spawnedAtoms = list()

	if(prob(50))
		spawnedAtoms.Add(new  /obj/item/storage/backpack/ironhammer(NULLSPACE))
	else
		spawnedAtoms.Add(new  /obj/item/storage/backpack/sport/ironhammer(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/storage/backpack/satchel/ironhammer(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/clothing/head/beret/sec/navy/hos(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/clothing/head/HoS(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/clothing/head/caphat/ihc(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/clothing/mask/gas/ihs(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/clothing/suit/storage/greatcoat/ironhammer(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/clothing/under/rank/ih_commander(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/device/radio/headset/heads/hos(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/clothing/glasses/sunglasses/sechud/tactical(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/storage/belt/tactical/ironhammer(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/clothing/gloves/stungloves(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/cell/medium/high(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/ammo_magazine/magnum/rubber(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/ammo_magazine/magnum/rubber(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/ammo_magazine/magnum/rubber(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/cell/small/high(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/cell/small/high(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/gun/energy/gun/martin(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/clothing/accessory/holster(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/melee/telebaton(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/clothing/accessory/badge/commander(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/storage/pouch/holster(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/storage/pouch/holster/baton(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/flame/lighter/zippo/syndicate(NULLSPACE))
	for(var/atom/movable/a in spawnedAtoms)
		a.forceMove(src)

/obj/structure/closet/secure_closet/warden
	name = "Gunnery Sergeant's locker"
	req_access = list(access_armory)
	icon_state = "warden"

/obj/structure/closet/secure_closet/warden/populate_contents()
	var/list/spawnedAtoms = list()

	if(prob(50))
		spawnedAtoms.Add(new  /obj/item/storage/backpack/ironhammer(NULLSPACE))
	else
		spawnedAtoms.Add(new  /obj/item/storage/backpack/sport/ironhammer(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/storage/backpack/satchel/ironhammer(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/clothing/under/rank/warden(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/clothing/head/beret/sec/navy/warden(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/device/radio/headset/headset_sec(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/clothing/glasses/sunglasses/sechud/tactical(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/storage/belt/tactical/ironhammer(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/clothing/suit/storage/vest/ironhammer(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/clothing/suit/armor/vest/warden/ironhammer(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/clothing/under/rank/security/turtleneck(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/clothing/mask/gas/ihs(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/storage/box/teargas(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/storage/box/flashbangs(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/ammo_magazine/pistol/rubber(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/ammo_magazine/pistol/rubber(NULLSPACE))
	spawnedAtoms.Add(new 	/obj/item/gun/projectile/paco(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/ammo_magazine/ihclrifle/rubber(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/ammo_magazine/ihclrifle/rubber(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/gun/projectile/automatic/sol(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/storage/box/holobadge(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/clothing/accessory/badge/holo/sergeant(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/storage/pouch/holster(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/storage/pouch/holster/baton(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/clothing/suit/armor/vest/ironhammer(NULLSPACE))
	for(var/atom/movable/a in spawnedAtoms)
		a.forceMove(src)

/obj/structure/closet/secure_closet/personal/security
	name = "Ironhammer Operative locker"
	req_access = list(access_hos)
	access_occupy = list(access_brig)
	icon_state = "sec"

/obj/structure/closet/secure_closet/personal/security/populate_contents()
	var/list/spawnedAtoms = list()

	if(prob(50))
		spawnedAtoms.Add(new  /obj/item/storage/backpack/ironhammer(NULLSPACE))
	else
		spawnedAtoms.Add(new  /obj/item/storage/backpack/sport/ironhammer(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/storage/backpack/satchel/ironhammer(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/device/radio/headset/headset_sec(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/storage/belt/tactical/ironhammer(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/clothing/suit/storage/vest/ironhammer(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/clothing/under/rank/security/turtleneck(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/clothing/mask/gas/ihs(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/clothing/glasses/sunglasses/sechud/tactical(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/ammo_magazine/ihclrifle/rubber(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/ammo_magazine/ihclrifle/rubber(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/gun/projectile/automatic/sol(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/ammo_magazine/pistol/rubber(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/ammo_magazine/pistol/rubber(NULLSPACE))
	spawnedAtoms.Add(new 	/obj/item/gun/projectile/paco(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/storage/pouch/holster(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/storage/pouch/holster/baton(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/storage/ration_pack/ihr(NULLSPACE))
	for(var/atom/movable/a in spawnedAtoms)
		a.forceMove(src)

/obj/structure/closet/secure_closet/medspec
	name = "Ironhammer Medical Specialist locker"
	req_access = list(access_medspec)
	icon_state = "sec"

/obj/structure/closet/secure_closet/medspec/populate_contents()
	var/list/spawnedAtoms = list()

	spawnedAtoms.Add(new  /obj/item/clothing/glasses/sunglasses/sechud/tactical(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/clothing/mask/gas/ihs(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/taperoll/police(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/clothing/under/rank/medspec(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/device/radio/headset/headset_sec(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/storage/belt/tactical/ironhammer(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/clothing/shoes/reinforced/ironhammer(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/clothing/gloves/stungloves(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/cell/medium/high(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/clothing/suit/storage/toggle/labcoat/medspec(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/ammo_magazine/smg/rubber(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/gun/projectile/automatic/molly(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/clothing/accessory/badge/holo/specialist(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/storage/pouch/holster(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/storage/briefcase/crimekit(NULLSPACE))
	for(var/atom/movable/a in spawnedAtoms)
		a.forceMove(src)

/obj/structure/closet/secure_closet/detective
	name = "Ironhammer Inspector locker"
	req_access = list(access_forensics_lockers)
	icon_state = "cabinetdetective"

/obj/structure/closet/secure_closet/detective/populate_contents()
	var/list/spawnedAtoms = list()

	spawnedAtoms.Add(new  /obj/item/clothing/under/rank/det(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/clothing/under/rank/det/black(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/clothing/under/rank/inspector(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/clothing/suit/storage/detective(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/clothing/suit/storage/detective/brown(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/clothing/suit/storage/detective/black(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/clothing/mask/gas/ihs(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/clothing/gloves/thick(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/clothing/head/detective(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/clothing/head/detective/grey(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/clothing/head/detective/black(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/clothing/shoes/reinforced/ironhammer(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/storage/box/evidence(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/device/radio/headset/headset_sec(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/storage/belt/tactical/ironhammer(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/clothing/suit/armor/vest/detective(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/taperoll/police(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/clothing/glasses/sunglasses/sechud/tactical(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/cell/small/high(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/cell/small/high(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/device/taperecorder(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/gun/projectile/revolver/consul(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/clothing/accessory/holster(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/ammo_magazine/slmagnum/rubber(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/ammo_magazine/slmagnum/rubber(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/ammo_magazine/slmagnum/rubber(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/storage/pouch/holster(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/clothing/accessory/badge/inspector(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/storage/briefcase/crimekit(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/storage/box/syndie_kit/spy(NULLSPACE))
	for(var/atom/movable/a in spawnedAtoms)
		a.forceMove(src)

/obj/structure/closet/secure_closet/injection
	name = "lethal injections locker"
	req_access = list(access_captain)
	icon_state = "secure"

/obj/structure/closet/secure_closet/injection/populate_contents()
	var/list/spawnedAtoms = list()

	spawnedAtoms.Add(new  /obj/item/reagent_containers/syringe/ld50_syringe/chlorine(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/reagent_containers/syringe/ld50_syringe/chlorine(NULLSPACE))
	for(var/atom/movable/a in spawnedAtoms)
		a.forceMove(src)

/obj/structure/closet/secure_closet/brig
	name = "brig locker"
	req_access = list(access_brig)
	anchored = TRUE
	icon_state = "secure"
	var/id

/obj/structure/closet/secure_closet/brig/populate_contents()
	var/list/spawnedAtoms = list()

	spawnedAtoms.Add(new  /obj/item/clothing/under/color/orange(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/clothing/shoes/color/orange(NULLSPACE))
	for(var/atom/movable/a in spawnedAtoms)
		a.forceMove(src)

/obj/structure/closet/secure_closet/courtroom
	name = "courtroom locker"
	req_access = list(access_security)
	icon_state = "sec"

/obj/structure/closet/secure_closet/courtroom/populate_contents()
	var/list/spawnedAtoms = list()

	spawnedAtoms.Add(new  /obj/item/clothing/shoes/color/brown(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/paper/court(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/paper/court(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/paper/court(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/pen(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/clothing/suit/judgerobe(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/clothing/head/powdered_wig(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/storage/briefcase(NULLSPACE))
	for(var/atom/movable/a in spawnedAtoms)
		a.forceMove(src)
