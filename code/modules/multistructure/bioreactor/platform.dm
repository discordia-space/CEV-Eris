

/obj/machinery/multistructure/bioreactor_part/platform
	name = "bioreactor platform"
	icon = 'icons/obj/machines/bioreactor.dmi'
	icon_state = "platform_5"
	density = FALSE
	layer = LOW_OBJ_LAYER


/obj/machinery/multistructure/bioreactor_part/platform/Initialize()
	. = ..()
	update_icon()


/obj/machinery/multistructure/bioreactor_part/platform/Process()
	if(!MS)
		return
	if((!is_breached() || MS_bioreactor.is_operational()) && MS_bioreactor.chamber_solution)
		for(var/atom/movable/M in loc)
			if(isliving(M))
				var/mob/living/victim = M
				if((issilicon(victim) || victim.mob_classification == CLASSIFICATION_SYNTHETIC) && victim.mob_size <= MOB_SMALL)
					victim.forceMove(MS_bioreactor.misc_output)
					continue
				var/hazard_protection = victim.run_armor_check(null, "bio", silent = TRUE)
				if(!hazard_protection)
					victim.apply_damage(5, CLONE)
					if(victim.health >= victim.maxHealth*2)
						MS_bioreactor.biotank_platform.take_amount(victim.mob_size*5)
						MS_bioreactor.biotank_platform.pipes_wearout(victim.mob_size/5, forced = TRUE)
						consume(victim)
					continue

			if(istype(M, /obj/item))
				if(M.anchored)
					continue
				var/obj/item/target = M
				if(MATERIAL_BIOMATTER in target.matter)
					target.alpha -= round(100 / target.w_class)
					var/icon/I = new(target.icon, icon_state = target.icon_state)
					I.Turn(rand(-10, 10))
					target.icon = I
					if(target.alpha <= 50)
						MS_bioreactor.biotank_platform.take_amount(target.matter[MATERIAL_BIOMATTER])
						MS_bioreactor.biotank_platform.pipes_wearout(target.w_class)
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
					spawn(5)
						I.Turn(rand(-5, 5))
				else
					target.forceMove(MS_bioreactor.misc_output)
	else
		if(MS_bioreactor.chamber_solution)
			MS_bioreactor.pump_solution()


/obj/machinery/multistructure/bioreactor_part/platform/proc/consume(atom/movable/object)
	if(ishuman(object))
		var/mob/living/carbon/human/H = object
		for(var/obj/item/item in H.contents)
			world << item
			//non robotic limbs will be consumed
			if(istype(item, /obj/item/organ))
				var/obj/item/organ/organ = item
				if(istype(organ, /obj/item/organ/external) && !organ.robotic)
					continue
				//this should make a lil smooth spreading with moving animation
				for(var/obj/machinery/multistructure/bioreactor_part/platform/P in MS_bioreactor.platforms)
					organ.forceMove(H.loc)
				organ.removed()
				continue
			H.drop_from_inventory(item)
	qdel(object)
	for(var/obj/structure/window/reinforced/bioreactor/glass in loc)
		if(glass.dir != MS_bioreactor.platform_enter_side)
			glass.apply_dirt(1)


/obj/machinery/multistructure/bioreactor_part/platform/update_icon()
	var/corner_dir = 0		//used at sprite determination, direction point to center of whole bioreactor platform
	for(var/direction in cardinal)
		if(locate(type) in get_step(src, direction))
			corner_dir += direction
	if(corner_dir in list(9, 6, 5, 10))
		icon_state = "platform_[corner_dir]"


/obj/machinery/multistructure/bioreactor_part/platform/proc/get_opened_dirs()
	var/list/open_dirs = list()
	for(var/direction in cardinal)
		if(!locate(type) in get_step(src, direction))
			open_dirs += direction
	return open_dirs


/obj/machinery/multistructure/bioreactor_part/platform/proc/make_windows()
	var/list/open_dirs = get_opened_dirs()
	for(var/direction in open_dirs)
		for(var/obj/structure/window/reinforced/bioreactor/exist_glass in loc)
			if(exist_glass.dir == direction)
				open_dirs -= exist_glass.dir
				continue
	for(var/remaining_dir in open_dirs)
		var/obj/structure/window/reinforced/bioreactor/glass = new(loc)
		apply_window(glass, remaining_dir)


