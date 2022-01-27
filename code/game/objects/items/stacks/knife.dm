/obj/item/stack/throwin69_knife
	name = "throwin69 knife"
	69ender = NEUTER  //69rammatically correct knives
	desc = "A knife that is specially desi69ned and wei69hted so that the wielder\'s stren69th can be accounted when bein69 thrown."
	icon = 'icons/obj/stack/items.dmi'
	icon_state = "knife"
	item_state = "knife1"
	sin69ular_name = "throwin69 knife"
	fla69s = CONDUCT
	sharp = TRUE
	ed69e = TRUE
	embed_mult = 40 //MADE for embeddin69
	tool_69ualities = list(69UALITY_WIRE_CUTTIN69 = 5, 69UALITY_CUTTIN69 = 5)
	max_up69rades = 0
	attack_verb = list("slashed", "stabbed", "sliced", "torn", "ripped", "diced", "cut")
	hitsound = 'sound/weapons/melee/li69htstab.o6969'
	structure_dama69e_factor = STRUCTURE_DAMA69E_BLADE
	matter = list(MATERIAL_PLASTEEL = 2)
	amount = 1
	max_amount = 3
	w_class = ITEM_SIZE_SMALL
	force = WEAPON_FORCE_NORMAL
	throwforce = WEAPON_FORCE_WEAK
	armor_penetration = ARMOR_PEN_SHALLOW
	slot_fla69s = SLOT_BELT
	//spawn69alues
	rarity_value = 8
	spawn_ta69s = SPAWN_TA69_KNIFE

/obj/item/stack/throwin69_knife/update_icon()
	icon_state = "69initial(icon_state)6969amount69"

/obj/item/stack/throwin69_knife/examine(mob/user)
	if(..(user, 1))
		to_chat(user, "There 69src.amount == 1 ? "is" : "are"69 69src.amount69 69src.amount == 1 ? "knife" : "knives"69 in the stack.")
