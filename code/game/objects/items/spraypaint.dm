/obj/item/spraypaint
	name = "spraycan"
	desc = "Aerosol paint sealed in a pressurized container."
	icon = 'icons/obj/items.dmi'
	icon_state = "spraypaint"
	matter = list(MATERIAL_PLASTIC = 4, MATERIAL_STEEL = 5)
	price_tag = 40
	var/uses = 30
	w_class = ITEM_SIZE_SMALL
	throwforce = WEAPON_FORCE_HARMLESS

/obj/item/spraypaint/afterattack(atom/target, mob/user as mob, proximity)
	if(!proximity) return
	if(istype(target,/turf))
		var/graffititype = input("Choose what you'd like to paint") in list("Kot","Onestar","Doodle","Piss","Clown","Skull","Heart","Excelsior","Ironhammer","Moebius","Neotheology","Technomancer","Aster","Ancap yes","Ancap no")
		if(uses <= 0)
			playsound(loc, 'sound/effects/interaction/graffiti_empty.ogg', 100, 1)
			to_chat(user, SPAN_NOTICE("The spray can is empty."))
			return FALSE
		else
			playsound(loc, 'sound/effects/interaction/graffiti.ogg', 100, 1)
		if(do_after(user, 2 SECONDS, target))
			to_chat(user, SPAN_NOTICE("You start tagging \the [target.name]!"))
		else
			to_chat(user, SPAN_NOTICE("You must stand still while tagging \the [target.name]!"))
			return FALSE
		switch(graffititype)
			if("Kot")
				new /obj/effect/decal/cleanable/graffiti/graffiti_kot(target)
			if("Onestar")
				new /obj/effect/decal/cleanable/graffiti/graffiti_onestar(target)
			if("Doodle")
				new /obj/effect/decal/cleanable/graffiti/graffiti_doodle(target)
			if("Piss")
				new /obj/effect/decal/cleanable/graffiti/graffiti_piss(target)
			if("Clown")
				new /obj/effect/decal/cleanable/graffiti/graffiti_clown(target)
			if("Skull")
				new /obj/effect/decal/cleanable/graffiti/graffiti_skull(target)
			if("Heart")
				new /obj/effect/decal/cleanable/graffiti/graffiti_heart(target)
			if("Excelsior")
				new /obj/effect/decal/cleanable/graffiti/graffiti_excelsior(target)
			if("Ironhammer")
				new /obj/effect/decal/cleanable/graffiti/graffiti_ironhammer(target)
			if("Moebius")
				new /obj/effect/decal/cleanable/graffiti/graffiti_moebius(target)
			if("Neotheology")
				new /obj/effect/decal/cleanable/graffiti/graffiti_neotheo(target)
			if("Technomancer")
				new /obj/effect/decal/cleanable/graffiti/graffiti_techno(target)
			if("Aster")
				new /obj/effect/decal/cleanable/graffiti/graffiti_aster(target)
			if("Ancap yes")
				new /obj/effect/decal/cleanable/graffiti/graffiti_ancapyes(target)
			if("Ancap no")
				new /obj/effect/decal/cleanable/graffiti/graffiti_ancapno(target)
		if(uses)
			uses--
		if(uses <= 0)
			playsound(loc, 'sound/effects/interaction/graffiti_empty.ogg', 100, 1)
			to_chat(user, SPAN_NOTICE("You have emptied the spray can."))
			icon_state = "spraypaint_empty"
			name = "empty spraycan"
			desc = "This spraycan is empty."
