/obj/item/gun_upgrade
	icon = 'icons/obj/guns/mods.dmi'
	w_class = ITEM_SIZE_TINY
	price_tag = 100
	rarity_value = 10
	spawn_tags = SPAWN_TAG_GUN_UPGRADE
	bad_type = /obj/item/gun_upgrade

/obj/item/gun_upgrade/barrel
	bad_type = /obj/item/gun_upgrade/barrel

/obj/item/gun_upgrade/muzzle
	bad_type = /obj/item/gun_upgrade/muzzle

/obj/item/gun_upgrade/underbarrel
	bad_type = /obj/item/gun_upgrade/underbarrel

/obj/item/gun_upgrade/underbarrel/bipod
	name = "bipod"
	desc = "A simple set of telescopic poles to keep a weapon stabilized during firing. It greatly reduces recoil when deployed, but also increases the gun\'s weight, making it unwieldy unless braced."
	matter = list(MATERIAL_STEEL = 3, MATERIAL_PLASTEEL = 3)
	icon_state = "bipod"
	rarity_value = 15

/obj/item/gun_upgrade/underbarrel/bipod/New()
	..()
	var/datum/component/item_upgrade/I = AddComponent(/datum/component/item_upgrade)
	I.weapon_upgrades = list(
		GUN_UPGRADE_BIPOD = TRUE,
		GUN_UPGRADE_RECOIL = 1.2
		)
	I.gun_loc_tag = GUN_UNDERBARREL

//Silences the weapon, reduces damage multiplier slightly, Legacy port.
/obj/item/gun_upgrade/muzzle/silencer
	name = "silencer"
	desc = "a threaded silencer that can be attached to the muzzle of certain guns. Vastly reduces noise, but impedes muzzle velocity."
	matter = list(MATERIAL_PLASTEEL = 3, MATERIAL_PLASTIC = 1)
	icon_state = "silencer"
	rarity_value = 20


/obj/item/gun_upgrade/muzzle/silencer/New()
	..()
	var/datum/component/item_upgrade/I = AddComponent(/datum/component/item_upgrade)
	I.weapon_upgrades = list(
		GUN_UPGRADE_SILENCER = TRUE,
		GUN_UPGRADE_MUZZLEFLASH = 0.8,
		GUN_UPGRADE_DAMAGE_PLUS = -0.1,
		GUN_UPGRADE_RECOIL = 0.9
		)
	I.gun_loc_tag = GUN_MUZZLE
	I.req_gun_tags = list(GUN_SILENCABLE)

//Decreases fire delay. Acquired through loot spawns
/obj/item/gun_upgrade/barrel/forged
	name = "forged barrel"
	desc = "Despite advancements in 3D printing, a properly forged plasteel barrel can still outperform anything that comes from an autolathe."
	matter = list(MATERIAL_PLASTEEL = 5)
	icon_state = "Forged_barrel"
	rarity_value = 10

/obj/item/gun_upgrade/barrel/forged/New()
	..()
	var/datum/component/item_upgrade/I = AddComponent(/datum/component/item_upgrade)
	I.weapon_upgrades = list(
		GUN_UPGRADE_FIRE_DELAY_MULT = 0.8
		)
	I.gun_loc_tag = GUN_BARREL
	I.req_gun_tags = list(GUN_PROJECTILE)

/obj/item/gun_upgrade/barrel/blender
	name = "OR \"Bullet Blender\" barrel"
	desc = "A curious-looking barrel bearing the Oberth insignia. A small label reads \"No refunds for any collateral damage caused\"."
	matter = list(MATERIAL_STEEL = 2, MATERIAL_PLASTEEL = 3, MATERIAL_DIAMOND = 1)
	icon_state = "Penetrator"
	rarity_value = 30

/obj/item/gun_upgrade/barrel/blender/New()
	..()
	var/datum/component/item_upgrade/I = AddComponent(/datum/component/item_upgrade)
	I.weapon_upgrades = list(
		GUN_UPGRADE_PEN_MULT = -0.5,
		GUN_UPGRADE_PIERC_MULT = 3,
		GUN_UPGRADE_RICO_MULT = 5,
		GUN_UPGRADE_STEPDELAY_MULT = 0.6,
		GUN_UPGRADE_RECOIL = 1.4
		)
	I.gun_loc_tag = GUN_BARREL
	I.req_gun_tags = list(GUN_PROJECTILE)

