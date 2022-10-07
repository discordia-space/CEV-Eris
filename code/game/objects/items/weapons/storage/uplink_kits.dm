/obj/item/storage/box/syndicate
	spawn_blacklisted = TRUE

/obj/item/storage/box/syndicate/populate_contents()
	switch (pickweight(list("bloodyspai" = 1, "stealth" = 1, "screwed" = 1, "guns" = 1, "murder" = 1, "freedom" = 1, "hacker" = 1, /*"lordsingulo" = 1,*/ "smoothoperator" = 1)))
		if("bloodyspai")
			new /obj/item/clothing/under/chameleon(src)
			new /obj/item/clothing/mask/chameleon/voice(src)
			new /obj/item/card/id/syndicate(src)
			new /obj/item/clothing/shoes/syndigaloshes(src)
			return

		if("stealth")
			new /obj/item/gun/energy/crossbow(src)
			new /obj/item/pen/reagent/paralysis(src)
			new /obj/item/device/chameleon(src)
			return

		if("screwed")
			new /obj/effect/spawner/newbomb/timer/syndicate(src)
			new /obj/effect/spawner/newbomb/timer/syndicate(src)
			new /obj/item/device/powersink(src)
			new /obj/item/clothing/suit/space/syndicate/uplink(src)
			new /obj/item/clothing/head/space/syndicate/uplink(src)
			new /obj/item/clothing/mask/gas/syndicate(src)
			new /obj/item/tank/emergency_oxygen/double(src)
			return

		if("guns")
			new /obj/item/gun/projectile/revolver(src)
			new /obj/item/ammo_magazine/slmagnum(src)
			new /obj/item/card/emag(src)
			new /obj/item/plastique(src)
			new /obj/item/plastique(src)
			return

		if("murder")
			new /obj/item/melee/energy/sword(src)
			new /obj/item/clothing/glasses/powered/thermal/syndi(src)
			new /obj/item/card/emag(src)
			new /obj/item/clothing/shoes/syndigaloshes(src)
			return

		if("freedom")
			var/obj/item/implanter/O = new /obj/item/implanter(src)
			O.implant = new /obj/item/implant/freedom(O)
			var/obj/item/implanter/U = new /obj/item/implanter(src)
			U.implant = new /obj/item/implant/uplink(U)
			return

		if("hacker")
			new /obj/item/device/encryptionkey/syndicate(src)
			new /obj/item/electronics/ai_module/syndicate(src)
			new /obj/item/card/emag(src)
			new /obj/item/device/encryptionkey/binary(src)
			return

/*			if("lordsingulo")
			new /obj/item/device/radio/beacon/syndicate(src)
			new /obj/item/clothing/suit/space/syndicate/uplink(src)
			new /obj/item/clothing/head/space/syndicate/uplink(src)
			new /obj/item/clothing/mask/gas/syndicate(src)
			new /obj/item/tank/emergency_oxygen/double(src)
			new /obj/item/card/emag(src)
			return
*/
		if("smoothoperator")
			new /obj/item/storage/box/syndie_kit/pistol(src)
			new /obj/item/storage/bag/trash(src)
			new /obj/item/soap/syndie(src)
			new /obj/item/bodybag(src)
			new /obj/item/clothing/shoes/reinforced(src)
			return

/obj/item/storage/box/syndie_kit
	name = "box"
	desc = "A sleek, sturdy box. This one is using state of the art folding to hold more inside!"
	max_storage_space = DEFAULT_NORMAL_STORAGE //bigger so they hold their gear!
	icon_state = "box_of_doom"
	illustration = "writing_of_doom"
	bad_type = /obj/item/storage/box/syndie_kit
	description_antag = "Can be folded into a non-identifiable cardboard while holding another item in the another hand."
	spawn_blacklisted = TRUE

/obj/item/storage/box/syndie_kit/imp_freedom
	name = "boxed freedom implant (with injector)"
	desc = "A box with freedom implant inside. Install it in your hand or leg, chose emote. You can remove instantly handcuffs or legcuffs with your emotion. Have a small amount of uses."

