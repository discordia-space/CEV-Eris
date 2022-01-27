/obj/effect/decal/cleanable/crayon
	name = "rune"
	desc = "A rune drawn in crayon."
	icon = 'icons/obj/rune.dmi'
	layer = TURF_DECAL_LAYER
	anchored = TRUE
	random_rotation = 0

	New(location,main = "#FFFFFF",shade = "#000000",var/type = "graffiti")
		..()
		loc = location

		name = type
		desc = "A 69type69 drawn in crayon."

		switch(type)
			if("rune")
				type = "rune69rand(1,6)69"
			if("graffiti")
				type = pick("amyjon","face","matt","revolution","engie","guy","end","dwarf","uboa")

		var/icon/mainOverlay = new/icon('icons/effects/crayondecal.dmi',"69type69",2.1)
		var/icon/shadeOverlay = new/icon('icons/effects/crayondecal.dmi',"69type69s",2.1)

		mainOverlay.Blend(main,ICON_ADD)
		shadeOverlay.Blend(shade,ICON_ADD)

		overlays +=69ainOverlay
		overlays += shadeOverlay

		add_hiddenprint(usr)
