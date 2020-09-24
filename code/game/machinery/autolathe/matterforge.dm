
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
    if(isnull(requested_amount) || requested_amount <=0 || requested_amount > 120)
        return
    stored_material[MATERIAL_COMPRESSED_MATTER] -= requested_amount

    var/obj/item/stack/material/compressed_matter/MS = new(drop_location())
    MS.amount = requested_amount
    MS.update_strings()
    MS.update_icon()

/obj/machinery/matter_nanoforge/attackby(obj/item/I, mob/user)
	if(power_source)
		eat(user, I)
		return
/obj/machinery/matter_nanoforge/proc/eat(mob/living/user, obj/item/eating)
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
					total_material *= stack.get_amount()
				total_material_gained[material] += total_material
				total_used += total_material
				mass_per_sheet += O.matter[material]
	for(var/material in total_material_gained)
		stored_material[MATERIAL_COMPRESSED_MATTER] += total_material_gained[material]

	if(istype(eating, /obj/item/stack))
		var/obj/item/stack/stack = eating
		var/used_sheets = min(stack.get_amount(), round(total_used/mass_per_sheet))

		to_chat(user, SPAN_NOTICE("You create [used_sheets] Compressed Matter from [stack.singular_name]\s in \the [src]."))

		if(!stack.use(used_sheets))
			qdel(stack)	// Protects against weirdness
	else
		to_chat(user, SPAN_NOTICE("You recycle \the [eating] in \the [src]."))
		qdel(eating)