/obj/item/storage/box/syndie_kit/imp_freedom/populate_contents()
	new /obj/item/implanter/freedom(src)

/obj/item/storage/box/syndie_kit/imp_compress
	name = "box (C)"
	desc = "A box with compressed implanter inside. Choose an item with this implant, install it inside you and choose emote to activate it. Take your chosen item whenever you want by your chosen emotion. One use."

/obj/item/storage/box/syndie_kit/imp_compress/populate_contents()
	new /obj/item/implanter/compressed(src)

/obj/item/storage/box/syndie_kit/imp_explosive
	name = "box (E)"
	desc = "A box with explosive implant inside. When you use it on yours enemy, you can choose three ways to use it: destroy limb, destroy your enemy or make a small explosion. Activation by phrase you choose too. One use."

/obj/item/storage/box/syndie_kit/imp_explosive/populate_contents()
	new /obj/item/implanter/explosive(src)

/obj/item/storage/box/syndie_kit/imp_spying
	name = "box (S)"
	desc = "A box with spying implanter inside. Implant your contract target with it and wait 1 minute for the confirmation."

/obj/item/storage/box/syndie_kit/imp_spying/populate_contents()
	new /obj/item/implanter/spying(src)

/obj/item/storage/box/syndie_kit/imp_uplink
	name = "boxed uplink implant (with injector)"
	desc = "Uplink inside your head."

/obj/item/storage/box/syndie_kit/imp_uplink/populate_contents()
	//Turn off passive gain for boxed implant uplinks. To prevent exploits of gathering tons of free TC
	var/obj/item/implanter/uplink/U1 = new /obj/item/implanter/uplink(src)
	var/obj/item/implant/uplink/U2 = locate(/obj/item/implant/uplink) in U1
	var/obj/item/device/uplink/hidden/U3 = locate(/obj/item/device/uplink/hidden) in U2
	U3.passive_gain = 0

/obj/item/storage/box/syndie_kit/space
	name = "boxed voidsuit"

/obj/item/storage/box/syndie_kit/space/populate_contents()
	new /obj/item/clothing/suit/space/void/merc/boxed(src)
	new /obj/item/clothing/mask/gas/syndicate(src)

/obj/item/storage/box/syndie_kit/softsuit
	name = "boxed soft suit"

/obj/item/storage/box/syndie_kit/softsuit/populate_contents()
	new /obj/item/clothing/suit/space/syndicate/uplink(src)
	new /obj/item/clothing/head/space/syndicate/uplink(src)

/obj/item/storage/backpack/chameleon/populate_contents()
	new /obj/item/clothing/under/chameleon(src)
	new /obj/item/clothing/head/chameleon(src)
	new /obj/item/clothing/suit/chameleon(src)
	new /obj/item/clothing/shoes/chameleon(src)
	new /obj/item/clothing/gloves/chameleon(src)
	new /obj/item/clothing/mask/chameleon(src)
	new /obj/item/clothing/glasses/chameleon(src)
	new /obj/item/gun/energy/chameleon(src)
	new /obj/item/device/radio/headset/chameleon(src)

/obj/item/storage/box/syndie_kit/clerical
	name = "clerical kit"
	desc = "Comes with all you need to fake paperwork. Assumes you have passed basic writing lessons."

/obj/item/storage/box/syndie_kit/clerical/populate_contents()
	new /obj/item/stamp/chameleon(src)
	new /obj/item/pen/chameleon(src)
	new /obj/item/device/destTagger(src)
	new /obj/item/packageWrap(src)
	new /obj/item/hand_labeler(src)

/obj/item/storage/box/syndie_kit/spy
	name = "spy kit"
	desc = "For when you want to conduct voyeurism from afar."

/obj/item/storage/box/syndie_kit/spy/populate_contents()
	new /obj/item/device/spy_bug(src)
	new /obj/item/device/spy_bug(src)
	new /obj/item/device/spy_bug(src)
	new /obj/item/device/spy_bug(src)
	new /obj/item/device/spy_bug(src)
	new /obj/item/device/spy_bug(src)
	new /obj/item/device/spy_monitor(src)



// Guns
/obj/item/storage/box/syndie_kit/dartgun
	name  = "dartgun kit"
	desc = "Just like a mosquito bite."

