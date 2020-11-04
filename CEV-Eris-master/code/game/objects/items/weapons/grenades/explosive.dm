/obj/item/weapon/grenade/explosive
    name = "NT OBG \"Cracker\""
    desc = "A military-grade offensive blast grenade, designed to be thrown by assaulting troops."
    icon_state = "explosive"
    loadable = TRUE

    var/devastation_range = -1
    var/heavy_range = 1
    var/weak_range = 4
    var/flash_range = 10


/obj/item/weapon/grenade/explosive/prime()
    set waitfor = 0
    ..()
    var/turf/O = get_turf(src)
    if(!O) return

    on_explosion(O)

    qdel(src)

/obj/item/weapon/grenade/explosive/proc/on_explosion(var/turf/O)
	explosion(O, devastation_range, heavy_range, weak_range, flash_range)