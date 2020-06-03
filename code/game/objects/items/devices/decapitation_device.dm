/obj/item/device/decapitation_device
	name = "decapitation device"
	desc = "Device that decapitates people."
	icon_state = "decapitation_device"
	throwforce = WEAPON_FORCE_HARMLESS
	w_class = ITEM_SIZE_NORMAL

	matter = list(MATERIAL_PLASTIC = 2, MATERIAL_GLASS = 1)
	origin_tech = list(TECH_BIO = 1)

	var/obj/item/weapon/cell/cell
	var/suitable_cell = /obj/item/weapon/cell/small
	var/charge_per_use = 25

/obj/item/device/decapitation_device/Initialize()
	. = ..()
	if(!cell && suitable_cell)
		cell = new suitable_cell(src)

/obj/item/device/decapitation_device/handle_atom_del(atom/A)
	..()
	if(A == cell)
		cell = null

/obj/item/device/decapitation_device/MouseDrop(over_object)
	if((src.loc == usr) && istype(over_object, /obj/screen/inventory/hand) && eject_item(cell, usr))
		cell = null
	else
		return ..()

/obj/item/device/decapitation_device/attackby(obj/item/C, mob/living/user)
	if(istype(C, suitable_cell) && !cell && insert_item(C, user))
		src.cell = C

/obj/item/device/decapitation_device/attack(mob/living/M, mob/living/user, target_zone)
	if(!user || !M)
		return

	if(!ishuman(M))
		to_chat(user, "You can only decapitate human beings.")
		return

	if(!cell || !cell.checked_use(charge_per_use))
		to_chat(user, "[src] battery is dead or missing.")
		return

	var/mob/living/carbon/human/H = M
	var/obj/item/organ/external/head_to_cut = H.organs_by_name["head"]

	if(!istype(head_to_cut, /obj/item/organ/external/head) || !head_to_cut)
		user.visible_message(
			SPAN_DANGER("[user] tried to decapitate [M] using [src.name], but found no head to cut."),
			SPAN_NOTICE("[M]'s body is already decapitated")
		)
		return

	M.attack_log += text("\[[time_stamp()]\] <font color='orange'>Has been decapitated (attempt) with [src.name] by [user.name] ([user.ckey])</font>")
	user.attack_log += text("\[[time_stamp()]\] <font color='red'>Attempted to decapitate [M.name] ([M.ckey]) with [src.name]</font>")
	msg_admin_attack("[user.name] ([user.ckey]) attempted to decapitate [M.name] ([M.ckey]) with [src.name] (<A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[user.x];Y=[user.y];Z=[user.z]'>JMP</a>)")

	M.visible_message(
		SPAN_DANGER("[user] tries to decapitate [M] with [src.name]!"),
		SPAN_DANGER("[user] tries to decapitate you with [src.name]!")
	)

	user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
	user.do_attack_animation(M)

	if(!do_after(user, 150, M))
		return

	head_to_cut.droplimb(TRUE, DROPLIMB_EDGE)

	user.visible_message(
		SPAN_DANGER("[user] successfully decapitates [M] with [src.name]!"),
		SPAN_DANGER("You successfully decapitate [M] with [src.name]!")
	)

	M.attack_log += text("\[[time_stamp()]\] <font color='orange'>Has been decapitated with [src.name] by [user.name] ([user.ckey])</font>")
	user.attack_log += text("\[[time_stamp()]\] <font color='red'>Decapitated [M.name] ([M.ckey]) with [src.name]</font>")
	msg_admin_attack("[user.name] ([user.ckey]) decapitated [M.name] ([M.ckey]) with [src.name] (<A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[user.x];Y=[user.y];Z=[user.z]'>JMP</a>)")