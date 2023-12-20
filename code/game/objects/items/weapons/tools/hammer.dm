/obj/item/tool/hammer //needs new sprite
	name = "hammer"
	desc = "Used for applying blunt force to a surface."
	icon_state = "hammer"
	item_state = "hammer"
	melleDamages = list(ARMOR_BLUNT = list(DELEM(BRUTE,17)))
	volumeClass = ITEM_SIZE_SMALL
	worksound = WORKSOUND_HAMMER
	flags = CONDUCT
	push_attack = TRUE
	origin_tech = list(TECH_ENGINEERING = 1)
	tool_qualities = list(QUALITY_HAMMERING = 20, QUALITY_PRYING = 10)
	matter = list(MATERIAL_STEEL = 4, MATERIAL_WOOD = 2)
	attack_verb = list("attacked", "bashed", "battered", "bludgeoned", "whacked","flattened","pulped")
	hitsound = 'sound/weapons/melee/blunthit.ogg'
	rarity_value = 5

/obj/item/tool/hammer/wield(mob/living/user)
	screen_shake = TRUE
	..()

/obj/item/tool/hammer/unwield(mob/living/user)
	screen_shake = FALSE
	..()

/obj/item/tool/hammer/powered_hammer //to be made into proper two-handed tool as small "powered" hammer doesn't make sense
	name = "powered hammer"					//lacks normal sprites, both icon, item and twohanded for this
	desc = "Used for applying excessive blunt force to a surface. Powered edition."
	icon_state = "powered_hammer"
	item_state = "powered_hammer"
	structure_damage_factor = STRUCTURE_DAMAGE_BREACHING
	melleDamages = list(ARMOR_BLUNT = list(DELEM(BRUTE,45)))
	WieldedattackDelay = 7
	volumeClass = ITEM_SIZE_HUGE
	tool_qualities = list(QUALITY_HAMMERING = 30)
	matter = list(MATERIAL_STEEL = 5, MATERIAL_PLASTEEL = 10, MATERIAL_PLASTIC = 1)
	degradation = 0.7
	use_power_cost = 2
	suitable_cell = /obj/item/cell/medium
	maxUpgrades = 4
	rarity_value = 24

/obj/item/tool/hammer/sledgehammer
	name = "sledgehammer"
	desc = "With this in your hands, every problem looks like a nail."
	icon_state = "sledgehammer"
	item_state = "sledgehammer"
	wielded_icon = "sledgehammer_wielded"
	structure_damage_factor = STRUCTURE_DAMAGE_BREACHING
	melleDamages = list(ARMOR_BLUNT = list(DELEM(BRUTE,30)))
	WieldedattackDelay = 4
	wieldedMultiplier = 1.4
	volumeClass = ITEM_SIZE_HUGE
	slot_flags = SLOT_BACK
	matter = list(MATERIAL_STEEL = 10, MATERIAL_WOOD = 2)
	tool_qualities = list(QUALITY_HAMMERING = 30)
	maxUpgrades = 2
	rarity_value = 2

/obj/item/tool/hammer/sledgehammer/advanced
	name = "advanced sledgehammer"
	desc = "Used for applying excessive blunt force to a problem, now with even more force."
	icon_state = "sledgehammer_advanced"
	item_state = "sledgehammer_advanced"
	wielded_icon = "sledgehammer_advanced_wielded"
	structure_damage_factor = STRUCTURE_DAMAGE_POWERFUL
	melleDamages = list(ARMOR_BLUNT = list(DELEM(BRUTE,35)))
	wieldedMultiplier = 1.4
	WieldedattackDelay = 8
	tool_qualities = list(QUALITY_HAMMERING = 40)
	matter = list(MATERIAL_STEEL = 5, MATERIAL_PLASTEEL = 10, MATERIAL_PLASTIC = 3)
	maxUpgrades = 3
	spawn_blacklisted = TRUE

