/obj/item/weapon/gun_upgrade
	icon = 'icons/obj/guns/mods.dmi'
	w_class = ITEM_SIZE_TINY
	price_tag = 500

/obj/item/weapon/gun_upgrade/barrel

//Silences the weapon, reduces damage multiplier slightly, Legacy port.
/obj/item/weapon/gun_upgrade/barrel/silencer
	name = "silencer"
	desc = "a threaded silencer that can be attached to the barrel of certain guns. Vastly reduces noise, but impedes muzzle velocity."
	matter = list(MATERIAL_PLASTEEL = 3, MATERIAL_PLASTIC = 1)
	icon_state = "silencer"


/obj/item/weapon/gun_upgrade/barrel/silencer/New()
	..()
	var/datum/component/item_upgrade/I = AddComponent(/datum/component/item_upgrade)
	I.weapon_upgrades = list(
		GUN_UPGRADE_SILENCER = TRUE,
		GUN_UPGRADE_DAMAGE_PLUS = -0.1
		)
	I.gun_loc_tag = GUN_BARREL
	I.req_gun_tags = list(GUN_SILENCABLE)

//Decreases fire delay. Acquired through loot spawns
/obj/item/weapon/gun_upgrade/barrel/forged
	name = "forged barrel"
	desc = "Despite advancements in 3D printing, a properly forged plasteel barrel can still outperform anything that comes from an autolathe."
	icon_state = "Forged_barrel"

/obj/item/weapon/gun_upgrade/barrel/forged/New()
	..()
	var/datum/component/item_upgrade/I = AddComponent(/datum/component/item_upgrade)
	I.weapon_upgrades = list(
		GUN_UPGRADE_FIRE_DELAY_MULT = 0.8
		)
	I.gun_loc_tag = GUN_BARREL
	I.req_gun_tags = list(GUN_PROJECTILE)

//Increases penetration multiplier, projectile speed. Increases fire delay. Acquired via science
/obj/item/weapon/gun_upgrade/barrel/mag_accel
	name = "Moebius \"Penetrator\" magnetic accelerator barrel"
	desc = "Uses sympathetic magnetic coiling to increase exit velocity of a metal projectile."
	icon_state = "Penetrator"
	matter = list(MATERIAL_PLASTIC = 2, MATERIAL_PLASTEEL = 1, MATERIAL_GOLD = 1)

/obj/item/weapon/gun_upgrade/barrel/mag_accel/New()
	..()
	var/datum/component/item_upgrade/I = AddComponent(/datum/component/item_upgrade)
	I.weapon_upgrades = list(
		GUN_UPGRADE_PEN_MULT = 1.2,
		GUN_UPGRADE_STEPDELAY_MULT = 0.8,
		GUN_UPGRADE_FIRE_DELAY_MULT = 1.5,
		)
	I.gun_loc_tag = GUN_BARREL
	I.req_gun_tags = list(GUN_PROJECTILE)

//Adds +10 burn damage to a bullet, lowers armor penetration, adds a constant projectile offset, increases recoil and fire delay. Acquired via science
/obj/item/weapon/gun_upgrade/barrel/overheat
	name = "Moebius \"Caster\" magnetic overheat barrel"
	desc = "Uses magnetic induction to heat the projectile of a weapon. Arguable combat effectiveness, but flashy nonetheless."
	icon_state = "Caster"
	matter = list(MATERIAL_PLASTIC = 2, MATERIAL_PLASTEEL = 1, MATERIAL_GOLD = 1)

/obj/item/weapon/gun_upgrade/barrel/overheat/New()
	..()
	var/datum/component/item_upgrade/I = AddComponent(/datum/component/item_upgrade)
	I.weapon_upgrades = list(
		GUN_UPGRADE_PEN_MULT = 0.8,
		GUN_UPGRADE_DAMAGE_BURN = 10,
		GUN_UPGRADE_OFFSET = 5,
		GUN_UPGRADE_RECOIL = 1.5,
		GUN_UPGRADE_FIRE_DELAY_MULT = 1.2,
		)
	I.gun_loc_tag = GUN_BARREL
	I.req_gun_tags = list(GUN_PROJECTILE)

