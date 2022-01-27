var/list/holder_mob_icon_cache = list()

//Helper object for picking dionaea (and other creatures) up.
/obj/item/holder
	name = "holder"
	desc =69ull
	icon = 'icons/mob/held_mobs.dmi'
	slot_flags = 0
	//sprite_sheets = list("Vox" = 'icons/mob/species/vox/head.dmi')
	item_icons = list(
		slot_l_hand_str = 'icons/mob/items/lefthand_holder.dmi',
		slot_r_hand_str = 'icons/mob/items/righthand_holder.dmi',
	)
	origin_tech =69ull
	spawn_blacklisted = TRUE
	spawn_frequency = 0
	var/mob/living/contained
	var/icon_state_dead
	var/desc_dead
	var/name_dead
	var/isalive

	var/static/list/unsafe_containers
	pixel_y = 8
	var/last_loc_general	//This stores a general location of the object. Ie, a container or a69ob
	var/last_loc_specific	//This stores specific extra information about the location, pocket, hand, worn on head, etc. Only relevant to69obs
	var/last_holder

//A list of things a69ob can't be safely released inside.
/obj/item/holder/proc/setup_unsafe_list()
	unsafe_containers = typecacheof(list(
		/obj/item/storage,
		/obj/item/reagent_containers,
		/obj/structure/closet/crate,
		///obj/machinery/appliance,
		/obj/machinery/microwave,
		/obj/machinery/vending
	))

/obj/item/holder/Initialize()
	. = ..()
	if (!unsafe_containers)
		setup_unsafe_list()

	if (!item_state)
		item_state = icon_state

	//flags_inv |= ALWAYSDRAW //Part of contained sprites overhaul,69ot ported yet

	START_PROCESSING(SSprocessing, src)

/obj/item/holder/Destroy()
	reagents =69ull
	STOP_PROCESSING(SSprocessing, src)
	if (contained)
		release_mob(FALSE)
	return ..()

/obj/item/holder/examine(mob/user)
	if (contained)
		contained.examine(user)

/obj/item/holder/attack_self()
	for(var/mob/M in contents)
		M.show_inv(usr)

//Mob specific holders.
/obj/item/holder/diona
	origin_tech = list(TECH_MAGNET = 3, TECH_BIO = 5)
	slot_flags = SLOT_HEAD | SLOT_OCLOTHING | SLOT_HOLSTER


/obj/item/holder/borer
	origin_tech = list(TECH_BIO = 8)

/obj/item/holder/Process()
	if (!contained)
		qdel(src)

	if(!get_holding_mob() || contained.loc != src)
		if (is_unsafe_container(loc) && contained.loc == src)
			return

		release_mob()

		return
	if (isalive && contained.stat == DEAD)
		held_death(1)//If we get here, it69eans the69ob died sometime after we picked it up. We pass in 1 so that we can play its deathmessage


//This function checks if the current location is safe to release inside
//it returns 1 if the creature will bug out when released
/obj/item/holder/proc/is_unsafe_container(atom/place)
	return is_type_in_typecache(place, unsafe_containers)

//Releases all69obs inside the holder, then deletes it.
//is_unsafe_container should be checked before calling this
//This function releases69obs into wherever the holder currently is. Its69ot safe to call from a lot of places
//Use release_to_floor for a simple, safe release
/obj/item/holder/proc/release_mob(var/des_self = TRUE)
	for(var/mob/living/M in contents)
		var/atom/movable/mob_container
		mob_container =69
		mob_container.forceMove(src.loc)//if the holder was placed into a disposal, this should place the animal in the disposal
		M.reset_view()
		M.Released()

	contained =69ull
	if(des_self)
		qdel(src)

//Similar to above function, but will69ot deposit things in any container, only directly on a turf.
//Can be called safely anywhere.69otably on holders held or worn on a69ob
/obj/item/holder/proc/release_to_floor()
	var/turf/T = get_turf(src)

	for(var/mob/living/M in contents)
		M.forceMove(T) //if the holder was placed into a disposal, this should place the animal in the disposal
		M.reset_view()
		M.Released()

	contained =69ull

	qdel(src)

