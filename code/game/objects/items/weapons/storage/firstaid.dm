/* First aid storage
 * Contains:
 *		First Aid Kits
 * 		Pill Bottles
 */

/*
 * First Aid Kits
 */
/obj/item/weapon/storage/firstaid
	name = "first-aid kit"
	desc = "It's an emergency medical kit for those serious boo-boos."
	icon_state = "firstaid"
	throw_speed = 2
	throw_range = 8
	var/empty = 0


/obj/item/weapon/storage/firstaid/fire
	name = "fire first-aid kit"
	desc = "It's an emergency medical kit for when the toxins lab <i>-spontaneously-</i> burns down."
	icon_state = "ointment"
	item_state = "firstaid-ointment"

/obj/item/weapon/storage/firstaid/fire/populate_contents()
	icon_state = pick("ointment","firefirstaid")

	if (empty) return
	new /obj/item/stack/medical/ointment(src)
	new /obj/item/stack/medical/ointment(src)
	new /obj/item/weapon/reagent_containers/pill/kelotane(src)
	new /obj/item/weapon/reagent_containers/pill/kelotane(src)
	new /obj/item/weapon/reagent_containers/pill/kelotane(src) //Replaced ointment with these since they actually work --Errorage
	new /obj/item/weapon/reagent_containers/hypospray/autoinjector(src)
	new /obj/item/device/scanner/health(src)


/obj/item/weapon/storage/firstaid/regular
	icon_state = "firstaid"

/obj/item/weapon/storage/firstaid/regular/populate_contents()
	if (empty) return
	new /obj/item/stack/medical/bruise_pack(src)
	new /obj/item/stack/medical/bruise_pack(src)
	new /obj/item/stack/medical/bruise_pack(src)
	new /obj/item/stack/medical/ointment(src)
	new /obj/item/stack/medical/ointment(src)
	new /obj/item/weapon/reagent_containers/hypospray/autoinjector(src)
	new /obj/item/device/scanner/health(src)


/obj/item/weapon/storage/firstaid/toxin
	name = "toxin first aid"
	desc = "Used to treat when you have a high amoutn of toxins in your body."
	icon_state = "antitoxin"
	item_state = "firstaid-toxin"

/obj/item/weapon/storage/firstaid/toxin/populate_contents()
	icon_state = pick("antitoxin","antitoxfirstaid","antitoxfirstaid2","antitoxfirstaid3")

	if (empty) return
	new /obj/item/weapon/reagent_containers/syringe/antitoxin(src)
	new /obj/item/weapon/reagent_containers/syringe/antitoxin(src)
	new /obj/item/weapon/reagent_containers/syringe/antitoxin(src)
	new /obj/item/weapon/reagent_containers/pill/antitox(src)
	new /obj/item/weapon/reagent_containers/pill/antitox(src)
	new /obj/item/weapon/reagent_containers/pill/antitox(src)
	new /obj/item/weapon/reagent_containers/hypospray/autoinjector(src)
	new /obj/item/device/scanner/health(src)


/obj/item/weapon/storage/firstaid/o2
	name = "oxygen deprivation first aid"
	desc = "A box full of oxygen goodies."
	icon_state = "o2"
	item_state = "firstaid-o2"

/obj/item/weapon/storage/firstaid/o2/populate_contents()
	if (empty) return
	new /obj/item/weapon/reagent_containers/pill/dexalin(src)
	new /obj/item/weapon/reagent_containers/pill/dexalin(src)
	new /obj/item/weapon/reagent_containers/pill/dexalin(src)
	new /obj/item/weapon/reagent_containers/pill/dexalin(src)
	new /obj/item/weapon/reagent_containers/hypospray/autoinjector(src)
	new /obj/item/weapon/reagent_containers/syringe/inaprovaline(src)
	new /obj/item/device/scanner/health(src)


/obj/item/weapon/storage/firstaid/adv
	name = "advanced first-aid kit"
	desc = "Contains advanced medical treatments."
	icon_state = "advfirstaid"
	item_state = "firstaid-advanced"

