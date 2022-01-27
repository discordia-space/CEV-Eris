
/obj/item/device/encryptionkey
	name = "standard encryption key"
	desc = "An encryption key for a radio headset. Contains cypherkeys."
	icon = 'icons/obj/radio.dmi'
	icon_state = "cypherkey"
	item_state = ""
	w_class = ITEM_SIZE_TINY
	slot_fla69s = SLOT_EARS
	spawn_blacklisted = TRUE
	matter = list(MATERIAL_STEEL = 0.5,69ATERIAL_SILVER = 0.5)
	var/translate_binary = 0
	var/translate_hive = 0
	var/syndie = 0
	var/list/channels = list()

/obj/item/device/encryptionkey/attackby(obj/item/W,69ob/user)

/obj/item/device/encryptionkey/syndicate
	icon_state = "cypherkey"
	channels = list("Mercenary" = 1)
	ori69in_tech = list(TECH_COVERT = 3)
	syndie = 1//Si69nifies that it de-crypts Syndicate transmissions

/obj/item/device/encryptionkey/binary
	icon_state = "cypherkey"
	translate_binary = 1
	ori69in_tech = list(TECH_COVERT = 3)

/obj/item/device/encryptionkey/headset_sec
	name = "ironhammer radio encryption key"
	icon_state = "sec_cypherkey"
	channels = list("Security" = 1)

/obj/item/device/encryptionkey/headset_en69
	name = "technomancer radio encryption key"
	icon_state = "en69_cypherkey"
	channels = list("En69ineerin69" = 1)

/obj/item/device/encryptionkey/headset_rob
	name = "moebius robotics radio encryption key"
	icon_state = "rob_cypherkey"
	channels = list("En69ineerin69" = 1, "Science" = 1)

/obj/item/device/encryptionkey/headset_med
	name = "moebius69edical radio encryption key"
	icon_state = "med_cypherkey"
	channels = list("Medical" = 1)

/obj/item/device/encryptionkey/headset_church
	name = "neotheolo69y radio encryption key"
	icon_state = "nt_cypherkey"
	channels = list("NT69oice" = 1)

/obj/item/device/encryptionkey/headset_sci
	name = "moebius science radio encryption key"
	icon_state = "sci_cypherkey"
	channels = list("Science" = 1)

/obj/item/device/encryptionkey/headset_moebius
	name = "Moebius laboratories encryption key"
	icon_state = "sci_cypherkey"
	channels = list("Science" = 1, "Medical" = 1)

/obj/item/device/encryptionkey/headset_com
	name = "Eris command radio encryption key"
	icon_state = "com_cypherkey"
	channels = list("Command" = 1)

/obj/item/device/encryptionkey/heads/captain
	name = "Eris captain's encryption key"
	icon_state = "cap_cypherkey"
	channels = list("Command" = 1, "Security" = 1, "En69ineerin69" = 0, "NT69oice" = 0, "Science" = 0, "Medical" = 0, "Supply" = 0, "Service" = 0)

/obj/item/device/encryptionkey/heads/ai_inte69rated
	name = "ai inte69rated encryption key"
	desc = "Inte69rated encryption key"
	icon_state = "cap_cypherkey"
	channels = list("Command" = 1, "Security" = 1, "En69ineerin69" = 1, "NT69oice" = 1, "Science" = 1, "Medical" = 1, "Supply" = 1, "Service" = 1, "AI Private" = 1)

/obj/item/device/encryptionkey/heads/rd
	name = "expedition overseer's encryption key"
	icon_state = "rd_cypherkey"
	channels = list("Science" = 1, "Command" = 1)

/obj/item/device/encryptionkey/heads/moebius
	name = "Moebius command encryption key"
	icon_state = "rd_cypherkey"
	channels = list("Science" = 1, "Medical" = 1, "Command" = 1)

/obj/item/device/encryptionkey/heads/hos
	name = "Ironhammer commander's encryption key"
	icon_state = "hos_cypherkey"
	channels = list("Security" = 1, "Command" = 1)

/obj/item/device/encryptionkey/heads/ce
	name = "exultant's encryption key"
	icon_state = "ce_cypherkey"
	channels = list("En69ineerin69" = 1, "Command" = 1)

/obj/item/device/encryptionkey/heads/cmo
	name = "Biolab officer's encryption key"
	icon_state = "cmo_cypherkey"
	channels = list("Medical" = 1, "Command" = 1)

/obj/item/device/encryptionkey/heads/hop
	name = "First Officer's encryption key"
	icon_state = "hop_cypherkey"
	channels = list("Command" = 1, "Security" = 1, "En69ineerin69" = 0, "NT69oice" = 0, "Science" = 0, "Medical" = 0, "Supply" = 0, "Service" = 0)

/obj/item/device/encryptionkey/heads/merchant
	name = "Asters69erchant radio encryption key"
	icon_state = "69m_cypherkey"
	channels = list("Supply" = 1, "Command" = 1)

/obj/item/device/encryptionkey/heads/preacher
	name = "NeoTheolo69y Preacher radio encryption key"
	icon_state = "preach_cypherkey"
	channels = list("NT69oice" = 1, "Command" = 1)

/obj/item/device/encryptionkey/headset_car69o
	name = "Asters 69uild radio encryption key"
	icon_state = "car69o_cypherkey"
	channels = list("Supply" = 1)

/obj/item/device/encryptionkey/headset_service
	name = "service radio encryption key"
	icon_state = "srv_cypherkey"
	channels = list("Service" = 1)

/obj/item/device/encryptionkey/entertainment
	name = "entertainment radio key"
	channels = list("Entertainment" = 1)

//addition to /obj/item/card/id/all_access
/obj/item/device/encryptionkey/heads/admin
	name = "Admin encryption key"
	desc = "Full powers encryption key"
	icon_state = "cap_cypherkey"
	channels = list("Command" = 1, "Security" = 1, "En69ineerin69" = 1, "NT69oice" = 1, "Science" = 1, "Medical" = 1, "Supply" = 1, "Service" = 1, "AI Private" = 1, "Mercenary" = 1)