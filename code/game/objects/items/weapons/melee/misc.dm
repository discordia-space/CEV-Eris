/obj/item/melee/toolbox_maul
	name = "toolmop the69aul"
	desc = "Toolbox tied to69op. A weapon of choice."
	icon = 'icons/obj/weapons.dmi'
	icon_state = "hm_hammer"
	item_state = "hm_hammer"
	force = WEAPON_FORCE_PAINFUL
	throwforce = WEAPON_FORCE_PAINFUL
	w_class = ITEM_SIZE_BULKY
	origin_tech = list(TECH_COMBAT = 3)
	attack_verb = list("robusted", "slammed")
	structure_damage_factor = STRUCTURE_DAMAGE_HEAVY
	var/reinforced = FALSE
	var/obj/item/storage/toolbox/toolbox
	New()
		..()
		if(!toolbox)
			src.name = "unfinished 69src.name69"
			src.desc = "Wired69op. You need toolbox to finish this."
			icon_state = "hm_hammer_unfinished"
			item_state = ""
			force = WEAPON_FORCE_WEAK
			throwforce = WEAPON_FORCE_WEAK
			origin_tech = list(TECH_COMBAT = 1)


/obj/item/melee/toolbox_maul/update_icon()
	..()
	cut_overlays()
	if(reinforced)
		overlays += "69icon_state69-duct_tape"

/obj/item/melee/toolbox_maul/proc/break_apart(var/mob/living/user)
	69del(src)
	var/obj/item/mop/mop = new(user.loc)
	if(!user.get_active_hand())
		user.put_in_active_hand(mop)
	else
		user.put_in_inactive_hand(mop)
	toolbox.loc = user.loc


/obj/item/melee/toolbox_maul/attackby(obj/item/C,69ob/living/user)
	if(toolbox)
		if(istype(C, /obj/item/tool/wirecutters))
			if(reinforced)
				to_chat(user, SPAN_NOTICE("You cutted up the tapes from 69src69."))
				reinforced = FALSE
			else
				to_chat(user, SPAN_NOTICE("You carefully cut cables from 69src69."))
				break_apart(user)

		if(istype(C, /obj/item/tool/tape_roll))
			to_chat(user, SPAN_NOTICE("You begins to tie 69src69 with 69C69..."))
			if(do_after(user, 50))
				if(!reinforced)
					to_chat(user, SPAN_NOTICE("You reinforce 69src69."))
					reinforced = TRUE
				else
					to_chat(user, SPAN_WARNING("69src69 is already reinforced."))
	else
		if(istype(C, /obj/item/storage/toolbox))
			src.name = initial(src.name)
			src.desc = initial(src.desc)
			src.force = initial(src.force)
			throwforce = initial(throwforce)
			origin_tech = initial(origin_tech)
			icon_state = initial(icon_state)
			item_state = initial(item_state)
			toolbox = C
			user.drop_from_inventory(C, src)
			if(istype(C, /obj/item/storage/toolbox/electrical))
				icon_state = "hm_hammer_yellow"
				item_state = "hm_hammer_yellow"
			if(istype(C, /obj/item/storage/toolbox/mechanical))
				icon_state = "hm_hammer_blue"
				item_state = "hm_hammer_blue"
			to_chat(user, SPAN_NOTICE("You tied 69C69 to 69src69 and finally finish it!"))
	update_icon()

/obj/item/melee/toolbox_maul/attack(mob/living/carbon/human/M as69ob,69ob/living/carbon/user as69ob)
	..()
	if(!reinforced && prob(5))
		break_apart(user)
		playsound(src.loc, 'sound/effects/bang.ogg', 45, 1)
		user.visible_message(SPAN_WARNING("69src69 breaks in hands of 69user69!"))
