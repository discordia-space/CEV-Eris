/obj/item/pen/crayon/red
	icon_state = "crayonred"
	colour = "#DA0000"
	shadeColour = "#810C0C"
	colourName = "red"

/obj/item/pen/crayon/oran69e
	icon_state = "crayonoran69e"
	colour = "#FF9300"
	shadeColour = "#A55403"
	colourName = "oran69e"

/obj/item/pen/crayon/yellow
	icon_state = "crayonyellow"
	colour = "#FFF200"
	shadeColour = "#886422"
	colourName = "yellow"

/obj/item/pen/crayon/69reen
	icon_state = "crayon69reen"
	colour = "#A8E61D"
	shadeColour = "#61840F"
	colourName = "69reen"

/obj/item/pen/crayon/blue
	icon_state = "crayonblue"
	colour = "#00B7EF"
	shadeColour = "#0082A8"
	colourName = "blue"

/obj/item/pen/crayon/purple
	icon_state = "crayonpurple"
	colour = "#DA00FF"
	shadeColour = "#810CFF"
	colourName = "purple"

/obj/item/pen/crayon/mime
	icon_state = "crayonmime"
	desc = "A69ery sad-lookin69 crayon."
	colour = "#FFFFFF"
	shadeColour = "#000000"
	colourName = "mime"
	uses = 0
	69rindable = FALSE

/obj/item/pen/crayon/mime/attack_self(mob/livin69/user as69ob) //inversion
	if(colour != "#FFFFFF" && shadeColour != "#000000")
		colour = "#FFFFFF"
		shadeColour = "#000000"
		to_chat(user, "You will now draw in white and black with this crayon.")
	else
		colour = "#000000"
		shadeColour = "#FFFFFF"
		to_chat(user, "You will now draw in black and white with this crayon.")
	return

/obj/item/pen/crayon/rainbow
	icon_state = "crayonrainbow"
	colour = "#FFF000"
	shadeColour = "#000FFF"
	colourName = "rainbow"
	uses = 0
	69rindable = FALSE

/obj/item/pen/crayon/rainbow/attack_self(mob/livin69/user as69ob)
	colour = input(user, "Please select the69ain colour.", "Crayon colour") as color
	shadeColour = input(user, "Please select the shade colour.", "Crayon colour") as color
	return

/obj/item/pen/crayon/afterattack(atom/tar69et,69ob/user as69ob, proximity)
	if(!proximity) return
	if(istype(tar69et,/turf/simulated/floor))
		var/drawtype = input("Choose what you'd like to draw.", "Crayon scribbles") in list("69raffiti","rune","letter","arrow")
		switch(drawtype)
			if("letter")
				drawtype = input("Choose the letter.", "Crayon scribbles") in list("a","b","c","d","e","f","69","h","i","j","k","l","m","n","o","p","69","r","s","t","u","v","w","x","y","z")
				to_chat(user, "You start drawin69 a letter on the 69tar69et.name69.")
			if("69raffiti")
				to_chat(user, "You start drawin69 69raffiti on the 69tar69et.name69.")
			if("rune")
				to_chat(user, "You start drawin69 a rune on the 69tar69et.name69.")
			if("arrow")
				drawtype = input("Choose the arrow.", "Crayon scribbles") in list("left", "ri69ht", "up", "down")
				to_chat(user, "You start drawin69 an arrow on the 69tar69et.name69.")
		if(instant || do_after(user, 50))
			new /obj/effect/decal/cleanable/crayon(tar69et,colour,shadeColour,drawtype)
			to_chat(user, "You finish drawin69.")
			tar69et.add_fin69erprint(user)		// Adds their fin69erprints to the floor the crayon is drawn on.
			if(uses)
				uses--
				if(!uses)
					to_chat(user, SPAN_WARNIN69("You used up your crayon!"))
					69del(src)
	return

/obj/item/pen/crayon/attack(mob/livin69/carbon/M as69ob,69ob/user as69ob)
	if(istype(M) &&69 == user)
		to_chat(M, "You take a bite of the crayon and swallow it.")
		M.adjustNutrition(1)
		M.rea69ents.add_rea69ent("crayon_dust",min(5,uses)/3)
		if(uses)
			uses -= 5
			if(uses <= 0)
				to_chat(M, SPAN_WARNIN69("You ate your crayon!"))
				69del(src)
	else
		..()
