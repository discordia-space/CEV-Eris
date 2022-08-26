/obj/machinery/sleeper/sarcophagus
	name = "medi-sarcophagus"
	icon = 'icons/obj/machines/medisarcophagus.dmi'
	icon_state = "sarcophagus_0"
	desc = "A fancy bed with built-in injectors, a dialysis machine, and a limited health scanner. It looks like it needs to be pried open."
	spawn_tags = SPAWN_TAG_ABERRANT_MACHINERY
	spawn_frequency = 10
	rarity_value = 80
	var/horror_occupant = null
	var/mob_count = 1
	var/accompanying_loot = null

	// Internal
	var/preset_direction = FALSE

/obj/machinery/sleeper/sarcophagus/Initialize()
	. = ..()
	if(!preset_direction)
		set_dir(pick(NORTH, EAST, WEST))

	available_chemicals = list("inaprovaline2" = "Synth-Inaprovaline", "anti_toxin" = "Dylovene")

	if(prob(75))
		available_chemicals |= list("paracetamol" = "Paracetamol")
	if(prob(75))
		available_chemicals |= list("polystem" = "Polystem")

	if(prob(50))
		available_chemicals |= pick(list(list("bicaridine" = "Bicaridine"), list("oil" = "Bicaridone"), list("mold" = "Bicarizine")))
	if(prob(50))
		available_chemicals |= pick(list(list("dermaline" = "Dermaline"), list("oil" = "Dermazine"), list("mold" = "Dermalyne")))
	if(prob(50))
		available_chemicals |= pick(list(list("tramadol" = "Tramadol"), list("oil" = "Tramadone"), list("mold" = "Tramamol")))
	if(prob(50))
		available_chemicals |= pick(list(list("hyronalin" = "Hyronalin"), list("oil" = "Hyronaline"), list("mold" = "Hyronalyne")))

	if(prob(25))
		available_chemicals |= pick(list(list("oxycodone" = "Oxycodone"), list("oil" = "Oxycodol"), list("mold" = "Oxycodine")))

	if(prob(5))
		available_chemicals |= pick(list(list("meralyne" = "Meralyne"), list("oil" = "Meraline"), list("mold" = "Meradine")))
	if(prob(5))
		available_chemicals |= pick(list(list("rezadone" = "Rezadone"), list("oil" = "Rezadine"), list("mold" = "Rezaline")))

	if(prob(1))
		available_chemicals |= list("ossisine" = "Ossisine")
	if(prob(1))
		available_chemicals |= list("kyphotorin" = "Kyphotorin")

/obj/machinery/sleeper/sarcophagus/update_icon()
	var/is_occupied = horror_occupant || occupant ? 1 : 0
	icon_state = "sarcophagus_[num2text(is_occupied)]"
	set_light(1.4, is_occupied, COLOR_LIGHTING_RED_DARK)

/obj/machinery/sleeper/sarcophagus/go_in(mob/M, mob/user)
	if(horror_occupant)
		to_chat(user, SPAN_WARNING("\The [src] is already occupied."))
		return
	. = ..()

/obj/machinery/sleeper/sarcophagus/go_out()
	if(horror_occupant)
		desc = "A fancy bed with built-in injectors, a dialysis machine, and a limited health scanner."

		var/list/targets = get_mobs_or_objects_in_view(1, src, TRUE, FALSE)
		if(targets.len)
			for(var/atom/movable/target in targets)
				target.throw_at_random(FALSE, 3, 2)
				if(isliving(target))
					var/mob/living/L = target
					L.apply_damage(5, BRUTE)
					L.apply_damage(10, HALLOSS)

		for(var/count in 1 to mob_count)
			new horror_occupant(src.loc)

		if(accompanying_loot)
			new accompanying_loot(src.loc)

		horror_occupant = null
		accompanying_loot = null

		update_use_power(1)
		update_icon()
		toggle_filter()

		return
	. = ..()

/obj/machinery/sleeper/sarcophagus/attackby(obj/item/I, mob/user)
	if(..())
		return
	if(istool(I) && horror_occupant)
		var/obj/item/tool/T = I
		if(T.has_quality(QUALITY_PRYING))
			user.visible_message(SPAN_NOTICE("[user] starts opening the [src]. Something stirs within the [src]..."), SPAN_NOTICE("You start opening \the [src]. Something stirs within the [src]..."))
			if(!I.use_tool(user = user, target =  src, base_time = WORKTIME_NORMAL, required_quality = QUALITY_PRYING, fail_chance = FAILCHANCE_NORMAL, required_stat = STAT_ROB, forced_sound = WORKSOUND_EASY_CROWBAR))
				return
			go_out()

/obj/machinery/sleeper/sarcophagus/hive
	rarity_value = 60
	accompanying_loot = /obj/item/storage/freezer/medical/contains_teratomas

/obj/machinery/sleeper/sarcophagus/hive/Initialize()
	. = ..()
	horror_occupant = pick(subtypesof(/mob/living/simple_animal/hostile/hivemind))
	update_icon()

// To be placed on the map
/obj/machinery/sleeper/sarcophagus/random
	spawn_tags = null
	spawn_frequency = null
	rarity_value = null
	preset_direction = TRUE

/obj/machinery/sleeper/sarcophagus/random/Initialize()
	. = ..()
	if(prob(50))
		horror_occupant = pick(subtypesof(/mob/living/simple_animal/hostile/hivemind))
		accompanying_loot = /obj/item/storage/freezer/medical/contains_teratomas
	else
		horror_occupant = null
		desc = "A fancy bed with built-in injectors, a dialysis machine, and a limited health scanner."

	update_icon()