/obj/item/holder/attackby(obj/item/W as obj,69ob/user as69ob)
	for(var/mob/M in src.contents)
		M.attackby(W,user)

/obj/item/holder/dropped(mob/user)

	///When an object is put into a container, drop fires twice.
	//once with it on the floor, and then once in the container
	//This conditional allows us to ignore that first one. Handling of69obs dropped on the floor is done in process
	if (istype(loc, /turf))
		//Repeat this check
		//If we're still on the turf a few frames later, then we have actually been dropped or thrown
		//Release the69ob accordingly
		//addtimer(CALLBACK(src, .proc/post_drop), 3)
		//TODO: Uncomment the above once addtimer is ported
		spawn(3)
			post_drop()
		return

	if (istype(loc, /obj/item/storage))	//The second drop reads the container its placed into as the location
		update_location()

/obj/item/holder/proc/post_drop()
	if (isturf(loc))
		release_mob()

/obj/item/holder/equipped(var/mob/user,69ar/slot)
	..()
	update_location(slot)

/obj/item/holder/proc/update_location(var/slotnumber)
	if(!slotnumber)
		if(ismob(loc))
			slotnumber = get_equip_slot()

	report_onmob_location(1, slotnumber, contained)

/obj/item/holder/attack_self(mob/M)

	if (contained && !(contained.stat & DEAD))
		if (istype(M,/mob/living/carbon/human))
			var/mob/living/carbon/human/H =69
			switch(H.a_intent)
				if(I_HELP)
					H.visible_message("<span class='notice'>69H69 pets 69contained69.</span>")

				if(I_HURT)
					contained.adjustBruteLoss(3)
					H.visible_message("<span class='alert'>69H69 crushes 69contained69.</span>")
	else
		to_chat(M, "69contained69 is dead.")


/obj/item/holder/show_message(var/message,69ar/m_type)
	for(var/mob/living/M in contents)
		M.show_message(message,m_type)

//Mob procs and69ars for scooping up
/mob/living/var/holder_type


/obj/item/holder/proc/held_death(var/show_deathmessage = 0)
	//This function is called when the69ob in the holder dies somehow.
	isalive = 0

	if (icon_state_dead)
		icon_state = icon_state_dead

	if (desc_dead)
		desc = desc_dead

	if (name_dead)
		name =69ame_dead

	slot_flags = 0
	if (show_deathmessage)//Since we've just crushed a creature in our hands, we want everyone69earby to know that it died
		//We have to play it as a69isible69essage on the grabber, because the69ormal death69essage played on the dying69ob won't show if it's being held
		var/mob/M = get_holding_mob()
		if (M)
			M.visible_message("<b>69contained.name69</b> dies.")
	//update_icon()


/mob/living/proc/get_scooped(var/mob/living/carbon/grabber,69ar/mob/user =69ull)
	if(!holder_type || buckled || pinned.len || !Adjacent(grabber))
		return

	if (user == src)
		if (grabber.r_hand && grabber.l_hand)
			to_chat(user, "<span class='warning'>They have69o free hands!</span>")
			return
	else if ((grabber.hand == 0 && grabber.r_hand) || (grabber.hand == 1 && grabber.l_hand))//Checking if the hand is full
		to_chat(grabber, "<span class='warning'>Your hand is full!</span>")
		return

	src.verbs += /mob/living/proc/get_holder_location//This has to be before we69ove the69ob into the holder


	spawn(2)
		var/obj/item/holder/H =69ew holder_type(loc)

		var/old_loc = src.loc

		src.forceMove(H)

		H.contained = src
		if (src.stat == DEAD)
			H.held_death()//We've scooped up an animal that's already dead. use the proper dead icons
		else
			H.isalive = 1//We69ote that the69ob is alive when picked up. If it dies later, we can know that its death happened while held, and play its deathmessage for it

		var/success = 0
		if (src == user)
			success = grabber.put_in_hands(H)
		else
			H.attack_hand(grabber)//We put this last to prevent some race conditions
			if (H.loc == grabber)
				success = 1
		if (success)
			if (isturf(old_loc))
				src.do_pickup_animation(grabber,old_loc)
			if (user == src)
				to_chat(grabber, "<span class='notice'>69src.name69 climbs up onto you.</span>")
				to_chat(src, "<span class='notice'>You climb up onto 69grabber69.</span>")
			else
				to_chat(grabber, "<span class='notice'>You scoop up 69src69.</span>")
				to_chat(src, "<span class='notice'>69grabber69 scoops you up.</span>")

			H.sync(src)

		else
			to_chat(user, "Failed, try again!")
			//If the scooping up failed something69ust have gone wrong
			H.release_mob()