/obj/item/tool/hammer/sledgehammer/improvised
	name = "homewrecker"
	desc = "A large steel chunk welded to a long handle which resembles a sledgehammer. Extremely heavy."
	icon_state = "homewrecker0"
	item_state = "homewrecker"
	wielded_icon = "homewrecker1"
	structure_damage_factor = STRUCTURE_DAMAGE_HEAVY
	wieldedMultiplier = 2
	WieldedattackDelay = 10
	slot_flags = SLOT_BELT|SLOT_BACK
	tool_qualities = list(QUALITY_HAMMERING = 15)
	matter = list(MATERIAL_STEEL = 15, MATERIAL_PLASTIC = 1)
	maxUpgrades = 3
	spawn_tags = SPAWN_TAG_JUNKTOOL
	rarity_value = 32

/obj/item/tool/hammer/sledgehammer/ironhammer //triple hammer!
	name = "FS \"Ironhammer\" Breaching Hammer"
	desc = "A modified sledgehammer produced by Frozen Star for Ironhammer forces. This tool can take down standard walls and if the user is strong enough, reinforced walls."
	icon = 'icons/obj/weapons.dmi'
	icon_state = "iron_hammer"
	item_state = "iron_hammer"
	wielded_icon = "iron_hammer_wielded"
	structure_damage_factor = STRUCTURE_DAMAGE_POWERFUL
	tool_qualities = list(QUALITY_HAMMERING = 40, QUALITY_PRYING = 1)
	matter = list(MATERIAL_STEEL = 15, MATERIAL_PLASTIC = 1, MATERIAL_PLASTEEL = 2)
	spawn_blacklisted = TRUE

/obj/item/tool/hammer/sledgehammer/onestar
	name = "One Star sledgehammer"
	desc = "A sledgehammer model produced by One Star, used for applying immeasurable blunt force to anything in your way. Capable of breaching even the toughtest obstacles, and cracking the most resilient skulls."
	icon_state = "onehammer"
	item_state = "onehammer"
	wielded_icon = "onehammer_on"
	structure_damage_factor = STRUCTURE_DAMAGE_DESTRUCTIVE
	melleDamages = list(ARMOR_BLUNT = list(DELEM(BRUTE,40)))
	wieldedMultiplier = 1.5
	volumeClass = ITEM_SIZE_HUGE
	slot_flags = SLOT_BACK
	matter = list(MATERIAL_STEEL = 10, MATERIAL_PLATINUM = 5, MATERIAL_DIAMOND = 5)
	tool_qualities = list(QUALITY_HAMMERING = 50)
	suitable_cell = /obj/item/cell/medium
	degradation = 0.6
	use_power_cost = 1.5
	workspeed = 1.5
	maxUpgrades = 2
	spawn_blacklisted = TRUE
	rarity_value = 10
	spawn_tags = SPAWN_TAG_OS_TOOL

/obj/item/tool/hammer/mace
	name = "mace"
	desc = "Used for applying blunt force trauma to a person's ribcage."
	icon = 'icons/obj/weapons.dmi'
	icon_state = "mace"
	item_state = "mace"
	volumeClass = ITEM_SIZE_NORMAL
	melleDamages = list(ARMOR_BLUNT = list(DELEM(BRUTE,25)), ARMOR_POINTY = list(DELEM(BRUTE,15)))
	tool_qualities = list(QUALITY_HAMMERING = 20)
	spawn_tags = SPAWN_TAG_WEAPON
	rarity_value = 15
	structure_damage_factor = STRUCTURE_DAMAGE_BLUNT

/obj/item/tool/hammer/mace/makeshift
	name = "makeshift mace"
	desc = "Some metal attached to the end of a stick, for applying blunt force trauma to a roach."
	icon_state = "ghetto_mace"
	item_state = "ghetto_mace"
	melleDamages = list(ARMOR_BLUNT = list(DELEM(BRUTE,20)))
	tool_qualities = list(QUALITY_HAMMERING = 15)
	degradation = 3 //This one breaks fast
	maxUpgrades = 5 //all makeshift tools get more mods to make them actually viable for mid-late game
	rarity_value = 30
	spawn_tags = SPAWN_TAG_JUNKTOOL


/obj/item/tool/hammer/mace/makeshift/baseballbat
	name = "baseball bat"
	desc = "HOME RUN!"
	icon_state = "woodbat0"
	wielded_icon = "woodbat1"
	item_state = "woodbat0"
	melleDamages = list(ARMOR_BLUNT = list(DELEM(BRUTE,25)))
	// big swing
	WieldedattackDelay = 16
	wieldedMultiplier = 2
	attack_verb = list("smashed", "beaten", "slammed", "smacked", "struck", "battered", "bonked")
	hitsound = 'sound/weapons/genhit3.ogg'
	slot_flags = SLOT_BELT|SLOT_BACK