/obj/machinery/multistructure/bioreactor_part/platform/proc/apply_window(obj/structure/window/reinforced/glass, var/direction)
	if(MS_bioreactor.platform_enter_side == direction)
		glass.basestate = "platform_door"
		glass.icon_state = "platform_door"
	else
		glass.basestate = "[icon_state]-glass_[direction]"
		glass.icon_state = "[icon_state]-glass_[direction]"
	glass.dir = direction
	glass.update_icon()


/obj/machinery/multistructure/bioreactor_part/platform/proc/is_breached()
	var/list/glass_dirs = get_opened_dirs()
	for(var/obj/structure/window/reinforced/glass in loc)
		if(glass.dir in glass_dirs)
			glass_dirs -= glass.dir
	if(glass_dirs.len)
		MS_bioreactor.chamber_breached = TRUE
		return TRUE
	MS_bioreactor.chamber_breached = FALSE
	return FALSE



/obj/structure/window/reinforced/bioreactor
	name = "bioreactor glass"
	icon = 'icons/obj/machines/bioreactor.dmi'
	var/dirty_level = 0
	var/max_dirty_lvl = 5


/obj/structure/window/reinforced/bioreactor/examine(mob/user)
	..()
	switch(dirty_level)
		if(1)
			to_chat(user, SPAN_NOTICE("There are a few stains on it. Except this, [src] looks pretty clean."))
		if(2)
			to_chat(user, SPAN_NOTICE("You see a signs of biomatter on this [src]. Better to clean it up."))
		if(3)
			to_chat(user, SPAN_WARNING("This [src] wear a clear signs and stains of biomatter."))
		if(4)
			to_chat(user, SPAN_WARNING("You see a high amount of biomatter on this [src]. It's dirty as hell."))
		if(5)
			to_chat(user, SPAN_WARNING("Now it's hard to see what inside. Better to clean this [src]."))
		else
			to_chat(user, SPAN_NOTICE("This [src] so clean, that you can see your reflection. Is that something green at your teeth?"))


/obj/structure/window/reinforced/bioreactor/update_icon()
	overlays.Cut()
	..()
	if(dirty_level)
		var/biomass_alpha = min((50*dirty_level), 255)
		var/icon/default = new /icon(icon, icon_state)
		var/icon/biomass = new /icon('icons/obj/machines/bioreactor.dmi', "glass_biomass")
		biomass.Turn(-40, 40)
		biomass.Blend(rgb(0, 0, 0, biomass_alpha))
		default.Blend(biomass, ICON_MULTIPLY)
		overlays += default


/obj/structure/window/reinforced/bioreactor/proc/apply_dirt(var/amount)
	dirty_level += amount
	if(dirty_level >= max_dirty_lvl)
		dirty_level = 5
		opacity = FALSE
	if(dirty_level <= 0)
		dirty_level = 0
		opacity = TRUE
	update_icon()


/obj/structure/window/reinforced/bioreactor/attackby(var/obj/item/I, var/mob/user)
	if(istype(I, /obj/item/weapon/mop) || istype(I, /obj/item/weapon/soap))
		if(user.loc != loc)
			to_chat(user, SPAN_WARNING("You need to come inside to clean it."))
			return
		to_chat(user, SPAN_NOTICE("You begin cleaning [src] with your [I]..."))
		if(do_after(user, CLEANING_TIME * dirty_level, src))
			to_chat(user, SPAN_NOTICE("You cleaned [src]."))
			toxin_attack(user, 5*dirty_level)
			apply_dirt(-dirty_level)
			if(dirty_level >= 4)
				spill_biomass(user, cardinal)
		else
			to_chat(user, SPAN_WARNING("You need to stand still to clean it properly."))
	else
		..()


/obj/structure/window/reinforced/bioreactor/MouseDrop_T(mob/victim, mob/user as mob)
	var/base_chance = 70
	if(victim == user)
		to_chat(user, SPAN_NOTICE("You trying to climb out of [src]..."))
		if(do_after(user, 3 SECONDS, src))
			if(prob(base_chance - 10*dirty_level))
				to_chat(user, SPAN_NOTICE("You successfuly climbed on [src]."))
				user.forceMove(get_step(src, user.dir))
			else
				to_chat(user, SPAN_WARNING("You tried to climb on [src], but slipped!"))
				user.Weaken(1)
	else
		to_chat(user, SPAN_NOTICE("You trying to push [victim] through [src]..."))
		to_chat(victim, SPAN_WARNING("[user] is trying to push you through [src]!"))
		if(do_after(user, 3 SECONDS, src))
			victim.visible_message(SPAN_WARNING("[victim] pushed through [src]!"))
			victim.forceMove(get_step(src, user.dir))