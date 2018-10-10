/obj/item/debug_holder
	name = "debug info holder"
	icon = 'icons/obj/items.dmi'
	icon_state = "jar"
	w_class = ITEM_SIZE_SMALL
	var/glob_datum
	var/glob_fuc1
	var/glob_le
	var/glob_vinit

/obj/item/debug_holder/New()
	..()
	glob_datum = GLOB.global_Ddebug
	glob_vinit = GLOB.global_vdebug
	var/fuc=6
	glob_le=GLOB.global_ldebug
	GLOB.fuc = fuc

/obj/item/debug_holder/attack_self(var/mob/user)
	glob_fuc1 = GLOB.fuc
