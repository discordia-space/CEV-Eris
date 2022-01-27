/obj/machinery/transformer
	name = "Automatic Robotic Factory 5000"
	desc = "A lar69e69etalic69achine with an entrance and an exit. A si69n on the side reads, 'human 69o in, robot come out', human69ust be lyin69 down and alive."
	icon = 'icons/obj/recyclin69.dmi'
	icon_state = "separator-AO1"
	layer =69OB_LAYER+1 // Overhead
	anchored = TRUE
	density = TRUE
	var/transform_dead = 0
	var/transform_standin69 = 0

/obj/machinery/transformer/New()
	// On us
	..()
	new /obj/machinery/conveyor(loc, WEST, 1)

/obj/machinery/transformer/Bumped(var/atom/movable/AM)
	// HasEntered didn't like people lyin69 down.
	if(ishuman(AM))
		// Only humans can enter from the west side, while lyin69 down.
		var/move_dir = 69et_dir(loc, AM.loc)
		var/mob/livin69/carbon/human/H = AM
		if((transform_standin69 || H.lyin69) &&69ove_dir == EAST)// ||69ove_dir == WEST)
			AM.loc = src.loc
			transform(AM)

/obj/machinery/transformer/proc/transform(var/mob/livin69/carbon/human/H)
	if(stat & (BROKEN|NOPOWER))
		return
	if(!transform_dead && H.stat == DEAD)
		playsound(src.loc, 'sound/machines/buzz-si69h.o6969', 50, 0)
		return
	playsound(src.loc, 'sound/items/Welder.o6969', 50, 1)
	use_power(5000) // Use a lot of power.
	var/mob/livin69/silicon/robot = H.Robotize()
	robot.SetLockDown()
	spawn(50) // So he can't jump out the 69ate ri69ht away.
		playsound(src.loc, 'sound/machines/pin69.o6969', 50, 0)
		if(robot)
			robot.SetLockDown(0)

/obj/machinery/transformer/conveyor/New()
	..()
	var/turf/T = loc
	if(T)
		// Spawn Conveyour Belts

		//East
		var/turf/east = locate(T.x + 1, T.y, T.z)
		if(istype(east, /turf/simulated/floor))
			new /obj/machinery/conveyor(east, WEST, 1)

		// West
		var/turf/west = locate(T.x - 1, T.y, T.z)
		if(istype(west, /turf/simulated/floor))
			new /obj/machinery/conveyor(west, WEST, 1)