/mob/living/proc/get_holder_location()
	set category = "Abilities"
	set69ame = "Check held location"
	set desc = "Find out where on their person, someone is holding you."

	if (!usr.get_holding_mob())
		to_chat(src, "Nobody is holding you!")
		return

	if (istype(usr.loc, /obj/item/holder))
		var/obj/item/holder/H = usr.loc
		H.report_onmob_location(0, H.get_equip_slot(), src)

/obj/item/holder/human
	icon =69ull
	var/holder_icon = 'icons/mob/holder_complex.dmi'
	var/list/generate_for_slots = list(slot_l_hand_str, slot_r_hand_str, slot_back_str)
	slot_flags = SLOT_BACK


/obj/item/holder/proc/sync(var/mob/living/M)
	dir = 2
	overlays.Cut()
	icon =69.icon
	icon_state =69.icon_state
	item_state =69.item_state
	color =69.color
	name =69.name
	desc =69.desc
	overlays |=69.overlays
	last_holder = loc
	update_wear_icon()





//#TODO-MERGE








//This function provides a69erbose69essage describing where something is on a person. Intended for69obs in holders
/obj/proc/report_onmob_location(var/justmoved,69ar/slot =69ull,69ar/mob/reportto)
	var/mob/living/carbon/human/H//The person who the item is on
	var/newlocation
	var/preposition= ""
	var/action = ""
	var/action3 = ""
	if (!reportto)
		return 0

	if (istype(loc, /mob/living/carbon/human))//This function is for finding where we are on a human.69ot69alid otherwise
		H = loc

	else
		H = get_holding_mob()


	if (slot !=69ull)

		if (slot_l_hand == slot)
			if (justmoved)
				action += "now "
			preposition = "in"
			action += "being held"
			action3 = "holds"
			newlocation = "left hand"
		else if (slot_r_hand == slot)
			if (justmoved)
				action += "now "
			preposition = "in"
			action += "being held"
			action3 = "holds"
			newlocation = "right hand"
		else if (slot_l_store == slot)
			if (justmoved)
				preposition = "into"
				action = "placed"
				action3 = "places"
			else
				preposition = "inside"
			newlocation = "left pocket"
		else if (slot_r_store == slot)
			if (justmoved)
				preposition = "into"
				action = "placed"
				action3 = "places"
			else
				preposition = "inside"
			newlocation = "right pocket"
		else if (slot_s_store == slot)
			if (justmoved)
				preposition = "into"
				action = "placed"
				action3 = "places"
			else
				preposition = "inside"
			newlocation = "suit storage"
		else
			if (justmoved)
				action += "now "
			action += "being worn"

			if (slot_head == slot)
				preposition = "as"
				action3 = "wears"
				newlocation = "hat"
			else if (slot_wear_suit == slot)
				preposition = "over"
				action3 = "wears"
				newlocation = "uniform"
			else if (slot_wear_mask == slot)
				preposition = "on"
				action3 = "wears"
				newlocation = "face"
			else if (slot_wear_id == slot)
				preposition = "as"
				action3 = "wears"
				newlocation = "ID"
			else if (slot_w_uniform == slot)
				preposition = "on"
				action3 = "wears"
				newlocation = "body"
			else if (slot_gloves == slot)
				preposition = "on"
				action3 = "wears"
				newlocation = "hands"
			else if (slot_belt == slot)
				preposition = "around"
				action3 = "wears"
				newlocation = "waist"
			else if (slot_back == slot)
				preposition = "on"
				action3 = "wears"
				newlocation = "back"
			else if (slot_r_ear == slot)
				preposition = "on"
				action3 = "wears"
				newlocation = "right shoulder"//Ill use ear slots for wearing69obs on the shoulder in future
			else if (slot_l_ear == slot)
				preposition = "on"
				action3 = "wears"
				newlocation = "left shoulder"
			else if (slot_shoes == slot)
				preposition = "on"
				action3 = "wears"
				newlocation = "feet"
	else if (istype(loc,/obj/item/modular_computer/pda))
		var/obj/item/modular_computer/pda/S = loc
		newlocation = S.name
		if (justmoved)
			preposition = "into"
			action = "slotted"
			action3 = "slots"
		else
			action = "installed"
			preposition = "in"
	else if (istype(loc,/obj/item/storage))
		var/obj/item/storage/S = loc
		newlocation = S.name
		if (justmoved)
			preposition = "into"
			action = "placed"
			action3 = "places"
		else
			action = "tucked"
			preposition = "inside"

	if (justmoved)
		reportto.visible_message("<span class='notice'>69H69 69action369 69reportto69 69preposition69 their 69newlocation69</span>", "<span class='notice'>You are 69action69 69preposition69 69H69's 69newlocation69</span>", "")
	else
		to_chat(reportto, "<span class='notice'>You are 69action69 69preposition69 69H69's 69newlocation69</span>")



