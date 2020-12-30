/*
 *	Everything derived from the common cardboard box.
 *	Basically everything except the original is a kit (starts full).
 *
 *	Contains:
 *		Empty box, starter boxes (survival/engineer),
 *		Latex glove and sterile mask boxes,
 *		Syringe, beaker, dna injector boxes,
 *		Blanks, flashbangs, and EMP grenade boxes,
 *		Tracking and chemical implant boxes,
 *		Prescription glasses and drinking glass boxes,
 *		Condiment bottle and silly cup boxes,
 *		Donkpocket and monkeycube boxes,
 *		ID and security PDA cart boxes,
 *		Handcuff, mousetrap, and pillbottle boxes,
 *		Snap-pops and matchboxes,
 *		Replacement light boxes.
 *
 *		For syndicate call-ins see uplink_kits.dm
 */

/obj/item/weapon/storage/box
	name = "box"
	desc = "It's just an ordinary box."
	icon = 'icons/obj/storage/boxes.dmi'
	icon_state = "box"
	item_state = "box"
	max_w_class = ITEM_SIZE_SMALL
	max_storage_space = DEFAULT_SMALL_STORAGE + 1
	contained_sprite = TRUE
	health = 20
	bad_type = /obj/item/weapon/storage/box
	spawn_blacklisted = FALSE
	spawn_tags = SPAWN_TAG_BOX
	rarity_value = 20
	spawn_frequency = 10
	var/foldable = /obj/item/stack/material/cardboard	//If set, can be folded (when empty) into the set object.
	var/illustration = "writing"
	var/initial_amount = 0
	var/spawn_type

/obj/item/weapon/storage/box/Initialize(mapload)
	. = ..()
	update_icon()

/obj/item/weapon/storage/box/update_icon()
	. = ..()
	if(illustration)
		cut_overlays()
		add_overlay(illustration)

/obj/item/weapon/storage/box/proc/damage(severity)
	health -= severity
	check_health()

/obj/item/weapon/storage/box/proc/check_health()
	if (health <= 0)
		spill()
		qdel(src)

/obj/item/weapon/storage/box/attack_generic(mob/user)
	user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN*2)
	if (istype(user, /mob/living))
		var/mob/living/L = user
		var/damage = L.mob_size ? L.mob_size : MOB_MINISCULE

		if (!damage || damage <= 0)
			return

		user.do_attack_animation(src)

		var/toplay = pick(list('sound/effects/creatures/nibble1.ogg','sound/effects/creatures/nibble2.ogg'))
		playsound(loc, toplay, 50, 1, 2)
		shake_animation()
		spawn(5)
			if ((health-damage) <= 0)
				L.visible_message("<span class='danger'>[L] tears open \the [src], spilling its contents everywhere!</span>", "<span class='danger'>You tear open the [src], spilling its contents everywhere!</span>")
			damage(damage)
		..()

/obj/item/weapon/storage/box/attack_self(mob/user)
	if(..()) return

	//try to fold it.
	if(contents.len)
		to_chat(user, "<span class='warning'>You can't fold this box with items still inside!</span>")
		return

	if(!ispath(src.foldable))
		return

	// Close any open UI windows first
	close_all()

	// Now make the cardboard
	to_chat(user, SPAN_NOTICE("You fold [src] flat."))
	new src.foldable(get_turf(src))
	qdel(src)

/obj/item/weapon/storage/box/survival/populate_contents()
	new /obj/item/clothing/mask/breath(src)
	new /obj/item/weapon/tank/emergency_oxygen(src)
	new /obj/item/weapon/reagent_containers/hypospray/autoinjector(src)

/obj/item/weapon/storage/box/survival/extended/populate_contents()
	new /obj/item/clothing/mask/breath(src)
	new /obj/item/weapon/tank/emergency_oxygen/engi(src)
	new /obj/item/weapon/reagent_containers/hypospray/autoinjector(src)
	new /obj/item/device/lighting/glowstick/yellow(src)

/obj/item/weapon/storage/box/gloves
	name = "box of latex gloves"
	desc = "Contains white gloves."
	illustration = "latex"
	initial_amount = 7
	spawn_type = /obj/item/clothing/gloves/latex

/obj/item/weapon/storage/box/gloves/populate_contents()
	for(var/i in 1 to initial_amount)
		new spawn_type(src)

