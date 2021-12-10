/obj/item/stack/throwing_knife
	name = "throwing knife"
	gender = NEUTER  //Grammatically correct knives
	desc = "A knife that is specially designed and weighted so that the wielder\'s strength can be accounted when being thrown."
	icon = 'icons/obj/stack/items.dmi'
	icon_state = "knife"
	item_state = "knife1"
	singular_name = "throwing knife"
	flags = CONDUCT
	sharp = TRUE
	edge = TRUE
	embed_mult = 40 //MADE for embedding
	tool_qualities = list(QUALITY_WIRE_CUTTING = 5, QUALITY_CUTTING = 5)
	max_upgrades = 0
	attack_verb = list("slashed", "stabbed", "sliced", "torn", "ripped", "diced", "cut")
	hitsound = 'sound/weapons/melee/lightstab.ogg'
	structure_damage_factor = STRUCTURE_DAMAGE_BLADE
	matter = list(MATERIAL_PLASTEEL = 2)
	amount = 1
	max_amount = 3
	w_class = ITEM_SIZE_SMALL
	force = WEAPON_FORCE_NORMAL
	throwforce = WEAPON_FORCE_WEAK
	armor_penetration = ARMOR_PEN_SHALLOW
	slot_flags = SLOT_BELT
	//spawn values
	rarity_value = 8
	spawn_tags = SPAWN_TAG_KNIFE

/obj/item/stack/throwing_knife/on_update_icon()
	icon_state = "[initial(icon_state)][amount]"

/obj/item/stack/throwing_knife/examine(mob/user)
	if(..(user, 1))
		to_chat(user, "There [src.amount == 1 ? "is" : "are"] [src.amount] [src.amount == 1 ? "knife" : "knives"] in the stack.")