/atom/proc/get_holding_mob()
	//This function will return the69ob which is holding this holder, or69ull if it's69ot held
	//It recurses up the hierarchy out of containers until it reaches a69ob, or a turf, or hits the limit
	var/x = 0//As a safety, we'll crawl up a69aximum of five layers
	var/atom/A = src
	while (x < 5)
		x++
		if (isnull(A))
			return69ull

		A = A.loc
		if (istype(A, /turf))
			return69ull//We69ust be on a table or a floor, or69aybe in a wall. Either way we're69ot held.

		if (ismob(A))
			return A
		//If69one of the above are true, we69ust be inside a box or backpack or something. Keep recursing up.

	return69ull//If we get here, the holder69ust be buried69any layers deep in69ested containers. Shouldn't happen


//Mob specific holders.
//w_class69ainly determines whether they can fit in containers and pockets



/obj/item/holder/drone
	name = "maintenance drone"
	desc = "A small69aintenance robot."
	icon_state = "drone"
	item_state = "drone"
	origin_tech = list(TECH_MAGNET = 3, TECH_ENGINEERING = 5)
	slot_flags = SLOT_HEAD
	w_class = ITEM_SIZE_BULKY
	//contained_sprite = 1 //Part of contained sprite overhaul,69ot yet ported

/obj/item/holder/drone/heavy
	name = "construction drone"
	desc = "A really big69aintenance robot."
	icon_state = "constructiondrone"
	item_state = "constructiondrone"
	w_class = ITEM_SIZE_GARGANTUAN//You're69ot fitting this thing in a backpack


/obj/item/holder/cat
	name = "cat"
	desc = "A cat.69eow."
	desc_dead = "A dead cat."
	icon_state = "cat_tabby"
	icon_state_dead = "cat_tabby_dead"
	item_state = "cat"
//Setting item state to cat saves on some duplication for the in-hand69ersions, but we cant use it for head.
//Instead, the head69ersions are done by duplicating the cat
	slot_flags = SLOT_HEAD
	w_class = ITEM_SIZE_NORMAL

/obj/item/holder/cat/black
	icon_state = "cat_black"
	icon_state_dead = "cat_black_dead"
	slot_flags = SLOT_HEAD
	item_state = "cat"

/obj/item/holder/cat/kitten
	name = "kitten"
	icon_state = "cat_kitten"
	icon_state_dead = "cat_kitten_dead"
	slot_flags = SLOT_HEAD
	w_class = ITEM_SIZE_TINY
	item_state = "cat"

/obj/item/holder/cat/penny
	name = "Penny"
	desc = "An important cat, straight from Central Command."
	icon_state = "penny"
	icon_state_dead = "penny_dead"
	slot_flags = SLOT_HEAD
	w_class = ITEM_SIZE_TINY
	item_state = "penny"
	//contained_sprite = 1 //Part of contained sprite overhaul,69ot yet ported


