/obj/item/weapon/coreimplant_upgrade
	name = "Upgrade"
	desc = "Upgrade module for coreimplant. Must be activated after install."
	icon = 'icons/obj/module.dmi'
	icon_state = "core_upgrade"
	var/implant_type = /obj/item/weapon/implant/external/core_implant
	var/obj/item/weapon/implant/external/core_implant/implant
	var/datum/core_module/module
	var/remove_module = TRUE //if TRUE, module will removed on upgrade remove
	var/mob/living/user

/obj/item/weapon/coreimplant_upgrade/New()
	..()
	set_up()

/obj/item/weapon/coreimplant_upgrade/attack(var/mob/living/carbon/human/target, var/mob/living/user, var/target_zone)
	if(!ishuman(target) || !module)
		user << "<span class='warning'>This upgrade is blank.</span>"
		return

	var/obj/item/weapon/implant/external/core_implant/I = target.get_core_implant()

	if(!I || !istype(I, implant_type) || !I.active || !I.wearer)
		user << "<span class='warning'>[target] doesn't have an impant to install [src].</span>"
		return

	for(var/U in I.upgrades)
		if(istype(I,src.type))
			user << "<span class='warning'>[target] already have this upgrade.</span>"
			return

	user.visible_message("<span class='danger'>[user] attempts to install [src] in \the [target]'s [I].</span>",
		"<span class='danger'>You are trying to install [src] in the [target]'s \the [I].</span>")

	if(do_after(user,50,target))
		user.drop_item(src)
		forceMove(I)
		implant = I
		on_install(target,user,target_zone)
		implant.upgrades.Add(src)
		implant.add_module(module)
		user << SPAN_NOTICE("You are successfully installed [src] in the [target]'s \the [I].")
		return

	..()

/obj/item/weapon/coreimplant_upgrade/proc/on_install(var/mob/living/carbon/human/target, var/mob/living/user, var/target_zone)


/obj/item/weapon/coreimplant_upgrade/proc/remove()
	if(implant && implant.wearer)
		src.forceMove(implant.wearer.loc)
		implant.upgrades.Remove(src)
		if(module && remove_module)
			implant.remove_module(module)
		implant = null

/obj/item/weapon/coreimplant_upgrade/proc/set_up()

