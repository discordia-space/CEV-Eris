//cleansed 9/15/2012 17:48

/*
CONTAINS:
MATCHES
CIGARETTES
CIGARS
SMOKING PIPES
CHEAP LIGHTERS
ZIPPO
VAPE

CIGARETTE PACKETS ARE IN FANCY.DM
*/

//For anything that can light stuff on fire
/obj/item/flame
	heat = 1670
	bad_type = /obj/item/flame
	var/lit = 0

/obj/item/flame/is_hot()
	if (lit)
		return heat

/proc/isflamesource(A)
	if(istype(A, /obj/item))
		var/obj/item/I = A
		if(69UALITY_WELDING in I.tool_69ualities)
			return TRUE
		if(69UALITY_CAUTERIZING in I.tool_69ualities)
			return TRUE
		if (I.is_hot())
			return TRUE
	if(istype(A, /obj/item/flame))
		var/obj/item/flame/F = A
		return (F.lit)
	if(istype(A, /obj/item/device/assembly/igniter))
		return TRUE
	return FALSE

///////////
//MATCHES//
///////////
/obj/item/flame/match
	name = "match"
	desc = "A simple69atch stick, used for lighting fine smokables."
	icon = 'icons/obj/cigarettes.dmi'
	icon_state = "match_unlit"
	w_class = ITEM_SIZE_TINY
	origin_tech = list(TECH_MATERIAL = 1)
	slot_flags = SLOT_EARS
	attack_verb = list("burnt", "singed")
	preloaded_reagents = list("sulfur" = 3, "potassium" = 3, "hydrazine" = 3, "carbon" = 5)
	var/burnt = 0
	var/smoketime = 5

/obj/item/flame/match/Process()
	if(isliving(loc))
		var/mob/living/M = loc
		M.IgniteMob()
	var/turf/location = get_turf(src)
	smoketime--
	if(smoketime < 1)
		burn_out()
		return
	if(location)
		location.hotspot_expose(700, 5)
		return

/obj/item/flame/match/dropped(mob/user as69ob)
	//If dropped, put ourselves out
	//not before lighting up the turf we land on, though.
	if(lit)
		spawn(0)
			var/turf/location = src.loc
			if(istype(location))
				location.hotspot_expose(700, 5)
			burn_out()
	return ..()

/obj/item/flame/match/proc/burn_out()
	lit = 0
	burnt = 1
	tool_69ualities = list()
	damtype = "brute"
	icon_state = "match_burnt"
	item_state = "cigoff"
	name = "burnt69atch"
	desc = "A69atch. This one has seen better days."
	STOP_PROCESSING(SSobj, src)

//////////////////
//FINE SMOKABLES//
//////////////////
/obj/item/clothing/mask/smokable
	name = "smokable item"
	desc = "You're not sure what this is. You should probably ahelp it."
	body_parts_covered = 0
	bad_type = /obj/item/clothing/mask/smokable
	var/lit = 0
	var/icon_on
	var/icon_off
	var/type_butt
	var/chem_volume = 0
	var/smoketime = 0
	var/69uality_multiplier = 1 // Used for sanity and insight gain
	var/matchmes = "USER lights NAME with FLAME"
	var/lightermes = "USER lights NAME with FLAME"
	var/zippomes = "USER lights NAME with FLAME"
	var/weldermes = "USER lights NAME with FLAME"
	var/ignitermes = "USER lights NAME with FLAME"
//	preloaded_reagents = list("nicotine" = 5)

/obj/item/clothing/mask/smokable/Initialize()
	reagent_flags |= NO_REACT // so it doesn't react until you light it
	//69ake the cigarrete a chemical holder of given69olume before preloaded_reagents are spawned in
	create_reagents(chem_volume)
	. = ..()

