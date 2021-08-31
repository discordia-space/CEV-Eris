/obj/item/tool/tape_roll
	name = "duct tape"
	desc = "The technomancer's eternal friend. Fixes just about anything, for a while at least."
	icon = 'icons/obj/tools.dmi'
	icon_state = "taperoll"
	w_class = ITEM_SIZE_SMALL
	tool_qualities = list(QUALITY_ADHESIVE = 30, QUALITY_SEALING = 30)
	matter = list(MATERIAL_PLASTIC = 3)
	worksound = WORKSOUND_TAPE
	use_stock_cost = 0.15
	max_stock = 100
	degradation = 0 //its consumable anyway
	flags = NOBLUDGEON //Its not a weapon
	max_upgrades = 0 //These are consumable, so no wasting upgrades on them
	rarity_value = 4

/obj/item/tool/tape_roll/web
	name = "web tape"
	desc = "A strip of fabric covered in an all-natural adhesive. Holds things together with the power of thoughts and prayers."
	tool_qualities = list(QUALITY_ADHESIVE = 15, QUALITY_SEALING = 15)
	use_stock_cost = 0.17
	max_stock = 30
	alpha = 150
	rarity_value = 2
	spawn_tags = SPAWN_TAG_JUNKTOOL

/obj/item/tool/tape_roll/fiber
	name = "fiber tape"
	desc = "A roll of flexible adhesive polymer mesh, which sets as strong as welded steel."
	icon_state = "fiber_tape"
	tool_qualities = list(QUALITY_ADHESIVE = 50, QUALITY_SEALING = 50)
	matter = list(MATERIAL_PLASTIC = 20)
	use_stock_cost = 0.10
	max_stock = 100
	spawn_frequency = 8
	rarity_value = 24
	spawn_tags = SPAWN_TAG_TOOL_ADVANCED

/obj/item/tool/tape_roll/glue
	name = "superglue"
	desc = "A bucket of milky white fluid. Can be used to stick things together, but unlike tape, it cannot be used to seal things."
	icon = 'icons/obj/tools.dmi'
	icon_state = "glue"
	tool_qualities = list(QUALITY_ADHESIVE = 40, QUALITY_CAUTERIZING = 5) // Better than duct tape, but can't seal things and is mostly used in crafting - also, it's glue, so it can be used as an extremely shitty way of sealing wounds
	matter = list(MATERIAL_BIOMATTER = 30)
	worksound = NO_WORKSOUND

/obj/item/tool/tape_roll/attack(mob/living/carbon/human/H, mob/user)
	if(istype(H))
		if(user.targeted_organ == BP_EYES)

			if(!H.organs_by_name[BP_HEAD])
				to_chat(user, SPAN_WARNING("\The [H] doesn't have a head."))
				return
			if(!H.has_eyes())
				to_chat(user, SPAN_WARNING("\The [H] doesn't have any eyes."))
				return
			if(H.glasses)
				to_chat(user, SPAN_WARNING("\The [H] is already wearing somethign on their eyes."))
				return
			if(H.head && (H.head.body_parts_covered & FACE))
				to_chat(user, SPAN_WARNING("Remove their [H.head] first."))
				return
			user.visible_message(SPAN_DANGER("\The [user] begins taping over \the [H]'s eyes!"))

			if(!use_tool(user, H, 70, QUALITY_ADHESIVE))
				return

			// Repeat failure checks.
			if(!H || !src || !H.organs_by_name[BP_HEAD] || !H.has_eyes() || H.glasses || (H.head && (H.head.body_parts_covered & FACE)))
				return

			user.visible_message(SPAN_DANGER("\The [user] has taped up \the [H]'s eyes!"))
			H.equip_to_slot_or_del(new /obj/item/clothing/glasses/sunglasses/blindfold/tape(H), slot_glasses)

		else if(user.targeted_organ == BP_MOUTH || user.targeted_organ == BP_HEAD)
			if(!H.organs_by_name[BP_HEAD])
				to_chat(user, SPAN_WARNING("\The [H] doesn't have a head."))
				return
			if(!H.check_has_mouth())
				to_chat(user, SPAN_WARNING("\The [H] doesn't have a mouth."))
				return
			if(H.wear_mask)
				to_chat(user, SPAN_WARNING("\The [H] is already wearing a mask."))
				return
			if(H.head && (H.head.body_parts_covered & FACE))
				to_chat(user, SPAN_WARNING("Remove their [H.head] first."))
				return
			user.visible_message(SPAN_DANGER("\The [user] begins taping up \the [H]'s mouth!"))

			if(!use_tool(user, H, 70, QUALITY_ADHESIVE))
				return

			// Repeat failure checks.
			if(!H || !src || !H.organs_by_name[BP_HEAD] || !H.check_has_mouth() || H.wear_mask || (H.head && (H.head.body_parts_covered & FACE)))
				return

			user.visible_message(SPAN_DANGER("\The [user] has taped up \the [H]'s mouth!"))
			H.equip_to_slot_or_del(new /obj/item/clothing/mask/muzzle/tape(H), slot_wear_mask)

		else if(user.targeted_organ == BP_R_ARM || user.targeted_organ == BP_L_ARM)
			if(use_tool(user, H, 90, QUALITY_ADHESIVE))
				var/obj/item/handcuffs/cable/tape/T = new(user)
				if(!T.place_handcuffs(H, user))
					user.unEquip(T)
					qdel(T)
		else
			return ..()
		return 1

