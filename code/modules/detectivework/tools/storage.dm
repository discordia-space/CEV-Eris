/obj/item/storage/box/swabs
	name = "box of swab kits"
	desc = "Sterilized equipment within. Do not contaminate."
	icon = 'icons/obj/forensics.dmi'
	icon_state = "dnakit"
	illustration = null
	can_hold = list(/obj/item/forensics/swab)
	storage_slots = 14
	prespawned_content_amount = 14
	prespawned_content_type = /obj/item/forensics/swab

/obj/item/storage/box/evidence
	name = "evidence bag box"
	desc = "A box claiming to contain evidence bags."
	can_hold = list(/obj/item/evidencebag)
	prespawned_content_amount = 7
	prespawned_content_type = /obj/item/evidencebag

/obj/item/storage/box/fingerprints
	name = "box of fingerprint cards"
	desc = "Sterilized equipment within. Do not contaminate."
	icon = 'icons/obj/forensics.dmi'
	icon_state = "dnakit"
	illustration = null
	can_hold = list(/obj/item/sample/print)
	storage_slots = 14
	prespawned_content_amount = 14
	prespawned_content_type = /obj/item/sample/print
