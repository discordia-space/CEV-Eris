/*
 *	Everything derived from the common cardboard box.
 *	Basically everything except the original is a kit (starts full).
 */

/obj/item/storage/box
	name = "box"
	desc = "It's just an ordinary box."
	icon = 'icons/obj/storage/boxes.dmi'
	icon_state = "box"
	item_state = "box"
	max_volumeClass = ITEM_SIZE_SMALL
	max_storage_space = DEFAULT_SMALL_STORAGE + 1
	contained_sprite = TRUE
	health = 20
	bad_type = /obj/item/storage/box
	spawn_blacklisted = FALSE
	spawn_tags = SPAWN_TAG_BOX
	rarity_value = 20
	spawn_frequency = 10
	var/illustration = "writing"

/obj/item/storage/box/Initialize(mapload)
	if(illustration)
		add_overlay(illustration)
	. = ..()

/obj/item/storage/box/attack_generic(mob/user)
	user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN*2)
	if(isliving(user))
		user.do_attack_animation(src)
		playsound(loc, pick('sound/effects/creatures/nibble1.ogg', 'sound/effects/creatures/nibble2.ogg'), 50, 1, 2)
		shake_animation()
		var/damage_amount = user.mob_size ? user.mob_size : MOB_MINISCULE
		addtimer(CALLBACK(src, PROC_REF(handle_generic_damage), user, damage_amount), 0.5 SECONDS)

/obj/item/storage/box/proc/handle_generic_damage(mob/user, severity)
	if(QDELETED(src))
		return
	health -= severity
	if(health <= 0)
		visible_message(SPAN_DANGER("[user] tears open \the [src], spilling its contents everywhere!"), SPAN_DANGER("You tear open the [src], spilling its contents everywhere!"))
		spill()
		qdel(src)

/obj/item/storage/box/attack_self(mob/user)
	if(..()) // Opened the box sucessfully
		return

	if(LAZYLEN(contents))
		to_chat(user, SPAN_WARNING("You can't fold this box with items still inside!"))
		return

	close_all() // Close open UI windows
	to_chat(user, SPAN_NOTICE("You fold [src] flat."))
	new /obj/item/stack/material/cardboard(get_turf(src))
	qdel(src)

