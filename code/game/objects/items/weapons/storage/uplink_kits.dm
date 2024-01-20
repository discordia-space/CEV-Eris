/obj/item/storage/box/syndicate
	spawn_blacklisted = TRUE

/obj/item/storage/box/syndicate/populate_contents()
	var/list/spawnedAtoms = list()

	switch(pickweight(list("bloodyspai" = 1, "stealth" = 1, "screwed" = 1, "guns" = 1, "murder" = 1, "freedom" = 1, "hacker" = 1, "smoothoperator" = 1)))
		if("bloodyspai")
			spawnedAtoms.Add(new /obj/item/clothing/under/chameleon(NULLSPACE))
			spawnedAtoms.Add(new /obj/item/clothing/mask/chameleon/voice(NULLSPACE))
			spawnedAtoms.Add(new /obj/item/card/id/syndicate(NULLSPACE))
			spawnedAtoms.Add(new /obj/item/clothing/shoes/syndigaloshes(NULLSPACE))

		if("stealth")
			spawnedAtoms.Add(new /obj/item/gun/energy/crossbow(NULLSPACE))
			spawnedAtoms.Add(new /obj/item/pen/reagent/paralysis(NULLSPACE))
			spawnedAtoms.Add(new /obj/item/device/chameleon(NULLSPACE))

		if("screwed")
			spawnedAtoms.Add(new /obj/effect/spawner/newbomb/timer/syndicate(NULLSPACE))
			spawnedAtoms.Add(new /obj/effect/spawner/newbomb/timer/syndicate(NULLSPACE))
			spawnedAtoms.Add(new /obj/item/device/powersink(NULLSPACE))
			spawnedAtoms.Add(new /obj/item/clothing/suit/space/syndicate/uplink(NULLSPACE))
			spawnedAtoms.Add(new /obj/item/clothing/head/space/syndicate/uplink(NULLSPACE))
			spawnedAtoms.Add(new /obj/item/clothing/mask/gas/syndicate(NULLSPACE))
			spawnedAtoms.Add(new /obj/item/tank/emergency_oxygen/double(NULLSPACE))

		if("guns")
			spawnedAtoms.Add(new /obj/item/gun/projectile/revolver(NULLSPACE))
			spawnedAtoms.Add(new /obj/item/ammo_magazine/slmagnum(NULLSPACE))
			spawnedAtoms.Add(new /obj/item/card/emag(NULLSPACE))
			spawnedAtoms.Add(new /obj/item/plastique(NULLSPACE))
			spawnedAtoms.Add(new /obj/item/plastique(NULLSPACE))

		if("murder")
			spawnedAtoms.Add(new /obj/item/melee/energy/sword(NULLSPACE))
			spawnedAtoms.Add(new /obj/item/clothing/glasses/powered/thermal/syndi(NULLSPACE))
			spawnedAtoms.Add(new /obj/item/card/emag(NULLSPACE))
			spawnedAtoms.Add(new /obj/item/clothing/shoes/syndigaloshes(NULLSPACE))

		if("freedom")
			var/obj/item/implanter/O = spawnedAtoms.Add(new /obj/item/implanter(NULLSPACE))
			O.implant = new /obj/item/implant/freedom(O)
			var/obj/item/implanter/U = spawnedAtoms.Add(new /obj/item/implanter(NULLSPACE))
			U.implant = new /obj/item/implant/uplink(U)

		if("hacker")
			spawnedAtoms.Add(new /obj/item/device/encryptionkey/syndicate(NULLSPACE))
			spawnedAtoms.Add(new /obj/item/electronics/ai_module/syndicate(NULLSPACE))
			spawnedAtoms.Add(new /obj/item/card/emag(NULLSPACE))
			spawnedAtoms.Add(new /obj/item/device/encryptionkey/binary(NULLSPACE))

		if("smoothoperator")
			spawnedAtoms.Add(new /obj/item/storage/box/syndie_kit/pistol(NULLSPACE))
			spawnedAtoms.Add(new /obj/item/storage/bag/trash(NULLSPACE))
			spawnedAtoms.Add(new /obj/item/soap/syndie(NULLSPACE))
			spawnedAtoms.Add(new /obj/item/bodybag(NULLSPACE))
			spawnedAtoms.Add(new /obj/item/clothing/shoes/reinforced(NULLSPACE))

	for(var/atom/movable/a in spawnedAtoms)
		a.forceMove(src)