//For energy weapons, increases the damage output, but also the charge cost. Acquired through loot spawns or Eye of the Protector.
/obj/item/gun_upgrade/barrel/excruciator
	name = "NeoTheology \"EXCRUCIATOR\" giga lens"
	desc = "It's time for us to shine."
	icon_state = "Excruciator"
	matter = list(MATERIAL_BIOMATTER = 3, MATERIAL_PLASTEEL = 2, MATERIAL_GOLD = 2, MATERIAL_GLASS = 1)
	rarity_value = 50

/obj/item/gun_upgrade/barrel/excruciator/New()
	..()
	var/datum/component/item_upgrade/I = AddComponent(/datum/component/item_upgrade)
	I.weapon_upgrades = list(
		GUN_UPGRADE_DAMAGE_MULT = 1.3,
		GUN_UPGRADE_CHARGECOST = 2
		)
	I.gun_loc_tag = GUN_BARREL
	I.req_gun_tags = list(GUN_ENERGY)

/obj/item/gun_upgrade/trigger
	bad_type = /obj/item/gun_upgrade/trigger

//Disables the ability to toggle the safety, toggles the safety permanently off, decreases fire delay. Acquired through loot spawns
/obj/item/gun_upgrade/trigger/dangerzone
	name = "Frozen Star \"Danger Zone\" Trigger"
	desc = "When you need that extra edge."
	matter = list(MATERIAL_PLASTEEL = 2, MATERIAL_SILVER = 1)
	icon_state = "Danger_Zone"
	rarity_value = 15


/obj/item/gun_upgrade/trigger/dangerzone/New()
	..()
	var/datum/component/item_upgrade/I = AddComponent(/datum/component/item_upgrade)
	I.weapon_upgrades = list(
		GUN_UPGRADE_FIRE_DELAY_MULT = 0.8,
		GUN_UPGRADE_FORCESAFETY = FALSE
		)
	I.gun_loc_tag = GUN_TRIGGER

//Disables the ability to toggle the safety, toggles the safety permanently on, takes 2 minutes to remove (yikes). Acquired through loot spawns
/obj/item/gun_upgrade/trigger/cop_block
	name = "Frozen Star \"Cop Block\" Trigger"
	desc = "A simpler way of making a weapon display-only"
	matter = list(MATERIAL_PLASTEEL = 2)
	icon_state = "Cop_Block"
	rarity_value = 15

/obj/item/gun_upgrade/trigger/cop_block/New()
	..()
	var/datum/component/item_upgrade/I = AddComponent(/datum/component/item_upgrade)
	I.weapon_upgrades = list(
		GUN_UPGRADE_FORCESAFETY = TRUE
		)
	I.removal_time *= 10
	I.gun_loc_tag = GUN_TRIGGER
	I.breakable = FALSE

/obj/item/gun_upgrade/trigger/dnalock
	name = "Frozen Star \"DNA lock\" Trigger"
	desc = "There are many guns, but that one will be yours. Prevents others from using weapon with this trigger."
	matter = list(MATERIAL_PLASTEEL = 2, MATERIAL_DIAMOND = 1)
	icon_state = "DNA_lock"
	rarity_value = 15

/obj/item/gun_upgrade/trigger/dnalock/New()
	..()
	var/datum/component/item_upgrade/I = AddComponent(/datum/component/item_upgrade)
	I.weapon_upgrades = list(
		GUN_UPGRADE_DNALOCK = TRUE
		)
	I.removal_time *= 10
	I.gun_loc_tag = GUN_TRIGGER
	I.breakable = FALSE
	I.removal_difficulty = FAILCHANCE_VERY_HARD

/obj/item/gun_upgrade/trigger/dnalock
	name = "Frozen Star \"DNA lock\" Trigger"
	desc = "There are many guns, but that one will be yours. Prevents others from using weapon with this trigger."
	matter = list(MATERIAL_STEEL = 2, MATERIAL_DIAMOND = 1)
	icon_state = "DNA_lock"
	rarity_value = 15

