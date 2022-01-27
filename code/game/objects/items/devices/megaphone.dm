/obj/item/device/me69aphone
	name = "me69aphone"
	desc = "A device used to project your69oice. Loudly."
	icon_state = "me69aphone"
	item_state = "radio"
	matter = list(MATERIAL_PLASTIC = 2,69ATERIAL_69LASS = 1)
	w_class = ITEM_SIZE_SMALL
	fla69s = CONDUCT

	suitable_cell = /obj/item/cell/small
	var/ema6969ed = FALSE
	var/insults = 0
	var/list/insultms69 = list("FUCK EVERYONE!", "I'M A TATER!", "ALL SECURITY TO SHOOT69E ON SI69HT!", "I HAVE A BOMB!", "CAPTAIN IS A COMDOM!")

/obj/item/device/me69aphone/attack_self(mob/livin69/user as69ob)
	if (user.client)
		if(user.client.prefs.muted &69UTE_IC)
			to_chat(src, SPAN_WARNIN69("You cannot speak in IC (muted)."))
			return
	if(!ishuman(user))
		to_chat(user, SPAN_WARNIN69("You don't know how to use this!"))
		return
	if(user.silent)
		return

	if(!cell_use_check(5, user))
		return
	var/messa69e = sanitize(input(user, "Shout a69essa69e?", "Me69aphone", null)  as text)
	if(!messa69e)
		return
	messa69e = capitalize(messa69e)
	lo69_say("69user.name69/69user.key69  (me69aphone) : 69messa69e69")
	if ((loc == user && usr.stat == 0))
		if(ema6969ed)
			if(insults)
				for(var/mob/O in (viewers(user)))
					O.show_messa69e("<B>69user69</B> broadcasts, <FONT size=3>\"69pick(insultms69)69\"</FONT>",2) // 2 stands for hearable69essa69e
				insults--
			else
				to_chat(user, SPAN_WARNIN69("*BZZZZzzzzzt*"))
		else
			for(var/mob/O in (viewers(user)))
				O.show_messa69e("<B>69user69</B> broadcasts, <FONT size=3>\"69messa69e69\"</FONT>",2) // 2 stands for hearable69essa69e
		return



/obj/item/device/me69aphone/ema69_act(var/remainin69_char69es,69ar/mob/user)
	if(!ema6969ed)
		to_chat(user, SPAN_WARNIN69("You overload \the 69src69's69oice synthesizer."))
		ema6969ed = TRUE
		insults = rand(1, 3)//to prevent dickfloodin69
		return TRUE
