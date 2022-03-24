/obj/item/grenade/heatwave
    name = "FS HG \"Phoenix\""
    desc = "A military-grade offensive heatwave grenade, designed to be thrown behind cover."
    icon_state = "incendiary"
    item_state = "grenade"
    matter = list(MATERIAL_STEEL = 3, MATERIAL_PLASMA = 4)

    var/heavy_range = 2
    var/weak_range = 3
    var/flash_range = 10
    var/heat_damage = 90
    var/fire_stacks = TRUE
    var/penetration = 0


/obj/item/grenade/heatwave/prime()
    set waitfor = 0
    ..()
    var/turf/O = get_turf(src)
    if(!O) return

    on_explosion(O)

    qdel(src)

/obj/item/grenade/heatwave/proc/on_explosion(var/turf/O)
    heatwave(O, heavy_range, weak_range, heat_damage, fire_stacks, penetration)


/obj/item/grenade/heatwave/nt
    name = "NT HG \"Inferno\""
    desc = "A military-grade offensive heatwave grenade. \
            There\'s an inscription along the bands. \'Fear the Fire whose fuel is men and steel,- which is prepared for those who reject Faith.\'"
    icon_state = "frag_nt"
    item_state = "fraggrenade_nt"
    heavy_range = 2
    weak_range = 4
    heat_damage = 90
    penetration = 25
    matter = list(MATERIAL_BIOMATTER = 30, MATERIAL_PLASMA = 5)