//For energy weapons, increases the damage output, but also the charge cost. Acquired through loot spawns.
/obj/item/weapon/gun_upgrade/barrel/excruciator
	name = "NeoTheology \"EXCRUCIATOR\" giga lens"
	desc = "It's time for us to shine."
	icon_state = "Excruciator"

/obj/item/weapon/gun_upgrade/barrel/excruciator/New()
	..()
	var/datum/component/item_upgrade/I = AddComponent(/datum/component/item_upgrade)
	I.weapon_upgrades = list(
		GUN_UPGRADE_DAMAGE_MULT = 1.3,
		GUN_UPGRADE_CHARGECOST = 2
		)
	I.gun_loc_tag = GUN_BARREL
	I.req_gun_tags = list(GUN_ENERGY)

/obj/item/weapon/gun_upgrade/trigger

//Disables the ability to toggle the safety, toggles the safety permanently off, decreases fire delay. Acquired through loot spawns
/obj/item/weapon/gun_upgrade/trigger/dangerzone
	name = "Frozen Star \"Danger Zone\" Trigger"
	desc = "When you need that extra edge."
	icon_state = "Danger_Zone"

/obj/item/weapon/gun_upgrade/trigger/dangerzone/New()
	..()
	var/datum/component/item_upgrade/I = AddComponent(/datum/component/item_upgrade)
	I.weapon_upgrades = list(
		GUN_UPGRADE_FIRE_DELAY_MULT = 0.8,
		GUN_UPGRADE_FORCESAFETY = FALSE,
		)
	I.gun_loc_tag = GUN_TRIGGER

//Disables the ability to toggle the safety, toggles the safety permanently on, takes 2 minutes to remove (yikes). Acquired through loot spawns
/obj/item/weapon/gun_upgrade/trigger/cop_block
	name = "Frozen Star \"Cop Block\" Trigger"
	desc = "A simpler way of making a weapon display-only"
	icon_state = "Cop_Block"

/obj/item/weapon/gun_upgrade/trigger/cop_block/New()
	..()
	var/datum/component/item_upgrade/I = AddComponent(/datum/component/item_upgrade)
	I.weapon_upgrades = list(
		GUN_UPGRADE_FORCESAFETY = TRUE,
		)
	I.removal_time *= 10
	I.gun_loc_tag = GUN_TRIGGER

/obj/item/weapon/gun_upgrade/mechanism

//Adds +3 to the internal magazine of a weapon. Acquired through loot spawns.
/obj/item/weapon/gun_upgrade/mechanism/overshooter
	name = "Frozen Star \"Overshooter\" internal magazine kit"
	desc = "A method of overloading a weapon's internal magazine, fitting more ammunition within the weapon."
	icon_state = "Overshooter"

/obj/item/weapon/gun_upgrade/mechanism/overshooter/New()
	..()
	var/datum/component/item_upgrade/I = AddComponent(/datum/component/item_upgrade)
	I.weapon_upgrades = list(
		GUN_UPGRADE_MAGUP = 3
		)
	I.req_gun_tags = list(GUN_PROJECTILE, GUN_INTERNAL_MAG)
	I.gun_loc_tag = GUN_MECHANISM

//Adds radiation damage to .35 rounds. Acquired through telecrystal uplink
/obj/item/weapon/gun_upgrade/mechanism/glass_widow
	name = "Syndicate \"Glass Widow\" infuser"
	desc = "An old technology from the Corporate Wars, used to make formerly useless civilian-grade weaponry into something much more lethal."
	icon_state = "Glass_Widow"

/obj/item/weapon/gun_upgrade/mechanism/glass_widow/New()
	..()
	var/datum/component/item_upgrade/I = AddComponent(/datum/component/item_upgrade)
	I.weapon_upgrades = list(
		GUN_UPGRADE_DAMAGE_RADIATION = 5
		)
	I.req_gun_tags = list(GUN_PROJECTILE, GUN_CALIBRE_35)
	I.gun_loc_tag = GUN_MECHANISM