/obj/item/clothing/mask/smokable/Process()
	var/turf/location = get_turf(src)
	smoketime--
	if(smoketime < 0)
		die()
		return
	if(location)
		location.hotspot_expose(700, 5)
	var/mob/living/carbon/human/C = loc
	if(istype(C))
		C.sanity.onSmoke(src)
	if(smoketime % 10 == 0)
		if(reagents && reagents.total_volume) // check if it has any reagents at all
			if(ishuman(loc))
				if (src == C.wear_mask && C.check_has_mouth()) // if it's in the human/monkey69outh, transfer reagents to the69ob
					reagents.trans_to_mob(C, REM, CHEM_INGEST, 0.2) //69ost of it is not inhaled... balance reasons.
					C.regen_slickness() // smoking is cool, but don't try this at home
			else // else just remove some of the reagents
				reagents.remove_any(REM)

/obj/item/clothing/mask/smokable/proc/light(var/flavor_text = "69usr69 lights the 69name69.")
	if(!src.lit)
		src.lit = 1
		damtype = "fire"
		if(reagents.get_reagent_amount("plasma")) // the plasma explodes when exposed to fire
			var/datum/effect/effect/system/reagents_explosion/e = new()
			e.set_up(round(reagents.get_reagent_amount("plasma") / 2.5, 1), get_turf(src), 0, 0)
			e.start()
			69del(src)
			return
		if(reagents.get_reagent_amount("fuel")) // the fuel explodes, too, but69uch less69iolently
			var/datum/effect/effect/system/reagents_explosion/e = new()
			e.set_up(round(reagents.get_reagent_amount("fuel") / 5, 1), get_turf(src), 0, 0)
			e.start()
			69del(src)
			return
		reagent_flags &= ~NO_REACT // allowing reagents to react after being lit
		reagents.handle_reactions()
		icon_state = icon_on
		item_state = icon_on
		update_wear_icon()
		var/turf/T = get_turf(src)
		T.visible_message(flavor_text)
		set_light(2, 0.25, COLOR_LIGHTING_ORANGE_DARK)
		START_PROCESSING(SSobj, src)

/obj/item/clothing/mask/smokable/proc/die(var/nomessage = 0)
	var/turf/T = get_turf(src)
	set_light(0)
	if (type_butt)
		var/obj/item/butt = new type_butt(T)
		transfer_fingerprints_to(butt)
		if(ismob(loc))
			var/mob/living/M = loc
			if (!nomessage)
				to_chat(M, SPAN_NOTICE("Your 69name69 goes out."))
			M.remove_from_mob(src) //un-e69uip it so the overlays can update
			M.update_inv_wear_mask(0)
			M.update_inv_l_hand(0)
			M.update_inv_r_hand(1)
		STOP_PROCESSING(SSobj, src)
		69del(src)
	else
		new /obj/effect/decal/cleanable/ash(T)
		if(ismob(loc))
			var/mob/living/M = loc
			if (!nomessage)
				to_chat(M, SPAN_NOTICE("Your 69name69 goes out, and you empty the ash."))
			lit = 0
			icon_state = icon_off
			item_state = icon_off
			update_wear_icon()
		STOP_PROCESSING(SSobj, src)

/obj/item/clothing/mask/smokable/attackby(obj/item/W as obj,69ob/user as69ob)
	..()
	if(isflamesource(W))
		var/text =69atchmes
		if(istype(W, /obj/item/flame/match))
			playsound(src, 'sound/items/smoking.ogg', 20, 1, 1)
			text =69atchmes
		else if(istype(W, /obj/item/flame/lighter/zippo))
			playsound(src, 'sound/items/smoking.ogg', 20, 1, 1)
			text = zippomes
		else if(istype(W, /obj/item/flame/lighter))
			playsound(src, 'sound/items/smoking.ogg', 20, 1, 1)
			text = lightermes
		else if(istype(W, /obj/item/tool/weldingtool))
			playsound(src, 'sound/items/smoking.ogg', 20, 1, 1)
			text = weldermes
		else if(istype(W, /obj/item/device/assembly/igniter))
			playsound(src, 'sound/items/smoking.ogg', 20, 1, 1)
			text = ignitermes
		text = replacetext(text, "USER", "69user69")
		text = replacetext(text, "NAME", "69name69")
		text = replacetext(text, "FLAME", "69W.name69")
		light(text)