/obj/item/tool/tape_roll/stick(obj/item/target, mob/user)
	if (!istype(target) || target.anchored)
		return

	if (target.w_class > ITEM_SIZE_SMALL)
		to_chat(user, SPAN_WARNING("The [target] is too big to stick with tape!"))
		return
	if (istype(target.loc, /obj))
		return
	consume_resources(10, user)
	user.drop_from_inventory(target)
	var/obj/item/ducttape/tape = new(get_turf(src))
	tape.attach(target)
	user.put_in_hands(tape)
	return TRUE


/obj/item/ducttape
	name = "tape"
	desc = "A piece of sticky tape."
	icon = 'icons/obj/bureaucracy.dmi'
	icon_state = "tape"
	w_class = ITEM_SIZE_TINY
	layer = BELOW_MOB_LAYER
	anchored = TRUE //it's sticky, no you cant move it
	spawn_frequency = 0
	bad_type = /obj/item/ducttape

	var/obj/item/stuck

/obj/item/ducttape/New()
	..()
	flags |= NOBLUDGEON

/obj/item/ducttape/update_plane()
	..()
	update_icon()


/obj/item/ducttape/examine(mob/user)
	return stuck.examine(user)

/obj/item/ducttape/proc/attach(obj/item/W)
	stuck = W
	W.forceMove(src)
	update_icon()
	name = W.name + " (taped)"

/obj/item/ducttape/on_update_icon()
	if (!stuck)
		return

	if (istype(stuck, /obj/item/paper))
		icon_state = stuck.icon_state
		cut_overlays()
		set_overlays(stuck.overlays + "tape_overlay")
	else
		var/mutable_appearance/MA = new(stuck)
		MA.layer = layer-0.1
		MA.plane = plane
		MA.pixel_x = 0
		MA.pixel_y = 0
		underlays.Cut()
		underlays += MA

/obj/item/ducttape/attack_self(mob/user)
	if(!stuck)
		return

	to_chat(user, "You remove \the [initial(name)] from [stuck].")

	user.drop_from_inventory(src)
	stuck.forceMove(get_turf(src))
	user.put_in_hands(stuck)
	stuck = null
	set_overlays(null)
	qdel(src)

/obj/item/ducttape/afterattack(A, mob/user, flag, params)

	if(!in_range(user, A) || istype(A, /obj/machinery/door) || !stuck)
		return

	var/turf/target_turf = get_turf(A)
	var/turf/source_turf = get_turf(user)

	var/dir_offset = 0
	if(target_turf != source_turf)
		dir_offset = get_dir(source_turf, target_turf)
		if(!(dir_offset in cardinal))
			to_chat(user, "You cannot reach that from here.") // can only place stuck papers in cardinal directions, to
			return											  // reduce papers around corners issue.

	user.drop_from_inventory(src)
	forceMove(source_turf)

	if(params)
		var/list/mouse_control = params2list(params)
		if(mouse_control["icon-x"])
			pixel_x = text2num(mouse_control["icon-x"]) - 16
			if(dir_offset & EAST)
				pixel_x += 32
			else if(dir_offset & WEST)
				pixel_x -= 32
		if(mouse_control["icon-y"])
			pixel_y = text2num(mouse_control["icon-y"]) - 16
			if(dir_offset & NORTH)
				pixel_y += 32
			else if(dir_offset & SOUTH)
				pixel_y -= 32