/obj/item/storage/box/syndie_kit/dartgun/populate_contents()
	new /obj/item/gun/projectile/dartgun(src)
	new /obj/item/ammo_magazine/chemdart(src)


/obj/item/storage/box/syndie_kit/pistol
	name = "smooth operator"
	desc = ".25 Caseless handgun with a single magazine and pocket holster for easy consealment."

/obj/item/storage/box/syndie_kit/pistol/populate_contents()
	new /obj/item/gun/projectile/mandella(src)
	new /obj/item/ammo_magazine/cspistol(src)
	new /obj/item/storage/pouch/holster(src)

/obj/item/storage/box/syndie_kit/c20r
	name = "C-20r box"
	desc = "C-20r kit"

/obj/item/storage/box/syndie_kit/c20r/populate_contents()
	new /obj/item/gun/projectile/automatic/c20r(src)
	new /obj/item/ammo_magazine/smg(src)

/obj/item/storage/box/syndie_kit/revolver
	name = "Revolver box"
	desc = "Revolver kit"

/obj/item/storage/box/syndie_kit/revolver/populate_contents()
	new /obj/item/gun/projectile/revolver(src)
	new /obj/item/ammo_magazine/slmagnum(src)

/obj/item/storage/box/syndie_kit/hornet
	name = "Revolver box"
	desc = "Revolver kit"

/obj/item/storage/box/syndie_kit/hornet/populate_contents()
	new /obj/item/gun/projectile/revolver/hornet(src)
	new /obj/item/ammo_magazine/slsrifle_rev(src)

/obj/item/storage/box/syndie_kit/sts35
	name = "Assault rifle box"
	desc = "Assault rifle kit"
	icon_state = "box_of_doom_big"
	w_class = ITEM_SIZE_HUGE

/obj/item/storage/box/syndie_kit/sts35/populate_contents()
	new /obj/item/gun/projectile/automatic/sts35(src)
	new /obj/item/ammo_magazine/lrifle(src)

/obj/item/storage/box/syndie_kit/winchester
	name = "lever-action rifle box"
	desc = "A suspicious looking box containing a lever-action rifle and some spare ammo to it."
	icon_state = "box_of_doom_big"
	w_class = ITEM_SIZE_HUGE

/obj/item/storage/box/syndie_kit/winchester/populate_contents()
	new /obj/item/gun/projectile/boltgun/levergun(src)
	new /obj/item/ammo_magazine/slmagnum(src)

/obj/item/storage/box/syndie_kit/lshotgun
	name = "lever shotgun box"
	desc = "lever-action shotgun kit"
	icon_state = "box_of_doom_big"
	w_class = ITEM_SIZE_HUGE

/obj/item/storage/box/syndie_kit/lshotgun/populate_contents()
	new /obj/item/gun/projectile/boltgun/levergun/shotgun(src)
	new /obj/item/ammo_casing/shotgun/prespawned(src)

 /obj/item/storage/box/syndie_kit/pug
	name = "Pug box"
	desc = "Pug kit with one M12 buckshot mag"
	icon_state = "box_of_doom_big"
	w_class = ITEM_SIZE_HUGE

/obj/item/storage/box/syndie_kit/pug/populate_contents()
	new /obj/item/gun/projectile/shotgun/bojevic(src)
	new /obj/item/ammo_magazine/m12/pellet(src)


/obj/item/storage/briefcase/antimaterial_rifle
	desc = "An ominous leather briefcase that has the unmistakeable smell of old, stale cigarette smoke, and gives those who look at it a bad feeling."
	spawn_blacklisted = TRUE

/obj/item/storage/briefcase/antimaterial_rifle/populate_contents()
	new /obj/item/ammo_casing/antim(src)
	new /obj/item/part/gun/frame/heavysniper(src)
	new /obj/item/part/gun/grip/serb(src)
	new /obj/item/part/gun/mechanism/boltgun(src)
	new /obj/item/part/gun/barrel/antim(src)

/obj/item/storage/box/syndie_kit/toxin
	name = "toxin kit"
	desc = "An apple will not be enough to keep the doctor away after this."

