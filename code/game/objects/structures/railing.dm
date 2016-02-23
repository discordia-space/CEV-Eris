/obj/structure/railing
	name = "railing"
	desc = "A railing."
	icon = 'icons/obj/railing.dmi'
	density = 1
	layer = 3.2//Just above doors
	//pressure_resistance = 4*ONE_ATMOSPHERE
	anchored = 1.0
	flags = ON_BORDER
	icon_state = "railing"
	layer = 4.1

/obj/structure/railing/CanPass(atom/movable/mover, turf/target, height=0, air_group=0)
	if(!mover)
		return 1

	if(istype(mover) && mover.checkpass(PASSTABLE))
		return 1
	if(get_dir(loc, target) == dir)
		return !density
	else
		return 1


/obj/structure/railing/CheckExit(atom/movable/O as mob|obj, target as turf)
	if(istype(O) && O.checkpass(PASSTABLE))
		return 1
	if(get_dir(O.loc, target) == dir)
		return 0
	return 1



/obj/structure/railing/corner
	desc = "A railing corner."
	icon_state = "railing-2corner"


/obj/structure/railing/corner/CanPass(atom/movable/mover, turf/target, height=0, air_group=0)
	if(!mover)
		return 1

	if(istype(mover) && mover.checkpass(PASSTABLE))
		return 1

	if(dir == EAST)
		if(mover.loc != src.loc)
			if((get_dir(loc, target) == WEST) || (get_dir(loc, target) == NORTH))
				return 1

	else if(dir == WEST)
		if(mover.loc != src.loc)
			if((get_dir(loc, target) == EAST) || (get_dir(loc, target) == NORTH))
				return 1

	else if(dir == NORTH)
		if(mover.loc != src.loc)
			if((get_dir(loc, target) == WEST) || (get_dir(loc, target) == SOUTH))
				return 1

	else if(dir == SOUTH)
		if(mover.loc != src.loc)
			if((get_dir(loc, target) == EAST) || (get_dir(loc, target) == SOUTH))
				return 1
	else
		return 0

/obj/structure/railing/corner/CheckExit(atom/movable/O as mob|obj, target as turf)
	if(istype(O) && O.checkpass(PASSTABLE))
		return 1

	if(dir == EAST)
		if(O.loc == src.loc)
			if(get_dir(loc, target) == SOUTH)
				return 0
			if((get_dir(loc, target) == WEST) || (get_dir(loc, target) == NORTH))
				return 1

	else if(dir == WEST)
		if(O.loc == src.loc)
			if(get_dir(loc, target) == SOUTH)
				return 0
			if((get_dir(loc, target) == EAST) || (get_dir(loc, target) == NORTH))
				return 1

	else if(dir == NORTH)
		if(O.loc == src.loc)
			if(get_dir(loc, target) == EAST)
				return 0
			if((get_dir(loc, target) == WEST) || (get_dir(loc, target) == SOUTH))
				return 1

	else if(dir == SOUTH)
		if(O.loc == src.loc)
			if(get_dir(loc, target) == WEST)
				return 0
			if((get_dir(loc, target) == EAST) || (get_dir(loc, target) == SOUTH))
				return 1

	if(get_dir(O.loc, target) == dir)
		return 0
	return 1



/obj/structure/railing/full
	icon_state = "railing-full"

/obj/structure/railing/full/CanPass(atom/movable/mover, turf/target, height=0, air_group=0)
	if(!mover)
		return 1

	if(istype(mover) && mover.checkpass(PASSTABLE))
		return 1
	else return 0


/obj/structure/railing/full/CheckExit(atom/movable/O as mob|obj, target as turf)
	if(istype(O) && O.checkpass(PASSTABLE))
		return 1
	else
		return 0


/obj/structure/railing/triple
	icon_state = "railing-3corner"


/obj/structure/railing/triple/CanPass(atom/movable/mover, turf/target, height=0, air_group=0)
	if(!mover)
		return 1

	if(istype(mover) && mover.checkpass(PASSTABLE))
		return 1
	if(dir == EAST)
		if(mover.loc != src.loc)
			if(get_dir(loc, target) == WEST)
				return 1

	else if(dir == WEST)
		if(mover.loc != src.loc)
			if(get_dir(loc, target) == EAST)
				return 1

	else if(dir == NORTH)
		if(mover.loc != src.loc)
			if(get_dir(loc, target) == SOUTH)
				return 1

	else if(dir == SOUTH)
		if(mover.loc != src.loc)
			if(get_dir(loc, target) == NORTH)
				return 1

	else
		return 0

