

/obj/machinery/multistructure/bioreactor_part/capsule
	name = "capsule"
	icon = 'icons/obj/machines/bioreactor.dmi'
	icon_state = "capsule_3"
	flags = ON_BORDER
	density = FALSE
	layer = LOW_OBJ_LAYER
	var/list/blocked_dirs = list(SOUTH, NORTH, WEST)



/obj/machinery/multistructure/bioreactor_part/capsule/Initialize()
	. = ..()
	update_blocked_dirs()


/obj/machinery/multistructure/bioreactor_part/capsule/is_block_dir(target_dir, border_only, atom/target)
	if(!target_dir in blocked_dirs)
		return TRUE
	return ..()


/obj/machinery/multistructure/bioreactor_part/capsule/CheckExit(atom/movable/O as mob|obj, target as turf)
	if(get_dir(O.loc, target) in blocked_dirs)
		return FALSE
	return TRUE


/obj/machinery/multistructure/bioreactor_part/capsule/CanPass(atom/movable/mover, turf/target, height=0, air_group=0)
	if(!mover)
		return TRUE

	if(get_dir(loc, target) in blocked_dirs)
		return FALSE
	else
		return TRUE



/obj/machinery/multistructure/bioreactor_part/capsule/proc/take_obj(atom/movable/target)
	if(istype(target))
		target.forceMove(src.loc)


/obj/machinery/multistructure/bioreactor_part/capsule/Process()
	if(!MS)
		return
	for(var/atom/movable/M in loc)
		if(isliving(M))
			var/mob/living/victim = M
			if(issilicon(victim) || victim.mob_classification == CLASSIFICATION_SYNTHETIC)
				victim.forceMove(MS_bioreactor.misc_output)
				continue
			victim.apply_damage(5, CLONE)
			if(victim.getCloneLoss() >= victim.maxHealth*2)
				MS_bioreactor.biotank.take_amount(victim.mob_size*5)
				consume(victim)
			continue

		if(istype(M, /obj/item))
			var/obj/item/target = M
			if(MATERIAL_BIOMATTER in target.matter)
				target.alpha -= round(100 / target.w_class)
				if(target.alpha <= 50)
					MS_bioreactor.biotank.take_amount(target.matter[MATERIAL_BIOMATTER])
					target.matter -= MATERIAL_BIOMATTER
					//if we have other matter, let's spit it out
					for(var/material in target.matter)
						world << material
						var/stack_type = material_stack_type(material_display_name(material))
						if(stack_type)
							var/obj/item/stack/material/waste = new stack_type(MS_bioreactor.misc_output)
							waste.amount = target.matter[material]
							waste.update_strings()
						target.matter -= material
					consume(target)
			else
				target.forceMove(MS_bioreactor.misc_output)


/obj/machinery/multistructure/bioreactor_part/capsule/proc/consume(atom/movable/object)
	if(ishuman(object))
		var/mob/living/carbon/human/H = object
		for(var/obj/item/item in H.contents)
			//non robotic limbs will be consumed
			if(istype(item, /obj/item/organ))
				var/obj/item/organ/organ = item
				if(istype(organ, /obj/item/organ/external) && !organ.robotic)
					continue
				organ.removed()
				organ.forceMove(loc)
				continue
			H.drop_from_inventory(item)
	qdel(object)


/obj/machinery/multistructure/bioreactor_part/capsule/proc/update_blocked_dirs()
	blocked_dirs = list()
	var/corner_dir = 0		//used at sprite determination, direction point to center of whole bioreactor capsule
	for(var/direction in cardinal)
		if(!locate(type) in get_step(src, direction))
			blocked_dirs += direction
		else
			corner_dir += direction
	if(corner_dir)
		icon_state = "capsule_[corner_dir]"