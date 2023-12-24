/* First aid storage
 * Contains:
 *		First Aid Kits
 * 		Pill Bottles
 *		Portable Freezer
 */

/*
 * First Aid Kits
 */
/obj/item/storage/firstaid
	name = "first-aid kit"
	desc = "An emergency medical kit for those serious boo-boos."
	icon_state = "firstaid"
	throw_speed = 2
	throw_range = 8
	rarity_value = 10
	spawn_tags = SPAWN_TAG_FIRSTAID
	bad_type = /obj/item/storage/firstaid

/obj/item/storage/firstaid/fire
	name = "fire first-aid kit"
	desc = "An emergency medical kit for when the toxins lab <i>-spontaneously-</i> burns down."
	icon_state = "ointment"
	item_state = "firstaid-ointment"
	rarity_value = 15
	prespawned_content_amount = 2
	prespawned_content_type = /obj/item/stack/medical/ointment

/obj/item/storage/firstaid/fire/populate_contents()
	icon_state = pick("ointment","firefirstaid")
	var/list/spawnedAtoms = list()

	for(var/i in 1 to prespawned_content_amount)
		spawnedAtoms.Add(new prespawned_content_type(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/reagent_containers/pill/kelotane(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/reagent_containers/pill/kelotane(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/reagent_containers/pill/kelotane(NULLSPACE)) //Replaced ointment with these since they actually work --Errorage
	spawnedAtoms.Add(new /obj/item/reagent_containers/hypospray/autoinjector(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/device/scanner/health(NULLSPACE))
	for(var/atom/movable/a in spawnedAtoms)
		a.forceMove(src)


/obj/item/storage/firstaid/regular
	icon_state = "firstaid"
	rarity_value = 10
	prespawned_content_amount = 3
	prespawned_content_type = /obj/item/stack/medical/bruise_pack

/obj/item/storage/firstaid/regular/populate_contents()
	var/list/spawnedAtoms = list()

	for(var/i in 1 to prespawned_content_amount)
		spawnedAtoms.Add(new prespawned_content_type(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/stack/medical/ointment(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/stack/medical/ointment(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/reagent_containers/hypospray/autoinjector(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/device/scanner/health(NULLSPACE))
	for(var/atom/movable/a in spawnedAtoms)
		a.forceMove(src)


/obj/item/storage/firstaid/toxin
	name = "toxin first aid"
	desc = "Used to treat when you have a high amoutn of toxins in your body."
	icon_state = "antitoxin"
	item_state = "firstaid-toxin"
	rarity_value = 15
	prespawned_content_amount = 3
	prespawned_content_type = /obj/item/reagent_containers/syringe/antitoxin

/obj/item/storage/firstaid/toxin/populate_contents()
	icon_state = pick("antitoxin","antitoxfirstaid2","antitoxfirstaid3")
	var/list/spawnedAtoms = list()

	for(var/i in 1 to prespawned_content_amount)
		spawnedAtoms.Add(new prespawned_content_type(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/reagent_containers/pill/antitox(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/reagent_containers/pill/antitox(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/reagent_containers/pill/antitox(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/reagent_containers/pill/carbon(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/reagent_containers/pill/carbon(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/reagent_containers/pill/carbon(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/reagent_containers/hypospray/autoinjector(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/device/scanner/health(NULLSPACE))
	for(var/atom/movable/a in spawnedAtoms)
		a.forceMove(src)


/obj/item/storage/firstaid/o2
	name = "oxygen deprivation first aid"
	desc = "A box full of oxygen goodies."
	icon_state = "o2"
	item_state = "firstaid-o2"
	rarity_value = 15
	prespawned_content_amount = 4
	prespawned_content_type = /obj/item/reagent_containers/pill/dexalin

/obj/item/storage/firstaid/o2/populate_contents()
	var/list/spawnedAtoms = list()

	for(var/i in 1 to prespawned_content_amount)
		spawnedAtoms.Add(new prespawned_content_type(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/reagent_containers/hypospray/autoinjector(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/reagent_containers/syringe/inaprovaline(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/device/scanner/health(NULLSPACE))
	for(var/atom/movable/a in spawnedAtoms)
		a.forceMove(src)


/obj/item/storage/firstaid/adv
	name = "advanced first-aid kit"
	desc = "Contains advanced medical treatments."
	icon_state = "advfirstaid"
	item_state = "firstaid-advanced"
	rarity_value = 30
	prespawned_content_amount = 3
	prespawned_content_type = /obj/item/stack/medical/advanced/bruise_pack

/obj/item/storage/firstaid/adv/populate_contents()
	var/list/spawnedAtoms = list()

	for(var/i in 1 to prespawned_content_amount)
		spawnedAtoms.Add(new prespawned_content_type(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/stack/medical/advanced/ointment(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/stack/medical/advanced/ointment(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/stack/medical/splint(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/reagent_containers/syringe/inaprovaline(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/device/scanner/health(NULLSPACE))
	for(var/atom/movable/a in spawnedAtoms)
		a.forceMove(src)

/obj/item/storage/firstaid/combat
	name = "combat medical kit"
	desc = "Contains advanced medical treatments."
	icon_state = "bezerk"
	item_state = "firstaid-advanced"
	rarity_value = 100
	prespawned_content_amount = 1
	prespawned_content_type = /obj/item/stack/medical/splint

/obj/item/storage/firstaid/combat/populate_contents()
	var/list/spawnedAtoms = list()

	for(var/i in 1 to prespawned_content_amount)
		spawnedAtoms.Add(new prespawned_content_type(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/storage/pill_bottle/meralyne(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/storage/pill_bottle/dermaline(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/storage/pill_bottle/dexalin_plus(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/storage/pill_bottle/dylovene(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/storage/pill_bottle/tramadol(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/storage/pill_bottle/spaceacillin(NULLSPACE))
	for(var/atom/movable/a in spawnedAtoms)
		a.forceMove(src)

/obj/item/storage/firstaid/surgery
	name = "surgery kit"
	desc = "Contains tools for surgery. Has precise foam fitting for safe transport."
	icon_state = "surgeon"
	item_state = "firstaid-surgeon"
	rarity_value = 90
	can_hold = list(
		/obj/item/tool/bonesetter,
		/obj/item/tool/cautery,
		/obj/item/tool/saw,
		/obj/item/tool/hemostat,
		/obj/item/tool/retractor,
		/obj/item/tool/scalpel,
		/obj/item/tool/surgicaldrill,
		/obj/item/device/scanner,
		/obj/item/storage/pill_bottle,
		/obj/item/stack/medical,
		/obj/item/tool/tape_roll
		)

/obj/item/storage/firstaid/surgery/populate_contents()
	var/list/spawnedAtoms = list()

	spawnedAtoms.Add(new /obj/item/tool/bonesetter(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/tool/cautery(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/tool/saw/circular(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/tool/hemostat(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/tool/retractor(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/tool/scalpel(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/tool/surgicaldrill(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/tool/tape_roll/fiber/medical(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/stack/medical/advanced/bruise_pack(NULLSPACE))
	for(var/atom/movable/a in spawnedAtoms)
		a.forceMove(src)
	make_exact_fit()

/obj/item/storage/firstaid/surgery/contractor
	spawn_blacklisted = TRUE

/obj/item/storage/firstaid/surgery/contractor/populate_contents()
	var/list/spawnedAtoms = list()

	spawnedAtoms.Add(new /obj/item/tool/bonesetter(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/tool/cautery(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/tool/saw/circular/advanced(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/tool/hemostat(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/tool/retractor(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/tool/scalpel/advanced(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/tool/surgicaldrill(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/tool/tape_roll/fiber/medical(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/device/scanner/health(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/stack/medical/advanced/bruise_pack(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/storage/pill_bottle/oxycodone(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/storage/pill_bottle/prosurgeon(NULLSPACE))
	for(var/atom/movable/a in spawnedAtoms)
		a.forceMove(src)
	make_exact_fit()

/obj/item/storage/firstaid/nt
	name = "NeoTheology medkit"
	desc = "A medkit filled with a set of high-end trauma kits and anti-toxins."
	icon_state = "nt_kit"
	item_state = "nt_kit"
	matter = list(MATERIAL_BIOMATTER = 10)
	prespawned_content_amount = 2
	prespawned_content_type = /obj/item/stack/medical/advanced/bruise_pack/nt
	spawn_blacklisted = TRUE

/obj/item/storage/firstaid/nt/populate_contents()
	var/list/spawnedAtoms = list()

	for(var/i in 1 to prespawned_content_amount)
		spawnedAtoms.Add(new prespawned_content_type(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/stack/medical/advanced/ointment/nt(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/stack/medical/advanced/ointment/nt(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/reagent_containers/syringe/large/antitoxin(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/reagent_containers/syringe/large/dexalin_plus(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/reagent_containers/pill/carbon(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/reagent_containers/pill/carbon(NULLSPACE))
	for(var/atom/movable/a in spawnedAtoms)
		a.forceMove(src)

/obj/item/storage/firstaid/nt/update_icon()
	if(!contents.len)
		icon_state = "[initial(icon_state)]_empty"
		item_state = "[initial(item_state)]_empty"
	else
		icon_state = "[initial(icon_state)]"
		item_state = "[initial(item_state)]"
	..()

/*
 * Pill Bottles
 */
/obj/item/storage/pill_bottle
	name = "pill bottle"
	desc = "An airtight container for storing medication."
	icon_state = "pill_canister"
	icon = 'icons/obj/chemical.dmi'
	item_state = "contsolid"
	volumeClass = ITEM_SIZE_SMALL
	can_hold = list(/obj/item/reagent_containers/pill,
		/obj/item/dice,
		/obj/item/paper)
	allow_quick_gather = TRUE
	use_to_pickup = TRUE
	use_sound = null
	matter = list(MATERIAL_PLASTIC = 1)
	max_storage_space = 12
	rarity_value = 10
	bad_type = /obj/item/storage/pill_bottle
	spawn_tags = SPAWN_TAG_MEDICINE
	prespawned_content_amount = 7

/obj/item/storage/pill_bottle/antitox
	name = "bottle of Dylovene pills"
	desc = "Contains pills used to counter toxins."
	prespawned_content_type = /obj/item/reagent_containers/pill/antitox

/obj/item/storage/pill_bottle/bicaridine
	name = "bottle of Bicaridine pills"
	desc = "Contains pills used to stabilize the severely injured."
	prespawned_content_type = /obj/item/reagent_containers/pill/bicaridine

/obj/item/storage/pill_bottle/dexalin_plus
	name = "bottle of Dexalin Plus pills"
	desc = "Contains pills used to treat extreme cases of oxygen deprivation."
	prespawned_content_type = /obj/item/reagent_containers/pill/dexalin_plus

/obj/item/storage/pill_bottle/dermaline
	name = "bottle of Dermaline pills"
	desc = "Contains pills used to treat burn wounds."
	prespawned_content_type = /obj/item/reagent_containers/pill/dermaline

/obj/item/storage/pill_bottle/dylovene
	name = "bottle of Dylovene pills"
	desc = "Contains pills used to treat toxic substances in the blood."
	prespawned_content_type = /obj/item/reagent_containers/pill/dylovene

/obj/item/storage/pill_bottle/carbon
	name = "bottle of Carbon pills"
	desc = "Contains pills used to purge stomach contents."
	prespawned_content_type = /obj/item/reagent_containers/pill/carbon

/obj/item/storage/pill_bottle/inaprovaline
	name = "bottle of Inaprovaline pills"
	desc = "Contains pills used to stabilize patients."
	prespawned_content_type = /obj/item/reagent_containers/pill/inaprovaline

/obj/item/storage/pill_bottle/kelotane
	name = "bottle of Kelotane pills"
	desc = "Contains pills used to treat burns."
	prespawned_content_type = /obj/item/reagent_containers/pill/kelotane

/obj/item/storage/pill_bottle/spaceacillin
	name = "bottle of Spaceacillin pills"
	desc = "A theta-lactam antibiotic. Effective against many diseases likely to be encountered in space."
	prespawned_content_type = /obj/item/reagent_containers/pill/spaceacillin

/obj/item/storage/pill_bottle/tramadol
	name = "bottle of Tramadol pills"
	desc = "Contains pills used to relieve pain."
	rarity_value = 15
	prespawned_content_type = /obj/item/reagent_containers/pill/tramadol

/obj/item/storage/pill_bottle/citalopram
	name = "bottle of Citalopram pills"
	desc = "Contains pills used to stabilize a patient's mood."
	prespawned_content_type = /obj/item/reagent_containers/pill/citalopram

/obj/item/storage/pill_bottle/prosurgeon
	name = "bottle of ProSurgeon pills"
	desc = "Contains pills used to reduce hand tremor."
	prespawned_content_type = /obj/item/reagent_containers/pill/prosurgeon
	rarity_value = 20

/obj/item/storage/pill_bottle/oxycodone
	name = "bottle of Oxycodone pills"
	desc = "Contains pills used to relieve extreme pain. DO NOT OVERCONSUME."
	spawn_tags = SPAWN_TAG_MEDICINE_CONTRABAND
	prespawned_content_type = /obj/item/reagent_containers/pill/oxycodone
	rarity_value = 30

/obj/item/storage/pill_bottle/meralyne
	name = "bottle of Meralyne pills"
	desc = "Contains pills used to heal physical harm."
	prespawned_content_type = /obj/item/reagent_containers/pill/meralyne
	rarity_value = 20

/obj/item/storage/pill_bottle/njoy
	name = "bottle of Njoy pills"
	desc = "Contains pills used to stop all breakdowns."
	icon_state = "bottle_njoy_red"
	prespawned_content_type = /obj/item/reagent_containers/pill/suppressital/red

/obj/item/storage/pill_bottle/njoy/green
	icon_state = "bottle_njoy_green"
	prespawned_content_type = /obj/item/reagent_containers/pill/suppressital/green

/obj/item/storage/pill_bottle/njoy/blue
	icon_state = "bottle_njoy_blue"
	prespawned_content_type = /obj/item/reagent_containers/pill/suppressital/blue

/*
 * Portable Freezers
 */
/obj/item/storage/freezer
	name = "portable freezer"
	desc = "This nifty shock-resistant device will keep your 'groceries' nice and non-spoiled."
	icon_state = "freezer"
	item_state = "medicalpack"
	max_volumeClass = ITEM_SIZE_NORMAL
	matter = list(MATERIAL_STEEL = 1, MATERIAL_PLASTIC = 2)
	can_hold = list(/obj/item/organ, /obj/item/modification/organ, /obj/item/reagent_containers/food, /obj/item/reagent_containers/glass)
	max_storage_space = DEFAULT_NORMAL_STORAGE
	use_to_pickup = TRUE

/obj/item/storage/freezer/contains_food/populate_contents()
	var/list/spawnedAtoms = list()

	new /obj/spawner/pizza/low_chance(src)
	new /obj/spawner/soda(src)
	new /obj/spawner/soda/low_chance(src)
	new /obj/spawner/rations/low_chance(src)
	new /obj/spawner/junkfood(src)
	new /obj/spawner/junkfood(src)
	new /obj/spawner/junkfood(src)
	new /obj/spawner/junkfood/low_chance(src)
	new /obj/spawner/junkfood/low_chance(src)
	new /obj/spawner/booze/low_chance(src)
	for(var/atom/movable/a in spawnedAtoms)
		a.forceMove(src)

/obj/item/storage/freezer/medical
	name = "organ freezer"
	icon_state = "freezer_red"
	item_state = "medicalpack"
	matter = list(MATERIAL_PLASTEEL = 1, MATERIAL_PLASTIC = 2)
	max_storage_space = DEFAULT_NORMAL_STORAGE * 1.25