/obj/item/gun_upgrade/trigger/dnalock/New()
	..()
	var/datum/component/item_upgrade/I = AddComponent(/datum/component/item_upgrade)
	I.weapon_upgrades = list(
		GUN_UPGRADE_DNALOCK = TRUE
		)
	I.removal_time *= 10
	I.gun_loc_tag = GUN_TRIGGER
	I.breakable = FALSE
	I.removal_difficulty = FAILCHANCE_VERY_HARD

/obj/item/gun_upgrade/mechanism
	bad_type = /obj/item/gun_upgrade/mechanism

//Adds +3 to the internal magazine of a weapon. Acquired through loot spawns.
/obj/item/gun_upgrade/mechanism/overshooter
	name = "Frozen Star \"Overshooter\" internal magazine kit"
	desc = "A method of overloading a weapon's internal magazine, fitting more ammunition within the weapon."
	matter = list(MATERIAL_STEEL = 3, MATERIAL_PLASTEEL = 4, MATERIAL_PLASTIC = 4)
	icon_state = "Overshooter"
	rarity_value = 20

/obj/item/gun_upgrade/mechanism/overshooter/New()
	..()
	var/datum/component/item_upgrade/I = AddComponent(/datum/component/item_upgrade)
	I.weapon_upgrades = list(
		GUN_UPGRADE_MAGUP = 3
		)
	I.req_gun_tags = list(GUN_PROJECTILE, GUN_INTERNAL_MAG)
	I.gun_loc_tag = GUN_MECHANISM

//Adds radiation damage to .35 rounds. Acquired through telecrystal uplink
/obj/item/gun_upgrade/mechanism/glass_widow
	name = "Syndicate \"Glass Widow\" infuser"
	desc = "An old technology from the Corporate Wars, this mechanism rests inside the receiver and adds trace amounts of radioactive material to each bullet fired." // wtf
	matter = list(MATERIAL_STEEL = 2, MATERIAL_URANIUM = 3)
	icon_state = "Glass_Widow"
	rarity_value = 50
	spawn_blacklisted = TRUE

/obj/item/gun_upgrade/mechanism/glass_widow/New()
	..()
	var/datum/component/item_upgrade/I = AddComponent(/datum/component/item_upgrade)
	I.weapon_upgrades = list(
		GUN_UPGRADE_DAMAGE_RADIATION = 100
	)
	I.req_gun_tags = list(GUN_PROJECTILE, GUN_CALIBRE_35)
	I.gun_loc_tag = GUN_MECHANISM

//Lets the SOL be made into a fully automatic weapon, but increases recoil. Acquirable through Frozen Star Guns&Ammo Vendor
/obj/item/gun_upgrade/mechanism/weintraub
	name = "Frozen Star \"Weintraub\" full auto kit"
	desc = "A fully automatic receiver for rifles"
	matter = list(MATERIAL_STEEL = 3, MATERIAL_PLASTEEL = 3)
	icon_state = "Weintraub"
	rarity_value = 30

/obj/item/gun_upgrade/mechanism/weintraub/New()
	..()
	var/datum/component/item_upgrade/I = AddComponent(/datum/component/item_upgrade)
	I.weapon_upgrades = list(
		GUN_UPGRADE_FULLAUTO = TRUE,
		GUN_UPGRADE_RECOIL = 1.2
	)
	I.req_gun_tags = list(GUN_FA_MODDABLE)
	I.gun_loc_tag = GUN_MECHANISM

//Causes your weapon to shoot you in the face, then explode. Acquired through uplink
/obj/item/gun_upgrade/mechanism/reverse_loader
	name = "Syndicate reverse loader"
	desc = "Makes bullets loaded into the weapon fire backwards, into its user."
	matter = list(MATERIAL_STEEL = 3, MATERIAL_PLASTEEL = 3, MATERIAL_PLASTIC = 3)
	icon_state = "Reverse_loader"
	spawn_blacklisted = TRUE

/obj/item/gun_upgrade/mechanism/reverse_loader/New()
	..()
	var/datum/component/item_upgrade/I = AddComponent(/datum/component/item_upgrade)
	I.weapon_upgrades = list(
		GUN_UPGRADE_RIGGED = TRUE
	)
	I.removal_time *= 5
	I.req_gun_tags = list(GUN_PROJECTILE)
	I.gun_loc_tag = GUN_MECHANISM

/obj/item/storage/box/gun_upgrades
	name = "Big box of gun fun"
	desc = "If seen, please report to your nearest \[REDACTED\]"
	spawn_blacklisted = TRUE