/obj/item/storage/box/survival/populate_contents()
	var/list/spawnedAtoms = list()

	spawnedAtoms.Add(new /obj/item/clothing/mask/breath(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/tank/emergency_oxygen(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/reagent_containers/hypospray/autoinjector(NULLSPACE))
	for(var/atom/movable/a in spawnedAtoms)
		a.forceMove(src)

/obj/item/storage/box/survival/extended/populate_contents()
	var/list/spawnedAtoms = list()

	spawnedAtoms.Add(new /obj/item/clothing/mask/breath(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/tank/emergency_oxygen/engi(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/reagent_containers/hypospray/autoinjector(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/device/lighting/glowstick/yellow(NULLSPACE))
	for(var/atom/movable/a in spawnedAtoms)
		a.forceMove(src)

/obj/item/storage/box/gloves
	name = "box of latex gloves"
	desc = "Contains white gloves."
	illustration = "latex"
	prespawned_content_amount = 7
	prespawned_content_type = /obj/item/clothing/gloves/latex

/obj/item/storage/box/masks
	name = "box of sterile masks"
	desc = "This box contains masks of sterility."
	illustration = "sterile"
	prespawned_content_amount = 7
	prespawned_content_type = /obj/item/clothing/mask/surgical

/obj/item/storage/box/syringes
	name = "box of syringes"
	desc = "A box full of syringes."
	illustration = "syringe"
	prespawned_content_amount = 7
	prespawned_content_type = /obj/item/reagent_containers/syringe

/obj/item/storage/box/syringegun
	name = "box of syringe gun cartridges"
	desc = "A box full of compressed gas cartridges."
	illustration = "syringe"
	prespawned_content_amount = 7
	prespawned_content_type = /obj/item/syringe_cartridge

/obj/item/storage/box/beakers
	name = "box of beakers"
	illustration = "beaker"
	rarity_value = 5
	prespawned_content_amount = 7
	prespawned_content_type = /obj/item/reagent_containers/glass/beaker

/obj/item/storage/box/bodybags
	name = "body bags"
	desc = "This box contains a number of body bags."
	illustration = "bodybags"
	prespawned_content_amount = 7
	prespawned_content_type = /obj/item/bodybag

/obj/item/storage/box/shotgunammo
	name = "box of shotgun slugs"
	desc = "It has a picture of a gun and several warning symbols on the front.<br>WARNING: Live ammunition. Misuse may result in serious injury or death."
	illustration = "ammo"
	rarity_value = 40
	spawn_tags = SPAWN_TAG_AMMO_SHOTGUN_COMMON
	bad_type = /obj/item/storage/box/shotgunammo
	prespawned_content_amount = 7
	spawn_blacklisted = TRUE

/obj/item/storage/box/shotgunammo/slug
	name = "box of shotgun slugs"
	prespawned_content_type = /obj/item/ammo_casing/shotgun/prespawned
	rarity_value = 20

/obj/item/storage/box/shotgunammo/blanks
	name = "box of blank shells"
	prespawned_content_type = /obj/item/ammo_casing/shotgun/blank/prespawned
	rarity_value = 50
	spawn_tags = SPAWN_TAG_AMMO_SHOTGUN

/obj/item/storage/box/shotgunammo/beanbags
	name = "box of beanbag shells"
	prespawned_content_type = /obj/item/ammo_casing/shotgun/beanbag/prespawned
	rarity_value = 10

/obj/item/storage/box/shotgunammo/buckshot
	name = "box of shotgun shells"
	prespawned_content_type = /obj/item/ammo_casing/shotgun/pellet/prespawned
	rarity_value = 13.33
	spawn_tags = SPAWN_TAG_AMMO_SHOTGUN

/obj/item/storage/box/shotgunammo/flashshells
	name = "box of illumination shells"
	prespawned_content_type = /obj/item/ammo_casing/shotgun/flash/prespawned
	rarity_value = 40
	spawn_tags = SPAWN_TAG_AMMO_SHOTGUN

/obj/item/storage/box/shotgunammo/practiceshells
	name = "box of practice shells"
	prespawned_content_type = /obj/item/ammo_casing/shotgun/practice/prespawned
	rarity_value = 50

/obj/item/storage/box/shotgunammo/incendiaryshells
	name = "box of incendiary shells"
	prespawned_content_type = /obj/item/ammo_casing/shotgun/incendiary/prespawned
	rarity_value = 100
	spawn_tags = SPAWN_TAG_AMMO_SHOTGUN

/obj/item/storage/box/sniperammo
	name = "box of .60 \"Penetrator\" Anti Material shells"
	desc = "It has a picture of a gun and several warning symbols on the front.<br>WARNING: Live ammunition. Misuse may result in serious injury or death."
	illustration = "ammo"
	rarity_value = 80
	prespawned_content_amount = 3
	prespawned_content_type = /obj/item/ammo_casing/antim/prespawned
	spawn_tags = SPAWN_TAG_AMMO

/obj/item/storage/box/sniperammo/emp
	name = "box of .60 \"Blackout\" Anti Material shells"
	desc = "It has a picture of a gun and several warning symbols on the front, among them is a symbol you're not quite able to make sense of.<br>WARNING: Live EMP ammunition. Misuse may result in serious injury or death."
	illustration = "ammo"
	rarity_value = 80
	prespawned_content_amount = 3
	prespawned_content_type = /obj/item/ammo_casing/antim/emp/prespawned
	spawn_tags = SPAWN_TAG_AMMO

/obj/item/storage/box/sniperammo/uranium
	name = "box of .60 \"Meltdown\" Anti Material shells"
	desc = "It has a picture of a gun and several warning symbols on the front, including a radiation hazard sign.<br>WARNING: Live depleted uranium ammunition. Misuse may result in serious injury or death."
	illustration = "ammo"
	rarity_value = 80
	prespawned_content_amount = 3
	prespawned_content_type = /obj/item/ammo_casing/antim/uranium/prespawned
	spawn_tags = SPAWN_TAG_AMMO

/obj/item/storage/box/sniperammo/breach
	name = "box of .60 \"Breacher\" Anti Material shells"
	desc = "It has a picture of a gun and several warning symbols on the front, including an explosive hazard sign.<br>WARNING: Live breaching ammunition. Misuse may result in serious injury or death."
	illustration = "ammo"
	rarity_value = 80
	prespawned_content_amount = 3
	prespawned_content_type = /obj/item/ammo_casing/antim/breach/prespawned
	spawn_tags = SPAWN_TAG_AMMO

/obj/item/storage/box/flashbangs
	name = "box of flashbangs"
	desc = "A box containing 7 antipersonnel flashbang grenades.<br> WARNING: These devices are extremely dangerous and can cause blindness or deafness in repeated use."
	icon_state = "box_security"
	illustration = "flashbang"
	rarity_value = 60
	prespawned_content_amount = 7
	prespawned_content_type = /obj/item/grenade/flashbang

/obj/item/storage/box/phosphorous
	name = "box of white phosphorous grenades"
	desc = "A box containing 7 antipersonnel incendiary  grenades.<br> WARNING: These devices are extremely dangerous and can cause severe burns and fires."
	icon_state = "box_security"
	illustration = "flashbang"
	rarity_value = 60
	prespawned_content_amount = 7
	prespawned_content_type = /obj/item/grenade/frag/white_phosphorous

/obj/item/storage/box/flashbangs/uplink_item
	name = "box of flashbangs"
	desc = "A box containing 5 antipersonnel flashbang grenades.<br> WARNING: These devices are extremely dangerous and can cause blindness or deafness in repeated use."
	icon_state = "box_security"
	illustration = "flashbang"
	rarity_value = 60
	prespawned_content_amount = 5
	prespawned_content_type = /obj/item/grenade/flashbang

/obj/item/storage/box/teargas
	name = "box of pepperspray grenades"
	desc = "A box containing 6 tear gas grenades. A gas mask is printed on the label.<br> WARNING: Exposure carries risk of serious injury or death. Keep away from persons with lung conditions."
	icon_state = "box_security"
	illustration = "flashbang"
	rarity_value = 50
	prespawned_content_amount = 6
	prespawned_content_type = /obj/item/grenade/chem_grenade/teargas

/obj/item/storage/box/emps
	name = "box of emp grenades"
	desc = "A box containing 5 military grade EMP grenades.<br> WARNING: Do not use near unshielded electronics or biomechanical augmentations, death or permanent paralysis may occur."
	icon_state = "box_security"
	illustration = "flashbang"
	rarity_value = 60
	prespawned_content_amount = 5
	prespawned_content_type = /obj/item/grenade/empgrenade

/obj/item/storage/box/frag
	name = "box of fragmentation grenades"
	desc = "A box containing 4 fragmentation grenades. Designed for use on enemies in the open."
	icon_state = "box_security"
	illustration = "flashbang"
	rarity_value = 60
	prespawned_content_amount = 4
	prespawned_content_type = /obj/item/grenade/frag

/obj/item/storage/box/stinger
	name = "box of sting grenades"
	desc = "A box containing 4 sting grenades. Designed for use against unruly crowds. <br> WARNING: May cause long-lasting injuries in close proximity."
	icon_state = "box_security"
	illustration = "flashbang"
	rarity_value = 60
	prespawned_content_amount = 4
	prespawned_content_type = /obj/item/grenade/frag/sting

/obj/item/storage/box/explosive
	name = "box of blast grenades"
	desc = "A box containing 4 blast grenades. Designed for assaulting strongpoints."
	icon_state = "box_security"
	illustration = "flashbang"
	rarity_value = 70
	prespawned_content_amount = 4
	prespawned_content_type = /obj/item/grenade/explosive

/obj/item/storage/box/smokes
	name = "box of smoke bombs"
	desc = "A box containing 5 smoke bombs."
	illustration = "flashbang"
	prespawned_content_amount = 5
	prespawned_content_type = /obj/item/grenade/smokebomb

/obj/item/storage/box/anti_photons
	name = "box of anti-photon grenades"
	desc = "A box containing 5 experimental photon disruption grenades."
	illustration = "flashbang"
	rarity_value = 60
	prespawned_content_amount = 5
	prespawned_content_type = /obj/item/grenade/anti_photon

/obj/item/storage/box/incendiary
	name = "box of incendiary grenades"
	desc = "A box containing 5 incendiary grenades."
	icon_state = "box_security"
	illustration = "flashbang"
	rarity_value = 60
	prespawned_content_amount = 5
	prespawned_content_type = /obj/item/grenade/chem_grenade/incendiary

/obj/item/storage/box/sting_rounds
	name = "box of sting rounds"
	desc = "A box containing 6 sting rounds, designed to be fired from grenade launchers."
	icon_state = "box_security"
	illustration = "flashbang"
	rarity_value = 60
	prespawned_content_amount = 6
	prespawned_content_type = /obj/item/ammo_casing/grenade

/obj/item/storage/box/blast_rounds
	name = "box of explosive grenade shells"
	desc = "A box containing 6 explosive grenade shells, designed to be fired from grenade launchers."
	icon_state = "box_security"
	illustration = "flashbang"
	rarity_value = 60
	prespawned_content_amount = 6
	prespawned_content_type = /obj/item/ammo_casing/grenade/blast

/obj/item/storage/box/frag_rounds
	name = "box of frag grenade shells"
	desc = "A box containing 6 frag grenade shells, designed to be fired from grenade launchers."
	icon_state = "box_security"
	illustration = "flashbang"
	rarity_value = 60
	prespawned_content_amount = 6
	prespawned_content_type = /obj/item/ammo_casing/grenade/frag

/obj/item/storage/box/teargas_rounds
	name = "box of pepperspray Shells"
	desc = "A box containing 6 tear gas shells for use with a launcher. A gas mask is printed on the label.<br> WARNING: Exposure carries risk of serious injury or death. Keep away from persons with lung conditions."
	icon_state = "box_security"
	illustration = "flashbang"
	rarity_value = 50
	prespawned_content_amount = 6
	prespawned_content_type =  /obj/item/ammo_casing/grenade/teargas

/obj/item/storage/box/emp_rounds
	name = "box of EMP grenade shells"
	desc = "A box containing 6 EMP grenade shells, designed to be fired from grenade launchers."
	icon_state = "box_security"
	illustration = "flashbang"
	rarity_value = 60
	prespawned_content_amount = 6
	prespawned_content_type = /obj/item/ammo_casing/grenade/emp

/obj/item/storage/box/trackimp
	name = "boxed tracking implant kit"
	desc = "Box full of scum-bag tracking utensils."
	illustration = "implant"
	rarity_value = 60
	prespawned_content_amount = 4
	prespawned_content_type = /obj/item/implantcase/tracking

/obj/item/storage/box/trackimp/populate_contents()
	var/list/spawnedAtoms = list()

	for(var/i in 1 to prespawned_content_amount)
		spawnedAtoms.Add(new prespawned_content_type(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/implanter(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/implantpad(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/device/gps/locator(NULLSPACE))
	for(var/atom/movable/a in spawnedAtoms)
		a.forceMove(src)

/obj/item/storage/box/chemimp
	name = "boxed chemical implant kit"
	desc = "Box of stuff used to implant chemicals."
	illustration = "implant"
	rarity_value = 60
	prespawned_content_amount = 5
	spawn_blacklisted = TRUE
	prespawned_content_type = /obj/item/implantcase/chem

/obj/item/storage/box/chemimp/populate_contents()
	var/list/spawnedAtoms = list()

	for(var/i in 1 to prespawned_content_amount)
		spawnedAtoms.Add(new prespawned_content_type(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/implanter(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/implantpad(NULLSPACE))
	for(var/atom/movable/a in spawnedAtoms)
		a.forceMove(src)

/obj/item/storage/box/rxglasses
	name = "box of prescription glasses"
	desc = "This box contains nerd glasses."
	illustration = "glasses"
	prespawned_content_amount = 7
	prespawned_content_type = /obj/item/clothing/glasses/regular

/obj/item/storage/box/drinkingglasses
	name = "box of drinking glasses"
	desc = "It has a picture of drinking glasses on it."
	rarity_value = 10
	prespawned_content_amount = 6
	prespawned_content_type = /obj/item/reagent_containers/food/drinks/drinkingglass

/obj/item/storage/box/cdeathalarm_kit
	name = "death alarm kit"
	desc = "Box of stuff used to implant death alarms."
	illustration = "implant"
	item_state = "syringe_kit"
	rarity_value = 50
	prespawned_content_amount = 6
	prespawned_content_type = /obj/item/implantcase/death_alarm

/obj/item/storage/box/cdeathalarm_kit/populate_contents()
	var/list/spawnedAtoms = list()

	spawnedAtoms.Add(new /obj/item/implanter(NULLSPACE))
	for(var/i in 1 to prespawned_content_amount)
		spawnedAtoms.Add(new prespawned_content_type(NULLSPACE))
	for(var/atom/movable/a in spawnedAtoms)
		a.forceMove(src)

/obj/item/storage/box/condimentbottles
	name = "box of condiment bottles"
	desc = "It has a large ketchup smear on it."
	prespawned_content_amount = 7
	prespawned_content_type = /obj/item/reagent_containers/food/condiment

/obj/item/storage/box/cups
	name = "box of paper cups"
	desc = "It has pictures of paper cups on the front."
	prespawned_content_amount = 7
	prespawned_content_type = /obj/item/reagent_containers/food/drinks/sillycup

/obj/item/storage/box/donkpockets
	name = "box of donk-pockets"
	desc = "<B>Instructions:</B> <I>Heat in microwave. Product will cool if not eaten within seven minutes.</I>"
	icon_state = "box_donk_pocket"
	illustration = null
	rarity_value = 10
	prespawned_content_amount = 6
	prespawned_content_type = /obj/item/reagent_containers/food/snacks/donkpocket

/obj/item/storage/box/sinpockets
	name = "box of sin-pockets"
	desc = "<B>Instructions:</B> <I>Crush bottom of package to initiate chemical heating. Wait for 20 seconds before consumption. Product will cool if not eaten within seven minutes.</I>"
	icon_state = "box_donk_pocket"
	illustration = null
	prespawned_content_amount = 6
	prespawned_content_type = /obj/item/reagent_containers/food/snacks/donkpocket/sinpocket

/obj/item/storage/box/monkeycubes
	name = "monkey cube box"
	desc = "Drymate brand monkey cubes. Just add water!"
	icon = 'icons/obj/food.dmi'
	icon_state = "monkeycubebox"
	illustration = null
	can_hold = list(/obj/item/reagent_containers/food/snacks/monkeycube)
	prespawned_content_amount = 5
	prespawned_content_type = /obj/item/reagent_containers/food/snacks/monkeycube/wrapped

/obj/item/storage/box/ids
	name = "box of spare IDs"
	desc = "Has so many empty IDs."
	icon_state = "box_id"
	illustration = null
	prespawned_content_amount = 7
	prespawned_content_type = /obj/item/card/id

/obj/item/storage/box/handcuffs
	name = "box of spare handcuffs"
	desc = "A box full of handcuffs."
	icon_state = "box_security"
	illustration = "handcuff"
	rarity_value = 10
	prespawned_content_amount = 7
	prespawned_content_type = /obj/item/handcuffs

/obj/item/storage/box/mousetraps
	name = "box of Pest-B-Gon mousetraps"
	desc = "<B><FONT color='red'>WARNING:</FONT></B> <I>Keep out of reach of children</I>."
	illustration = "mousetraps"
	prespawned_content_amount = 7
	prespawned_content_type = /obj/item/device/assembly/mousetrap

/obj/item/storage/box/pillbottles
	name = "box of pill bottles"
	desc = "It has pictures of pill bottles on its front."
	prespawned_content_amount = 7
	prespawned_content_type = /obj/item/storage/pill_bottle


/obj/item/storage/box/snappops
	name = "snap pop box"
	desc = "Eight wrappers of fun! Ages 8 and up. Not suitable for children."
	icon = 'icons/obj/toy.dmi'
	icon_state = "spbox"
	prespawned_content_amount = 8
	prespawned_content_type = /obj/item/toy/snappop

/obj/item/storage/box/matches
	name = "matchbox"
	desc = "A small box of 'Space-Proof' premium matches."
	icon = 'icons/obj/cigarettes.dmi'
	icon_state = "matchbox"
	item_state = "zippo"
	illustration = null
	volumeClass = ITEM_SIZE_TINY
	slot_flags = SLOT_BELT
	rarity_value = 5
	spawn_tags = SPAWN_TAG_BOX_TAG_JUNK
	prespawned_content_amount = 14
	prespawned_content_type = /obj/item/flame/match

/obj/item/storage/box/matches/populate_contents()
	var/list/spawnedAtoms = list()

	for(var/i in 1 to prespawned_content_amount)
		spawnedAtoms.Add(new prespawned_content_type(NULLSPACE))

	for(var/atom/movable/a in spawnedAtoms)
		a.forceMove(src)
	make_exact_fit()

/obj/item/storage/box/matches/attackby(obj/item/flame/match/W, mob/user)
	if(istype(W) && !W.lit && !W.burnt)
		playsound(src, 'sound/items/matchstrike.ogg', 20, 1, 1)
		W.lit = 1
		W.icon_state = "match_lit"
		W.tool_qualities = list(QUALITY_CAUTERIZING = 10)
		START_PROCESSING(SSobj, W)
	W.update_icon()

/obj/item/storage/box/autoinjectors
	name = "box of injectors"
	desc = "Contains autoinjectors."
	illustration = "syringe"
	rarity_value = 10
	prespawned_content_amount = 7
	prespawned_content_type = /obj/item/reagent_containers/hypospray/autoinjector

/obj/item/storage/box/lights
	name = "box of replacement bulbs"
	illustration = "light"
	desc = "This box is shaped on the inside so that only light tubes and bulbs fit."
	use_to_pickup = TRUE // for picking up broken bulbs, not that most people will try
	spawn_tags = SPAWN_TAG_BOX_TAG_JUNK
	prespawned_content_amount = 21
	prespawned_content_type = /obj/item/light/bulb

/obj/item/storage/box/lights/bulbs/populate_contents()
	var/list/spawnedAtoms = list()

	for(var/i in 1 to prespawned_content_amount)
		spawnedAtoms.Add(new prespawned_content_type(NULLSPACE))

	for(var/atom/movable/a in spawnedAtoms)
		a.forceMove(src)
	make_exact_fit()

/obj/item/storage/box/lights/tubes
	name = "box of replacement tubes"
	illustration = "lighttube"
	spawn_tags = SPAWN_TAG_BOX_TAG_JUNK
	prespawned_content_amount = 21
	prespawned_content_type = /obj/item/light/tube

/obj/item/storage/box/lights/tubes/populate_contents()
	var/list/spawnedAtoms = list()

	for(var/i in 1 to prespawned_content_amount)
		spawnedAtoms.Add(new prespawned_content_type(NULLSPACE))

	for(var/atom/movable/a in spawnedAtoms)
		a.forceMove(src)
	make_exact_fit()

/obj/item/storage/box/lights/mixed
	name = "box of replacement lights"
	illustration = "lightmixed"
	spawn_tags = SPAWN_TAG_BOX_TAG_JUNK
	rarity_value = 6.66
	prespawned_content_amount = 14
	prespawned_content_type = /obj/item/light/tube

/obj/item/storage/box/lights/mixed/populate_contents()
	var/list/spawnedAtoms = list()

	for(var/i in 1 to prespawned_content_amount)
		spawnedAtoms.Add(new prespawned_content_type(NULLSPACE))
	for(var/i in 1 to 7)
		spawnedAtoms.Add(new /obj/item/light/bulb(NULLSPACE))

	for(var/atom/movable/a in spawnedAtoms)
		a.forceMove(src)
	make_exact_fit()

/obj/item/storage/box/data_disk
	name = "data disk box"
	illustration = "disk"
	rarity_value = 30
	prespawned_content_amount = 7
	prespawned_content_type = /obj/item/computer_hardware/hard_drive/portable

/obj/item/storage/box/data_disk/basic
	name = "basic data disk box"
	illustration = "disk"
	rarity_value = 10
	prespawned_content_amount = 7
	prespawned_content_type = /obj/item/computer_hardware/hard_drive/portable/basic

/obj/item/storage/box/headset_church
	name = "neotheology radio encryption key box"
	illustration = "disk"
	prespawned_content_amount = 7
	prespawned_content_type = /obj/item/device/encryptionkey/headset_church
	spawn_blacklisted = TRUE

/obj/item/storage/box/happy_meal
	name = "McRonalds' Robust Meal"
	desc = "This is typical Robust Meal from McRonalds.\
	And you almost feel smell of delicious food from it.\
	Wait! It must have toy inside! Unpack it now!"
	icon_state = "happy_meal"

/obj/item/storage/box/happy_meal/populate_contents()
	var/list/spawnedAtoms = list()

	var/list/things2spawn = list(
		/obj/item/reagent_containers/food/snacks/creamcheesebreadslice,
		/obj/item/reagent_containers/food/snacks/applecakeslice,
		/obj/item/reagent_containers/food/snacks/bigbiteburger,
		/obj/item/reagent_containers/food/snacks/fishandchips,
		/obj/spawner/soda)
	things2spawn += pick(/obj/spawner/toy/figure, /obj/spawner/toy/plushie, /obj/spawner/toy/card)
	for(var/path in things2spawn)
		spawnedAtoms.Add(new path(NULLSPACE))

	for(var/atom/movable/a in spawnedAtoms)
		a.forceMove(src)

/obj/item/storage/box/njoy
	name = "red Njoy packet"
	desc = "Packet full of njoy pills."
	illustration = null
	icon_state = "packet_njoy_red"
	item_state = "packet_njoy_red"
	prespawned_content_amount = 4
	prespawned_content_type = /obj/item/storage/pill_bottle/njoy

/obj/item/storage/box/njoy/blue
	name = "blue Njoy packet"
	icon_state = "packet_njoy_blue"
	item_state = "packet_njoy_blue"
	prespawned_content_type = /obj/item/storage/pill_bottle/njoy/blue

/obj/item/storage/box/njoy/green
	name = "green Njoy packet"
	icon_state = "packet_njoy_green"
	item_state = "packet_njoy_green"
	prespawned_content_type = /obj/item/storage/pill_bottle/njoy/green