/obj/item/weapon/storage/box/masks
	name = "box of sterile masks"
	desc = "This box contains masks of sterility."
	illustration = "sterile"
	initial_amount = 7
	spawn_type = /obj/item/clothing/mask/surgical

/obj/item/weapon/storage/box/masks/populate_contents()
	for(var/i in 1 to initial_amount)
		new spawn_type(src)

/obj/item/weapon/storage/box/syringes
	name = "box of syringes"
	desc = "A box full of syringes."
	illustration = "syringe"
	initial_amount = 7
	spawn_type = /obj/item/weapon/reagent_containers/syringe

/obj/item/weapon/storage/box/syringes/populate_contents()
	for(var/i in 1 to initial_amount)
		new spawn_type(src)

/obj/item/weapon/storage/box/syringegun
	name = "box of syringe gun cartridges"
	desc = "A box full of compressed gas cartridges."
	illustration = "syringe"
	initial_amount = 7
	spawn_type = /obj/item/weapon/syringe_cartridge

/obj/item/weapon/storage/box/syringegun/populate_contents()
	for(var/i in 1 to initial_amount)
		new spawn_type(src)

/obj/item/weapon/storage/box/beakers
	name = "box of beakers"
	illustration = "beaker"
	rarity_value = 5
	initial_amount = 7
	spawn_type = /obj/item/weapon/reagent_containers/glass/beaker

/obj/item/weapon/storage/box/beakers/populate_contents()
	for(var/i in 1 to initial_amount)
		new spawn_type(src)

/obj/item/weapon/storage/box/bodybags
	name = "body bags"
	desc = "This box contains a number of body bags."
	illustration = "bodybags"
	initial_amount = 7
	spawn_type = /obj/item/bodybag

/obj/item/weapon/storage/box/bodybags/populate_contents()
	for(var/i in 1 to initial_amount)
		new spawn_type(src)

/obj/item/weapon/storage/box/injectors
	name = "box of DNA injectors"
	desc = "This box contains injectors it seems."
	initial_amount = 3
	spawn_type = /obj/item/weapon/dnainjector/h2m

/obj/item/weapon/storage/box/injectors/populate_contents()
	for(var/i in 1 to initial_amount)
		new spawn_type(src)
	new /obj/item/weapon/dnainjector/m2h(src)
	new /obj/item/weapon/dnainjector/m2h(src)
	new /obj/item/weapon/dnainjector/m2h(src)

/obj/item/weapon/storage/box/shotgunammo
	name = "box of shotgun slugs"
	desc = "It has a picture of a gun and several warning symbols on the front.<br>WARNING: Live ammunition. Misuse may result in serious injury or death."
	illustration = "ammo"
	rarity_value = 40
	spawn_tags = SPAWN_TAG_AMMO_SHOTGUN_COMMON
	bad_type = /obj/item/weapon/storage/box/shotgunammo
	initial_amount = 7

/obj/item/weapon/storage/box/shotgunammo/populate_contents()
	if(initial_amount > 0 && spawn_type)
		for(var/i in 1 to initial_amount)
			new spawn_type(src)

/obj/item/weapon/storage/box/shotgunammo/slug
	name = "box of shotgun slugs"
	spawn_type = /obj/item/ammo_casing/shotgun/prespawned
	rarity_value = 20

/obj/item/weapon/storage/box/shotgunammo/blanks
	name = "box of blank shells"
	spawn_type = /obj/item/ammo_casing/shotgun/blank/prespawned
	rarity_value = 50
	spawn_tags = SPAWN_TAG_AMMO_SHOTGUN

/obj/item/weapon/storage/box/shotgunammo/beanbags
	name = "box of beanbag shells"
	spawn_type = /obj/item/ammo_casing/shotgun/beanbag/prespawned
	rarity_value = 10

/obj/item/weapon/storage/box/shotgunammo/buckshot
	name = "box of shotgun shells"
	spawn_type = /obj/item/ammo_casing/shotgun/pellet/prespawned
	rarity_value = 13.33
	spawn_tags = SPAWN_TAG_AMMO_SHOTGUN

/obj/item/weapon/storage/box/shotgunammo/flashshells
	name = "box of illumination shells"
	spawn_type = /obj/item/ammo_casing/shotgun/flash/prespawned
	rarity_value = 40
	spawn_tags = SPAWN_TAG_AMMO_SHOTGUN

