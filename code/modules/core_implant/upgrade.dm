/obj/item/coreimplant_upgrade
	name = "Upgrade"
	desc = "Upgrade module for coreimplant. Must be activated after install."
	icon = 'icons/obj/module.dmi'
	icon_state = "core_upgrade"
	var/implant_type = /obj/item/implant/core_implant
	var/obj/item/implant/core_implant/implant
	var/datum/core_module/module
	var/remove_module = TRUE //if TRUE, module will removed on upgrade remove
	var/mob/living/user

/obj/item/coreimplant_upgrade/New()
	..()
	set_up()

/obj/item/coreimplant_upgrade/attack(mob/living/carbon/human/target, mob/living/user, target_zone)
	if(!ishuman(target) || !module)
		to_chat(user, span_warning("This upgrade is blank."))
		return

	var/obj/item/implant/core_implant/I = target.get_core_implant()

	if(!I || !istype(I, implant_type) || !I.active || !I.wearer)
		to_chat(user, span_warning("[target] doesn't have an impant to install [src]."))
		return

	for(var/U in I.upgrades)
		if(istype(I,src.type))
			to_chat(user, span_warning("[target] already have this upgrade."))
			return

	user.visible_message(span_danger("[user] attempts to install [src] in \the [target]'s [I]."),
		span_danger("You are trying to install [src] in the [target]'s \the [I]."))

	if(do_after(user,50,target))
		user.drop_item(src)
		forceMove(I)
		implant = I
		on_install(target,user,target_zone)
		implant.upgrades.Add(src)
		implant.add_module(module)
		to_chat(user, span_notice("You are successfully installed [src] in the [target]'s \the [I]."))
		return

	..()

/obj/item/coreimplant_upgrade/proc/on_install(mob/living/carbon/human/target, mob/living/user, target_zone)


/obj/item/coreimplant_upgrade/proc/remove()
	if(implant && implant.wearer)
		src.forceMove(implant.wearer.loc)
		implant.upgrades.Remove(src)
		if(module && remove_module)
			implant.remove_module(module)
		implant = null

/obj/item/coreimplant_upgrade/proc/set_up()