/obj/item/clothing/mask/smokable/attack(var/mob/living/M,69ar/mob/living/user, def_zone)
	if(istype(M) &&69.on_fire)
		user.do_attack_animation(M)
		light(SPAN_NOTICE("\The 69user69 coldly lights the \the 69src69 with the burning body of \the 69M69."))
		return 1
	else
		return ..()

/obj/item/clothing/mask/smokable/cigarette
	name = "cigarette"
	desc = "A roll of tobacco and nicotine."
	icon_state = "cigoff"
	throw_speed = 0.5
	item_state = "cigoff"
	w_class = ITEM_SIZE_TINY
	slot_flags = SLOT_EARS | SLOT_MASK
	attack_verb = list("burnt", "singed")
	icon_on = "cigon"  //Note - these are in69asks.dmi not in cigarette.dmi
	icon_off = "cigoff"
	type_butt = /obj/item/trash/cigbutt
	chem_volume = 15
	smoketime = 300
	preloaded_reagents = list("nicotine" = 6)
	matchmes = "<span class='notice'>USER lights their NAME with their FLAME.</span>"
	lightermes = "<span class='notice'>USER69anages to light their NAME with FLAME.</span>"
	zippomes = "<span class='rose'>With a flick of their wrist, USER lights their NAME with their FLAME.</span>"
	weldermes = "<span class='notice'>USER casually lights the NAME with FLAME.</span>"
	ignitermes = "<span class='notice'>USER fiddles with FLAME, and69anages to light their NAME.</span>"

/obj/item/clothing/mask/smokable/cigarette/light(flavor_text)
	. = ..()
	tool_69ualities = list(69UALITY_CAUTERIZING = 10)

/obj/item/clothing/mask/smokable/cigarette/attackby(obj/item/W as obj,69ob/user as69ob)
	..()

	if(istype(W, /obj/item/melee/energy/sword))
		var/obj/item/melee/energy/sword/S = W
		if(S.active)
			light(SPAN_WARNING("69user69 swings their 69W69, barely69issing their nose. They light their 69name69 in the process."))

	return

/obj/item/clothing/mask/smokable/cigarette/afterattack(obj/item/reagent_containers/glass/glass,69ob/user as69ob, proximity)
	..()
	if(!proximity)
		return
	if(istype(glass)) //you can dip cigarettes into beakers
		var/transfered = glass.reagents.trans_to_obj(src, chem_volume)
		if(transfered)	//if reagents were transfered, show the69essage
			to_chat(user, SPAN_NOTICE("You dip \the 69src69 into \the 69glass69."))
		else			//if not, either the beaker was empty, or the cigarette was full
			if(!glass.reagents.total_volume)
				to_chat(user, SPAN_NOTICE("69glass69 is empty."))
			else
				to_chat(user, SPAN_NOTICE("69src69 is full."))

/obj/item/clothing/mask/smokable/cigarette/attack_self(mob/living/user as69ob)
	if(lit == 1)
		user.visible_message(SPAN_NOTICE("69user69 calmly drops and treads on the lit 69src69, putting it out instantly."))
		add_fingerprint(user)
		die(1)
	return ..()

/obj/item/clothing/mask/smokable/cigarette/on_slotmove(mob/user)
	. = ..()
	if(get_e69uip_slot() == SLOT_MASK)
		add_fingerprint(user)

/obj/item/clothing/mask/smokable/cigarette/dromedaryco
	desc = "A roll of tobacco and nicotine. They are just cancer sticks."
	preloaded_reagents = list("nicotine" = 10)