/obj/item/storage/box/gun_upgrades/populate_contents()
	for(var/i in subtypesof(/obj/item/gun_upgrade))
		var/obj/test = i
		if(initial(test.icon_state))
			new i(src)
	new /obj/item/bikehorn(src)
	new /obj/item/tool_upgrade/productivity/ergonomic_grip(src)
	new /obj/item/tool_upgrade/refinement/laserguide(src)
	new /obj/item/tool_upgrade/augment/ai_tool(src)
	new /obj/item/tool_upgrade/refinement/gravenhancer(src)

/obj/item/gun_upgrade/trigger/boom
	name = "Syndicate \"Self Destruct\" trigger"
	desc = "Trigger that explode gun on shoot, only for energy weapon."
	matter = list(MATERIAL_STEEL = 3, MATERIAL_SILVER = 3)
	icon_state = "Boom"
	spawn_blacklisted = TRUE

/obj/item/gun_upgrade/trigger/boom/New()
	..()
	var/datum/component/item_upgrade/I = AddComponent(/datum/component/item_upgrade)
	I.weapon_upgrades = list(
		GUN_UPGRADE_EXPLODE = TRUE
		)
	I.removal_time *= 10
	I.gun_loc_tag = GUN_TRIGGER
	I.req_gun_tags = list(GUN_ENERGY)

/obj/item/gun_upgrade/scope
	bad_type = /obj/item/gun_upgrade/scope

/obj/item/gun_upgrade/scope/watchman
	name = "Frozen Star \"Watchman\" scope"
	desc = "Scope that can be attachet to avarage gun."
	matter = list(MATERIAL_GLASS = 2, MATERIAL_PLASTEEL = 2)
	icon_state = "Watchman"

/obj/item/gun_upgrade/scope/watchman/New()
	..()
	var/datum/component/item_upgrade/I = AddComponent(/datum/component/item_upgrade)
	I.weapon_upgrades = list(
		GUN_UPGRADE_RECOIL = 1.1,
		GUN_UPGRADE_ZOOM = 1.2
		)
	I.gun_loc_tag = GUN_SCOPE
	I.req_gun_tags = list(GUN_SCOPE)

/obj/item/gun_upgrade/scope/killer
	name = "Syndicate \"Contract Killer\" scope"
	desc = "Scope used for sniping from large distances."
	matter = list(MATERIAL_PLASMAGLASS = 3, MATERIAL_PLASTEEL = 3)
	icon_state = "Killer"
	spawn_blacklisted = TRUE

/obj/item/gun_upgrade/scope/killer/New()
	..()
	var/datum/component/item_upgrade/I = AddComponent(/datum/component/item_upgrade)
	I.weapon_upgrades = list(
		GUN_UPGRADE_RECOIL = 1.3,
		GUN_UPGRADE_ZOOM = 2
		)
	I.gun_loc_tag = GUN_SCOPE
	I.req_gun_tags = list(GUN_SCOPE)


/obj/item/gun_upgrade/mechanism/gravcharger
	name = "makeshift bullet time generator"
	desc = "When attached to a gun, this device bends time and space to create a localized microgravity field around each bullet, with peculiar results"
	matter = list(MATERIAL_STEEL = 3, MATERIAL_PLASMA = 2, MATERIAL_PLASTEEL = 2, MATERIAL_URANIUM = 2)
	icon_state = "gravbarrel"
	rarity_value = 20

/obj/item/gun_upgrade/mechanism/gravcharger/New()
	..()
	var/datum/component/item_upgrade/I = AddComponent(/datum/component/item_upgrade)
	I.weapon_upgrades = list(
		GUN_UPGRADE_STEPDELAY_MULT = 10, // bullets fly 10 times slower than a regular bullet. this is intended.
		GUN_UPGRADE_FIRE_DELAY_MULT = 0.5
		)
	I.gun_loc_tag = GUN_MECHANISM
	I.req_gun_tags = list(GUN_PROJECTILE)

/obj/item/gun_upgrade/cosmetic
	bad_type = /obj/item/gun_upgrade/cosmetic

/obj/item/gun_upgrade/cosmetic/gold
	name = "\"Scaramanga\" gold paint"
	desc = "A small pot of gold paint, for the kingpin in your life."
	icon_state = "gold_pot"
	matter = list(MATERIAL_GOLD = 15)
	rarity_value = 20
	price_tag = 1600