/obj/item/tool/hammer/mace/makeshift/baseballbat/bone
	name = "bone club"
	desc = "Seems like someone gave up an arm and a leg for this thing. And a head."
	icon_state = "bonemace"
	item_state = "bonemace"
	slot_flags = SLOT_BELT
	degradation = 1.5 //Something something bones are hard.
	spawn_blacklisted = TRUE

/obj/item/tool/hammer/charge
	name = "charge hammer"
	desc = "After many issues with scientists trying to hammer a nail, one bright individual wondered what could be achieved by attaching a stellar-grade ship engine to the back."
	icon = 'icons/obj/weapons.dmi'
	icon_state = "chargehammer"
	item_state = "chargehammer"
	volumeClass = ITEM_SIZE_HUGE
	switchedOn = list(ARMOR_BLUNT = list(DELEM(BRUTE,30)))
	structure_damage_factor = STRUCTURE_DAMAGE_BREACHING
	switched_on_qualities = list(QUALITY_HAMMERING = 60)
	switched_off_qualities = list(QUALITY_HAMMERING = 35)
	toggleable = TRUE
	slot_flags = SLOT_BACK
	suitable_cell = /obj/item/cell/medium
	use_power_cost = 15
	rarity_value = 100
	spawn_frequency = 4
	var/datum/effect/effect/system/trail/T
	var/last_launch

/obj/item/tool/hammer/charge/New()
	..()
	T = new /datum/effect/effect/system/trail/fire()
	T.set_up(src)

/obj/item/tool/hammer/charge/Destroy()
	QDEL_NULL(T)
	return ..()

/obj/item/tool/hammer/charge/afterattack(atom/target, mob/user, proximity_flag, params)
	if(!switched_on || world.time < last_launch + 3 SECONDS)
		return
	var/cost = use_power_cost*get_dist(target, user)
	if(user.check_gravity())
		cost *= (user.mob_size/10)

	if(cell?.checked_use(cost))
		if(!wielded)
			var/drop_prob = 30
			if(ishuman(user))
				var/mob/living/carbon/human/H = user
				drop_prob *= H.stats.getMult(STAT_ROB, STAT_LEVEL_EXPERT)
			if(prob(drop_prob))
				to_chat(user, SPAN_WARNING("\The [src] launches from your grasp!"))
				user.drop_item(src)
				T.start()
				playsound(src, 'sound/machines/hiss.ogg', 50, 0, 0)
				throw_at(target, get_dist(target, user), 1, user)
				T.stop()
				last_launch = world.time
				return
		last_launch = world.time
		T.start()
		playsound(src, 'sound/machines/hiss.ogg', 50, 0, 0)
		user.throw_at(target, get_dist(target, user), 1, user)
		T.stop()

/obj/item/tool/hammer/dumbbell
	name = "dumbbell"
	desc = "To get stronger with this thing, you need to regularly train for many a month. But to hammer a nail, or crack a skull..."
	icon_state = "dumbbell"
	item_state = "dumbbell"
	tool_qualities = list(QUALITY_HAMMERING = 15)
	matter = list(MATERIAL_STEEL = 5)
	rarity_value = 35

/obj/item/tool/hammer/staff
	name = "makeshift staff"
	desc = "Three rods, some duct tape and a lot of bloodlust give you this. Its size helps greatly with blocking melee attacks and reaching far."
	icon = 'icons/obj/weapons.dmi'
	icon_state = "staff"
	item_state = "staff"
	wielded_icon = "staff_wielded"
	tool_qualities = list(QUALITY_HAMMERING = 5)
	matter = list(MATERIAL_STEEL = 3)
	extended_reach = TRUE
	rarity_value = 70
	maxUpgrades = 3
	armor_divisor = ARMOR_PEN_GRAZING //blunt force trauma strong
	wieldedMultiplier = 1.3
	volumeClass = ITEM_SIZE_HUGE
