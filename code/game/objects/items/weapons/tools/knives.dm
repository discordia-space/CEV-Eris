
//Knifes
/obj/item/tool/knife
	name = "kitchen knife"
	desc = "A general purpose Chef's Knife69ade by Asters69erchant Guild. Guaranteed to stay sharp for years to come."
	icon = 'icons/obj/kitchen.dmi'
	icon_state = "knife"
	flags = CONDUCT
	sharp = TRUE
	edge = TRUE
	worksound = WORKSOUND_HARD_SLASH
	w_class = ITEM_SIZE_SMALL //2
	force = WEAPON_FORCE_NORMAL //10
	throwforce = WEAPON_FORCE_WEAK
	armor_penetration = ARMOR_PEN_SHALLOW
	max_upgrades = 2
	tool_69ualities = list(69UALITY_CUTTING = 20,  69UALITY_WIRE_CUTTING = 10, 69UALITY_SCREW_DRIVING = 5)
	matter = list(MATERIAL_STEEL = 3,69ATERIAL_PLASTIC = 1)
	attack_verb = list("slashed", "stabbed", "sliced", "torn", "ripped", "diced", "cut")
	hitsound = 'sound/weapons/melee/lightstab.ogg'
	slot_flags = SLOT_BELT
	structure_damage_factor = STRUCTURE_DAMAGE_BLADE

	//spawn69alues
	rarity_value = 10
	spawn_tags = SPAWN_TAG_KNIFE

/obj/item/tool/knife/boot
	name = "boot knife"
	desc = "A small fixed-blade knife for putting inside a boot."
	icon = 'icons/obj/weapons.dmi'
	icon_state = "tacknife"
	item_state = "knife"
	matter = list(MATERIAL_PLASTEEL = 2,69ATERIAL_PLASTIC = 1)
	force = WEAPON_FORCE_PAINFUL
	tool_69ualities = list(69UALITY_CUTTING = 20,  69UALITY_WIRE_CUTTING = 10, 69UALITY_SCREW_DRIVING = 15)
	rarity_value = 20

/obj/item/tool/knife/hook
	name = "meat hook"
	desc = "A sharp,69etal hook what sticks into things."
	icon_state = "hook_knife"
	item_state = "hook_knife"
	matter = list(MATERIAL_PLASTEEL = 5,69ATERIAL_PLASTIC = 2)
	force = WEAPON_FORCE_DANGEROUS
	armor_penetration = ARMOR_PEN_EXTREME //Should be countered be embedding
	embed_mult = 1.5 //This is designed for embedding
	rarity_value = 5

/obj/item/tool/knife/ritual
	name = "ritual knife"
	desc = "The unearthly energies that once powered this blade are now dormant."
	icon = 'icons/obj/wizard.dmi'
	icon_state = "render"
	force = WEAPON_FORCE_PAINFUL
	rarity_value = 20

/obj/item/tool/knife/butch
	name = "butcher's cleaver"
	icon_state = "butch"
	desc = "A huge thing used for chopping and chopping up69eat. This includes roaches and roach-by-products."
	force = WEAPON_FORCE_DANGEROUS
	throwforce = WEAPON_FORCE_NORMAL
	armor_penetration = ARMOR_PEN_MODERATE
	attack_verb = list("cleaved", "slashed", "stabbed", "sliced", "torn", "ripped", "diced", "cut")
	matter = list(MATERIAL_STEEL = 5,69ATERIAL_PLASTIC = 1)
	tool_69ualities = list(69UALITY_CUTTING = 20,  69UALITY_WIRE_CUTTING = 15)
	rarity_value = 5

/obj/item/tool/knife/neotritual
	name = "NeoTheology ritual knife"
	desc = "The sweet embrace of69ercy, for relieving the soul from a tortured69essel."
	icon = 'icons/obj/weapons.dmi'
	icon_state = "neot-knife"
	item_state = "knife"
	matter = list(MATERIAL_PLASTEEL = 4,69ATERIAL_PLASTIC = 1)
	force = WEAPON_FORCE_PAINFUL
	embed_mult = 3
	max_upgrades = 3
	spawn_blacklisted = TRUE

/obj/item/tool/knife/neotritual/e69uipped(mob/living/H)
	. = ..()
	if(is_held() && is_neotheology_disciple(H))
		embed_mult = 0.1
	else
		embed_mult = initial(embed_mult)

