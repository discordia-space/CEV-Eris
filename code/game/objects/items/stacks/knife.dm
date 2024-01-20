/obj/item/stack/thrown
	name = "throwing knife"
	gender = NEUTER  //Grammatically correct knives
	desc = "A knife that is specially designed and weighted so that the wielder\'s strength can be accounted when being thrown."
	icon = 'icons/obj/stack/items.dmi'
	icon_state = "knife"
	item_state = "knife"
	singular_name = "throwing knife"
	var/plural_name = "throwing knives"
	flags = CONDUCT
	sharp = TRUE
	edge = TRUE
	tool_qualities = list(QUALITY_WIRE_CUTTING = 5, QUALITY_CUTTING = 5)
	maxUpgrades = 0
	attack_verb = list("slashed", "stabbed", "sliced", "torn", "ripped", "diced", "cut")
	hitsound = 'sound/weapons/melee/lightstab.ogg'
	structure_damage_factor = STRUCTURE_DAMAGE_BLADE
	matter = list(MATERIAL_PLASTEEL = 2)
	amount = 1
	max_amount = 3
	volumeClass = ITEM_SIZE_SMALL
	melleDamages = list(
		ARMOR_POINTY = list(
			DELEM(BRUTE, 20)
		)
	)
	throwforce = WEAPON_FORCE_WEAK
	armor_divisor = ARMOR_PEN_SHALLOW
	throw_speed = 3
	slot_flags = SLOT_BELT
	//spawn values
	rarity_value = 8
	spawn_tags = SPAWN_TAG_KNIFE
	bad_type = /obj/item/stack/thrown

/obj/item/stack/thrown/update_icon()
	icon_state = "[initial(icon_state)][amount]"

/obj/item/stack/thrown/examine(mob/user)
	..(user, afterDesc = "There [src.amount == 1 ? "is" : "are"] [src.amount] [src.amount == 1 ? singular_name : plural_name] in the stack.")

/obj/item/stack/thrown/proc/fireAt(atom/target, mob/living/carbon/C)
	if(amount == 1)
		C.drop_from_inventory(src)
		launchAt(target, C)
	else
		amount--
		update_icon()

		var/obj/item/stack/thrown/J = new src.type(get_turf(src))
		J.throwforce = throwforce
		J.setAmount(1)
		J.update_icon()
		J.launchAt(target, C)
	visible_message(SPAN_DANGER("[C] has thrown \the [src]."))
	update_icon()

/obj/item/stack/thrown/proc/launchAt(atom/target, mob/living/carbon/C)
	throw_at(target, throw_range, throw_speed, C)

/obj/item/stack/thrown/throwing_knife
	name = "throwing knife"
	gender = NEUTER  //Grammatically correct knives
	desc = "A knife that is specially designed and weighted so that the wielder\'s strength can be accounted when being thrown."
	icon = 'icons/obj/stack/items.dmi'
	icon_state = "knife"
	item_state = "knife"
	singular_name = "throwing knife"
	flags = CONDUCT
	sharp = TRUE
	edge = TRUE
	embed_mult = 80 //MADE for embedding
	tool_qualities = list(QUALITY_WIRE_CUTTING = 5, QUALITY_CUTTING = 5)
	maxUpgrades = 0
	attack_verb = list("slashed", "stabbed", "sliced", "torn", "ripped", "diced", "cut")
	hitsound = 'sound/weapons/melee/lightstab.ogg'
	structure_damage_factor = STRUCTURE_DAMAGE_BLADE
	matter = list(MATERIAL_PLASTEEL = 1)
	amount = 3
	max_amount = 3
	volumeClass = ITEM_SIZE_SMALL
	melleDamages = list(
		ARMOR_POINTY = list(
			DELEM(BRUTE, 15)
		)
	)
	throwforce = WEAPON_FORCE_NORMAL
	armor_divisor = ARMOR_PEN_SHALLOW
	slot_flags = SLOT_BELT
	//spawn values
	rarity_value = 8
	spawn_tags = SPAWN_TAG_KNIFE

/obj/item/stack/thrown/throwing_knife/launchAt(atom/target, mob/living/carbon/C)
	var/ROB_throwing_damage = max(C.stats.getStat(STAT_ROB), 1)
	throwforce = 35 / (1 + 100 / ROB_throwing_damage) + throwforce //soft cap; This would result in knives doing 10 damage at 0 rob, 20 at 50 ROB, 25 at 100 etc.
	..()