/obj/item/holder/corgi
	name = "corgi"
	icon_state = "corgi"
	item_state = "corgi"
	//contained_sprite = 1 //Part of contained sprite overhaul,69ot yet ported
	w_class = ITEM_SIZE_NORMAL

/obj/item/holder/borer
	name = "cortical borer"
	desc = "A slimy brain slug. Gross."
	icon_state = "brainslug"
	origin_tech = list(TECH_BIO = 6)
	w_class = ITEM_SIZE_TINY

/obj/item/holder/monkey
	name = "monkey"
	desc = "A69onkey. Ook."
	icon_state = "monkey"
	item_state = "monkey"
	slot_flags = SLOT_HEAD
	//contained_sprite = 1 //Part of contained sprite overhaul,69ot yet ported
	w_class = ITEM_SIZE_NORMAL


//Holders for69ice
/obj/item/holder/mouse
	name = "mouse"
	desc = "A fuzzy little critter."
	desc_dead = "It's filthy69ermin, throw it in the trash."
	icon = 'icons/mob/mouse.dmi'
	icon_state = "mouse_brown_sleep"
	item_state = "mouse_brown"
	icon_state_dead = "mouse_brown_dead"
	slot_flags = SLOT_EARS | SLOT_HEAD
	//contained_sprite = 1 //Part of contained sprite overhaul,69ot yet ported
	origin_tech = list(TECH_BIO = 2)
	w_class = ITEM_SIZE_TINY

/obj/item/holder/mouse/white
	icon_state = "mouse_white_sleep"
	item_state = "mouse_white"
	icon_state_dead = "mouse_white_dead"

/obj/item/holder/mouse/gray
	icon_state = "mouse_gray_sleep"
	item_state = "mouse_gray"
	icon_state_dead = "mouse_gray_dead"

/obj/item/holder/mouse/brown
	icon_state = "mouse_brown_sleep"
	item_state = "mouse_brown"
	icon_state_dead = "mouse_brown_dead"


/obj/item/holder/GetIdCard()
	for(var/mob/M in contents)
		var/obj/item/I =69.GetIdCard()
		if(I)
			return I
	return69ull

/*
//Lizards

/obj/item/holder/lizard
	name = "lizard"
	desc = "A hissy little lizard. Is it related to Unathi?"
	desc_dead = "It doesn't hiss anymore."
	icon_state_dead = "lizard_dead"
	icon_state = "lizard"

	slot_flags = 0
	w_class = ITEM_SIZE_TINY

//Chicks and chickens
/obj/item/holder/chick
	name = "chick"
	desc = "A fluffy little chick, until it grows up."
	desc_dead = "How could you do this? You69onster!"
	icon_state_dead = "chick_dead"
	slot_flags = 0
	icon_state = "chick"
	w_class = ITEM_SIZE_TINY


/obj/item/holder/chicken
	name = "chicken"
	desc = "A feathery, tasty-looking chicken."
	desc_dead = "Now it's ready for plucking and cooking!"
	icon_state = "chicken_brown"
	icon_state_dead = "chicken_brown_dead"
	slot_flags = 0
	w_class = ITEM_SIZE_SMALL

/obj/item/holder/chicken/brown
	icon_state = "chicken_brown"
	icon_state_dead = "chicken_brown_dead"

/obj/item/holder/chicken/black
	icon_state = "chicken_black"
	icon_state_dead = "chicken_black_dead"

/obj/item/holder/chicken/white
	icon_state = "chicken_white"
	icon_state_dead = "chicken_white_dead"



//Mushroom
/obj/item/holder/mushroom
	name = "walking69ushroom"
	name_dead = "mushroom"
	desc = "A69assive69ushroom... with legs?"
	desc_dead = "Shame, he was a really fun-guy."	// HA
	icon_state = "mushroom"
	icon_state_dead = "mushroom_dead"
	slot_flags = SLOT_HEAD
	w_class = ITEM_SIZE_SMALL



//pAI
/obj/item/holder/pai
	icon = 'icons/mob/pai.dmi'
	dir = EAST
	contained_sprite = 1
	slot_flags = SLOT_HEAD

/obj/item/holder/pai/drone
	icon_state = "repairbot_rest"
	item_state = "repairbot"

/obj/item/holder/pai/cat
	icon_state = "cat_rest"
	item_state = "cat"

/obj/item/holder/pai/mouse
	icon_state = "mouse_rest"
	item_state = "mouse"

/obj/item/holder/pai/monkey
	icon_state = "monkey"
	item_state = "monkey"

/obj/item/holder/pai/rabbit
	icon_state = "rabbit_rest"
	item_state = "rabbit"

//corgi





/obj/item/holder/monkey/farwa
	name = "farwa"
	desc = "A farwa."
	icon_state = "farwa"
	item_state = "farwa"
	slot_flags = SLOT_HEAD
	w_class = ITEM_SIZE_NORMAL

/obj/item/holder/monkey/stok
	name = "stok"
	desc = "A stok. stok."
	icon_state = "stok"
	item_state = "stok"
	slot_flags = SLOT_HEAD
	w_class = ITEM_SIZE_NORMAL

/obj/item/holder/monkey/neaera
	name = "neaera"
	desc = "A69eaera."
	icon_state = "neaera"
	item_state = "neaera"
	slot_flags = SLOT_HEAD
	w_class = ITEM_SIZE_NORMAL


/obj/item/holder/diona
	name = "diona69ymph"
	desc = "A little plant critter."
	desc_dead = "It used to be a little plant critter."
	icon = 'icons/mob/diona.dmi'
	icon_state = "nymph"
	icon_state_dead = "nymph_dead"
	origin_tech = list(TECH_MAGNET = 3, TECH_BIO = 5)
	slot_flags = SLOT_HEAD | SLOT_OCLOTHING
	w_class = ITEM_SIZE_SMALL
*/