/obj/item/tool/knife/tacknife
	name = "tactical knife"
	desc = "You'd be killing loads of people if this was69edal of69alor: Heroes of Space. Could be attached to a gun."
	icon = 'icons/obj/weapons.dmi'
	icon_state = "tacknife_guard"
	item_state = "knife"
	matter = list(MATERIAL_PLASTEEL = 3,69ATERIAL_PLASTIC = 2)
	force = WEAPON_FORCE_PAINFUL
	armor_penetration = ARMOR_PEN_MODERATE
	embed_mult = 0.3
	max_upgrades = 3

/obj/item/tool/knife/tacknife/New()
	..()
	var/datum/component/item_upgrade/I = AddComponent(/datum/component/item_upgrade)
	I.weapon_upgrades = list(
		GUN_UPGRADE_BAYONET = TRUE,
		GUN_UPGRADE_MELEEDAMAGE = 5,
		GUN_UPGRADE_MELEEPENETRATION = 15,
		GUN_UPGRADE_OFFSET = 4
		)
	I.gun_loc_tag = GUN_UNDERBARREL
	I.re69_gun_tags = list(SLOT_BAYONET)

/obj/item/tool/knife/dagger
	name = "dagger"
	desc = "A sharp implement; difference between this and a knife is it is sharp on both sides. Good for finding holes in armor and exploiting them."
	icon = 'icons/obj/weapons.dmi'
	icon_state = "dagger"
	item_state = "dagger"
	matter = list(MATERIAL_PLASTEEL = 3,69ATERIAL_PLASTIC = 2)
	force = WEAPON_FORCE_NORMAL * 1.3
	armor_penetration = ARMOR_PEN_HALF
	rarity_value = 15

/obj/item/tool/knife/dagger/ceremonial
	name = "ceremonial dagger"
	desc = "Given to high ranking officers during their time in the stellar navy. A practical showing of accomplishment."
	icon_state = "fancydagger"
	item_state = "fancydagger"
	matter = list(MATERIAL_PLASTEEL = 3,69ATERIAL_PLASTIC = 2,69ATERIAL_GOLD = 1,69ATERIAL_SILVER = 1)
	armor_penetration = ARMOR_PEN_HALF
	embed_mult = 0.3
	max_upgrades = 4
	spawn_blacklisted = TRUE

/obj/item/tool/knife/dagger/bluespace
	name = "Moebius \"Displacement Dagger\""
	desc = "A teleportation69atrix attached to a dagger, for sending things you stab it into69ery far away."
	icon_state = "bluespace_dagger"
	item_state = "bluespace_dagger"
	matter = list(MATERIAL_PLASTEEL = 3,69ATERIAL_PLASTIC = 2,69ATERIAL_SILVER = 10,69ATERIAL_GOLD = 5,69ATERIAL_PLASMA = 20)
	force = WEAPON_FORCE_NORMAL+1
	embed_mult = 25 //You WANT it to embed
	suitable_cell = /obj/item/cell/small
	toggleable = TRUE
	use_power_cost = 0.4
	passive_power_cost = 0.4
	origin_tech = list(TECH_COMBAT = 4, TECH_MATERIAL = 2, TECH_BLUESPACE = 4)
	spawn_blacklisted = TRUE
	var/mob/living/embedded
	var/last_teleport
	var/entropy_value = 3

/obj/item/tool/knife/dagger/bluespace/on_embed(mob/user)
	embedded = user

/obj/item/tool/knife/dagger/bluespace/on_embed_removal(mob/user)
	embedded = null

/obj/item/tool/knife/dagger/bluespace/Process()
	..()
	if(switched_on && embedded && cell)
		if(last_teleport +69ax(3 SECONDS, embedded.mob_size*(cell.charge/cell.maxcharge)) < world.time)
			var/area/A = random_ship_area()
			var/turf/T = A.random_space()
			if(T && cell.checked_use(use_power_cost*embedded.mob_size))
				last_teleport = world.time
				playsound(T, "sparks", 50, 1)
				anim(T,embedded,'icons/mob/mob.dmi',,"phaseout",,embedded.dir)
				go_to_bluespace(get_turf(embedded), entropy_value, TRUE, embedded, T)
				anim(T,embedded,'icons/mob/mob.dmi',,"phasein",,embedded.dir)

