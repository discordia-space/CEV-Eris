/obj/item/weapon/cheese_grater
	name = "Grater"
	desc = "Just a regular grater"
	icon = 'icons/hispania/obj/kitchen.dmi'
	icon_state = "cheese_grater"
	sharp = TRUE
	edge = FALSE
	force = WEAPON_FORCE_HARMLESS

//Para rallar el pan
/obj/item/weapon/cheese_grater/attackby(obj/item/I, mob/user, params)
    if(istype(I, /obj/item/weapon/reagent_containers/food/snacks/bun))
        if(isturf(loc))
            for(var/i=1 to 3)
                new /obj/item/weapon/reagent_containers/food/snacks/bread_crumbs (loc)
            to_chat(user, "<span class='notice'>You cut [src] into bread crumbs.</span>")
            qdel(I)
        else
            to_chat(user, "<span class='notice'>You need to put [src] on a surface to cut it!</span>")
    else
        ..()

//Para hacer la milanesa
/obj/item/weapon/reagent_containers/food/snacks/rawcutlet/attackby(obj/item/I, mob/user, params)
    if(istype(I, /obj/item/weapon/reagent_containers/food/snacks/bread_crumbs))
        if(isturf(loc))
            new /obj/item/weapon/reagent_containers/food/snacks/raw_milanesa (loc)
            to_chat(user, "<span class='notice'>You put bread crumbs all over the [src] and get a Milanesa!.</span>")
            qdel(I)
            qdel(src)
        else
            to_chat(user, "<span class='notice'>You need to put [src] on a surface to mix it!</span>")
    else
        ..()
