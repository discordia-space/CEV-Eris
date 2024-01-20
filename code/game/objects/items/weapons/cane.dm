/obj/item/tool/cane
	name = "cane"
	desc = "A cane used by a true gentlemen. Or a clown."
	icon = 'icons/obj/weapons.dmi'
	icon_state = "cane"
	item_state = "stick"
	flags = CONDUCT
	melleDamages = list(
		ARMOR_BLUNT = list(
			DELEM(BRUTE, 7)
		)
	)
	throwforce = WEAPON_FORCE_WEAK
	worksound = WORKSOUND_EASY_CROWBAR
	volumeClass = ITEM_SIZE_NORMAL
	matter = list(MATERIAL_PLASTIC = 5)
	attack_verb = list("bludgeoned", "whacked", "disciplined", "thrashed")
	tool_qualities = list(QUALITY_PRYING = 10)

/obj/item/tool/cane/concealed
	var/concealed_blade
	maxUpgrades = 5

/obj/item/tool/cane/concealed/New()
	..()
	var/obj/item/tool/knife/switchblade/temp_blade = new(src)
	concealed_blade = temp_blade
	temp_blade.maxUpgrades = 5
	temp_blade.attack_self()

/obj/item/tool/cane/concealed/attack_self(var/mob/user)
	if(concealed_blade)
		user.visible_message(
			SPAN_WARNING("[user] has unsheathed \a [concealed_blade] from \his [src]!"),
			"You unsheathe \the [concealed_blade] from \the [src]."
		)
		// Calling drop/put in hands to properly call item drop/pickup procs
		playsound(user.loc, 'sound/weapons/flipblade.ogg', 50, 1)
		user.drop_from_inventory(src)
		user.put_in_hands(concealed_blade)
		user.put_in_hands(src)
		concealed_blade = null
	else
		..()

/obj/item/tool/cane/concealed/attackby(var/obj/item/tool/knife/switchblade/W, var/mob/user)
	if(!src.concealed_blade && istype(W))
		user.visible_message(
			SPAN_WARNING("[user] has sheathed \a [W] into \his [src]!"),
			"You sheathe \the [W] into \the [src]."
		)
		user.drop_from_inventory(W)
		W.forceMove(src)
		src.concealed_blade = W
		update_icon()
	else
		..()