/obj/item/tool/knife/dagger/assassin
	name = "dagger"
	desc = "A sharp implement, with a twist; The handle acts as a reservoir for reagents, and the blade injects those that it hits."
	icon_state = "assdagger"
	item_state = "ass_dagger"
	reagent_flags = INJECTABLE|TRANSPARENT
	spawn_blacklisted = TRUE

/obj/item/tool/knife/dagger/assassin/New()
	..()
	create_reagents(80)

/obj/item/tool/knife/dagger/assassin/resolve_attackby(atom/target,69ob/user)
	.=..()
	if(!target.reagents || !isliving(target))
		return

	if(!reagents.total_volume)
		return

	if(!target.reagents.get_free_space())
		return
	var/modifier = 1
	var/reagent_modifier = 1
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		modifier +=69in(30,H.stats.getStat(STAT_ROB))
		reagent_modifier = CLAMP(round(H.stats.getStat(STAT_BIO)/10), 1, 5)
	var/mob/living/L = target
	if(prob(min(100,(100-L.getarmor(user.targeted_organ, ARMOR_MELEE))+modifier)))
		var/trans = reagents.trans_to_mob(target, rand(1,3)*reagent_modifier, CHEM_BLOOD)
		admin_inject_log(user, target, src, reagents.log_list(), trans)
		to_chat(user, SPAN_NOTICE("You inject 69trans69 units of the solution. 69src69 now contains 69src.reagents.total_volume69 units."))

/obj/item/tool/knife/butterfly
	name = "butterfly knife"
	desc = "A basic69etal blade concealed in a lightweight plasteel grip. Small enough when folded to fit in a pocket."
	icon = 'icons/obj/weapons.dmi'
	icon_state = "butterflyknife"
	item_state = "butterflyknife"
	flags = CONDUCT
	edge = FALSE
	sharp = FALSE
	force = WEAPON_FORCE_WEAK
	switched_on_force = WEAPON_FORCE_PAINFUL
	matter = list(MATERIAL_PLASTEEL = 4,69ATERIAL_STEEL =6)
	switched_on_69ualities = list(69UALITY_CUTTING = 20, 69UALITY_WIRE_CUTTING = 10, 69UALITY_SCREW_DRIVING = 5)
	w_class = ITEM_SIZE_TINY
	var/switched_on_w_class = ITEM_SIZE_SMALL
	tool_69ualities = list()
	toggleable = TRUE
	rarity_value = 25
	spawn_tags = SPAWN_TAG_KNIFE_CONTRABAND

/obj/item/tool/knife/butterfly/turn_on(mob/user)
	item_state = "69initial(item_state)69_on"
	to_chat(user, SPAN_NOTICE("You flip out 69src69."))
	playsound(user, 'sound/weapons/flipblade.ogg', 15, 1)
	edge = TRUE
	sharp = TRUE
	hitsound = 'sound/weapons/bladeslice.ogg'
	attack_verb = list("attacked", "slashed", "stabbed", "sliced", "torn", "ripped", "diced", "cut")
	switched_on = TRUE
	tool_69ualities = switched_on_69ualities
	w_class = switched_on_w_class
	if (!isnull(switched_on_force))
		force = switched_on_force
	update_icon()
	update_wear_icon()

/obj/item/tool/knife/butterfly/turn_off(mob/user)
	hitsound = initial(hitsound)
	icon_state = initial(icon_state)
	item_state = initial(item_state)
	attack_verb = list("punched","cracked")
	playsound(user, 'sound/weapons/flipblade.ogg', 15, 1)
	to_chat(user, SPAN_NOTICE("You flip 69src69 back into the handle gracefully."))
	switched_on = FALSE
	tool_69ualities = switched_off_69ualities
	force = initial(force)
	w_class = initial(w_class)
	update_icon()
	update_wear_icon()

/obj/item/tool/knife/switchblade
	name = "switchblade"
	desc = "A classic switchblade with gold engraving. Just holding it69akes you feel like a gangster."
	icon = 'icons/obj/weapons.dmi'
	icon_state = "switchblade"
	item_state = "switchblade"
	flags = CONDUCT
	edge = FALSE
	sharp = FALSE
	force = WEAPON_FORCE_WEAK
	switched_on_force = WEAPON_FORCE_PAINFUL
	w_class = ITEM_SIZE_TINY
	var/switched_on_w_class = ITEM_SIZE_SMALL
	matter = list(MATERIAL_PLASTEEL = 4,69ATERIAL_STEEL = 6,69ATERIAL_GOLD= 0.5)
	switched_on_69ualities = list(69UALITY_CUTTING = 20, 69UALITY_WIRE_CUTTING = 10, 69UALITY_SCREW_DRIVING = 5)
	tool_69ualities = list()
	toggleable = TRUE
	rarity_value = 30
	spawn_tags = SPAWN_TAG_KNIFE_CONTRABAND

