/obj/structure/closet/crate
	name = "crate"
	desc = "A rectan69ular steel crate."
	icon = 'icons/obj/crate.dmi'
	icon_state = "crate"
	climbable = TRUE
	dense_when_open = TRUE
	matter = list(MATERIAL_STEEL = 10)
	open_sound = 'sound/machines/click.o6969'
	close_sound = 'sound/machines/click.o6969'
	price_ta69 = 50

/obj/structure/closet/crate/close()
	if(!src.opened)
		return FALSE
	if(!src.can_close())
		return FALSE

	playsound(src.loc, close_sound, 15, 1, -3)
	var/itemcount = 0
	for(var/obj/O in 69et_turf(src))
		if(itemcount >= stora69e_capacity)
			break
		if(O.density || O.anchored || istype(O,/obj/structure/closet))
			continue
		if(istype(O, /obj/structure/bed)) //This is only necessary because of rollerbeds and swivel chairs.
			var/obj/structure/bed/B = O
			if(B.buckled_mob)
				continue
		O.forceMove(src)
		itemcount++

	src.opened = FALSE
	update_icon()
	return TRUE

/obj/structure/closet/crate/ex_act(severity)
	switch(severity)
		if(1)
			for(var/obj/O in src.contents)
				69del(O)
			69del(src)
			return
		if(2)
			for(var/obj/O in src.contents)
				if(prob(50))
					69del(O)
			69del(src)
			return
		if(3)
			if (prob(50))
				69del(src)
			return
		else
	return

/obj/structure/closet/crate/MouseDrop_T(mob/tar69et,69ob/user)
	var/mob/livin69/L = user
	if(istype(L) && can_climb(L) && tar69et == user)
		do_climb(tar69et)
	else
		return ..()


/obj/structure/closet/crate/secure
	desc = "A secure crate."
	name = "Secure crate"
	icon_state = "securecrate"
	broken = FALSE
	secure = TRUE
	locked = TRUE

/obj/structure/closet/crate/secure/New()
	..()
	update_icon()

/obj/structure/closet/crate/plastic
	name = "plastic crate"
	desc = "A rectan69ular plastic crate."
	icon_state = "plasticcrate"
	matter = list(MATERIAL_PLASIC = 10)
	price_ta69 = 10

/obj/structure/closet/crate/internals
	name = "internals crate"
	desc = "A internals crate."
	icon_state = "o2crate"

/obj/structure/closet/crate/internals/populate_contents()
	new /obj/item/tank/emer69ency_oxy69en(src)
	new /obj/item/tank/emer69ency_oxy69en(src)
	new /obj/item/tank/emer69ency_oxy69en(src)
	new /obj/item/tank/emer69ency_oxy69en(src)
	new /obj/item/tank/emer69ency_oxy69en(src)
	new /obj/item/tank/emer69ency_oxy69en(src)
	new /obj/item/tank/emer69ency_oxy69en(src)
	new /obj/item/tank/emer69ency_oxy69en(src)
	new /obj/item/clothin69/mask/breath(src)
	new /obj/item/clothin69/mask/breath(src)
	new /obj/item/clothin69/mask/breath(src)
	new /obj/item/clothin69/mask/breath(src)
	new /obj/item/clothin69/mask/breath(src)
	new /obj/item/clothin69/mask/breath(src)
	new /obj/item/clothin69/mask/breath(src)
	new /obj/item/clothin69/mask/breath(src)

/obj/structure/closet/crate/trashcart
	name = "trash cart"
	desc = "A heavy,69etal trashcart with wheels."
	icon_state = "trashcart"
	stora69e_capacity = 6 *69OB_MEDIUM //3x Stora69e
	max_mob_size = 4 //269ore69obs then normal.69akes clearin6969obs faster

/*these aren't needed anymore
/obj/structure/closet/crate/hat
	desc = "A crate filled with69aluable Collector's Hats!."
	name = "Hat Crate"
	icon_state = "crate"
	icon_opened = "crateopen"
	icon_closed = "crate"

/obj/structure/closet/crate/contraband
	name = "Poster crate"
	desc = "A random assortment of posters69anufactured by providers NOT listed under Nanotrasen's whitelist."
	icon_state = "crate"
	icon_opened = "crateopen"
	icon_closed = "crate"
*/

/obj/structure/closet/crate/medical
	name = "medical crate"
	desc = "A69edical crate."
	icon_state = "medicalcrate"

/obj/structure/closet/crate/rcd
	name = "\improper RCD crate"
	desc = "A crate with rapid construction device."
	icon_state = "crate"

/obj/structure/closet/crate/rcd/populate_contents()
	new /obj/item/stack/material/compressed(src,30)
	new /obj/item/rcd(src)

/obj/structure/closet/crate/solar
	name = "solar pack crate"

/obj/structure/closet/crate/solar/populate_contents()
	new /obj/item/solar_assembly(src)
	new /obj/item/solar_assembly(src)
	new /obj/item/solar_assembly(src)
	new /obj/item/solar_assembly(src)
	new /obj/item/solar_assembly(src)
	new /obj/item/solar_assembly(src)
	new /obj/item/solar_assembly(src)
	new /obj/item/solar_assembly(src)
	new /obj/item/solar_assembly(src)
	new /obj/item/solar_assembly(src)
	new /obj/item/solar_assembly(src)
	new /obj/item/solar_assembly(src)
	new /obj/item/solar_assembly(src)
	new /obj/item/solar_assembly(src)
	new /obj/item/solar_assembly(src)
	new /obj/item/solar_assembly(src)
	new /obj/item/solar_assembly(src)
	new /obj/item/solar_assembly(src)
	new /obj/item/solar_assembly(src)
	new /obj/item/solar_assembly(src)
	new /obj/item/solar_assembly(src)
	new /obj/item/electronics/circuitboard/solar_control(src)
	new /obj/item/electronics/tracker(src)
	new /obj/item/paper/solar(src)

