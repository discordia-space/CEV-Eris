/obj/item/coreimplant_upgrade
	name = "Upgrade"
	desc = "Upgrade69odule for coreimplant.69ust be activated after install."
	icon = 'icons/obj/module.dmi'
	icon_state = "core_upgrade"
	var/implant_type = /obj/item/implant/core_implant
	var/obj/item/implant/core_implant/implant
	var/datum/core_module/module
	var/remove_module = TRUE //if TRUE,69odule will removed on upgrade remove
	var/mob/living/user

/obj/item/coreimplant_upgrade/New()
	..()
	set_up()

/obj/item/coreimplant_upgrade/attack(var/mob/living/carbon/human/target,69ar/mob/living/user,69ar/target_zone)
	if(!ishuman(target) || !module)
		to_chat(user, SPAN_WARNING("This upgrade is blank."))
		return

	var/obj/item/implant/core_implant/I = target.get_core_implant()

	if(!I || !istype(I, implant_type) || !I.active || !I.wearer)
		to_chat(user, SPAN_WARNING("69target69 doesn't have an impant to install 69src69."))
		return

	for(var/U in I.upgrades)
		if(istype(I,src.type))
			to_chat(user, SPAN_WARNING("69target69 already have this upgrade."))
			return

	user.visible_message(SPAN_DANGER("69user69 attempts to install 69src69 in \the 69target69's 69I69."),
		SPAN_DANGER("You are trying to install 69src69 in the 69target69's \the 69I69."))

	if(do_after(user,50,target))
		user.drop_item(src)
		forceMove(I)
		implant = I
		on_install(target,user,target_zone)
		implant.upgrades.Add(src)
		implant.add_module(module)
		to_chat(user, SPAN_NOTICE("You are successfully installed 69src69 in the 69target69's \the 69I69."))
		return

	..()

/obj/item/coreimplant_upgrade/proc/on_install(var/mob/living/carbon/human/target,69ar/mob/living/user,69ar/target_zone)


/obj/item/coreimplant_upgrade/proc/remove()
	if(implant && implant.wearer)
		src.forceMove(implant.wearer.loc)
		implant.upgrades.Remove(src)
		if(module && remove_module)
			implant.remove_module(module)
		implant = null

/obj/item/coreimplant_upgrade/proc/set_up()

