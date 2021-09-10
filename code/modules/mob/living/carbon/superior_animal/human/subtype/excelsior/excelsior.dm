/mob/living/carbon/superior_animal/human/excelsior
	name = "Excelsior grunt"
	desc = "An excelsior rank and file, often converted unwillingly, making them nothing more than cannon fodder as they fight in the name of Haven."
	icon = 'icons/mob/animal.dmi'
	icon_state = "excel_makarov"
	stop_automated_movement_when_pulled = 1
	wander = 0
	maxHealth = 200
	health = 200
	gender = PLURAL

	//range/ammo stuff
	ranged = 1
	rapid = 1
	ranged_cooldown = 3
	projectiletype = /obj/item/projectile/bullet/pistol/hv
	projectilesound = 'sound/weapons/guns/fire/pistol_fire.ogg'

	melee_damage_lower = 10
	melee_damage_upper = 15
	breath_required_type = 0 // Doesn't need to breath, in a space suit
	breath_poison_type = 0 // Can't be poisoned
	min_air_pressure = 0 // Doesn't need pressure
	attacktext = "slashed"
	attack_sound = 'sound/weapons/bladeslice.ogg'

//They are all waring suits
	breath_required_type = NONE
	breath_poison_type = NONE
	min_breath_required_type = 0
	min_breath_poison_type = 0

	min_air_pressure = 0
	min_bodytemperature = 0

//Drops
	meat_amount = 4
	meat_type = /obj/item/reagent_containers/food/snacks/meat/human

	var/weapon1 = /obj/item/gun/projectile/selfload/makarov
	faction = "excelsior"

/mob/living/carbon/superior_animal/human/excelsior/excel_boltgun
	icon_state = "excel_boltgun"
	rapid = 0
	projectiletype = /obj/item/projectile/bullet/lrifle/hv
	weapon1 = /obj/item/gun/projectile/boltgun
	projectilesound = 'sound/weapons/guns/fire/ltrifle_fire.ogg'

/mob/living/carbon/superior_animal/human/excelsior/excel_ak
	icon_state = "excel_ak"
	projectiletype = /obj/item/projectile/bullet/lrifle/hv
	weapon1 = /obj/item/gun/projectile/automatic/ak47
	projectilesound = 'sound/weapons/guns/fire/ltrifle_fire.ogg'

/mob/living/carbon/superior_animal/human/excelsior/excel_vintorez
	icon_state = "excel_vintorez"
	rapid = 0 //The gun cant rapid fire...
	projectiletype = /obj/item/projectile/bullet/srifle/hv
	weapon1 = /obj/item/gun/projectile/automatic/vintorez
	projectilesound = 'sound/weapons/guns/fire/ltrifle_fire.ogg'

/mob/living/carbon/superior_animal/human/excelsior/excel_drozd
	icon_state = "excel_drozd"
	projectiletype = /obj/item/projectile/bullet/pistol/hv
	weapon1 = /obj/item/gun/projectile/automatic/drozd
	projectilesound = 'sound/weapons/guns/fire/smg_fire.ogg'

/mob/living/carbon/superior_animal/human/excelsior/death(gibbed, deathmessage = "drops \his weapon as \his implant explodes, spraying \him in a shower of gore!")
	..()
	new /obj/effect/gibspawner/human(src.loc)
	playsound(src, 'sound/effects/Explosion2.ogg', 75, 1, -3)
	if(weapon1)
		new weapon1(src.loc)
		weapon1 = null
	qdel(src)
	return