//Lets the SOL be made into a fully automatic weapon, but increases recoil. Acquirable through Frozen Star Guns&Ammo Vendor
/obj/item/weapon/gun_upgrade/mechanism/weintraub
	name = "Frozen Star \"Weintraub\" full auto kit"
	desc = "A fully automatic receiver for the .25 \"Sol\"."
	icon_state = "Weintraub"

/obj/item/weapon/gun_upgrade/mechanism/weintraub/New()
	..()
	var/datum/component/item_upgrade/I = AddComponent(/datum/component/item_upgrade)
	I.weapon_upgrades = list(
		GUN_UPGRADE_FULLAUTO = TRUE,
		GUN_UPGRADE_RECOIL = 1.2
	)
	I.req_gun_tags = list(GUN_SOL)
	I.gun_loc_tag = GUN_MECHANISM

//Causes your weapon to shoot you in the face, then explode. Acquired through uplink
/obj/item/weapon/gun_upgrade/mechanism/reverse_loader
	name = "Syndicate reverse loader"
	desc = "Makes bullets loaded into the weapon fire backwards, into its user."
	icon_state = "Reverse_loader"

/obj/item/weapon/gun_upgrade/mechanism/reverse_loader/New()
	..()
	var/datum/component/item_upgrade/I = AddComponent(/datum/component/item_upgrade)
	I.weapon_upgrades = list(
		GUN_UPGRADE_RIGGED = TRUE
	)
	I.removal_time *= 5
	I.req_gun_tags = list(GUN_PROJECTILE)
	I.gun_loc_tag = GUN_MECHANISM

/obj/item/weapon/gun_upgrade/underbarrel

/obj/item/weapon/storage/box/gun_upgrades
	name = "Big box of gun fun"
	desc = "If seen, please report to your nearest \[REDACTED\]"

/obj/item/weapon/storage/box/gun_upgrades/populate_contents()
	for(var/i in subtypesof(/obj/item/weapon/gun_upgrade))
		var/obj/test = i
		if(initial(test.icon_state))
			new i(src)
	new /obj/item/weapon/bikehorn(src)
	new /obj/item/weapon/tool_upgrade/productivity/ergonomic_grip(src)
	new /obj/item/weapon/tool_upgrade/refinement/laserguide(src)
	new /obj/item/weapon/tool_upgrade/augment/ai_tool(src)

// 	 EXPERIMENTAL WEAPON MODS
//------------------------------------------------

// Double damage at the cost of more recoil and a tripled energy consumption
/obj/item/weapon/gun_upgrade/mechanism/battery_shunt
	name = "Moebius \"Thunder\" battery shunt"
	desc = "This experimental battery shunt is a cutting edge tool attachment which bypasses battery protection circuits to deliver the maximum amount of power in the shortest amount of time."
	icon_state = "battery_shunt"
	matter = list(MATERIAL_PLASTIC = 2, MATERIAL_PLASTEEL = 1, MATERIAL_GOLD = 1, MATERIAL_URANIUM = 1)

/obj/item/weapon/gun_upgrade/mechanism/battery_shunt/New()
	..()
	var/datum/component/item_upgrade/I = AddComponent(/datum/component/item_upgrade)
	I.weapon_upgrades = list(
	GUN_UPGRADE_RECOIL = 1.2,
	GUN_UPGRADE_DAMAGE_MULT = 2,
	GUN_UPGRADE_CHARGECOST = 3)
	I.req_fuel_cell = REQ_CELL
	I.gun_loc_tag = GUN_MECHANISM

// Greatly increase firerate at the cost of lower damage
/obj/item/weapon/gun_upgrade/mechanism/overdrive
	name = "Moebius \"Tesla\" overdrive chip"
	desc = "This experimental chip is a cutting edge tool attachment which bypasses power management protocols to dramatically increase the rate of fire at the cost of a reduced stopping power."
	icon_state = "overdrive"
	matter = list(MATERIAL_PLASTIC = 2, MATERIAL_PLASTEEL = 1, MATERIAL_GOLD = 1, MATERIAL_URANIUM = 1)