/obj/item/weapon/storage/box/shotgunammo/practiceshells
	name = "box of practice shells"
	spawn_type = /obj/item/ammo_casing/shotgun/practice/prespawned
	rarity_value = 50

/obj/item/weapon/storage/box/sniperammo
	name = "box of .60 Anti Material shells"
	desc = "It has a picture of a gun and several warning symbols on the front.<br>WARNING: Live ammunition. Misuse may result in serious injury or death."
	illustration = "ammo"
	rarity_value = 80
	initial_amount = 1
	spawn_type = /obj/item/ammo_casing/antim/prespawned
	spawn_tags = SPAWN_TAG_AMMO

/obj/item/weapon/storage/box/sniperammo/populate_contents()
	new spawn_type(src)
	for(var/obj/item/ammo_casing/temp_casing in src)
		temp_casing.update_icon()

/obj/item/weapon/storage/box/flashbangs
	name = "box of flashbangs"
	desc = "A box containing 7 antipersonnel flashbang grenades.<br> WARNING: These devices are extremely dangerous and can cause blindness or deafness in repeated use."
	icon_state = "box_security"
	illustration = "flashbang"
	rarity_value = 60
	initial_amount = 7
	spawn_type = /obj/item/weapon/grenade/flashbang

/obj/item/weapon/storage/box/flashbangs/populate_contents()
	for(var/i in 1 to initial_amount)
		new spawn_type(src)

/obj/item/weapon/storage/box/teargas
	name = "box of pepperspray grenades"
	desc = "A box containing 6 tear gas grenades. A gas mask is printed on the label.<br> WARNING: Exposure carries risk of serious injury or death. Keep away from persons with lung conditions."
	icon_state = "box_security"
	illustration = "flashbang"
	rarity_value = 50
	initial_amount = 6
	spawn_type = /obj/item/weapon/grenade/chem_grenade/teargas

/obj/item/weapon/storage/box/teargas/populate_contents()
	for(var/i in 1 to initial_amount)
		new spawn_type(src)

/obj/item/weapon/storage/box/emps
	name = "box of emp grenades"
	desc = "A box containing 5 military grade EMP grenades.<br> WARNING: Do not use near unshielded electronics or biomechanical augmentations, death or permanent paralysis may occur."
	icon_state = "box_security"
	illustration = "flashbang"
	rarity_value = 60
	initial_amount = 5
	spawn_type = /obj/item/weapon/grenade/empgrenade

/obj/item/weapon/storage/box/emps/populate_contents()
	for(var/i in 1 to initial_amount)
		new spawn_type(src)

/obj/item/weapon/storage/box/frag
	name = "box of fragmentation grenades"
	desc = "A box containing 4 fragmentation grenades. Designed for use on enemies in the open."
	icon_state = "box_security"
	illustration = "flashbang"
	rarity_value = 60
	initial_amount = 4
	spawn_type = /obj/item/weapon/grenade/frag

/obj/item/weapon/storage/box/frag/populate_contents()
	for(var/i in 1 to initial_amount)
		new spawn_type(src)

/obj/item/weapon/storage/box/explosive
	name = "box of blast grenades"
	desc = "A box containing 4 blast grenades. Designed for assaulting strongpoints."
	icon_state = "box_security"
	illustration = "flashbang"
	rarity_value = 70
	initial_amount = 4
	spawn_type = /obj/item/weapon/grenade/explosive

/obj/item/weapon/storage/box/explosive/populate_contents()
	for(var/i in 1 to initial_amount)
		new spawn_type(src)

/obj/item/weapon/storage/box/smokes
	name = "box of smoke bombs"
	desc = "A box containing 5 smoke bombs."
	illustration = "flashbang"
	initial_amount = 5
	spawn_type = /obj/item/weapon/grenade/smokebomb

/obj/item/weapon/storage/box/smokes/populate_contents()
	for(var/i in 1 to initial_amount)
		new spawn_type(src)

/obj/item/weapon/storage/box/anti_photons
	name = "box of anti-photon grenades"
	desc = "A box containing 5 experimental photon disruption grenades."
	illustration = "flashbang"
	rarity_value = 60
	initial_amount = 5
	spawn_type = /obj/item/weapon/grenade/anti_photon

/obj/item/weapon/storage/box/anti_photons/populate_contents()
	for(var/i in 1 to initial_amount)
		new spawn_type(src)

