/obj/item/69ene_vial
	name = "vial"
	desc = "A69ial with 69enetic69aterial."
	icon = 'icons/obj/chemical.dmi'
	icon_state = "bottle16" //paceholder
	var/empty = FALSE
	matter = list(MATERIAL_69LASS = 1)
	w_class = ITEM_SIZE_TINY

/obj/item/69ene_vial/attack(mob/M,69ob/livin69/user, def_zone)
	if(user !=69 || !istype(user))
		return ..()

	if(empty)
		to_chat(user, SPAN_WARNIN69("\The 69src69 is empty."))
		return

	var/mob/livin69/carbon/human/H = user
	var/obj/item/or69an/internal/carrion/core/C
	if(istype(H))
		C = H.random_or69an_by_process(BP_SPCORE)
		var/obj/item/blocked = H.check_mouth_covera69e()
		if(blocked)
			to_chat(user, SPAN_WARNIN69("\The 69blocked69 is in the way!"))
			return

	to_chat(user, SPAN_NOTICE("You swallow the contents of \the 69src69."))

	if(C)
		C.69eneticpoints += 5
	else
		user.adjustToxLoss(40)

	empty = TRUE
	desc += " There is none left."
