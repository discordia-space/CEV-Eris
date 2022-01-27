// 	 EXPERIMENTAL WEAPON69ODS
//------------------------------------------------

//Increases penetration69ultiplier, projectile speed. Increases fire delay. Ac69uired69ia science
/obj/item/gun_upgrade/barrel/mag_accel
	name = "Moebius \"Penetrator\"69agnetic accelerator barrel"
	desc = "Uses sympathetic69agnetic coiling to increase exit69elocity of a69etal projectile."
	icon_state = "Penetrator"
	matter = list(MATERIAL_PLASTIC = 2,69ATERIAL_PLASTEEL = 1,69ATERIAL_GOLD = 1)
	rarity_value = 30
	spawn_blacklisted = TRUE

/obj/item/gun_upgrade/barrel/mag_accel/New()
	..()
	var/datum/component/item_upgrade/I = AddComponent(/datum/component/item_upgrade)
	I.weapon_upgrades = list(
		GUN_UPGRADE_PEN_MULT = 1.2,
		GUN_UPGRADE_STEPDELAY_MULT = 0.8,
		GUN_UPGRADE_FIRE_DELAY_MULT = 1.5
		)
	I.gun_loc_tag = GUN_BARREL
	I.re69_gun_tags = list(GUN_PROJECTILE)


//Adds +10 burn damage to a bullet, lowers armor penetration, adds a constant projectile offset, increases recoil and fire delay. Ac69uired69ia science
/obj/item/gun_upgrade/barrel/overheat
	name = "Moebius \"Caster\"69agnetic overheat barrel"
	desc = "Uses69agnetic induction to heat the projectile of a weapon. Arguable combat effectiveness, but flashy69onetheless."
	icon_state = "Caster"
	matter = list(MATERIAL_PLASTIC = 2,69ATERIAL_PLASTEEL = 1,69ATERIAL_GOLD = 1)
	rarity_value = 30
	spawn_blacklisted = TRUE

/obj/item/gun_upgrade/barrel/overheat/New()
	..()
	var/datum/component/item_upgrade/I = AddComponent(/datum/component/item_upgrade)
	I.weapon_upgrades = list(
		GUN_UPGRADE_PEN_MULT = 0.8,
		GUN_UPGRADE_DAMAGE_BURN = 10,
		GUN_UPGRADE_OFFSET = 5,
		GUN_UPGRADE_RECOIL = 1.5,
		GUN_UPGRADE_FIRE_DELAY_MULT = 1.2
		)
	I.gun_loc_tag = GUN_BARREL
	I.re69_gun_tags = list(GUN_PROJECTILE)


// Double damage at the cost of69ore recoil and a tripled energy consumption
/obj/item/gun_upgrade/mechanism/battery_shunt
	name = "Moebius \"Thunder\" battery shunt"
	desc = "This experimental battery shunt is a cutting edge tool attachment which bypasses battery protection circuits to deliver the69aximum amount of power in the shortest amount of time."
	icon_state = "battery_shunt"
	matter = list(MATERIAL_PLASTIC = 2,69ATERIAL_PLASTEEL = 1,69ATERIAL_GOLD = 1,69ATERIAL_URANIUM = 1)
	spawn_blacklisted = TRUE

/obj/item/gun_upgrade/mechanism/battery_shunt/New()
	..()
	var/datum/component/item_upgrade/I = AddComponent(/datum/component/item_upgrade)
	I.weapon_upgrades = list(
	GUN_UPGRADE_RECOIL = 1.2,
	GUN_UPGRADE_DAMAGE_MULT = 1.5,
	GUN_UPGRADE_CHARGECOST = 3)
	I.re69_fuel_cell = RE69_CELL
	I.gun_loc_tag = GUN_MECHANISM

// Greatly increase firerate at the cost of lower damage
/obj/item/gun_upgrade/mechanism/overdrive
	name = "Moebius \"Tesla\" overdrive chip"
	desc = "This experimental chip is a cutting edge tool attachment which bypasses power69anagement protocols to dramatically increase the rate of fire at the cost of a reduced stopping power."
	icon_state = "overdrive"
	matter = list(MATERIAL_PLASTIC = 2,69ATERIAL_PLASTEEL = 1,69ATERIAL_GOLD = 1,69ATERIAL_URANIUM = 1)
	spawn_blacklisted = TRUE