/obj/item/weapon/storage/firstaid/adv/populate_contents()
	if (empty) return
	new /obj/item/stack/medical/advanced/bruise_pack(src)
	new /obj/item/stack/medical/advanced/bruise_pack(src)
	new /obj/item/stack/medical/advanced/bruise_pack(src)
	new /obj/item/stack/medical/advanced/ointment(src)
	new /obj/item/stack/medical/advanced/ointment(src)
	new /obj/item/stack/medical/splint(src)
	new /obj/item/weapon/reagent_containers/syringe/inaprovaline(src)
	new /obj/item/device/scanner/health(src)

/obj/item/weapon/storage/firstaid/combat
	name = "combat medical kit"
	desc = "Contains advanced medical treatments."
	icon_state = "bezerk"
	item_state = "firstaid-advanced"

/obj/item/weapon/storage/firstaid/combat/populate_contents()
	if (empty) return
	new /obj/item/weapon/storage/pill_bottle/bicaridine(src)
	new /obj/item/weapon/storage/pill_bottle/dermaline(src)
	new /obj/item/weapon/storage/pill_bottle/dexalin_plus(src)
	new /obj/item/weapon/storage/pill_bottle/dylovene(src)
	new /obj/item/weapon/storage/pill_bottle/tramadol(src)
	new /obj/item/weapon/storage/pill_bottle/spaceacillin(src)
	new /obj/item/stack/medical/splint(src)

/obj/item/weapon/storage/firstaid/surgery
	name = "surgery kit"
	desc = "Contains tools for surgery. Has precise foam fitting for safe transport."
	icon_state = "surgeon"
	item_state = "firstaid-surgeon"
	can_hold = list(
		/obj/item/weapon/tool/bonesetter,
		/obj/item/weapon/tool/cautery,
		/obj/item/weapon/tool/saw,
		/obj/item/weapon/tool/hemostat,
		/obj/item/weapon/tool/retractor,
		/obj/item/weapon/tool/scalpel,
		/obj/item/weapon/tool/surgicaldrill,
		/obj/item/device/scanner,
		/obj/item/weapon/storage/pill_bottle,
		/obj/item/stack/medical,
		)

/obj/item/weapon/storage/firstaid/surgery/populate_contents()
	if (empty) return
	new /obj/item/weapon/tool/bonesetter(src)
	new /obj/item/weapon/tool/cautery(src)
	new /obj/item/weapon/tool/saw/circular(src)
	new /obj/item/weapon/tool/hemostat(src)
	new /obj/item/weapon/tool/retractor(src)
	new /obj/item/weapon/tool/scalpel(src)
	new /obj/item/weapon/tool/surgicaldrill(src)
	new /obj/item/stack/medical/advanced/bruise_pack(src)
	make_exact_fit()

/obj/item/weapon/storage/firstaid/surgery/traitor/populate_contents()
	if (empty) return
	new /obj/item/weapon/tool/bonesetter(src)
	new /obj/item/weapon/tool/cautery(src)
	new /obj/item/weapon/tool/saw/circular/advanced(src)
	new /obj/item/weapon/tool/hemostat(src)
	new /obj/item/weapon/tool/retractor(src)
	new /obj/item/weapon/tool/scalpel/advanced(src)
	new /obj/item/weapon/tool/surgicaldrill(src)
	new /obj/item/device/scanner/health(src)
	new /obj/item/stack/medical/advanced/bruise_pack(src)
	new /obj/item/weapon/storage/pill_bottle/tramadol(src)
	new /obj/item/weapon/storage/pill_bottle/prosurgeon(src)
	make_exact_fit()

/*
 * Pill Bottles
 */
/obj/item/weapon/storage/pill_bottle
	name = "pill bottle"
	desc = "It's an airtight container for storing medication."
	icon_state = "pill_canister"
	icon = 'icons/obj/chemical.dmi'
	item_state = "contsolid"
	w_class = ITEM_SIZE_SMALL
	can_hold = list(/obj/item/weapon/reagent_containers/pill,
		/obj/item/weapon/dice,
		/obj/item/weapon/paper
		)
	allow_quick_gather = TRUE
	use_to_pickup = TRUE
	use_sound = null
	matter = list(MATERIAL_PLASTIC = 1)
	max_storage_space = 12

/obj/item/weapon/storage/pill_bottle/antitox
	name = "bottle of Dylovene pills"
	desc = "Contains pills used to counter toxins."

