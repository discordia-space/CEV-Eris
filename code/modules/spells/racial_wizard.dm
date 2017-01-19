//this file is full of all the racial spells/artifacts/etc that each species has.

/obj/item/weapon/magic_rock
	name = "magical rock"
	desc = "Legends say that this rock will unlock the true potential of anyone who touches it."
	icon = 'icons/obj/wizard.dmi'
	icon_state = "magic rock"
	w_class = 2
	throw_speed = 1
	throw_range = 3
	force = 15
	var/list/potentials = list("Human" = /obj/item/weapon/storage/bag/cash/infinite)

/obj/item/weapon/magic_rock/attack_self(mob/user)
	if(!istype(user,/mob/living/carbon/human))
		user << "\The [src] can do nothing for such a simple being."
		return
	var/mob/living/carbon/human/H = user
	var/reward = potentials[H.species.get_bodytype()] //we get body type because that lets us ignore subspecies.
	if(!reward)
		user << "\The [src] does not know what to make of you."
		return
	for(var/spell/S in user.spell_list)
		if(istype(S,reward))
			user << "\The [src] can do no more for you."
			return
	user.drop_from_inventory(src)
	var/a = new reward()
	if(ispath(reward,/spell))
		H.add_spell(a)
	else if(ispath(reward,/obj))
		H.put_in_hands(a)
	user << "\The [src] crumbles in your hands."
	qdel(src)

//HUMAN
/obj/item/weapon/storage/bag/cash/infinite/remove_from_storage(obj/item/W as obj, atom/new_location)
	. = ..()
	if(.)
		if(istype(W,/obj/item/weapon/spacecash)) //only matters if its spacecash.
			var/obj/item/I = new /obj/item/weapon/spacecash/bundle/c1000()
			src.handle_item_insertion(I,1)
