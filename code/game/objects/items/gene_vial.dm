/obj/item/gene_vial
	name = "vial"
	desc = "A vial with genetic material."
	icon = 'icons/obj/chemical.dmi'
	icon_state = "bottle16" //paceholder
	var/empty = FALSE
	matter = list(MATERIAL_GLASS = 1)
	volumeClass = ITEM_SIZE_TINY

/obj/item/gene_vial/attack(mob/M, mob/living/user, def_zone)
	if(user != M || !istype(user))
		return ..()

	if(empty)
		to_chat(user, SPAN_WARNING("\The [src] is empty."))
		return

	var/mob/living/carbon/human/H = user
	var/obj/item/organ/internal/carrion/core/C
	if(istype(H))
		C = H.random_organ_by_process(BP_SPCORE)
		var/obj/item/blocked = H.check_mouth_coverage()
		if(blocked)
			to_chat(user, SPAN_WARNING("\The [blocked] is in the way!"))
			return

	to_chat(user, SPAN_NOTICE("You swallow the contents of \the [src]."))

	if(C)
		C.geneticpoints += 5
	else
		user.adjustToxLoss(40)

	empty = TRUE
	desc += " There is none left."