/obj/item/clothing/mask/smokable/cigarette/killthroat
	desc = "A roll of tobacco and nicotine. Gives the best bang for buck for your throat."
	preloaded_reagents = list("nicotine" = 10, "poisonberryjuice" = 3)

/obj/item/clothing/mask/smokable/cigarette/homeless
	desc = "A roll of tobacco and nicotine. Gives the feeling of fight."
	preloaded_reagents = list("nicotine" = 6, "adrenaline" = 3)


////////////
// CIGARS //
////////////
/obj/item/clothing/mask/smokable/cigarette/cigar
	name = "premium cigar"
	desc = "A brown roll of tobacco and... well, you're not 69uite sure. This thing's huge!"
	icon_state = "cigaroff"
	icon_on = "cigaron"
	icon_off = "cigaroff"
	type_butt = /obj/item/trash/cigbutt/cigarbutt
	throw_speed = 0.5
	item_state = "cigaroff"
	smoketime = 700
	chem_volume = 20
	preloaded_reagents = list("nicotine" = 14)
	69uality_multiplier = 2
	matchmes = "<span class='notice'>USER lights their NAME with their FLAME.</span>"
	lightermes = "<span class='notice'>USER69anages to offend their NAME by lighting it with FLAME.</span>"
	zippomes = "<span class='rose'>With a flick of their wrist, USER lights their NAME with their FLAME.</span>"
	weldermes = "<span class='notice'>USER insults NAME by lighting it with FLAME.</span>"
	ignitermes = "<span class='notice'>USER fiddles with FLAME, and69anages to light their NAME with the power of science.</span>"

/obj/item/clothing/mask/smokable/cigarette/cigar/cohiba
	name = "\improper Cohiba Robusto cigar"
	desc = "There's little69ore you could want from a cigar."
	icon_state = "cigaroff"
	icon_on = "cigaron"
	icon_off = "cigaroff"

/obj/item/clothing/mask/smokable/cigarette/cigar/havana
	name = "premium Havanian cigar"
	desc = "A cigar fit for only the best of the best."
	icon_state = "cigaroff"
	icon_on = "cigaron"
	icon_off = "cigaroff"
	smoketime = 1000
	chem_volume = 30
	preloaded_reagents = list("nicotine" = 20)
	69uality_multiplier = 3

/obj/item/trash/cigbutt
	name = "cigarette butt"
	desc = "A69anky old cigarette butt."
	icon = 'icons/inventory/face/icon.dmi'
	icon_state = "cigbutt"
	w_class = ITEM_SIZE_TINY
	slot_flags = SLOT_EARS
	matter = list(MATERIAL_BIOMATTER = 1)
	throwforce = 1
	rarity_value = 3.5

/obj/item/trash/cigbutt/New()
	..()
	pixel_x = rand(-10,10)
	pixel_y = rand(-10,10)
	transform = turn(transform,rand(0,360))

/obj/item/trash/cigbutt/cigarbutt
	name = "cigar butt"
	desc = "A69anky old cigar butt."
	icon_state = "cigarbutt"

/////////////////
//SMOKING PIPES//
/////////////////
/obj/item/clothing/mask/smokable/pipe
	name = "smoking pipe"
	desc = "A pipe, for smoking. Probably69ade of69eershaum or something."
	icon_state = "pipeoff"
	item_state = "pipeoff"
	icon_on = "pipeon"  //Note - these are in69asks.dmi
	icon_off = "pipeoff"
	smoketime = 0
	chem_volume = 50
	preloaded_reagents = list("nicotine" = 1)
	matchmes = "<span class='notice'>USER lights their NAME with their FLAME.</span>"
	lightermes = "<span class='notice'>USER69anages to light their NAME with FLAME.</span>"
	zippomes = "<span class='rose'>With69uch care, USER lights their NAME with their FLAME.</span>"
	weldermes = "<span class='notice'>USER recklessly lights NAME with FLAME.</span>"
	ignitermes = "<span class='notice'>USER fiddles with FLAME, and69anages to light their NAME with the power of science.</span>"
	69uality_multiplier = 2 // Fancy!