/obj/item/storage/box/syndie_kit
	desc = "A sleek, sturdy box. This one is using state of the art folding to hold more inside!"
	max_storage_space = DEFAULT_NORMAL_STORAGE //bigger so they hold their gear!
	icon_state = "box_of_doom"
	illustration = "writing_of_doom"
	bad_type = /obj/item/storage/box/syndie_kit
	prespawned_content_amount = 1
	description_antag = "Can be folded into a non-identifiable cardboard while holding another item in the another hand."
	spawn_blacklisted = TRUE

/obj/item/storage/box/syndie_kit/imp_freedom
	name = "boxed freedom implant (with injector)"
	desc = "A box with freedom implant inside. Install it in your hand or leg, chose emote. You can remove instantly handcuffs or legcuffs with your emotion. Have a small amount of uses."
	prespawned_content_type = /obj/item/implanter/freedom

/obj/item/storage/box/syndie_kit/imp_compress
	name = "box (C)"
	desc = "A box with compressed implanter inside. Choose an item with this implant, install it inside you and choose emote to activate it. Take your chosen item whenever you want by your chosen emotion. One use."
	prespawned_content_type = /obj/item/implanter/compressed

/obj/item/storage/box/syndie_kit/imp_explosive
	name = "box (E)"
	desc = "A box with explosive implant inside. When you use it on yours enemy, you can choose three ways to use it: destroy limb, destroy your enemy or make a small explosion. Activation by phrase you choose too. One use."
	prespawned_content_type = /obj/item/implanter/explosive

/obj/item/storage/box/syndie_kit/imp_spying
	name = "box (S)"
	desc = "A box with spying implanter inside. Implant your contract target with it and wait 1 minute for the confirmation."
	prespawned_content_type = /obj/item/implanter/spying

/obj/item/storage/box/syndie_kit/imp_uplink
	name = "boxed uplink implant (with injector)"
	desc = "Uplink inside your head."

/obj/item/storage/box/syndie_kit/imp_uplink/populate_contents()
	//Turn off passive gain for boxed implant uplinks. To prevent exploits of gathering tons of free TC
	var/list/spawnedAtoms = list()

	var/obj/item/implanter/uplink/U1 = spawnedAtoms.Add(new /obj/item/implanter/uplink(NULLSPACE))
	var/obj/item/implant/uplink/U2 = locate(/obj/item/implant/uplink) in U1
	var/obj/item/device/uplink/hidden/U3 = locate(/obj/item/device/uplink/hidden) in U2
	U3.passive_gain = 0
	for(var/atom/movable/a in spawnedAtoms)
		a.forceMove(src)

/obj/item/storage/box/syndie_kit/space
	name = "boxed voidsuit"