/obj/item/weapon/storage/pill_bottle/antitox/populate_contents()
	new /obj/item/weapon/reagent_containers/pill/antitox(src)
	new /obj/item/weapon/reagent_containers/pill/antitox(src)
	new /obj/item/weapon/reagent_containers/pill/antitox(src)
	new /obj/item/weapon/reagent_containers/pill/antitox(src)
	new /obj/item/weapon/reagent_containers/pill/antitox(src)
	new /obj/item/weapon/reagent_containers/pill/antitox(src)
	new /obj/item/weapon/reagent_containers/pill/antitox(src)

/obj/item/weapon/storage/pill_bottle/bicaridine
	name = "bottle of Bicaridine pills"
	desc = "Contains pills used to stabilize the severely injured."

/obj/item/weapon/storage/pill_bottle/bicaridine/populate_contents()
    new /obj/item/weapon/reagent_containers/pill/bicaridine(src)
    new /obj/item/weapon/reagent_containers/pill/bicaridine(src)
    new /obj/item/weapon/reagent_containers/pill/bicaridine(src)
    new /obj/item/weapon/reagent_containers/pill/bicaridine(src)
    new /obj/item/weapon/reagent_containers/pill/bicaridine(src)
    new /obj/item/weapon/reagent_containers/pill/bicaridine(src)
    new /obj/item/weapon/reagent_containers/pill/bicaridine(src)

/obj/item/weapon/storage/pill_bottle/dexalin_plus
	name = "bottle of Dexalin Plus pills"
	desc = "Contains pills used to treat extreme cases of oxygen deprivation."

/obj/item/weapon/storage/pill_bottle/dexalin_plus/populate_contents()
    new /obj/item/weapon/reagent_containers/pill/dexalin_plus(src)
    new /obj/item/weapon/reagent_containers/pill/dexalin_plus(src)
    new /obj/item/weapon/reagent_containers/pill/dexalin_plus(src)
    new /obj/item/weapon/reagent_containers/pill/dexalin_plus(src)
    new /obj/item/weapon/reagent_containers/pill/dexalin_plus(src)
    new /obj/item/weapon/reagent_containers/pill/dexalin_plus(src)
    new /obj/item/weapon/reagent_containers/pill/dexalin_plus(src)

/obj/item/weapon/storage/pill_bottle/dermaline
	name = "bottle of Dermaline pills"
	desc = "Contains pills used to treat burn wounds."

/obj/item/weapon/storage/pill_bottle/dermaline/populate_contents()
    new /obj/item/weapon/reagent_containers/pill/dermaline(src)
    new /obj/item/weapon/reagent_containers/pill/dermaline(src)
    new /obj/item/weapon/reagent_containers/pill/dermaline(src)
    new /obj/item/weapon/reagent_containers/pill/dermaline(src)
    new /obj/item/weapon/reagent_containers/pill/dermaline(src)
    new /obj/item/weapon/reagent_containers/pill/dermaline(src)
    new /obj/item/weapon/reagent_containers/pill/dermaline(src)

/obj/item/weapon/storage/pill_bottle/dylovene
	name = "bottle of Dylovene pills"
	desc = "Contains pills used to treat toxic substances in the blood."

/obj/item/weapon/storage/pill_bottle/dylovene/populate_contents()
    new /obj/item/weapon/reagent_containers/pill/dylovene(src)
    new /obj/item/weapon/reagent_containers/pill/dylovene(src)
    new /obj/item/weapon/reagent_containers/pill/dylovene(src)
    new /obj/item/weapon/reagent_containers/pill/dylovene(src)
    new /obj/item/weapon/reagent_containers/pill/dylovene(src)
    new /obj/item/weapon/reagent_containers/pill/dylovene(src)
    new /obj/item/weapon/reagent_containers/pill/dylovene(src)

/obj/item/weapon/storage/pill_bottle/inaprovaline
	name = "bottle of Inaprovaline pills"
	desc = "Contains pills used to stabilize patients."

/obj/item/weapon/storage/pill_bottle/inaprovaline/populate_contents()
	new /obj/item/weapon/reagent_containers/pill/inaprovaline(src)
	new /obj/item/weapon/reagent_containers/pill/inaprovaline(src)
	new /obj/item/weapon/reagent_containers/pill/inaprovaline(src)
	new /obj/item/weapon/reagent_containers/pill/inaprovaline(src)
	new /obj/item/weapon/reagent_containers/pill/inaprovaline(src)
	new /obj/item/weapon/reagent_containers/pill/inaprovaline(src)
	new /obj/item/weapon/reagent_containers/pill/inaprovaline(src)