/obj/item/weapon/storage/box/incendiary
	name = "box of incendiary grenades"
	desc = "A box containing 5 incendiary grenades."
	icon_state = "box_security"
	illustration = "flashbang"
	rarity_value = 60
	initial_amount = 5
	spawn_type = /obj/item/weapon/implantcase/tracking

/obj/item/weapon/storage/box/incendiary/populate_contents()
	for(var/i in 1 to initial_amount)
		new spawn_type(src)

/obj/item/weapon/storage/box/trackimp
	name = "boxed tracking implant kit"
	desc = "Box full of scum-bag tracking utensils."
	illustration = "implant"
	rarity_value = 60
	initial_amount = 4
	spawn_type = /obj/item/weapon/implantcase/tracking

/obj/item/weapon/storage/box/trackimp/populate_contents()
	for(var/i in 1 to initial_amount)
		new spawn_type(src)
	new /obj/item/weapon/implanter(src)
	new /obj/item/weapon/implantpad(src)
	new /obj/item/device/gps/locator(src)

/obj/item/weapon/storage/box/chemimp
	name = "boxed chemical implant kit"
	desc = "Box of stuff used to implant chemicals."
	illustration = "implant"
	rarity_value = 60
	initial_amount = 5
	spawn_blacklisted = 1
	spawn_type = /obj/item/weapon/implantcase/chem

/obj/item/weapon/storage/box/chemimp/populate_contents()
	for(var/i in 1 to initial_amount)
		new spawn_type(src)
	new /obj/item/weapon/implanter(src)
	new /obj/item/weapon/implantpad(src)

/obj/item/weapon/storage/box/rxglasses
	name = "box of prescription glasses"
	desc = "This box contains nerd glasses."
	illustration = "glasses"
	initial_amount = 7
	spawn_type = /obj/item/clothing/glasses/regular

/obj/item/weapon/storage/box/rxglasses/populate_contents()
	for(var/i in 1 to initial_amount)
		new spawn_type(src)

/obj/item/weapon/storage/box/drinkingglasses
	name = "box of drinking glasses"
	desc = "It has a picture of drinking glasses on it."
	rarity_value = 10
	initial_amount = 6
	spawn_type = /obj/item/weapon/reagent_containers/food/drinks/drinkingglass

/obj/item/weapon/storage/box/drinkingglasses/populate_contents()
	for(var/i in 1 to initial_amount)
		new spawn_type(src)

/obj/item/weapon/storage/box/cdeathalarm_kit
	name = "death alarm kit"
	desc = "Box of stuff used to implant death alarms."
	illustration = "implant"
	item_state = "syringe_kit"
	rarity_value = 50
	initial_amount = 6
	spawn_type = /obj/item/weapon/implantcase/death_alarm

/obj/item/weapon/storage/box/cdeathalarm_kit/populate_contents()
	new /obj/item/weapon/implanter(src)
	for(var/i in 1 to initial_amount)
		new spawn_type(src)

/obj/item/weapon/storage/box/condimentbottles
	name = "box of condiment bottles"
	desc = "It has a large ketchup smear on it."
	initial_amount = 7
	spawn_type = /obj/item/weapon/reagent_containers/food/condiment

/obj/item/weapon/storage/box/condimentbottles/populate_contents()
	for(var/i in 1 to initial_amount)
		new spawn_type(src)

/obj/item/weapon/storage/box/cups
	name = "box of paper cups"
	desc = "It has pictures of paper cups on the front."
	initial_amount = 7
	spawn_type = /obj/item/weapon/reagent_containers/food/drinks/sillycup

/obj/item/weapon/storage/box/cups/populate_contents()
	for(var/i in 1 to initial_amount)
		new spawn_type(src)


/obj/item/weapon/storage/box/donkpockets
	name = "box of donk-pockets"
	desc = "<B>Instructions:</B> <I>Heat in microwave. Product will cool if not eaten within seven minutes.</I>"
	icon_state = "box_donk_pocket"
	illustration = null
	rarity_value = 10
	initial_amount = 6
	spawn_type = /obj/item/weapon/reagent_containers/food/snacks/donkpocket

/obj/item/weapon/storage/box/donkpockets/populate_contents()
	for(var/i in 1 to initial_amount)
		new spawn_type(src)

