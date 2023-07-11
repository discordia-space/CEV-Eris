/obj/item/spraypaint
	name = "spraycan"
	desc = "Aerosol paint sealed in a pressurized container."
	icon = 'icons/obj/items.dmi'
	icon_state = "spraypaint"
	matter = list(MATERIAL_PLASTIC = 4, MATERIAL_STEEL = 5)
	price_tag = 200
	var/uses = 30
	w_class = ITEM_SIZE_TINY
	throwforce = WEAPON_FORCE_HARMLESS

/obj/item/spraypaint/afterattack(atom/target, mob/user as mob, proximity)
	if(!proximity) return
	if(istype(target,/turf))
		var/graffititype = input("Choose what you'd like to paint") in list("Kot","Onestar","Doodle","Piss","Clown","Skull","Heart")
		if(uses <= 0)
			playsound(loc, 'sound/effects/interaction/graffiti_empty.ogg', 100, 1)
			to_chat(user, "<span class='notice'>The can is empty.</span>")
			return FALSE
		if(do_after(user, 3 SECONDS, target))
			playsound(loc, 'sound/effects/interaction/graffiti.ogg', 100, 1)
			to_chat(user, "<span class='notice'>You start tagging \the [target.name]!</span>")
		else
			to_chat(user, "<span class='notice'>You must stand still while tagging \the [target.name]!</span>")
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
		if(uses)
			uses--
		if(uses <= 0)
			playsound(loc, 'sound/effects/interaction/graffiti_empty.ogg', 100, 1)
			to_chat(user, "<span class='notice'>[src] is empty.</span>")
			icon_state = "spraypaint_empty"
			name = "empty spray can"
			desc = "this spray can is empty."