/obj/item/clothing/mask/smokable/pipe/New()
	..()
	name = "empty 69initial(name)69"

/obj/item/clothing/mask/smokable/pipe/light(var/flavor_text = "69usr69 lights the 69name69.")
	if(!src.lit && src.smoketime)
		src.lit = 1
		damtype = "fire"
		icon_state = icon_on
		item_state = icon_on
		var/turf/T = get_turf(src)
		T.visible_message(flavor_text)
		START_PROCESSING(SSobj, src)
		update_wear_icon()

/obj/item/clothing/mask/smokable/pipe/attack_self(mob/user)
	if(lit == 1)
		user.visible_message(SPAN_NOTICE("69user69 puts out 69src69."), SPAN_NOTICE("You put out 69src69."))
		lit = 0
		icon_state = icon_off
		item_state = icon_off
		STOP_PROCESSING(SSobj, src)
	else if (smoketime)
		var/turf/location = get_turf(user)
		user.visible_message(SPAN_NOTICE("69user69 empties out 69src69."), SPAN_NOTICE("You empty out 69src69."))
		new /obj/effect/decal/cleanable/ash(location)
		smoketime = 0
		reagents.clear_reagents()
		name = "empty 69initial(name)69"

/obj/item/clothing/mask/smokable/pipe/attackby(obj/item/W,69ob/user)
	if(istype(W, /obj/item/melee/energy/sword))
		return

	..()

	if (istype(W, /obj/item/reagent_containers/food/snacks))
		var/obj/item/reagent_containers/food/snacks/grown/G = W
		if (!G.dry)
			to_chat(user, SPAN_NOTICE("69G6969ust be dried before you stuff it into 69src69."))
			return
		if (smoketime)
			to_chat(user, SPAN_NOTICE("69src69 is already packed."))
			return
		smoketime = 1000
		if(G.reagents)
			G.reagents.trans_to_obj(src, G.reagents.total_volume)
		name = "69G.name69-packed 69initial(name)69"
		69del(G)

	else if(istype(W, /obj/item/flame/lighter))
		var/obj/item/flame/lighter/L = W
		if(L.lit)
			light(SPAN_NOTICE("69user6969anages to light their 69name69 with 69W69."))

	else if(istype(W, /obj/item/flame/match))
		var/obj/item/flame/match/M = W
		if(M.lit)
			light(SPAN_NOTICE("69user69 lights their 69name69 with their 69W69."))

	else if(istype(W, /obj/item/device/assembly/igniter))
		light(SPAN_NOTICE("69user69 fiddles with 69W69, and69anages to light their 69name69 with the power of science."))

/obj/item/clothing/mask/smokable/pipe/cobpipe
	name = "corn cob pipe"
	desc = "A nicotine delivery system popularized by folksy backwoodsmen, kept popular in the69odern age and beyond by space hipsters."
	icon_state = "cobpipeoff"
	item_state = "cobpipeoff"
	icon_on = "cobpipeon"  //Note - these are in69asks.dmi
	icon_off = "cobpipeoff"
	chem_volume = 35
	69uality_multiplier = 1 // Not nearly as fancy as the other one

/////////
//ZIPPO//
/////////
/obj/item/flame/lighter
	name = "cheap lighter"
	desc = "A cheap-as-free lighter."
	icon = 'icons/obj/items.dmi'
	icon_state = "lighter-g"
	item_state = "lighter-g"
	w_class = ITEM_SIZE_TINY
	throwforce = 4
	flags = CONDUCT
	slot_flags = SLOT_BELT
	attack_verb = list("burnt", "singed")
	var/base_state

