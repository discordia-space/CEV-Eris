
/obj/machinery/matter_nanoforge
    name = "Matter NanoForge"
    desc = "It consumes items and produces compressed matter."
    icon = 'icons/obj/machines/autolathe.dmi'
    icon_state = "autolathe"
    density = TRUE
    anchored = TRUE
    layer = BELOW_OBJ_LAYER
    use_power = NO_POWER_USE
    var/list/stored_material = list()
    var/obj/power_source = null

/obj/machinery/matter_nanoforge/attack_hand(mob/user)
	if(..())
		return TRUE
	var/requested_amount = input(user, "How much Compressed Matter do you want to take out?", "Extracting Compressed Matter") as num|null
	if(isnull(requested_amount) || requested_amount <=0)
		return
	if(requested_amount > 120)
		to_chat(user, SPAN_WARNING("\The [src] can only deposit 120 Compressed Matter at a time."))
		return
	stored_material[MATERIAL_COMPRESSED_MATTER] -= requested_amount
	update_desc(stored_material[MATERIAL_COMPRESSED_MATTER])
	var/obj/item/stack/material/compressed_matter/MS = new(drop_location())
	MS.amount = requested_amount
	MS.update_strings()
	MS.update_icon()

/obj/machinery/matter_nanoforge/attackby(obj/item/I, mob/user)
	if(istype(I, /obj/item/weapon/oddity))
		var/obj/item/weapon/oddity/ps = I
		if(ps.oddity_stats[STAT_MEC]> 0)
			if(!power_source)
				user.drop_item(I)
				I.forceMove(src)
				power_source = ps

			else
				user.drop_item(I)
				I.forceMove(src)
				power_source.forceMove(loc)
				power_source = ps
			return

	if(power_source)
		eat(user, I)
		return
	else
		to_chat(user, SPAN_WARNING("\The [src] does not have any artifact powering it."))
/obj/machinery/matter_nanoforge/proc/eat(mob/living/user, obj/item/eating)
	var/used_sheets 
	if(!eating && istype(user))
		eating = user.get_active_hand()
	if(!istype(eating))
		return FALSE
	if(stat)
		return FALSE
	if(!Adjacent(user) && !Adjacent(eating))
		return FALSE
	if(!length(eating.get_matter()))
		to_chat(user, SPAN_WARNING("\The [eating] does not contain significant amounts of useful materials and cannot be accepted."))
		return FALSE
	var/total_used = 0     // Amount of material used.
	var/mass_per_sheet = 0 // Amount of material constituting one sheet.
	var/list/total_material_gained = list()
	for(var/obj/O in eating.GetAllContents(includeSelf = TRUE))
		var/list/_matter = O.get_matter()
		if(_matter)
			for(var/material in _matter)
				var/total_material = _matter[material]
				if(istype(O, /obj/item/stack))
					var/obj/item/stack/material/stack = O
					var/lst = matter_assoc_list()
					total_material *= stack.get_amount() * lst[stack.type]
				if(istype(O, /obj/item/stack/material/compressed_matter))
					to_chat(user, SPAN_NOTICE("You deposit [total_material] compressed matter into \the [src]."))
					stored_material[MATERIAL_COMPRESSED_MATTER] += total_material
					update_desc(stored_material[MATERIAL_COMPRESSED_MATTER])
					qdel(eating)
					return
				total_material_gained[material] += total_material
				total_used += total_material
				mass_per_sheet += O.matter[material]
	var/datum/component/artifact_power/artifact = power_source.GetComponent(/datum/component/artifact_power)
	for(var/material in total_material_gained)
		stored_material[MATERIAL_COMPRESSED_MATTER] += (artifact.power * total_material_gained[material])
		update_desc(stored_material[MATERIAL_COMPRESSED_MATTER])
		used_sheets = total_material_gained[material] * artifact.power
	if(istype(eating, /obj/item/stack))
		var/obj/item/stack/stack = eating

		to_chat(user, SPAN_NOTICE("You create [used_sheets] Compressed Matter from [stack.singular_name]\s in the [src]."))

		if(!stack.use(used_sheets))
			qdel(stack)	// Protects against weirdness
	else
		to_chat(user, SPAN_NOTICE("You recycle \the [eating] in \the [src]."))
		qdel(eating)
/obj/machinery/matter_nanoforge/proc/update_desc(var/stored_mats)
	desc = "It consumes items and produces compressed matter. It has [stored_mats] Compressed Matter stored."

/obj/machinery/matter_nanoforge/ex_act(severity)
	return 0

/obj/machinery/matter_nanoforge/bullet_act(obj/item/projectile/P, def_zone)
	return 0
/obj/machinery/matter_nanoforge/proc/matter_assoc_list()
	var/list/lst = new/list()
	lst[/obj/item/stack/material/iron] = 0.70
	lst[/obj/item/stack/material/glass] = 0.50
	lst[/obj/item/stack/material/steel] = 0.40
	lst[/obj/item/stack/material/glass/plasmaglass] = 0.70
	lst[/obj/item/stack/material/diamond] = 1
	lst[/obj/item/stack/material/plasma] = 0.60
	lst[/obj/item/stack/material/gold] = 0.70
	lst[/obj/item/stack/material/uranium] = 1
	lst[/obj/item/stack/material/silver] = 0.70
	lst[/obj/item/stack/material/plasteel] = 0.70
	lst[/obj/item/stack/material/plastic] = 0.50
	lst[/obj/item/stack/material/tritium] = 1
	lst[/obj/item/stack/material/osmium] = 1
	lst[/obj/item/stack/material/mhydrogen] = 1
	lst[/obj/item/stack/material/wood] = 0.20
	lst[/obj/item/stack/material/cloth] = 0.10
	lst[/obj/item/stack/material/cardboard] = 0.10
	lst[/obj/item/stack/material/glass/reinforced] = 0.55
	return lst