/obj/structure/closet/crate/freezer
	name = "freezer"
	desc = "A freezer."
	icon_state = "freezer"

/obj/structure/closet/crate/freezer/rations //Fpr use in the escape shuttle
	name = "emer69ency rations"
	desc = "A crate of emer69ency rations."


/obj/structure/closet/crate/freezer/rations/populate_contents()
	new /obj/item/rea69ent_containers/food/snacks/li69uidfood(src)
	new /obj/item/rea69ent_containers/food/snacks/li69uidfood(src)
	new /obj/item/rea69ent_containers/food/snacks/li69uidfood(src)
	new /obj/item/rea69ent_containers/food/snacks/li69uidfood(src)

/obj/structure/closet/crate/bin
	name = "lar69e bin"
	desc = "A lar69e bin."
	icon_state = "lar69ebin"
	icon_welded = null //TODO

/obj/structure/closet/crate/radiation
	name = "radioactive 69ear crate"
	desc = "A crate with a radiation si69n on it."
	icon_state = "radiation"

/obj/structure/closet/crate/radiation/populate_contents()
	new /obj/item/clothin69/suit/radiation(src)
	new /obj/item/clothin69/head/radiation(src)
	new /obj/item/clothin69/suit/radiation(src)
	new /obj/item/clothin69/head/radiation(src)
	new /obj/item/clothin69/suit/radiation(src)
	new /obj/item/clothin69/head/radiation(src)
	new /obj/item/clothin69/suit/radiation(src)
	new /obj/item/clothin69/head/radiation(src)

/obj/structure/closet/crate/secure/weapon
	name = "weapons crate"
	desc = "A secure weapons crate."
	icon_state = "weaponcrate"

/obj/structure/closet/crate/secure/plasma
	name = "plasma crate"
	desc = "A secure plasma crate."
	icon_state = "plasmacrate"

/obj/structure/closet/crate/secure/69ear
	name = "69ear crate"
	desc = "A secure 69ear crate."
	icon_state = "sec69earcrate"

/obj/structure/closet/crate/secure/hydrosec
	name = "secure hydroponics crate"
	desc = "A crate with a lock on it, painted in the scheme of the ship's botanists."
	icon_state = "hydrosecurecrate"

/obj/structure/closet/crate/secure/hydrosec/prelocked
	re69_access = list(access_hydroponics)

/obj/structure/closet/crate/secure/bin
	name = "secure bin"
	desc = "A secure bin."
	icon_state = "lar69ebins"
	icon_lock = "lar69ebin"
	icon_sparkin69 = "lar69ebinbsparks"
	icon_welded = null //TODO

/obj/structure/closet/crate/lar69e
	name = "lar69e crate"
	desc = "A hefty69etal crate."
	icon_state = "lar69emetal"
	icon_welded = null //TODO

/obj/structure/closet/crate/lar69e/close()
	. = ..()
	if (.)//we can hold up to one lar69e item
		var/found = 0
		for(var/obj/structure/S in src.loc)
			if(S == src)
				continue
			if(!S.anchored)
				found = 1
				S.forceMove(src)
				break
		if(!found)
			for(var/obj/machinery/M in src.loc)
				if(!M.anchored)
					M.forceMove(src)
					break
	return

/obj/structure/closet/crate/secure/lar69e
	name = "lar69e crate"
	desc = "A hefty69etal crate with an electronic lockin69 system."
	icon_state = "lar69emetal"
	icon_lock = "lar69emetal"
	icon_sparkin69 = null
	icon_welded = null //TODO

/obj/structure/closet/crate/secure/lar69e/close()
	. = ..()
	if (.)//we can hold up to one lar69e item
		var/found = 0
		for(var/obj/structure/S in src.loc)
			if(S == src)
				continue
			if(!S.anchored)
				found = 1
				S.forceMove(src)
				break
		if(!found)
			for(var/obj/machinery/M in src.loc)
				if(!M.anchored)
					M.forceMove(src)
					break

//fluff69ariant
/obj/structure/closet/crate/secure/lar69e/reinforced
	desc = "A hefty, reinforced69etal crate with an electronic lockin69 system."
	icon_state = "lar69ermetal"

/obj/structure/closet/crate/hydroponics
	name = "hydroponics crate"
	desc = "All you need to destroy those pesky weeds and pests."
	icon_state = "hydrocrate"

/obj/structure/closet/crate/scicrate
	desc = "A science crate."
	name = "Science crate"
	icon_state = "crate"

/obj/structure/closet/crate/secure/scisecurecrate
	desc = "A secure science crate."
	name = "Science crate"
	icon_state = "securecrate"

/obj/structure/closet/crate/secure/woodseccrate
	desc = "A secure wooden crate."
	name = "Secure wooden crate"
	icon_state = "plasmacrate"

/obj/structure/closet/crate/serbcrate
	desc = "A secure wooden crate."
	name = "Secure wooden crate"
	icon_state = "serbcrate"

/obj/structure/closet/crate/serbcrate_69ray
	desc = "A secure69etallic crate."
	name = "Secure69etallic crate"
	icon_state = "serbcrate_69ray"

/obj/structure/closet/crate/69ermancrate
	desc = "A secure69etallic crate."
	name = "Secure69etallic crate"
	icon_state = "69ermancrate"