/obj/item/storage/box/syndie_kit/toxin/populate_contents()
	new /obj/item/reagent_containers/glass/beaker/vial/random/toxin(src)
	new /obj/item/reagent_containers/glass/beaker/vial/random/toxin(src)
	new /obj/item/reagent_containers/glass/beaker/vial/random/toxin(src)
	new /obj/item/reagent_containers/glass/beaker/vial/random/toxin(src)
	new /obj/item/reagent_containers/glass/beaker/vial/random/toxin(src)
	new /obj/item/reagent_containers/glass/beaker/vial/random/toxin(src)
	new /obj/item/reagent_containers/syringe(src)

/obj/item/storage/box/syndie_kit/cigarette
	name = "\improper Tricky smokes"
	desc = "Comes with the following brands of cigarettes, in this order: 2xFlash, 2xSmoke, 1xMindBreaker, 1xTricordrazine. Avoid mixing them up."

/obj/item/storage/box/syndie_kit/cigarette/populate_contents()
	var/obj/item/storage/fancy/cigarettes/pack
	pack = new /obj/item/storage/fancy/cigarettes(src)
	fill_cigarre_package(pack, list("aluminum" = 5, "potassium" = 5, "sulfur" = 5))
	pack.desc += " 'F' has been scribbled on it."

	pack = new /obj/item/storage/fancy/cigarettes(src)
	fill_cigarre_package(pack, list("aluminum" = 5, "potassium" = 5, "sulfur" = 5))
	pack.desc += " 'F' has been scribbled on it."

	pack = new /obj/item/storage/fancy/cigarettes(src)
	fill_cigarre_package(pack, list("potassium" = 5, "sugar" = 5, "phosphorus" = 5))
	pack.desc += " 'S' has been scribbled on it."

	pack = new /obj/item/storage/fancy/cigarettes(src)
	fill_cigarre_package(pack, list("potassium" = 5, "sugar" = 5, "phosphorus" = 5))
	pack.desc += " 'S' has been scribbled on it."

	pack = new /obj/item/storage/fancy/cigarettes(src)
	// Dylovene. Going with 1.5 rather than 1.6666666...
	fill_cigarre_package(pack, list("potassium" = 1.5, "nitrogen" = 1.5, "silicon" = 1.5))
	// Mindbreaker
	fill_cigarre_package(pack, list("silicon" = 4.5))

	pack.desc += " 'MB' has been scribbled on it."

	pack = new /obj/item/storage/fancy/cigarettes(src)
	pack.reagents.add_reagent("tricordrazine", 15 * pack.storage_slots)
	pack.desc += " 'T' has been scribbled on it."

	new /obj/item/flame/lighter/zippo(src)

/proc/fill_cigarre_package(var/obj/item/storage/fancy/cigarettes/C, var/list/reagents)
	for(var/reagent in reagents)
		C.reagents.add_reagent(reagent, reagents[reagent] * C.storage_slots)

/obj/item/storage/box/syndie_kit/ewar_voice
	name = "Electrowarfare and Voice Synthesiser kit"
	desc = "Kit for confounding organic and synthetic entities alike."

/obj/item/storage/box/syndie_kit/ewar_voice/populate_contents()
	new /obj/item/rig_module/electrowarfare_suite(src)
	new /obj/item/rig_module/voice(src)

/obj/item/storage/box/syndie_kit/spy_sensor
	name = "sensor kit"

/obj/item/storage/box/syndie_kit/spy_sensor/populate_contents()
	new /obj/item/device/spy_sensor(src)
	new /obj/item/device/spy_sensor(src)
	new /obj/item/device/spy_sensor(src)
	new /obj/item/device/spy_sensor(src)


/obj/item/storage/secure/briefcase/money
	name = "secure briefcase"
	desc = "A large briefcase with a digital locking system."

