/obj/item/weapon/gun/matter/launcher/nt_sprayer
	name = "NT BCR \"Righteous One\""
	desc = "\"NeoTheology\" brand cleansing carbine. Uses solid biomass as ammo and dispense cleansing liquid on hit."
	icon_state = "nt_sprayer"
	icon = 'icons/obj/guns/matter/nt_sprayer.dmi'
	slot_flags = SLOT_BACK
	fire_sound = 'sound/weapons/Genhit.ogg'

	matter_type = MATERIAL_BIOMATTER

	projectile_cost = 0.5
	projectile_type = /obj/item/weapon/arrow/cleansing


/obj/item/weapon/arrow/cleansing
	icon = 'icons/obj/projectiles.dmi'
	icon_state = "toxin"
	throwforce = 1
	sharp = FALSE

/obj/item/weapon/arrow/cleansing/throw_impact()
	..()

	create_reagents(5)
	reagents.add_reagent("cleaner", 1)
	reagents.add_reagent("surfactant", 2)
	reagents.add_reagent("water", 2)

	qdel(src)
