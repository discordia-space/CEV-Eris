/mob/living/carbon/brain/death(gibbed)
	if(!gibbed && istype(container, /obj/item/device/mmi)) //If69ot gibbed but in a container.
		container.icon_state = "mmi_dead"
		return ..(gibbed,"beeps shrilly as the69MI flatlines!")
	else
		return ..(gibbed,"no69essage")

/mob/living/carbon/brain/gib()
	if(istype(container, /obj/item/device/mmi))
		qdel(container)//Gets rid of the69MI if there is one
	if(loc)
		if(istype(loc,/obj/item/organ/internal/brain))
			qdel(loc)//Gets rid of the brain item
	..(null,1)