/obj/item/weapon/storage/pill_bottle/kelotane
	name = "bottle of Kelotane pills"
	desc = "Contains pills used to treat burns."

/obj/item/weapon/storage/pill_bottle/kelotane/populate_contents()
	new /obj/item/weapon/reagent_containers/pill/kelotane(src)
	new /obj/item/weapon/reagent_containers/pill/kelotane(src)
	new /obj/item/weapon/reagent_containers/pill/kelotane(src)
	new /obj/item/weapon/reagent_containers/pill/kelotane(src)
	new /obj/item/weapon/reagent_containers/pill/kelotane(src)
	new /obj/item/weapon/reagent_containers/pill/kelotane(src)
	new /obj/item/weapon/reagent_containers/pill/kelotane(src)

/obj/item/weapon/storage/pill_bottle/spaceacillin
	name = "bottle of Spaceacillin pills"
	desc = "A theta-lactam antibiotic. Effective against many diseases likely to be encountered in space."

/obj/item/weapon/storage/pill_bottle/spaceacillin/populate_contents()
    new /obj/item/weapon/reagent_containers/pill/spaceacillin(src)
    new /obj/item/weapon/reagent_containers/pill/spaceacillin(src)
    new /obj/item/weapon/reagent_containers/pill/spaceacillin(src)
    new /obj/item/weapon/reagent_containers/pill/spaceacillin(src)
    new /obj/item/weapon/reagent_containers/pill/spaceacillin(src)
    new /obj/item/weapon/reagent_containers/pill/spaceacillin(src)
    new /obj/item/weapon/reagent_containers/pill/spaceacillin(src)

/obj/item/weapon/storage/pill_bottle/tramadol
	name = "bottle of Tramadol pills"
	desc = "Contains pills used to relieve pain."

/obj/item/weapon/storage/pill_bottle/tramadol/populate_contents()
	new /obj/item/weapon/reagent_containers/pill/tramadol(src)
	new /obj/item/weapon/reagent_containers/pill/tramadol(src)
	new /obj/item/weapon/reagent_containers/pill/tramadol(src)
	new /obj/item/weapon/reagent_containers/pill/tramadol(src)
	new /obj/item/weapon/reagent_containers/pill/tramadol(src)
	new /obj/item/weapon/reagent_containers/pill/tramadol(src)
	new /obj/item/weapon/reagent_containers/pill/tramadol(src)

/obj/item/weapon/storage/pill_bottle/citalopram
	name = "bottle of Citalopram pills"
	desc = "Contains pills used to stabilize a patient's mood."

/obj/item/weapon/storage/pill_bottle/citalopram/populate_contents()
	new /obj/item/weapon/reagent_containers/pill/citalopram(src)
	new /obj/item/weapon/reagent_containers/pill/citalopram(src)
	new /obj/item/weapon/reagent_containers/pill/citalopram(src)
	new /obj/item/weapon/reagent_containers/pill/citalopram(src)
	new /obj/item/weapon/reagent_containers/pill/citalopram(src)
	new /obj/item/weapon/reagent_containers/pill/citalopram(src)
	new /obj/item/weapon/reagent_containers/pill/citalopram(src)

/obj/item/weapon/storage/pill_bottle/prosurgeon
	name = "bottle of ProSurgeon pills"
	desc = "Contains pills used to reduce hand tremor."

/obj/item/weapon/storage/pill_bottle/prosurgeon/populate_contents()
	new /obj/item/weapon/reagent_containers/pill/prosurgeon(src)
	new /obj/item/weapon/reagent_containers/pill/prosurgeon(src)
	new /obj/item/weapon/reagent_containers/pill/prosurgeon(src)
	new /obj/item/weapon/reagent_containers/pill/prosurgeon(src)
	new /obj/item/weapon/reagent_containers/pill/prosurgeon(src)
	new /obj/item/weapon/reagent_containers/pill/prosurgeon(src)
	new /obj/item/weapon/reagent_containers/pill/prosurgeon(src)
