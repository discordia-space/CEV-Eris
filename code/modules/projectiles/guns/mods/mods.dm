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

//Decreases fire delay
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

//Increases penetration multiplier, projectile speed. Increases fire delay
/obj/item/weapon/gun_upgrade/barrel/mag_accel
	name = "Moebius \"Penetrator\" magnetic accelerator barrel"
	desc = "Uses sympathetic magnetic coiling to increase exit velocity of a metal projectile."
	icon_state = "Penetrator"

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

//Adds +10 burn damage to a bullet, lowers armor penetration, adds a constant projectile offset, increases recoil and fire delay
/obj/item/weapon/gun_upgrade/barrel/overheat
	name = "Moebius \"Caster\" magnetic overheat barrel"
	desc = "Uses magnetic induction to heat the projectile of a weapon. Arguable combat effectiveness, but flashy nonetheless."
	icon_state = "Caster"


/obj/item/weapon/gun_upgrade/trigger

//Disables the ability to toggle the safety, toggles the safety permanently off, decreases fire delay
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

//Disables the ability to toggle the safety, toggles the safety permanently on, takes 2 minutes to remove (yikes)
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

/obj/item/weapon/gun_upgrade/underbarrel