/obj/item/weapon/gun_upgrade/mechanism/overdrive/New()
	..()
	var/datum/component/item_upgrade/I = AddComponent(/datum/component/item_upgrade)
	I.weapon_upgrades = list(
	GUN_UPGRADE_RECOIL = 1.2,
	GUN_UPGRADE_DAMAGE_MULT = 0.20,
	GUN_UPGRADE_FIRE_DELAY_MULT = 0.25)
	I.req_fuel_cell = REQ_CELL
	I.gun_loc_tag = GUN_MECHANISM

// HONK
/obj/item/weapon/gun_upgrade/trigger/honker
	name = "Moebius \"Banana Split\" emitter"
	desc = "This experimental trigger mechanism taps directly into the bluespace dimension and refines its energy to produce the purest sounds possible."
	icon_state = "honker"
	matter = list(MATERIAL_PLASTIC = 2, MATERIAL_PLASTEEL = 1)

/obj/item/weapon/gun_upgrade/trigger/honker/New()
	..()
	var/datum/component/item_upgrade/I = AddComponent(/datum/component/item_upgrade)
	I.weapon_upgrades = list(
	GUN_UPGRADE_HONK = TRUE)
	I.gun_loc_tag = GUN_TRIGGER

// Add toxin damage to your weapon
/obj/item/weapon/gun_upgrade/barrel/toxin_coater
	name = "Moebius \"Black Mamba\" toxin coater"
	desc = "This experimental barrel coats bullets with a thin layer of toxins just before they leave the weapon. Do not lick it."
	icon_state = "toxin_coater"
	matter = list(MATERIAL_PLASTIC = 2, MATERIAL_PLASTEEL = 1, MATERIAL_GOLD = 2)

/obj/item/weapon/gun_upgrade/barrel/toxin_coater/New()
	..()
	var/datum/component/item_upgrade/I = AddComponent(/datum/component/item_upgrade)
	I.weapon_upgrades = list(
	GUN_UPGRADE_DAMAGE_TOX = 5)
	I.req_gun_tags = list(GUN_PROJECTILE)
	I.gun_loc_tag = GUN_BARREL

// Add radiation damage to your weapon
/obj/item/weapon/gun_upgrade/barrel/isotope_diffuser
	name = "Moebius \"Atomik\" isotope diffuser"
	desc = "This experimental barrel constantly sprays a thin mist of radioactive isotopes to make projectiles leaving the weapons deadlier, whether bullets, lasers or energy bolts. Do not put it in your mouth."
	icon_state = "isotope_diffuser"
	matter = list(MATERIAL_PLASTIC = 2, MATERIAL_PLASTEEL = 1, MATERIAL_URANIUM = 2)

/obj/item/weapon/gun_upgrade/barrel/isotope_diffuser/New()
	..()
	var/datum/component/item_upgrade/I = AddComponent(/datum/component/item_upgrade)
	I.weapon_upgrades = list(
	GUN_UPGRADE_DAMAGE_RADIATION = 5)
	I.req_gun_tags = list(GUN_PROJECTILE)
	I.gun_loc_tag = GUN_BARREL

// Add psy damage to your weapon
/obj/item/weapon/gun_upgrade/mechanism/psionic_catalyst
	name = "Moebius \"Mastermind\" psionic catalyst"
	desc = "This controversial device greatly amplifies the natural psionic ability of the user and allows them to project their will into the world. Before the development of the Psi Amp, psionic disciplines were mostly detectable only in a lab environment."
	icon_state = "psionic_catalyst"
	matter = list(MATERIAL_SILVER = 3, MATERIAL_PLASTEEL = 3, MATERIAL_URANIUM = 3)

/obj/item/weapon/gun_upgrade/mechanism/psionic_catalyst/New()
	..()
	var/datum/component/item_upgrade/I = AddComponent(/datum/component/item_upgrade)
	I.weapon_upgrades = list(
	GUN_UPGRADE_DAMAGE_PSY = 0.4)
	I.req_gun_tags = list(GUN_PROJECTILE)
	I.gun_loc_tag = GUN_MECHANISM