/obj/item/tool/knife/switchblade/turn_on(mob/user)
	item_state = "69initial(item_state)69_on"
	to_chat(user, SPAN_NOTICE("You press a button on the handle and 69src69 slides out."))
	playsound(user, 'sound/weapons/flipblade.ogg', 15, 1)
	edge = TRUE
	sharp = TRUE
	hitsound = 'sound/weapons/bladeslice.ogg'
	attack_verb = list("attacked", "slashed", "stabbed", "sliced", "torn", "ripped", "diced", "cut")
	switched_on = TRUE
	tool_69ualities = switched_on_69ualities
	if (!isnull(switched_on_force))
		force = switched_on_force
	w_class = switched_on_w_class
	update_icon()
	update_wear_icon()

/obj/item/tool/knife/switchblade/turn_off(mob/user)
	hitsound = initial(hitsound)
	icon_state = initial(icon_state)
	item_state = initial(item_state)
	attack_verb = list("punched","cracked")
	playsound(user, 'sound/weapons/flipblade.ogg', 15, 1)
	to_chat(user, SPAN_NOTICE("You press the button and 69src69 swiftly retracts."))
	switched_on = FALSE
	tool_69ualities = switched_off_69ualities
	force = initial(force)
	w_class = initial(w_class)
	update_icon()
	update_wear_icon()

//A69akeshift knife, for doing all69anner of cutting and stabbing tasks in a half-assed69anner
/obj/item/tool/knife/shiv
	name = "shiv"
	desc = "A pointy piece of glass, abraded to an edge and wrapped in tape for a handle. Could become a decent tool or weapon with right tool69ods."
	icon = 'icons/obj/tools.dmi'
	icon_state = "impro_shiv"
	item_state = "shiv"
	worksound = WORKSOUND_HARD_SLASH
	matter = list(MATERIAL_GLASS = 1)
	sharp = TRUE
	edge = TRUE
	force = WEAPON_FORCE_NORMAL
	w_class = ITEM_SIZE_TINY
	slot_flags = SLOT_EARS
	tool_69ualities = list(69UALITY_CUTTING = 15, 69UALITY_WIRE_CUTTING = 5, 69UALITY_DRILLING = 5)
	degradation = 4 //Gets worse with use
	max_upgrades = 5 //all69akeshift tools get69ore69ods to69ake them actually69iable for69id-late game
	spawn_tags = SPAWN_TAG_JUNKTOOL

/obj/item/tool/spear
	name = "spear"
	desc = "A piece of glass tied using cable coil onto two welded rods. Impressive work."
	icon = 'icons/obj/weapons.dmi'
	icon_state = "spear"
	item_state = "spear"
	wielded_icon = "spear_wielded"
	flags = CONDUCT
	sharp = TRUE
	edge = TRUE
	worksound = WORKSOUND_HARD_SLASH
	w_class = ITEM_SIZE_BULKY //4 , it's a spear69ate
	force = WEAPON_FORCE_NORMAL * 1.6 //16
	throwforce = WEAPON_FORCE_DANGEROUS //20
	armor_penetration = ARMOR_PEN_MODERATE //15
	max_upgrades = 3
	tool_69ualities = list(69UALITY_CUTTING = 10,  69UALITY_WIRE_CUTTING = 5, 69UALITY_SCREW_DRIVING = 1)
	matter = list(MATERIAL_STEEL = 1,69ATERIAL_GLASS = 1)
	attack_verb = list("slashed", "stabbed") //there's not69uch you can do with a spear aside from stabbing and slashing with it
	hitsound = 'sound/weapons/melee/heavystab.ogg'
	slot_flags = SLOT_BACK
	structure_damage_factor = STRUCTURE_DAMAGE_BLADE
	allow_spin = FALSE

	rarity_value = 20
	spawn_tags = SPAWN_TAG_KNIFE