/obj/structure/railing/triple/CheckExit(atom/movable/O as mob|obj, target as turf)
	if(istype(O) && O.checkpass(PASSTABLE))
		return 1

	if(dir == EAST)
		if(O.loc == src.loc)
			if((get_dir(loc, target) == SOUTH) || (get_dir(loc, target) == NORTH) || (get_dir(loc, target) == EAST))
				return 0
			if(get_dir(loc, target) == WEST)
				return 1

	else if(dir == WEST)
		if(O.loc == src.loc)
			if((get_dir(loc, target) == SOUTH) || (get_dir(loc, target) == NORTH) || (get_dir(loc, target) == WEST))
				return 0
			if(get_dir(loc, target) == EAST)
				return 1

	else if(dir == NORTH)
		if(O.loc == src.loc)
			if((get_dir(loc, target) == EAST) || (get_dir(loc, target) == NORTH) || (get_dir(loc, target) == WEST))
				return 0
			if(get_dir(loc, target) == SOUTH)
				return 1

	else if(dir == SOUTH)
		if(O.loc == src.loc)
			if((get_dir(loc, target) == EAST) || (get_dir(loc, target) == SOUTH) || (get_dir(loc, target) == WEST))
				return 0
			if(get_dir(loc, target) == NORTH)
				return 1

	if(get_dir(O.loc, target) == dir)
		return 0
	return 1



/obj/structure/railing/attack_hand(mob/user as mob)
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		if(H.a_intent == "disarm")
			if(prob(70))
				visible_message("<span class='notice'>[user] climbs on the [src].</span>")
				if(user.loc == src.loc)
					switch(dir)
						if(SOUTH)
							user.y--
						if(NORTH)
							user.y++
						if(WEST)
							user.x--
						if(EAST)
							user.x++
				else	H.loc = src.loc
					return 1
			else
				sleep(5)
				visible_message("<span class='warning'>[user] slipped off the edge of the [src].</span>")
				usr.weakened += 3

/*/obj/structure/railing/attackby(obj/item/weapon/W as obj,mob/user as mob) // Старый код, поотм пересмотреть.
	if (istype(W, /obj/item/weapon/grab) && get_dist(src,user)<2)
		var/obj/item/weapon/grab/G = W
		if(G.state<2)
			if(ishuman(G.affecting))
				G.affecting.attack_log += text("\[[time_stamp()]\] <font color='orange'>Has been smashed on a [src] by [G.assailant.name] ([G.assailant.ckey])</font>")
				G.assailant.attack_log += text("\[[time_stamp()]\] <font color='red'>Smashed [G.affecting.name] ([G.affecting.ckey]) on a [src].</font>")

				//log_admin("ATTACK: [G.assailant] ([G.assailant.ckey]) smashed [G.affecting] ([G.affecting.ckey]) on a table.", 2)
				message_admins("ATTACK: [G.assailant] ([G.assailant.ckey])(<A HREF='?_src_=holder;adminplayerobservejump=\ref[G]'>JMP</A>) smashed [G.affecting] ([G.affecting.ckey]) on a [src].", 2)
				log_attack("[G.assailant] ([G.assailant.ckey]) smashed [G.affecting] ([G.affecting.ckey]) on a [src].")

				var/mob/living/carbon/human/H = G.affecting
				var/datum/organ/external/affecting = H.get_organ("head")
				if(prob(25))
					add_blood(G.affecting, 1) //Forced
					affecting.take_damage(rand(10,15), 0)
					H.Weaken(2)
					if(prob(20)) // One chance in 20 to DENT THE TABLE
						affecting.take_damage(rand(5,10), 0) //Extra damage
					else if(prob(50))
						G.assailant.visible_message("\red [G.assailant] smashes \the [H]'s head on \the [src], [H.get_visible_gender() == MALE ? "his" : H.get_visible_gender() == FEMALE ? "her" : "their"] bone and cartilage making a loud crunch!",\
						"\red You smash \the [H]'s head on \the [src], [H.get_visible_gender() == MALE ? "his" : H.get_visible_gender() == FEMALE ? "her" : "their"] bone and cartilage making a loud crunch!",\
						"\red You hear the nauseating crunch of bone and gristle on solid metal, the noise echoing through the room.")
					else
						G.assailant.visible_message("\red [G.assailant] smashes \the [H]'s head on \the [src], [H.get_visible_gender() == MALE ? "his" : H.get_visible_gender() == FEMALE ? "her" : "their"] nose smashed and face bloodied!",\
						"\red You smash \the [H]'s head on \the [src], [H.get_visible_gender() == MALE ? "his" : H.get_visible_gender() == FEMALE ? "her" : "their"] nose smashed and face bloodied!",\
						"\red You hear the nauseating crunch of bone and gristle on solid metal and the gurgling gasp of someone who is trying to breathe through their own blood.")
				else
					affecting.take_damage(rand(5,10), 0)
					G.assailant.visible_message("\red [G.assailant] smashes \the [H]'s head on \the [src]!",\
					"\red You smash \the [H]'s head on \the [src]!",\
					"\red You hear the nauseating crunch of bone and gristle on solid metal.")
				H.UpdateDamageIcon()
				H.updatehealth()
				playsound(src.loc, 'sound/weapons/tablehit1.ogg', 50, 1, -3)
			return
		if(!G.affecting.buckled)
			G.affecting.loc = src.loc
			G.affecting.Weaken(5)
			for(var/mob/O in viewers(world.view, src))
				if (O.client)
					O << "\red [G.assailant] puts [G.affecting] on the [src]."
			del(W)
		return
	return*/

