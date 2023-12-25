//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:32

/obj/item/device/assembly/infra
	name = "infrared emitter"
	desc = "Emits a visible or invisible beam and is triggered when the beam is interrupted."
	icon_state = "infrared"
	origin_tech = list(TECH_MAGNET = 2)
	matter = list(MATERIAL_PLASTIC = 1)

	wires = WIRE_PULSE

	secured = FALSE

	var/on = FALSE
	var/visible = 0
	var/obj/effect/beam/i_beam/first = null


/obj/item/device/assembly/infra/activate()
	if(!..())
		return FALSE
	on = !on
	update_icon()
	return TRUE


/obj/item/device/assembly/infra/toggle_secure()
	secured = !secured
	if(secured)
		START_PROCESSING(SSobj, src)
	else
		on = FALSE
		if(first)	qdel(first)
		STOP_PROCESSING(SSobj, src)
	update_icon()
	return secured


/obj/item/device/assembly/infra/update_icon()
	overlays.Cut()
	attached_overlays = list()
	if(on)
		overlays += "infrared_on"
		attached_overlays += "infrared_on"

	if(holder)
		holder.update_icon()


/obj/item/device/assembly/infra/Process()//Old code
	if(!on)
		if(first)
			qdel(first)
			return

	if((!(first) && (secured && (istype(loc, /turf) || (holder && istype(holder.loc, /turf))))))
		var/obj/effect/beam/i_beam/I = new /obj/effect/beam/i_beam((holder ? holder.loc : loc) )
		I.master = src
		I.density = TRUE
		I.set_dir(dir)
		step(I, I.dir)
		if(I)
			I.density = FALSE
			first = I
			I.vis_spread(visible)
			spawn(0)
				if(I)
					I.limit = 8
					I.Process()



/obj/item/device/assembly/infra/attack_hand()
	qdel(first)
	..()


/obj/item/device/assembly/infra/Move(NewLoc, Dir = 0, step_x = 0, step_y = 0, glide_size_override = 0, initiator = src)
	var/t = dir
	. = ..()
	set_dir(t)
	qdel(first)


/obj/item/device/assembly/infra/holder_movement()
	if(!holder)
		return
	qdel(first)


/obj/item/device/assembly/infra/proc/trigger_beam()
	if((!secured)||(!on)||(cooldown > 0))	return 0
	pulse(0)
	if(!holder)
		visible_message("\icon[src] *beep* *beep*")
	cooldown = 2
	spawn(10)
		process_cooldown()
	return


/obj/item/device/assembly/infra/interact(mob/user as mob)//TODO: change this this to the wire control panel
	if(!secured)
		return
	user.set_machine(src)
	var/dat = {"<tt><b>Infrared Laser</b><br>
		<b>Status</b>: <a href='?src=\ref[src];state=[!on]'>[on ? "On" : "Off"]</a><br>
		<b>Visibility</b>: <a href='?src=\ref[src];visible=[!visible]'>[visible ? "Visible" : "Invisible"]</a><br></tt>
		<br><br><a href='?src=\ref[src];refresh=1'>Refresh</a>
		<br><br><a href='?src=\ref[src];close=1'>Close</a>
	"}
	user << browse(dat, "window=infra")
	onclose(user, "infra")


/obj/item/device/assembly/infra/Topic(href, href_list)
	if(..()) return 1
	if(!usr.canmove || usr.stat || usr.restrained() || !in_range(loc, usr))
		usr << browse(null, "window=infra")
		onclose(usr, "infra")
		return

	if(href_list["state"])
		on = !(on)
		update_icon()

	if(href_list["visible"])
		visible = !(visible)
		spawn(0)
			if(first)
				first.vis_spread(visible)

	if(href_list["close"])
		usr << browse(null, "window=infra")
		return

	if(usr)
		attack_self(usr)

	return


/obj/item/device/assembly/infra/verb/rotate()//This could likely be better
	set name = "Rotate Infrared Laser"
	set category = "Object"
	set src in usr

	set_dir(turn(dir, 90))
	return



/***************************IBeam*********************************/

/obj/effect/beam/i_beam
	name = "i beam"
	icon = 'icons/obj/projectiles.dmi'
	icon_state = "ibeam"
	var/obj/effect/beam/i_beam/next
	var/obj/item/device/assembly/infra/master
	var/limit
	var/visible = 0
	var/left
	anchored = TRUE


/obj/effect/beam/i_beam/proc/hit()
	if(master)
		master.trigger_beam()
	qdel(src)

/obj/effect/beam/i_beam/proc/vis_spread(v)
	visible = v
	spawn(0)
		if(next)
			next.vis_spread(v)


/obj/effect/beam/i_beam/Process()

	if((loc && loc.density) || !master)
		qdel(src)
		return

	if(left > 0)
		left--
	if(left < 1)
		if(!(visible))
			invisibility = 101
		else
			invisibility = 0
	else
		invisibility = 0


	var/obj/effect/beam/i_beam/I = new /obj/effect/beam/i_beam(loc)
	I.master = master
	I.density = TRUE
	I.set_dir(dir)
	step(I, I.dir)

	if(I)
		if(!(next))
			I.density = FALSE
			I.vis_spread(visible)
			next = I
			spawn(0)
				if((I && limit > 0))
					I.limit = limit - 1
					I.Process()
				return
		else
			qdel(I)
	else
		qdel(next)
	spawn(10)
		Process()

/obj/effect/beam/i_beam/Bump()
	qdel(src)

/obj/effect/beam/i_beam/Bumped()
	hit()

/obj/effect/beam/i_beam/Crossed(atom/movable/AM as mob|obj)
	if(istype(AM, /obj/effect/beam))
		return
	spawn(0)
		hit()

/obj/effect/beam/i_beam/Destroy()
	if(master.first == src)
		master.first = null
	if(next)
		qdel(next)
		next = null
	. = ..()