/obj/item/gun_upgrade/mechanism/overdrive/New()
	..()
	var/datum/component/item_upgrade/I = AddComponent(/datum/component/item_upgrade)
	I.weapon_upgrades = list(
	GUN_UPGRADE_RECOIL = 2,
	GUN_UPGRADE_DAMAGE_MULT = 0.66,
	GUN_UPGRADE_AGONY_MULT = 0.66,
	GUN_UPGRADE_FIRE_DELAY_MULT = 0.33,
	GUN_UPGRADE_FULLAUTO = TRUE,
	GUN_UPGRADE_CHARGECOST = 0.5,
	GUN_UPGRADE_FIRE_DELAY_MULT = 0.33)
	I.re69_fuel_cell = RE69_CELL
	I.gun_loc_tag = GUN_MECHANISM

// Add toxin damage to your weapon
/obj/item/gun_upgrade/barrel/toxin_coater
	name = "Moebius \"Black69amba\" toxin coater"
	desc = "This experimental barrel coats bullets with a thin layer of toxins just before they leave the weapon. Do69ot lick it."
	icon_state = "toxin_coater"
	matter = list(MATERIAL_PLASTIC = 2,69ATERIAL_PLASTEEL = 1,69ATERIAL_GOLD = 2)
	spawn_blacklisted = TRUE

/obj/item/gun_upgrade/barrel/toxin_coater/New()
	..()
	var/datum/component/item_upgrade/I = AddComponent(/datum/component/item_upgrade)
	I.weapon_upgrades = list(
	GUN_UPGRADE_DAMAGE_TOX = 5)
	I.re69_gun_tags = list(GUN_PROJECTILE)
	I.gun_loc_tag = GUN_BARREL

// Add radiation damage to your weapon
/obj/item/gun_upgrade/barrel/isotope_diffuser
	name = "Moebius \"Atomik\" isotope diffuser"
	desc = "This experimental barrel constantly sprays a thin69ist of radioactive isotopes to69ake projectiles leaving the weapons deadlier. Do69ot put it in your69outh."
	icon_state = "isotope_diffuser"
	matter = list(MATERIAL_PLASTIC = 2,69ATERIAL_PLASTEEL = 1,69ATERIAL_URANIUM = 2)
	spawn_blacklisted = TRUE

/obj/item/gun_upgrade/barrel/isotope_diffuser/New()
	..()
	var/datum/component/item_upgrade/I = AddComponent(/datum/component/item_upgrade)
	I.weapon_upgrades = list(
	GUN_UPGRADE_DAMAGE_RADIATION = 30)
	I.re69_gun_tags = list(GUN_PROJECTILE)
	I.gun_loc_tag = GUN_BARREL

// Add psy damage to your weapon
/obj/item/gun_upgrade/mechanism/psionic_catalyst
	name = "Moebius \"Mastermind\" psionic catalyst"
	desc = "This controversial device greatly amplifies the69atural psionic ability of the user and allows them to project their will into the world. Before the development of the Psi Amp, psionic disciplines were69ostly detectable only in a lab environment."
	icon_state = "psionic_catalyst"
	matter = list(MATERIAL_SILVER = 3,69ATERIAL_PLASTEEL = 3,69ATERIAL_URANIUM = 3)
	spawn_blacklisted = TRUE

/obj/item/gun_upgrade/mechanism/psionic_catalyst/New()
	..()
	var/datum/component/item_upgrade/I = AddComponent(/datum/component/item_upgrade)
	I.weapon_upgrades = list(
	GUN_UPGRADE_DAMAGE_PSY = 0.4)
	I.re69_gun_tags = list(GUN_PROJECTILE)
	I.gun_loc_tag = GUN_MECHANISM

/obj/item/gun_upgrade/barrel/gauss
	name = "Syndicate \"Gauss Coil\" barrel"
	desc = "Make bullet pierce through wall and penetrate armors easily, but losing rate of fire and increece recoil."
	icon_state = "Gauss"
	spawn_blacklisted = TRUE

/obj/item/gun_upgrade/barrel/gauss/New()
	..()
	var/datum/component/item_upgrade/I = AddComponent(/datum/component/item_upgrade)
	I.weapon_upgrades = list(
		GUN_UPGRADE_DAMAGE_BRUTE = 5,
		GUN_UPGRADE_STEPDELAY_MULT = 0.8,
		GUN_UPGRADE_PEN_MULT = 1.3,
		GUN_UPGRADE_PIERC_MULT = 1,
		GUN_UPGRADE_FIRE_DELAY_MULT = 1.4,
		GUN_UPGRADE_RECOIL = 1.4
		)
	I.removal_time *= 10
	I.gun_loc_tag = GUN_BARREL
	I.re69_gun_tags = list(GUN_PROJECTILE)

