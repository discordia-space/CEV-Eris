/obj/item/weapon/mine
	name = "Excelsior Mine"
	desc = "For the excelsior! Just add igniter with signaler or sensor in it, and it's ready to blow."
	icon = 'icons/obj/machines/excelsior/objects.dmi'
	icon_state = "mine"
	w_class = ITEM_SIZE_LARGE
	matter = list(MATERIAL_STEEL = 7)
	matter_reagents = list("fuel" = 30)

	var/obj/item/device/assembly_holder/detonator = null

	var/fragment_type = /obj/item/projectile/bullet/pellet/fragment/strong
	var/spread_radius = 8
	var/num_fragments = 350
	var/fragment_damage = 10
	var/damage_step = 2

	var/explosion_d_size = -1
	var/explosion_h_size = -1
	var/explosion_l_size = -1
	var/explosion_f_size = 15

/obj/item/weapon/mine/proc/explode()
	var/turf/T = get_turf(src)
	explosion(T,explosion_d_size,explosion_h_size,explosion_l_size,explosion_f_size)
	fragment_explosion(T, spread_radius, fragment_type, num_fragments, fragment_damage, damage_step)

	if(src)
		qdel(src)

/obj/item/weapon/mine/update_icon()
	overlays.Cut()

	if(detonator)
		overlays.Add(image(icon,"mine_light"))


/obj/item/weapon/mine/attackby(obj/item/I, mob/user)
	src.add_fingerprint(user)
	if(detonator && QUALITY_SCREW_DRIVING in I.tool_qualities)
		if(I.use_tool(user, src, WORKTIME_FAST, QUALITY_SCREW_DRIVING, FAILCHANCE_EASY, required_stat = STAT_COG))
			if(detonator)
				user.visible_message("[user] detaches \the [detonator] from [src].", \
					"You detach \the [detonator] from [src].")
				detonator.forceMove(get_turf(src))
				detonator = null

	if (istype(I,/obj/item/device/assembly_holder))
		if(detonator)
			user << SPAN_WARNING("There is another device in the way.")
			return ..()

		user.visible_message("\The [user] begins attaching [I] to \the [src].", "You begin attaching [I] to \the [src]")
		if(do_after(user, 20, src))
			user.visible_message("<span class='notice'>The [user] attach [I] to \the [src].", "\blue  You attach [I] to \the [src].</span>")

			detonator = I
			user.unEquip(I,src)

	return ..()
