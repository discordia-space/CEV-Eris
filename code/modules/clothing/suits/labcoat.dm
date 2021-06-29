/obj/item/clothing/suit/storage/toggle/labcoat
	name = "labcoat"
	desc = "A suit that protects against minor chemical spills."
	icon_state = "labcoat_open"
	item_state = "labcoat" //Is this even used for anything?
	icon_open = "labcoat_open"
	icon_closed = "labcoat"
	blood_overlay_type = "coat"
	body_parts_covered = UPPER_TORSO|ARMS|LEGS
	armor = list(
		melee = 0,
		bullet = 0,
		energy = 0,
		bomb = 0,
		bio = 50,
		rad = 0
	)

/obj/item/clothing/suit/storage/toggle/labcoat/cmo
	name = "moebius biolab officer's labcoat"
	desc = "Bluer than the standard model. Comes with nano-reinforced fabrics, for those psychotic patients."
	icon_state = "labcoat_cmo_open"
	item_state = "labcoat_cmo"
	icon_open = "labcoat_cmo_open"
	icon_closed = "labcoat_cmo"
	armor = list(
		melee = 20,
		bullet = 15,
		energy = 15,
		bomb = 0,
		bio = 80,
		rad = 0
	)

/obj/item/clothing/suit/storage/toggle/labcoat/chemist
	name = "moebius chemist labcoat"
	desc = "A suit that protects against minor chemical spills. Has an orange stripe on the shoulder."
	icon_state = "labcoat_chem_open"
	icon_open = "labcoat_chem_open"
	icon_closed = "labcoat_chem"

/obj/item/clothing/suit/storage/toggle/labcoat/virologist
	name = "moebius virologist labcoat"
	desc = "A suit that protects against minor chemical spills. Offers slightly more protection against biohazards than the standard model. Has a green stripe on the shoulder."
	icon_state = "labcoat_vir_open"
	icon_open = "labcoat_vir_open"
	icon_closed = "labcoat_vir"
	armor = list(
		melee = 0,
		bullet = 0,
		energy = 0,
		bomb = 0,
		bio = 75,
		rad = 0
	)

/obj/item/clothing/suit/storage/toggle/labcoat/science
	name = "moebius scientist labcoat"
	desc = "A suit that protects against minor chemical spills and elevated background radiation. Has a purple stripe on the shoulder."
	icon_state = "labcoat_tox_open"
	icon_open = "labcoat_tox_open"
	icon_closed = "labcoat_tox"
	armor = list(
		melee = 0,
		bullet = 0,
		energy = 0,
		bomb = 0,
		bio = 50,
		rad = 10
	)
	
/obj/item/clothing/suit/storage/toggle/labcoat/science/rd //sprite pending
	name = "moebius expedition overseer's labcoat"
	desc = "Somehow fancier than the standard model. Comes with nano-reinforced fabrics, for those psychotic bots."
	icon_state = "labcoat_tox_open"
	icon_open = "labcoat_tox_open"
	icon_closed = "labcoat_tox"
	armor = list(
		melee = 20,
		bullet = 15,
		energy = 15,
		bomb = 0,
		bio = 50,
		rad = 10
	)

/obj/item/clothing/suit/storage/toggle/labcoat/medspec
	name = "medical specialist's labcoat"
	desc = "A suit that protects against minor blood spills. Reinforced against high-velocity, low velocity and direct-energy impacts. This one has marks of Ironhammer Security."
	icon_state = "labcoat_medspec_open"
	item_state = "labcoat_medspec"
	icon_open = "labcoat_medspec_open"
	icon_closed = "labcoat_medspec"
	armor = list(
		melee = 20,
		bullet = 20,
		energy = 20,
		bomb = 10,
		bio = 40,
		rad = 0
	)