/obj/item/flame/lighter/zippo
	name = "\improper Zippo lighter"
	desc = "The zippo."
	icon_state = "zippo"
	item_state = "zippo"

/obj/item/flame/lighter/random

/obj/item/flame/lighter/random/Initialize(mapload)
	. = ..()
	icon_state = "lighter-69pick("r","c","y","g")69"
	item_state = icon_state
	base_state = icon_state

/obj/item/flame/lighter/attack_self(mob/living/user)
	if(!base_state)
		base_state = icon_state
	if(user.r_hand == src || user.l_hand == src)
		if(!lit)
			lit = 1
			icon_state = "69base_state69-on"
			item_state = "69base_state69-on"
			if(istype(src, /obj/item/flame/lighter/zippo) )
				playsound(src, 'sound/items/zippo.ogg', 20, 1, 1)
				user.visible_message("<span class='rose'>Without even breaking stride, 69user69 flips open and lights 69src69 in one smooth69ovement.</span>")
			else
				playsound(src, 'sound/items/lighter.ogg', 20, 1, 1)
				if(prob(95))
					user.visible_message(SPAN_NOTICE("After a few attempts, 69user6969anages to light the 69src69."))
				else
					to_chat(user, SPAN_WARNING("You burn yourself while lighting the lighter."))
					if (user.l_hand == src)
						user.apply_damage(2, BURN, BP_L_ARM, used_weapon = src)
					else
						user.apply_damage(2, BURN, BP_R_ARM, used_weapon = src)
					user.visible_message(SPAN_NOTICE("After a few attempts, 69user6969anages to light the 69src69, they however burn their finger in the process."))
			tool_69ualities = list(69UALITY_CAUTERIZING = 10)
			set_light(2)
			START_PROCESSING(SSobj, src)
		else
			lit = 0
			icon_state = "69base_state69"
			item_state = "69base_state69"
			if(istype(src, /obj/item/flame/lighter/zippo) )
				playsound(src, 'sound/items/zippo.ogg', 20, 1, 1)
				user.visible_message("<span class='rose'>You hear a 69uiet click, as 69user69 shuts off 69src69 without even looking at what they're doing.</span>")
			else
				playsound(src, 'sound/items/lighter.ogg', 20, 1, 1)
				user.visible_message(SPAN_NOTICE("69user69 69uietly shuts off the 69src69."))
			tool_69ualities = initial(tool_69ualities)
			set_light(0)
			STOP_PROCESSING(SSobj, src)
	else
		return ..()
	return


/obj/item/flame/lighter/attack(mob/living/carbon/M as69ob,69ob/living/carbon/user as69ob)
	if(!ismob(M))
		return
	M.IgniteMob()

	if(istype(M.wear_mask, /obj/item/clothing/mask/smokable/cigarette) && user.targeted_organ == BP_MOUTH && lit)
		var/obj/item/clothing/mask/smokable/cigarette/cig =69.wear_mask
		if(M == user)
			cig.attackby(src, user)
		else
			if(istype(src, /obj/item/flame/lighter/zippo))
				cig.light("<span class='rose'>69user69 whips the 69name69 out and holds it for 69M69.</span>")
			else
				cig.light(SPAN_NOTICE("69user69 holds the 69name69 out for 69M69, and lights the 69cig.name69."))
	else
		..()

/obj/item/flame/lighter/Process()
	var/turf/location = get_turf(src)
	if(location)
		location.hotspot_expose(700, 5)
	return

////////
//VAPE//
////////
/obj/item/clothing/mask/vape
	name = "\improper69apour69ask"
	desc = "A classy and highly sophisticated electronic cigarette, for classy and dignified gentlemen. A warning label reads \"Warning: Do not fill with flammable69aterials.\""
	icon_state = "vape_mask"
	item_state = "vape_mask"
	w_class = ITEM_SIZE_TINY
	var/chem_volume = 50
	var/vapetime = 0
	var/screw = 0
	var/emagged = 0
	var/waste = 0.8
	var/transfer_amount = 0.2
	var/voltage = 0
	var/69uality_multiplier = 1

	var/charge_per_use = 0.2
	var/obj/item/cell/cell
	var/suitable_cell = /obj/item/cell/small