/obj/item/storage/secure/briefcase/money/populate_contents()
	new /obj/item/spacecash/bundle/c1000(src)
	new /obj/item/spacecash/bundle/c1000(src)
	new /obj/item/spacecash/bundle/c1000(src)
	new /obj/item/spacecash/bundle/c1000(src)
	new /obj/item/spacecash/bundle/c1000(src)
	new /obj/item/spacecash/bundle/c1000(src)
	new /obj/item/spacecash/bundle/c1000(src)
	new /obj/item/spacecash/bundle/c1000(src)
	new /obj/item/spacecash/bundle/c1000(src)
	new /obj/item/spacecash/bundle/c1000(src)

/obj/item/storage/box/syndie_kit/randomstim
	name = "5 Random Stims Kit"
	desc = "Contain 5 random Stim Syringes."
	storage_slots = 5

/obj/item/storage/box/syndie_kit/randomstim/populate_contents()
	for(var/i, i < storage_slots , i++)
		var/stim = pick(subtypesof(/obj/item/reagent_containers/syringe/stim))
		new stim(src)

/obj/item/storage/box/syndie_kit/pickle
	name = "Pickle box"
	desc = "Pickle."
	icon_state = "box_of_doom_big"
	w_class = ITEM_SIZE_HUGE

/obj/item/storage/box/syndie_kit/pickle/populate_contents()
	new /obj/item/reagent_containers/food/snacks/pickle(src)

/obj/item/storage/box/syndie_kit/gentleman_kit
	name = "\improper Gentleman's Kit"
	desc = "Cane with hidden sword and white insulated gloves."

/obj/item/storage/box/syndie_kit/gentleman_kit/populate_contents()
	new /obj/item/tool/cane/concealed(src)
	new /obj/item/clothing/gloves/color/white/insulated(src)

/obj/item/storage/box/syndie_kit/cleanup_kit
	name = "\improper Crime Scene Cleanup Kit"
	desc = "Say good-fucking-bye to the evidence."

/obj/item/storage/box/syndie_kit/cleanup_kit/populate_contents()
	new /obj/item/soap/syndie(src)
	new /obj/item/bodybag/expanded(src)
	new /obj/item/grenade/chem_grenade/cleaner(src)
	new /obj/item/reagent_containers/spray/cleaner(src)

/obj/item/storage/box/syndie_kit/slmagnum/populate_contents()
	new /obj/item/ammo_magazine/slmagnum(src)
	new /obj/item/ammo_magazine/slmagnum(src)

/obj/item/storage/box/syndie_kit/slmagnum/highvelocity
	name = ".40 HV speedloader box"
	desc = "Contains 3 .40 HV speedloaders."

/obj/item/storage/box/syndie_kit/slmagnum/highvelocity/populate_contents()
	new /obj/item/ammo_magazine/slmagnum/highvelocity(src)
	new /obj/item/ammo_magazine/slmagnum/highvelocity(src)
	new /obj/item/ammo_magazine/slmagnum/highvelocity(src)

/obj/item/storage/box/syndie_kit/slpistol/populate_contents()
	new /obj/item/ammo_magazine/slpistol(src)
	new /obj/item/ammo_magazine/slpistol(src)

/obj/item/storage/box/syndie_kit/slpistol/hv
	name = ".35 HV speedloaders box"
	desc = "Contains 3 .35 HV speedloaders."

/obj/item/storage/box/syndie_kit/slpistol/hv/populate_contents()
	new /obj/item/ammo_magazine/slpistol/hv(src)
	new /obj/item/ammo_magazine/slpistol/hv(src)
	new /obj/item/ammo_magazine/slpistol/hv(src)

/obj/item/storage/box/syndie_kit/slsrifle/hv
	name = ".20 HV strip box"
	desc = "Contains 2 .20 HV strips."

/obj/item/storage/box/syndie_kit/slsrifle/hv/populate_contents()
	new /obj/item/ammo_magazine/slsrifle/hv(src)
	new /obj/item/ammo_magazine/slsrifle/hv(src)

/obj/item/storage/box/syndie_kit/sllrifle/hv
	name = ".30 HV strip box"
	desc = "Contains 2 .30 HV strips."

/obj/item/storage/box/syndie_kit/sllrifle/hv/populate_contents()
	new /obj/item/ammo_magazine/sllrifle/hv(src)
	new /obj/item/ammo_magazine/sllrifle/hv(src)
