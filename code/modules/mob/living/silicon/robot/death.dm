/mob/living/silicon/robot/dust()
	//Delete the69MI first so that it won't go popping out.
	if(mmi)
		qdel(mmi)
	..()

/mob/living/silicon/robot/death(gibbed)
	if(camera)
		camera.status = 0
	if(module)
		for (var/obj/item/gripper/G in69odule)
			G.drop_item()
	remove_robot_verbs()

	..(gibbed,"shudders69iolently for a69oment, then becomes69otionless, its eyes slowly darkening.")