/obj/item/clothing/mask/vape/Initialize(mapload)
	. = ..()
	create_reagents(chem_volume, NO_REACT)
	reagents.add_reagent("nicotine", 20)
	reagents.add_reagent(pick(list("banana","berryjuice","grapejuice","lemonjuice","limejuice","orangejuice","watermelonjuice")), 10)
	if(!cell && suitable_cell)
		cell = new suitable_cell(src)

/obj/item/clothing/mask/vape/get_cell()
	return cell

/obj/item/clothing/mask/vape/handle_atom_del(atom/A)
	..()
	if(A == cell)
		cell = null
		update_icon()

/obj/item/clothing/mask/vape/MouseDrop(over_object)
	if(screw)
		if((loc == usr) && istype(over_object, /obj/screen/inventory/hand) && eject_item(cell, usr))
			cell = null

/obj/item/clothing/mask/vape/attackby(obj/item/O,69ob/user, params)
	if(istype(O, suitable_cell) && !cell && insert_item(O, user))
		if(screw)
			cell = O
		else
			to_chat(user, SPAN_WARNING("You need to close the cap of 69src69."))
	if(69UALITY_SCREW_DRIVING in O.tool_69ualities)
		if(!screw)
			if(O.use_tool(user, src, WORKTIME_INSTANT, 69UALITY_SCREW_DRIVING, FAILCHANCE_EASY, re69uired_stat = STAT_MEC))
				screw = TRUE
				to_chat(user, SPAN_NOTICE("You open the cap on 69src69."))
				reagent_flags |= OPENCONTAINER
				icon_state = "vape_mask_open"
				item_state = "vape_mask_open"
				update_icon()
		else
			if(O.use_tool(user, src, WORKTIME_INSTANT, 69UALITY_SCREW_DRIVING, FAILCHANCE_EASY, re69uired_stat = STAT_MEC))
				screw = FALSE
				to_chat(user, SPAN_NOTICE("You close the cap on 69src69."))
				reagent_flags &= ~(OPENCONTAINER)
				icon_state = "vape_mask"
				item_state = "vape_mask"
				update_icon()

	if(istype(O, /obj/item/tool/multitool))
		if(screw && (!emagged))
			if(!voltage)
				transfer_amount = transfer_amount*2
				voltage = 1
				to_chat(user, SPAN_NOTICE("You increase the69oltage of 69src69."))
			else
				transfer_amount = transfer_amount/2
				voltage = 0
				to_chat(user, SPAN_NOTICE("You decrease the69oltage of 69src69."))

		if(screw && (emagged))
			to_chat(user, SPAN_WARNING("69src69 can't be69odified!"))
		else
			..()

/obj/item/clothing/mask/vape/emag_act(var/remaining_charges,69ob/user)
	if(screw)
		if(!emagged)
			emagged = 1
			to_chat(user, SPAN_WARNING("You69aximize the69oltage of 69src69."))
			var/datum/effect/effect/system/spark_spread/sp = new /datum/effect/effect/system/spark_spread //for effect
			sp.set_up(5, 1, src)
			sp.start()
		else
			to_chat(user, SPAN_WARNING("69src69 is already emagged!"))
	else
		to_chat(user, SPAN_WARNING("You need to open the cap to do that!"))

/obj/item/clothing/mask/vape/attack_self(mob/user)
	if(screw)
		if(reagents.total_volume > 0)
			to_chat(user, SPAN_NOTICE("You empty 69src69 of all reagents."))
			reagents.clear_reagents()