/obj/structure/railing/attackby(obj/item/W as obj, mob/user as mob) // Это спижено у стола данного билда
	if (!W) return

	// Handle harm intent grabbing/tabling.
	if(istype(W, /obj/item/weapon/grab) && get_dist(src,user)<2)
		var/obj/item/weapon/grab/G = W
		if (istype(G.affecting, /mob/living))
			var/mob/living/M = G.affecting
			var/obj/occupied = turf_is_crowded()
			if(occupied)
				user << "<span class='danger'>There's \a [occupied] in the way.</span>"
				return
			if (G.state < 2)
				if(user.a_intent == I_HURT)
					if (prob(15))	M.Weaken(5)
					M.apply_damage(8,def_zone = "head")
					visible_message("<span class='danger'>[G.assailant] slams [G.affecting]'s face against \the [src]!</span>")
					playsound(loc, 'sound/weapons/tablehit1.ogg', 50, 1)
					/*var/list/L = take_damage(rand(1,5))
					// Shards. Extra damage, plus potentially the fact YOU LITERALLY HAVE A PIECE OF GLASS/METAL/WHATEVER IN YOUR FACE
					for(var/obj/item/weapon/material/shard/S in L)
						if(prob(50))
							M.visible_message("<span class='danger'>\The [S] slices [M]'s face messily!</span>",
							                   "<span class='danger'>\The [S] slices your face messily!</span>")
							M.apply_damage(10, def_zone = "head")
							if(prob(2))
								M.embed(S, def_zone = "head")*/
				else
					user << "<span class='danger'>You need a better grip to do that!</span>"
					return
			else
				G.affecting.loc = src.loc
				G.affecting.Weaken(5)
				visible_message("<span class='danger'>[G.assailant] puts [G.affecting] on \the [src].</span>")
			qdel(W)
			return

	// Handle dismantling or placing things on the table from here on.
	if(isrobot(user))
		return

	if(W.loc != user) // This should stop mounted modules ending up outside the module.
		return

	if(istype(W, /obj/item/weapon/melee/energy/blade))
		var/datum/effect/effect/system/spark_spread/spark_system = new /datum/effect/effect/system/spark_spread()
		spark_system.set_up(5, 0, src.loc)
		spark_system.start()
		playsound(src.loc, 'sound/weapons/blade1.ogg', 50, 1)
		playsound(src.loc, "sparks", 50, 1)
		user.visible_message("<span class='danger'>\The [src] was sliced apart by [user]!</span>")
		//break_to_parts()
		return

	user.drop_item(src.loc)
	return


/obj/structure/railing/ex_act(severity)
	switch(severity)
		if(1.0)
			qdel(src)
			return
		if(2.0)
			qdel(src)
			return
		if(3.0)
			qdel(src)
			return
		else
	return

/obj/structure/railing/fake
	icon_state = "railing-1corner"
	CanPass(atom/movable/mover, turf/target, height=0, air_group=0)
		return 1
	CheckExit(atom/movable/O as mob|obj, target as turf)
		return 1