/obj/machinery/shaper
	name = "Shaper Device"
	desc = "A device used by Technomancers to rapidly build up entire sections of the ship. Uses a slurry of compressed matter guided by nanites to actually form the items it creates."
	var/max_stored_matter = 120
	var/stored_matter = 0
	var/list/stored_material = list()
	var/power_source = null

//This uses M56 code from Colonial Marines 13
/obj/item/device/shaper
	name = "\improper Shaper Device"
	desc = "A disassembled version of the Shaper Device, capable of being stored in a briefcase for ease of movement."
	w_class = SIZE_HUGE
	flags_equip_slot = SLOT_BACK
	icon = 'icons/turf/whiskeyoutpost.dmi'
	icon_state = "M56D_gun_e"
	var/stored_matter = 0

/obj/machinery/shaper/attackby(obj/item/W, mob/user)
	var/obj/item/stack/material/M = W
	if(istype(M) && M.material.name == MATERIAL_COMPRESSED)
		var/amount = min(M.get_amount(), round(max_stored_matter - stored_matter))
		if(M.use(amount) && stored_matter < max_stored_matter)
			stored_matter += amount
			playsound(src.loc, 'sound/machines/click.ogg', 50, 1)
			to_chat(user, "<span class='notice'>You load [amount] Compressed Matter into \the [src]</span>.")

/obj/machinery/shaper/connecttoglasses

/obj/item/device/m56d_gun/attack_self(mob/user)
	..()

	if(!ishuman(user))
		return
	if(user.z == GLOB.interior_manager.interior_z)
		to_chat(usr, SPAN_WARNING("It's too cramped in here to deploy \a [src]."))
		return
	var/turf/T = get_turf(usr)
	var/fail = FALSE
	if(T.density)
		fail = TRUE
	else
		for(var/obj/X in T.contents - src)
			if(X.density && !(X.flags_atom & ON_BORDER))
				fail = TRUE
				break
			if(istype(X, /obj/structure/machinery/defenses))
				fail = TRUE
				break
			else if(istype(X, /obj/structure/window))
				fail = TRUE
				break
			else if(istype(X, /obj/structure/windoor_assembly))
				fail = TRUE
				break
			else if(istype(X, /obj/structure/machinery/door))
				fail = TRUE
				break
	if(fail)
		to_chat(usr, SPAN_WARNING("You can't deploy \the [src] here, something is in the way."))
		return


	if(!do_after(user, 1 SECONDS, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD))
		return

	var/obj/structure/machinery/m56d_post/M = new /obj/structure/machinery/m56d_post(user.loc)
	M.setDir(user.dir) // Make sure we face the right direction
	M.gun_rounds = src.rounds //Inherit the amount of ammo we had.
	M.gun_mounted = TRUE
	M.anchored = TRUE
	M.update_icon()
	M.set_name_label(name_label)
	to_chat(user, SPAN_NOTICE("You deploy \the [src]."))
	qdel(src)

/obj/item/clothing/glasses/shaper
	name = "Optical Meson Scanner"
	desc = "Used for seeing walls, floors, and stuff through anything."
	icon_state = "meson"
	item_state = "glasses"


	action_button_name = "Test"
	action_button_proc = "togglebuildmode"

/obj/item/clothing/glasses/shaper/proc/toggleshapermode(mob/M)
	if(M.client)
		if(M.client.buildmode)
			log_admin("[key_name(usr)] has left build mode.")
			M.client.buildmode = 0
			M.client.show_popup_menus = 1
			for(var/obj/effect/bmode/buildholder/H)
				if(H.cl == M.client)
					qdel(H)
		else
			log_admin("[key_name(usr)] has entered build mode.")
			M.client.buildmode = 1
			M.client.show_popup_menus = 0

			var/obj/effect/bmode/buildholder/H = new/obj/effect/bmode/buildholder()
			var/obj/effect/bmode/builddir/A = new/obj/effect/bmode/builddir(H)
			A.master = H
			var/obj/effect/bmode/buildhelp/B = new/obj/effect/bmode/buildhelp(H)
			B.master = H
			var/obj/effect/bmode/buildmode/C = new/obj/effect/bmode/buildmode(H)
			C.master = H
			var/obj/effect/bmode/buildquit/D = new/obj/effect/bmode/buildquit(H)
			D.master = H

			H.builddir = A
			H.buildhelp = B
			H.buildmode = C
			H.buildquit = D
			M.client.screen += A
			M.client.screen += B
			M.client.screen += C
			M.client.screen += D
			H.cl = M.client