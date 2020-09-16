/obj/item/weapon/rallador_de_queso
	name = "Rallador de queso"
	desc = "Un simple rallador de queso"
	icon = 'icons/hispania/obj/kitchen.dmi'
	icon_state = "rallador_de_queso"
	sharp = TRUE
	edge = FALSE
	force = WEAPON_FORCE_HARMLESS

/obj/item/weapon/rallador_de_queso/attackby(obj/item/I, mob/user, params)
    if(istype(I, /obj/item/weapon/reagent_containers/food/snacks/bun))
        if(isturf(loc))
            for(var/i=1 to 3)
                new /obj/item/weapon/reagent_containers/food/snacks/pan_rallado (loc)
            to_chat(user, "<span class='notice'>You cut [src] into pan rallado.</span>")
            qdel(I)
        else
            to_chat(user, "<span class='notice'>You need to put [src] on a surface to cut it!</span>")
    else
        ..()

/obj/item/weapon/reagent_containers/food/snacks/rawcutlet/attackby(obj/item/I, mob/user, params)
    if(istype(I, /obj/item/weapon/reagent_containers/food/snacks/pan_rallado))
        if(isturf(loc))
            new /obj/item/weapon/reagent_containers/food/snacks/milanesa_cruda (loc)
            to_chat(user, "<span class='notice'>You put pan rallado all over the [src] and get a Milanesa!.</span>")
            qdel(I)
            qdel(src)
        else
            to_chat(user, "<span class='notice'>You need to put [src] on a surface to mix it!</span>")
    else
        ..()