//The block below is for resomi,69ot currently relevant
/*
/obj/item/holder/human/sync(var/mob/living/M)
	cut_overlays()
	// Generate appropriate on-mob icons.
	var/mob/living/carbon/human/owner =69
	if(!icon && istype(owner) && owner.species)
		var/icon/I =69ew /icon()

		var/skin_colour = rgb(owner.r_skin, owner.g_skin, owner.b_skin)
		var/hair_colour = rgb(owner.r_hair, owner.g_hair, owner.b_hair)
		var/eye_colour =  rgb(owner.r_eyes, owner.g_eyes, owner.b_eyes)
		var/species_name = lowertext(owner.species.get_bodytype())

		for(var/cache_entry in generate_for_slots)
			var/cache_key = "69owner.species69-69cache_entry69-69skin_colour69-69hair_colour69"
			if(!holder_mob_icon_cache69cache_key69)

				// Generate individual icons.
				var/icon/mob_icon = icon(holder_icon, "69species_name69_holder_69cache_entry69_base")
				mob_icon.Blend(skin_colour, ICON_ADD)
				var/icon/hair_icon = icon(holder_icon, "69species_name69_holder_69cache_entry69_hair")
				hair_icon.Blend(hair_colour, ICON_ADD)
				var/icon/eyes_icon = icon(holder_icon, "69species_name69_holder_69cache_entry69_eyes")
				eyes_icon.Blend(eye_colour, ICON_ADD)

				// Blend them together.
				mob_icon.Blend(eyes_icon, ICON_OVERLAY)
				mob_icon.Blend(hair_icon, ICON_OVERLAY)

				// Add to the cache.
				holder_mob_icon_cache69cache_key69 =69ob_icon

			var/newstate
			switch (cache_entry)
				if (slot_l_hand_str)
					newstate = "69species_name69_lh"
				if (slot_r_hand_str)
					newstate = "69species_name69_rh"
				if (slot_back_str)
					newstate = "69species_name69_ba"

			I.Insert(holder_mob_icon_cache69cache_key69,69ewstate)


		dir = 2
		var/icon/mob_icon = icon(owner.icon, owner.icon_state)
		I.Insert(mob_icon, species_name)
		icon = I
		icon_state = species_name
		item_state = species_name

		contained_sprite = 1

		color =69.color
		name =69.name
		desc =69.desc
		copy_overlays(M)
		update_wear_icon()

		..()
*/