/obj/item/weapon/storage/box/sinpockets
	name = "box of sin-pockets"
	desc = "<B>Instructions:</B> <I>Crush bottom of package to initiate chemical heating. Wait for 20 seconds before consumption. Product will cool if not eaten within seven minutes.</I>"
	icon_state = "box_donk_pocket"
	illustration = null
	initial_amount = 6
	spawn_type = /obj/item/weapon/reagent_containers/food/snacks/donkpocket/sinpocket

/obj/item/weapon/storage/box/sinpockets/populate_contents()
	for(var/i in 1 to initial_amount)
		new spawn_type(src)

/obj/item/weapon/storage/box/monkeycubes
	name = "monkey cube box"
	desc = "Drymate brand monkey cubes. Just add water!"
	icon = 'icons/obj/food.dmi'
	icon_state = "monkeycubebox"
	illustration = null
	can_hold = list(/obj/item/weapon/reagent_containers/food/snacks/monkeycube)
	initial_amount = 5
	spawn_type = /obj/item/weapon/reagent_containers/food/snacks/monkeycube/wrapped

/obj/item/weapon/storage/box/monkeycubes/populate_contents()
	for(var/i in 1 to initial_amount)
		new spawn_type(src)

/obj/item/weapon/storage/box/ids
	name = "box of spare IDs"
	desc = "Has so many empty IDs."
	icon_state = "box_id"
	illustration = null
	initial_amount = 7
	spawn_type = /obj/item/weapon/card/id

/obj/item/weapon/storage/box/ids/populate_contents()
	for(var/i in 1 to initial_amount)
		new spawn_type(src)

/obj/item/weapon/storage/box/handcuffs
	name = "box of spare handcuffs"
	desc = "A box full of handcuffs."
	icon_state = "box_security"
	illustration = "handcuff"
	rarity_value = 10
	initial_amount = 7
	spawn_type = /obj/item/weapon/handcuffs

/obj/item/weapon/storage/box/handcuffs/populate_contents()
	for(var/i in 1 to initial_amount)
		new spawn_type(src)


/obj/item/weapon/storage/box/mousetraps
	name = "box of Pest-B-Gon mousetraps"
	desc = "<B><FONT color='red'>WARNING:</FONT></B> <I>Keep out of reach of children</I>."
	illustration = "mousetraps"
	initial_amount = 7
	spawn_type = /obj/item/device/assembly/mousetrap

/obj/item/weapon/storage/box/mousetraps/populate_contents()
	for(var/i in 1 to initial_amount)
		new spawn_type(src)

/obj/item/weapon/storage/box/pillbottles
	name = "box of pill bottles"
	desc = "It has pictures of pill bottles on its front."
	initial_amount = 7
	spawn_type = /obj/item/weapon/storage/pill_bottle

/obj/item/weapon/storage/box/pillbottles/populate_contents()
	for(var/i in 1 to initial_amount)
		new spawn_type(src)

/obj/item/weapon/storage/box/snappops
	name = "snap pop box"
	desc = "Eight wrappers of fun! Ages 8 and up. Not suitable for children."
	icon = 'icons/obj/toy.dmi'
	icon_state = "spbox"
	initial_amount = 8
	spawn_type = /obj/item/toy/snappop

/obj/item/weapon/storage/box/snappops/populate_contents()
	for(var/i in 1 to initial_amount)
		new spawn_type(src)

/obj/item/weapon/storage/box/matches
	name = "matchbox"
	desc = "A small box of 'Space-Proof' premium matches."
	icon = 'icons/obj/cigarettes.dmi'
	icon_state = "matchbox"
	item_state = "zippo"
	illustration = null
	w_class = ITEM_SIZE_TINY
	slot_flags = SLOT_BELT
	rarity_value = 5
	spawn_tags = SPAWN_TAG_BOX_TAG_JUNK
	initial_amount = 14
	spawn_type = /obj/item/weapon/flame/match

/obj/item/weapon/storage/box/matches/populate_contents()
	for(var/i in 1 to initial_amount)
		new spawn_type(src)
	make_exact_fit()

/obj/item/weapon/storage/box/matches/attackby(obj/item/weapon/flame/match/W, mob/user)
	if(istype(W) && !W.lit && !W.burnt)
		playsound(src, 'sound/items/matchstrike.ogg', 20, 1, 1)
		W.lit = 1
		W.damtype = "burn"
		W.icon_state = "match_lit"
		W.tool_qualities = list(QUALITY_CAUTERIZING = 10)
		START_PROCESSING(SSobj, W)
	W.update_icon()
	return

