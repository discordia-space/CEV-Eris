/obj/item/weapon/storage/pill_bottle/dice
	name = "pack of dice"
	desc = "It's a small container with dice inside."

/obj/item/weapon/storage/pill_bottle/dice/populate_contents()
	new /obj/item/weapon/dice(src)
	new /obj/item/weapon/dice/d20(src)

/*
 * Donut Box
 */

/obj/item/weapon/storage/box/donut
	icon = 'icons/obj/food.dmi'
	icon_state = "donutbox"
	name = "donut box"
	var/startswith = 6
	max_storage_space = 12 //The amount of starting donuts multiplied by the donut item size to keep only exact space requirement met.
	can_hold = list(/obj/item/weapon/reagent_containers/food/snacks/donut)
	foldable = /obj/item/stack/material/cardboard

/obj/item/weapon/storage/box/donut/populate_contents()
	for(var/i in 1 to 6)
		new /obj/item/weapon/reagent_containers/food/snacks/donut/normal(src)
	update_icon()

/obj/item/weapon/storage/box/donut/update_icon()
	overlays.Cut()
	var/i = 0
	for(var/obj/item/weapon/reagent_containers/food/snacks/donut/D in contents)
		overlays += image('icons/obj/food.dmi', "[i][D.overlay_state]")
		i++

/obj/item/weapon/storage/box/donut/empty
	startswith = 0