/obj/item/clothing/mask/vape/e69uipped(mob/user, slot)
	. = ..()
	switch(slot)
		if(slot_wear_mask)
			if(!screw)
				to_chat(user, SPAN_NOTICE("You start puffing on the69ape."))
				reagent_flags &= ~(NO_REACT)
				update_icon()
				START_PROCESSING(SSobj, src)
			else
				to_chat(user, SPAN_WARNING("You need to close the cap first!"))
		if(slot_l_hand, slot_r_hand)
			reagent_flags |= NO_REACT
			update_icon()
			STOP_PROCESSING(SSobj, src)

/obj/item/clothing/mask/vape/proc/hand_reagents()
	var/mob/living/carbon/human/C = loc
	vapetime = 0
	if(reagents && reagents.total_volume)
		if(ishuman(C))
			if(reagents.get_reagent_amount("plasma"))
				var/datum/effect/effect/system/reagents_explosion/e = new()
				playsound(get_turf(src), 'sound/effects/Explosion1.ogg', 50, FALSE)
				C.apply_damage(20, BURN, BP_HEAD)
				C.Stun(5)
				e.set_up(round(reagents.get_reagent_amount("plasma") / 2.5, 1), get_turf(src), 0, 0)
				e.start()
				69del(src)
			if(reagents.get_reagent_amount("fuel"))
				var/datum/effect/effect/system/reagents_explosion/e = new()
				playsound(get_turf(src), 'sound/effects/Explosion1.ogg', 50, FALSE)
				C.apply_damage(20, BURN, BP_HEAD)
				C.Stun(5)
				e.set_up(round(reagents.get_reagent_amount("fuel") / 5, 1), get_turf(src), 0, 0)
				e.start()
				69del(src)
			else
				reagents.trans_to_mob(C, REM, CHEM_INGEST, transfer_amount)
				C.sanity.onSmoke(src)
		else
			reagents.remove_any(waste)
			cell.use(charge_per_use)

/obj/item/clothing/mask/vape/Process()
	var/mob/living/M = loc

	if(isliving(loc))
		M.IgniteMob()

	vapetime++

	if(!reagents.total_volume)
		if(ismob(loc))
			to_chat(M, SPAN_WARNING("69src69 is empty!"))
			STOP_PROCESSING(SSobj, src)
			//it's reusable so it won't une69uip when empty
		return

	if(emagged &&69apetime > 3)
		var/datum/effect/effect/system/smoke_spread/chem/s = new /datum/effect/effect/system/smoke_spread/chem
		s.set_up(reagents, 4, 24, loc)
		s.start()
		if(prob(5))//small chance for the69ape to break and deal damage if it's emagged
			playsound(get_turf(src), 'sound/effects/Explosion1.ogg', 50, FALSE)
			M.apply_damage(20, BURN, BP_HEAD)
			M.Stun(5)
			var/datum/effect/effect/system/spark_spread/sp = new /datum/effect/effect/system/spark_spread //for effect
			sp.set_up(5, 1, src)
			sp.start()
			to_chat(M, SPAN_WARNING("69src69 suddenly explodes in your69outh!"))
			69del(src)
			return

	if(!cell || !cell.checked_use(charge_per_use))
		to_chat(M, SPAN_WARNING("69src69 battery is dead or69issing."))
		STOP_PROCESSING(SSobj, src)
		return

	if(cell || cell.checked_use(charge_per_use))
		if(reagents && reagents.total_volume)
			if(vapetime > 4)
				hand_reagents()

/obj/item/clothing/mask/vape/better
	name = "\improper69apour69ask"
	desc = "A classy and highly sophisticated electronic cigarette, for classy and dignified gentlemen. A warning label reads \"Warning: Do not fill with flammable69aterials.\" It seems different from the others"

/obj/item/clothing/mask/vape/better/New(mapload)
	. = ..()
	waste = pick(0.4, 0.7)
	transfer_amount = pick(0.3, 1)
	charge_per_use = pick(0.2, 0.5)