/obj/item/weapon/storage/box/autoinjectors
	name = "box of injectors"
	desc = "Contains autoinjectors."
	illustration = "syringe"
	rarity_value = 10
	initial_amount = 7
	spawn_type = /obj/item/weapon/reagent_containers/hypospray/autoinjector

/obj/item/weapon/storage/box/autoinjectors/populate_contents()
	for(var/i in 1 to initial_amount)
		new spawn_type(src)

/obj/item/weapon/storage/box/lights
	name = "box of replacement bulbs"
	illustration = "light"
	desc = "This box is shaped on the inside so that only light tubes and bulbs fit."
	use_to_pickup = TRUE // for picking up broken bulbs, not that most people will try
	spawn_tags = SPAWN_TAG_BOX_TAG_JUNK
	initial_amount = 21
	spawn_type = /obj/item/weapon/light/bulb

/obj/item/weapon/storage/box/lights/bulbs/populate_contents()
	for(var/i in 1 to initial_amount)
		new spawn_type(src)
	make_exact_fit()

/obj/item/weapon/storage/box/lights/tubes
	name = "box of replacement tubes"
	illustration = "lighttube"
	spawn_tags = SPAWN_TAG_BOX_TAG_JUNK
	initial_amount = 21
	spawn_type = /obj/item/weapon/light/tube

/obj/item/weapon/storage/box/lights/tubes/populate_contents()
	for(var/i in 1 to initial_amount)
		new spawn_type(src)
	make_exact_fit()

/obj/item/weapon/storage/box/lights/mixed
	name = "box of replacement lights"
	illustration = "lightmixed"
	spawn_tags = SPAWN_TAG_BOX_TAG_JUNK
	rarity_value = 6.66
	initial_amount = 14
	spawn_type = /obj/item/weapon/light/tube

/obj/item/weapon/storage/box/lights/mixed/populate_contents()
	for(var/i in 1 to initial_amount)
		new spawn_type(src)
	for(var/i in 1 to 7)
		new /obj/item/weapon/light/bulb(src)
	make_exact_fit()

/obj/item/weapon/storage/box/data_disk
	name = "data disk box"
	illustration = "disk"
	rarity_value = 30
	initial_amount = 7
	spawn_type = /obj/item/weapon/computer_hardware/hard_drive/portable

/obj/item/weapon/storage/box/data_disk/populate_contents()
	for(var/i in 1 to initial_amount)
		new spawn_type(src)

/obj/item/weapon/storage/box/data_disk/basic
	name = "basic data disk box"
	illustration = "disk"
	rarity_value = 10
	initial_amount = 7
	spawn_type = /obj/item/weapon/computer_hardware/hard_drive/portable/basic

/obj/item/weapon/storage/box/data_disk/basic/populate_contents()
	for(var/i in 1 to initial_amount)
		new spawn_type(src)

/obj/item/weapon/storage/box/headset/church
	name = "neotheology radio encryption key box"
	illustration = "disk"
	initial_amount = 7
	spawn_type = /obj/item/device/encryptionkey/headset_church
	spawn_blacklisted = TRUE

/obj/item/weapon/storage/box/headset/church/populate_contents()
	for(var/i in 1 to initial_amount)
		new spawn_type(src)

/obj/item/weapon/storage/box/happy_meal
	name = "McRonalds' Robust Meal"
	desc = "This is typical Robust Meal from McRonalds... And you almost feel smell of delicious food from it. Wait! It must have toy inside! Unpack it now!"
	icon_state = "happy_meal"

/obj/item/weapon/storage/box/happy_meal/New()
	..()
	var/list/things2spawn = list(
		/obj/item/weapon/reagent_containers/food/snacks/sliceable/plaincake,
		/obj/item/weapon/reagent_containers/food/snacks/sliceable/chocolatecake,
		/obj/item/weapon/reagent_containers/food/snacks/bigbiteburger,
		/obj/item/weapon/reagent_containers/food/snacks/fishandchips
	)
/*someday...
	if(prob(1))
		things2spawn += /obj/item/clothing/head/kitty
*/
	things2spawn += pick(subtypesof(/obj/item/toy/plushie) + subtypesof(/obj/item/toy/figure))
	for(var/path in things2spawn)
		new path(src)
