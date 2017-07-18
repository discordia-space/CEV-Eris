/obj/item/device/megaphone
	name = "megaphone"
	desc = "A device used to project your voice. Loudly."
	icon_state = "megaphone"
	item_state = "radio"
	w_class = 2.0
	flags = CONDUCT

	var/obj/item/weapon/cell/cell = null
	var/suitable_cell = /obj/item/weapon/cell/small
	var/emagged = 0
	var/insults = 0
	var/list/insultmsg = list("FUCK EVERYONE!", "I'M A TATER!", "ALL SECURITY TO SHOOT ME ON SIGHT!", "I HAVE A BOMB!", "CAPTAIN IS A COMDOM!")

/obj/item/device/megaphone/New()
	..()
	if(!cell && suitable_cell)
		cell = new suitable_cell(src)

/obj/item/device/megaphone/attack_self(mob/living/user as mob)
	if (user.client)
		if(user.client.prefs.muted & MUTE_IC)
			src << "<span class='warning'>You cannot speak in IC (muted).</span>"
			return
	if(!ishuman(user))
		user << "<span class='warning'>You don't know how to use this!</span>"
		return
	if(user.silent)
		return

	var/message = sanitize(input(user, "Shout a message?", "Megaphone", null)  as text)
	if(!message)
		return
	if(cell && cell.checked_use(5))
		message = capitalize(message)
		log_say("[user.name]/[user.key]  (megaphone) : [message]")
		if ((src.loc == user && usr.stat == 0))
			if(emagged)
				if(insults)
					for(var/mob/O in (viewers(user)))
						O.show_message("<B>[user]</B> broadcasts, <FONT size=3>\"[pick(insultmsg)]\"</FONT>",2) // 2 stands for hearable message
					insults--
				else
					user << "<span class='warning'>*BZZZZzzzzzt*</span>"
			else
				for(var/mob/O in (viewers(user)))
					O.show_message("<B>[user]</B> broadcasts, <FONT size=3>\"[message]\"</FONT>",2) // 2 stands for hearable message
			return
	else
		user << "<span class='warning'>[src] battery is dead or missing</span>"

/obj/item/device/megaphone/MouseDrop(over_object)
	if((src.loc == usr) && istype(over_object, /obj/screen/inventory/hand) && eject_item(cell, usr))
		cell = null

/obj/item/device/megaphone/attackby(obj/item/C, mob/living/user)
	if(istype(C, suitable_cell) && !cell && insert_item(C, user))
		cell = C

/obj/item/device/megaphone/emag_act(var/remaining_charges, var/mob/user)
	if(!emagged)
		user << "<span class='warning'>You overload \the [src]'s voice synthesizer.</span>"
		emagged = 1
		insults = rand(1, 3)//to prevent dickflooding
		return 1
