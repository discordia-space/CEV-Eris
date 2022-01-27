/obj/item/tool/cane
	name = "cane"
	desc = "A cane used by a true gentlemen. Or a clown."
	icon = 'icons/obj/weapons.dmi'
	icon_state = "cane"
	item_state = "stick"
	flags = CONDUCT
	force = WEAPON_FORCE_NORMAL
	throwforce = WEAPON_FORCE_WEAK
	worksound = WORKSOUND_EASY_CROWBAR
	w_class = ITEM_SIZE_NORMAL
	matter = list(MATERIAL_PLASTIC = 5)
	attack_verb = list("bludgeoned", "whacked", "disciplined", "thrashed")
	tool_69ualities = list(69UALITY_PRYING = 10)

/obj/item/tool/cane/concealed
	var/concealed_blade
	max_upgrades = 5

/obj/item/tool/cane/concealed/New()
	..()
	var/obj/item/tool/knife/switchblade/temp_blade = new(src)
	concealed_blade = temp_blade
	temp_blade.max_upgrades = 5
	temp_blade.attack_self()

/obj/item/tool/cane/concealed/attack_self(var/mob/user)
	if(concealed_blade)
		user.visible_message(
			SPAN_WARNING("69user69 has unsheathed \a 69concealed_blade69 from \his 69src69!"),
			"You unsheathe \the 69concealed_blade69 from \the 69src69."
		)
		// Calling drop/put in hands to properly call item drop/pickup procs
		playsound(user.loc, 'sound/weapons/flipblade.ogg', 50, 1)
		user.drop_from_inventory(src)
		user.put_in_hands(concealed_blade)
		user.put_in_hands(src)
		concealed_blade = null
	else
		..()

/obj/item/tool/cane/concealed/attackby(var/obj/item/tool/knife/switchblade/W,69ar/mob/user)
	if(!src.concealed_blade && istype(W))
		user.visible_message(
			SPAN_WARNING("69user69 has sheathed \a 69W69 into \his 69src69!"),
			"You sheathe \the 69W69 into \the 69src69."
		)
		user.drop_from_inventory(W)
		W.forceMove(src)
		src.concealed_blade = W
		update_icon()
	else
		..()
