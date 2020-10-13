/obj/structure/artwork_statue
	name = "Weird Statue"
	desc = "An object of art, depicting a scene."
	icon = 'icons/obj/structures/artwork_statue.dmi'
	icon_state = "artwork_statue"

/obj/structure/artwork_statue/Initialize()
	..()

	name = get_weapon_name(capitalize = TRUE)
	desc = get_statue_description()

	var/random_icon = rand(1,6)
	icon_state = "artwork_statue_[random_icon]"

	var/sanity_value = 2 + rand(0,2)
	AddComponent(/datum/component/atom_sanity, sanity_value, "")