/obj/item/gun_upgrade/cosmetic/gold/New()
	..()
	var/datum/component/item_upgrade/I = AddComponent(/datum/component/item_upgrade)
	I.weapon_upgrades = list(
		GUN_UPGRADE_GILDED = TRUE
		)
	I.gun_loc_tag = GUN_COSMETIC
	I.req_gun_tags = list(GUN_GILDABLE)

//Trash mods, for putting on old guns

/obj/item/gun_upgrade/trigger/faulty
	name = "Faulty Trigger"
	desc = "Weirdly sticky, and none of your fingers seem to fit to it comfortably. This causes more recoil and increases delay between shots as you try to compensate for it."
	icon_state = "Cop_Block"
	spawn_blacklisted = TRUE
	price_tag = 0

/obj/item/gun_upgrade/trigger/faulty/New()
	..()
	var/datum/component/item_upgrade/I = AddComponent(/datum/component/item_upgrade)
	I.weapon_upgrades = list(
		GUN_UPGRADE_RECOIL = rand(12,30)/10,
		GUN_UPGRADE_FIRE_DELAY_MULT = rand(11,18)/10
	)
	I.destroy_on_removal = TRUE
	I.gun_loc_tag = GUN_TRIGGER
	I.removable = FALSE

/obj/item/gun_upgrade/barrel/faulty
	name = "Warped Barrel"
	desc = "Extreme heat has warped this barrel off-target. This decreases the impact force of bullets fired through it and makes it more difficult to correctly aim the weapon it's attached to."
	icon_state = "Forged_barrel"
	spawn_blacklisted = TRUE
	price_tag = 0

/obj/item/gun_upgrade/barrel/faulty/New()
	..()
	var/datum/component/item_upgrade/I = AddComponent(/datum/component/item_upgrade)
	I.weapon_upgrades = list(
		GUN_UPGRADE_OFFSET = rand(5,15),
		GUN_UPGRADE_PEN_MULT = rand(-0.2,0.2),
		GUN_UPGRADE_DAMAGE_MULT = rand(0.8,1.2)
	)
	I.destroy_on_removal = TRUE
	I.gun_loc_tag = GUN_BARREL
	I.removable = FALSE

/obj/item/gun_upgrade/muzzle/faulty
	name = "Failed Makeshift Silencer"
	desc = "Inspired by cheesy action movies, somebody has left trash on the end of this weapon. This causes the attached weapon to suffer from weaker armor penetration."
	icon_state = "silencer"
	spawn_blacklisted = TRUE
	price_tag = 0

/obj/item/gun_upgrade/muzzle/faulty/New()
	..()
	var/datum/component/item_upgrade/I = AddComponent(/datum/component/item_upgrade)
	I.weapon_upgrades = list(
		GUN_UPGRADE_PEN_MULT = -rand(0.1,0.6)/10,
		GUN_UPGRADE_STEPDELAY_MULT = rand(10,12)/10,
		GUN_UPGRADE_SILENCER = TRUE
	)
	I.destroy_on_removal = TRUE
	I.gun_loc_tag = GUN_MUZZLE
	I.removable = FALSE

/obj/item/gun_upgrade/mechanism/faulty
	name = "Unknown Clockwork Mechanism"
	desc = "It's really not clear what this modification actually does. It appears to effect the attached weapon's recoil, but if it actually helps or hinders the weapon is unclear."
	icon_state = "Weintraub"
	spawn_blacklisted = TRUE
	price_tag = 0

/obj/item/gun_upgrade/mechanism/faulty/New()
	..()
	var/datum/component/item_upgrade/I = AddComponent(/datum/component/item_upgrade)
	I.weapon_upgrades = list(
		GUN_UPGRADE_RECOIL = rand(5, 20)/10
	)
	I.destroy_on_removal = TRUE
	I.gun_loc_tag = GUN_MECHANISM
	I.removable = FALSE

/obj/item/gun_upgrade/scope/faulty
	name = "Misaligned sights"
	desc = "Some bad knocks have changed the angling on the sights of this weapon. This causes the attached weapon to suffer from decreased accuracy."
	icon_state = "Watchman"
	spawn_blacklisted = TRUE
	price_tag = 0

