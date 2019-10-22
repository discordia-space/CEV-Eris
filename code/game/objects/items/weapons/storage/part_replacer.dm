/obj/item/weapon/storage/part_replacer
	name = "rapid part exchange device"
	desc = "Special mechanical module made to store, sort, and apply standard machine parts."
	icon_state = "RPED"
	item_state = "RPED"
	w_class = ITEM_SIZE_HUGE
	can_hold = list(/obj/item/weapon/stock_parts)
	storage_slots = 50
	use_to_pickup = TRUE
	allow_quick_gather = TRUE
	allow_quick_empty = TRUE
	collection_mode = TRUE
	display_contents_with_number = TRUE
	max_w_class = ITEM_SIZE_NORMAL
	max_storage_space = 100
	matter = list(MATERIAL_PLASTIC = 5, MATERIAL_STEEL = 2)