/obj/item/storage/box/syndie_kit/space/populate_contents()
	var/list/spawnedAtoms = list()

	spawnedAtoms.Add(new /obj/item/clothing/suit/space/void/merc/boxed(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/clothing/mask/gas/syndicate(NULLSPACE))
	for(var/atom/movable/a in spawnedAtoms)
		a.forceMove(src)

/obj/item/storage/box/syndie_kit/mercarmor
	name = "boxed mercenary armor"
	desc = "A sleek, sturdy box. This one contains a full set of tan mercenary combat gear - a helmet and full-body vest."

/obj/item/storage/box/syndie_kit/mercarmor/populate_contents()
	var/list/spawnedAtoms = list()

	spawnedAtoms.Add(new /obj/item/clothing/suit/storage/vest/merc/full(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/clothing/head/armor/helmet/merchelm(NULLSPACE))
	for(var/atom/movable/a in spawnedAtoms)
		a.forceMove(src)

/obj/item/storage/box/syndie_kit/softsuit
	name = "boxed soft suit"

/obj/item/storage/box/syndie_kit/softsuit/populate_contents()
	var/list/spawnedAtoms = list()

	spawnedAtoms.Add(new /obj/item/clothing/suit/space/syndicate/uplink(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/clothing/head/space/syndicate/uplink(NULLSPACE))
	for(var/atom/movable/a in spawnedAtoms)
		a.forceMove(src)

/obj/item/storage/backpack/chameleon/populate_contents()
	var/list/spawnedAtoms = list()

	spawnedAtoms.Add(new /obj/item/clothing/under/chameleon(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/clothing/head/chameleon(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/clothing/suit/chameleon(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/clothing/shoes/chameleon(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/clothing/gloves/chameleon(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/clothing/mask/chameleon(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/clothing/glasses/chameleon(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/gun/energy/chameleon(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/device/radio/headset/chameleon(NULLSPACE))
	for(var/atom/movable/a in spawnedAtoms)
		a.forceMove(src)

/obj/item/storage/box/syndie_kit/clerical
	name = "clerical kit"
	desc = "Comes with all you need to fake paperwork. Assumes you have passed basic writing lessons."

/obj/item/storage/box/syndie_kit/clerical/populate_contents()
	var/list/spawnedAtoms = list()

	spawnedAtoms.Add(new /obj/item/stamp/chameleon(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/pen/chameleon(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/device/destTagger(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/packageWrap(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/hand_labeler(NULLSPACE))
	for(var/atom/movable/a in spawnedAtoms)
		a.forceMove(src)

/obj/item/storage/box/syndie_kit/spy
	name = "spy kit"
	desc = "For when you want to conduct voyeurism from afar."

/obj/item/storage/box/syndie_kit/spy/populate_contents()
	var/list/spawnedAtoms = list()

	spawnedAtoms.Add(new /obj/item/device/spy_bug(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/device/spy_bug(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/device/spy_bug(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/device/spy_bug(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/device/spy_bug(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/device/spy_bug(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/device/spy_monitor(NULLSPACE))
	for(var/atom/movable/a in spawnedAtoms)
		a.forceMove(src)



// Guns
/obj/item/storage/box/syndie_kit/dartgun
	name  = "dartgun kit"
	desc = "Just like a mosquito bite."

/obj/item/storage/box/syndie_kit/dartgun/populate_contents()
	var/list/spawnedAtoms = list()

	spawnedAtoms.Add(new /obj/item/gun/projectile/dartgun(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/ammo_magazine/chemdart(NULLSPACE))
	for(var/atom/movable/a in spawnedAtoms)
		a.forceMove(src)


/obj/item/storage/box/syndie_kit/pistol
	name = "smooth operator"
	desc = ".25 Caseless handgun with a single magazine and pocket holster for easy consealment."

/obj/item/storage/box/syndie_kit/pistol/populate_contents()
	var/list/spawnedAtoms = list()

	spawnedAtoms.Add(new /obj/item/gun/projectile/mandella(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/ammo_magazine/cspistol(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/storage/pouch/holster(NULLSPACE))
	for(var/atom/movable/a in spawnedAtoms)
		a.forceMove(src)

/obj/item/storage/box/syndie_kit/c20r
	name = "C-20r box"
	desc = "C-20r kit"

/obj/item/storage/box/syndie_kit/c20r/populate_contents()
	var/list/spawnedAtoms = list()

	spawnedAtoms.Add(new /obj/item/gun/projectile/automatic/c20r(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/ammo_magazine/smg(NULLSPACE))
	for(var/atom/movable/a in spawnedAtoms)
		a.forceMove(src)

/obj/item/storage/box/syndie_kit/revolver
	name = "revolver box"
	desc = "Revolver kit"

/obj/item/storage/box/syndie_kit/revolver/populate_contents()
	var/list/spawnedAtoms = list()

	spawnedAtoms.Add(new /obj/item/gun/projectile/revolver(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/ammo_magazine/slmagnum(NULLSPACE))
	for(var/atom/movable/a in spawnedAtoms)
		a.forceMove(src)

/obj/item/storage/box/syndie_kit/hornet
	name = "revolver box"
	desc = "Revolver kit"

/obj/item/storage/box/syndie_kit/hornet/populate_contents()
	var/list/spawnedAtoms = list()

	spawnedAtoms.Add(new /obj/item/gun/projectile/revolver/hornet(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/ammo_magazine/slsrifle_rev(NULLSPACE))
	for(var/atom/movable/a in spawnedAtoms)
		a.forceMove(src)

/obj/item/storage/box/syndie_kit/sts35
	name = "assault rifle box"
	desc = "Assault rifle kit"
	icon_state = "box_of_doom_big"
	volumeClass = ITEM_SIZE_HUGE

/obj/item/storage/box/syndie_kit/sts35/populate_contents()
	var/list/spawnedAtoms = list()

	spawnedAtoms.Add(new /obj/item/gun/projectile/automatic/sts35(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/ammo_magazine/lrifle(NULLSPACE))
	for(var/atom/movable/a in spawnedAtoms)
		a.forceMove(src)

/obj/item/storage/box/syndie_kit/winchester
	name = "lever-action rifle box"
	desc = "A suspicious looking box containing a lever-action rifle and some spare ammo to it."
	icon_state = "box_of_doom_big"
	volumeClass = ITEM_SIZE_HUGE

/obj/item/storage/box/syndie_kit/winchester/populate_contents()
	var/list/spawnedAtoms = list()

	spawnedAtoms.Add(new /obj/item/gun/projectile/boltgun/levergun(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/ammo_magazine/slmagnum(NULLSPACE))
	for(var/atom/movable/a in spawnedAtoms)
		a.forceMove(src)

/obj/item/storage/box/syndie_kit/lshotgun
	name = "lever shotgun box"
	desc = "lever-action shotgun kit"
	icon_state = "box_of_doom_big"
	volumeClass = ITEM_SIZE_HUGE

/obj/item/storage/box/syndie_kit/lshotgun/populate_contents()
	var/list/spawnedAtoms = list()

	spawnedAtoms.Add(new /obj/item/gun/projectile/boltgun/levergun/shotgun(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/ammo_casing/shotgun/prespawned(NULLSPACE))
	for(var/atom/movable/a in spawnedAtoms)
		a.forceMove(src)

 /obj/item/storage/box/syndie_kit/pug
	name = "pug box"
	desc = "Pug kit with one M12 buckshot mag"
	icon_state = "box_of_doom_big"
	volumeClass = ITEM_SIZE_HUGE

/obj/item/storage/box/syndie_kit/pug/populate_contents()
	var/list/spawnedAtoms = list()

	spawnedAtoms.Add(new /obj/item/gun/projectile/shotgun/bojevic(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/ammo_magazine/m12/pellet(NULLSPACE))
	for(var/atom/movable/a in spawnedAtoms)
		a.forceMove(src)

/obj/item/storage/briefcase/antimaterial_rifle
	desc = "An ominous leather briefcase that has the unmistakeable smell of old, stale cigarette smoke, and gives those who look at it a bad feeling."
	spawn_blacklisted = TRUE

/obj/item/storage/briefcase/antimaterial_rifle/populate_contents()
	var/list/spawnedAtoms = list()

	spawnedAtoms.Add(new /obj/item/ammo_casing/antim(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/part/gun/frame/heavysniper(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/part/gun/modular/grip/serb(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/part/gun/modular/mechanism/boltgun(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/part/gun/modular/barrel/antim(NULLSPACE))
	for(var/atom/movable/a in spawnedAtoms)
		a.forceMove(src)

/obj/item/storage/box/syndie_kit/toxin
	name = "toxin kit"
	desc = "An apple will not be enough to keep the doctor away after this."

/obj/item/storage/box/syndie_kit/toxin/populate_contents()
	var/list/spawnedAtoms = list()

	spawnedAtoms.Add(new /obj/item/reagent_containers/glass/beaker/vial/random/toxin(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/reagent_containers/glass/beaker/vial/random/toxin(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/reagent_containers/glass/beaker/vial/random/toxin(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/reagent_containers/glass/beaker/vial/random/toxin(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/reagent_containers/glass/beaker/vial/random/toxin(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/reagent_containers/glass/beaker/vial/random/toxin(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/reagent_containers/syringe(NULLSPACE))
	for(var/atom/movable/a in spawnedAtoms)
		a.forceMove(src)

/obj/item/storage/box/syndie_kit/cigarette
	name = "\improper Tricky smokes"
	desc = "Comes with the following brands of cigarettes, in this order: 2xFlash, 2xSmoke, 1xMindBreaker, 1xTricordrazine. Avoid mixing them up."

/obj/item/storage/box/syndie_kit/cigarette/populate_contents()
	var/list/spawnedAtoms = list()

	var/obj/item/storage/fancy/cigarettes/pack
	pack = spawnedAtoms.Add(new /obj/item/storage/fancy/cigarettes(NULLSPACE))
	fill_cigarre_package(pack, list("aluminum" = 5, "potassium" = 5, "sulfur" = 5))
	pack.desc += " 'F' has been scribbled on it."

	pack = spawnedAtoms.Add(new /obj/item/storage/fancy/cigarettes(NULLSPACE))
	fill_cigarre_package(pack, list("aluminum" = 5, "potassium" = 5, "sulfur" = 5))
	pack.desc += " 'F' has been scribbled on it."

	pack = spawnedAtoms.Add(new /obj/item/storage/fancy/cigarettes(NULLSPACE))
	fill_cigarre_package(pack, list("potassium" = 5, "sugar" = 5, "phosphorus" = 5))
	pack.desc += " 'S' has been scribbled on it."

	pack = spawnedAtoms.Add(new /obj/item/storage/fancy/cigarettes(NULLSPACE))
	fill_cigarre_package(pack, list("potassium" = 5, "sugar" = 5, "phosphorus" = 5))
	pack.desc += " 'S' has been scribbled on it."

	pack = spawnedAtoms.Add(new /obj/item/storage/fancy/cigarettes(NULLSPACE))
	// Dylovene. Going with 1.5 rather than 1.6666666...
	fill_cigarre_package(pack, list("potassium" = 1.5, "nitrogen" = 1.5, "silicon" = 1.5))
	// Mindbreaker
	fill_cigarre_package(pack, list("silicon" = 4.5))

	pack.desc += " 'MB' has been scribbled on it."

	pack = spawnedAtoms.Add(new /obj/item/storage/fancy/cigarettes(NULLSPACE))
	pack.reagents.add_reagent("tricordrazine", 15 * pack.storage_slots)
	pack.desc += " 'T' has been scribbled on it."

	spawnedAtoms.Add(new /obj/item/flame/lighter/zippo(NULLSPACE))
	for(var/atom/movable/a in spawnedAtoms)
		a.forceMove(src)

/proc/fill_cigarre_package(obj/item/storage/fancy/cigarettes/C, list/reagents)
	for(var/reagent in reagents)
		C.reagents.add_reagent(reagent, reagents[reagent] * C.storage_slots)

/obj/item/storage/box/syndie_kit/ewar_voice
	name = "electrowarfare and voice synthesiser kit"
	desc = "Kit for confounding organic and synthetic entities alike."

/obj/item/storage/box/syndie_kit/ewar_voice/populate_contents()
	var/list/spawnedAtoms = list()

	spawnedAtoms.Add(new /obj/item/rig_module/electrowarfare_suite(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/rig_module/voice(NULLSPACE))
	for(var/atom/movable/a in spawnedAtoms)
		a.forceMove(src)

/obj/item/storage/box/syndie_kit/spy_sensor
	name = "sensor kit"
	prespawned_content_amount = 4
	prespawned_content_type = /obj/item/device/spy_sensor

/obj/item/storage/secure/briefcase/money
	name = "secure briefcase"
	desc = "A large briefcase with a digital locking system."
	prespawned_content_amount = 10
	prespawned_content_type = /obj/item/spacecash/bundle/c1000

/obj/item/storage/box/syndie_kit/randomstim
	name = "5 Random Stims Kit"
	desc = "Contain 5 random Stim Syringes."
	storage_slots = 5

/obj/item/storage/box/syndie_kit/randomstim/populate_contents()
	var/list/spawnedAtoms = list()

	for(var/i, i < storage_slots , i++)
		var/stim = pick(subtypesof(/obj/item/reagent_containers/syringe/stim))
		spawnedAtoms.Add(new stim(NULLSPACE))

	for(var/atom/movable/a in spawnedAtoms)
		a.forceMove(src)

/obj/item/storage/box/syndie_kit/pickle
	name = "Pickle box"
	desc = "Pickle."
	icon_state = "box_of_doom_big"
	volumeClass = ITEM_SIZE_HUGE
	prespawned_content_type = /obj/item/reagent_containers/food/snacks/pickle

/obj/item/storage/box/syndie_kit/gentleman_kit
	name = "\improper Gentleman's Kit"
	desc = "Cane with hidden sword and white insulated gloves."

/obj/item/storage/box/syndie_kit/gentleman_kit/populate_contents()
	var/list/spawnedAtoms = list()

	spawnedAtoms.Add(new /obj/item/tool/cane/concealed(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/clothing/gloves/color/white/insulated(NULLSPACE))
	for(var/atom/movable/a in spawnedAtoms)
		a.forceMove(src)

/obj/item/storage/box/syndie_kit/cleanup_kit
	name = "\improper Crime Scene Cleanup Kit"
	desc = "Say good-fucking-bye to the evidence."

/obj/item/storage/box/syndie_kit/cleanup_kit/populate_contents()
	var/list/spawnedAtoms = list()

	spawnedAtoms.Add(new /obj/item/soap/syndie(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/bodybag/expanded(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/grenade/chem_grenade/cleaner(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/reagent_containers/spray/cleaner(NULLSPACE))
	for(var/atom/movable/a in spawnedAtoms)
		a.forceMove(src)

/obj/item/storage/box/syndie_kit/slmagnum
	name = ".40 speedloader box"
	desc = "Contains 3 .40 speedloaders."
	prespawned_content_amount = 3
	prespawned_content_type = /obj/item/ammo_magazine/slmagnum

/obj/item/storage/box/syndie_kit/slmagnum/highvelocity
	name = ".40 HV speedloader box"
	desc = "Contains 3 .40 HV speedloaders."
	prespawned_content_amount = 3
	prespawned_content_type = /obj/item/ammo_magazine/slmagnum/highvelocity

/obj/item/storage/box/syndie_kit/slpistol
	name = ".35 speedloaders box"
	desc = "Contains 3 .35 speedloaders."
	prespawned_content_amount = 3
	prespawned_content_type = /obj/item/ammo_magazine/slpistol

/obj/item/storage/box/syndie_kit/slpistol/hv
	name = ".35 HV speedloaders box"
	desc = "Contains 3 .35 HV speedloaders."
	prespawned_content_amount = 3
	prespawned_content_type = /obj/item/ammo_magazine/slpistol/hv

/obj/item/storage/box/syndie_kit/slsrifle
	name = ".20 strip box"
	desc = "Contains 2 .20 strips."
	prespawned_content_amount = 2
	prespawned_content_type = /obj/item/ammo_magazine/slsrifle

/obj/item/storage/box/syndie_kit/slsrifle/hv
	name = ".20 HV strip box"
	desc = "Contains 2 .20 HV strips."
	prespawned_content_amount = 2
	prespawned_content_type = /obj/item/ammo_magazine/slsrifle/hv

/obj/item/storage/box/syndie_kit/sllrifle
	name = ".30 strip box"
	desc = "Contains 2 .30 strips."
	prespawned_content_amount = 2
	prespawned_content_type = /obj/item/ammo_magazine/sllrifle

/obj/item/storage/box/syndie_kit/sllrifle/hv
	name = ".30 HV strip box"
	desc = "Contains 2 .30 HV strips."
	prespawned_content_amount = 2
	prespawned_content_type = /obj/item/ammo_magazine/sllrifle/hv
