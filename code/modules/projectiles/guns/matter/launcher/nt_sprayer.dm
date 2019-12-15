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
	var/emagged = FALSE


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

/obj/item/weapon/gun/matter/launcher/nt_sprayer/emag_act(remaining_charges, mob/user)
	if(!emagged)
		projectile_cost = 30
		projectile_type = /obj/item/weapon/arrow/biomass
		fire_sound = 'sound/weapons/tablehit1.ogg'
		to_chat(user, SPAN_DANGER("You overload \the [src]'s reagent synthesizer."))
		var/datum/effect/effect/system/spark_spread/spark_system = new /datum/effect/effect/system/spark_spread()
		spark_system.set_up(5, 0, src.loc)
		spark_system.start()
		playsound(src.loc, "sparks", 50, 1)
		emagged = TRUE
		return
	else
		to_chat(user, "Reagent synthesizer is fried. You can't even fit the sequencer into the input slot.")

/obj/item/weapon/arrow/biomass
	icon = 'icons/obj/projectiles.dmi'
	icon_state = "neurotoxin"
	throwforce = 1
	sharp = FALSE

/obj/item/weapon/arrow/biomass/throw_impact(var/turf/T)
	..()

	spill_biomass(T)

	qdel(src)