/obj/item/gun_upgrade/scope/faulty/New()
	..()
	var/datum/component/item_upgrade/I = AddComponent(/datum/component/item_upgrade)
	I.weapon_upgrades = list(
		GUN_UPGRADE_OFFSET = rand(1,3),
		GUN_UPGRADE_ZOOM = rand(0.4,0.8)
	)
	I.destroy_on_removal = TRUE
	I.gun_loc_tag = GUN_SCOPE
	I.removable = FALSE

/obj/item/gun_upgrade/trigger/better
	name = "Refined trigger"
	desc = "This trigger seems to be made of durable alloys and cut to the precision of milimeters."
	spawn_blacklisted = TRUE
	price_tag = 100

/obj/item/gun_upgrade/trigger/better/New()
	..()
	var/datum/component/item_upgrade/I = AddComponent(/datum/component/item_upgrade)
	I.weapon_upgrades = list(
		GUN_UPGRADE_FIRE_DELAY = 0.7
	)
	I.destroy_on_removal = TRUE
	I.gun_loc_tag = GUN_TRIGGER

/obj/item/gun_upgrade/barrel/better
	name = "High-temperature forged barrel"
	desc = "A barrel forged in high temperature, making the metal more resistant."
	spawn_blacklisted = TRUE
	price_tag = 150

/obj/item/gun_upgrade/barrel/better/New()
	..()
	var/datum/component/item_upgrade/I = AddComponent(/datum/component/item_upgrade)
	I.weapon_upgrades = list(
		GUN_UPGRADE_FIRE_DELAY = 0.7
	)
	I.destroy_on_removal = TRUE
	I.gun_loc_tag = GUN_BARREL

/obj/item/gun_upgrade/muzzle/better
	name = "Resonance muzzle"
	desc = "A high tech muzzle, made to resonate at the same frequency as the sound that comes from the gun."
	spawn_blacklisted = TRUE
	price_tag = 150

/obj/item/gun_upgrade/muzzle/better/New()
	..()
	var/datum/component/item_upgrade/I = AddComponent(/datum/component/item_upgrade)
	I.weapon_upgrades = list(
		GUN_UPGRADE_SILENCER = TRUE,
		GUN_UPGRADE_STEPDELAY_MULT = 0.9
	)
	I.destroy_on_removal = TRUE
	I.gun_loc_tag = GUN_MUZZLE

/obj/item/gun_upgrade/mechanism/better
	name = "Hydraulic mechanism"
	desc = "A high tech mechanism that uses hydraulic pumps to keep recoil at a minimum."
	spawn_blacklisted = TRUE
	price_tag = 300

/obj/item/gun_upgrade/mechanism/better/New()
	..()
	var/datum/component/item_upgrade/I = AddComponent(/datum/component/item_upgrade)
	I.weapon_upgrades = list(
		GUN_UPGRADE_RECOIL = 0.8,
	)
	I.destroy_on_removal = TRUE
	I.gun_loc_tag = GUN_MECHANISM

/obj/item/gun_upgrade/scope/better
	name = "High-res scope"
	desc = "A high resolution scope"
	matter = list(MATERIAL_STEEL = 1, MATERIAL_PLASMAGLASS = 3)
	spawn_blacklisted = TRUE
	price_tag = 100

/obj/item/gun_upgrade/scope/better/New()
	..()
	var/datum/component/item_upgrade/I = AddComponent(/datum/component/item_upgrade)
	I.weapon_upgrades = list(
		GUN_UPGRADE_ZOOM = 2,
	)
	I.destroy_on_removal = TRUE
	I.gun_loc_tag = GUN_SCOPE


#define TRASH_GUNMODS list(/obj/item/gun_upgrade/trigger/faulty, /obj/item/gun_upgrade/barrel/faulty, \
		/obj/item/gun_upgrade/muzzle/faulty, /obj/item/gun_upgrade/mechanism/faulty, \
		/obj/item/gun_upgrade/scope/faulty)

#define GREAT_GUNMODS list(/obj/item/gun_upgrade/trigger/better, /obj/item/gun_upgrade/barrel/better, \
	/obj/item/gun_upgrade/muzzle/better, /obj/item/gun_upgrade/mechanism/better, /obj/item/gun_upgrade/scope/better)

