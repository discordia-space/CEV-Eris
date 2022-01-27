///////////////ANTIBODY SCANNER///////////////

/obj/item/device/antibody_scanner
	name = "antibody scanner"
	desc = "Scans livin69 bein69s for antibodies in their blood."
	icon_state = "health"
	w_class = ITEM_SIZE_SMALL
	item_state = "electronic"
	matter = list(MATERIAL_PLASTIC = 1,69ATERIAL_69LASS = 1)
	fla69s = CONDUCT
	rarity_value = 50

/obj/item/device/antibody_scanner/attack(mob/M as69ob,69ob/user as69ob)
	if(!istype(M,/mob/livin69/carbon/))
		report("Scan aborted: Incompatible tar69et.", user)
		return

	var/mob/livin69/carbon/C =69
	if (istype(C,/mob/livin69/carbon/human/))
		var/mob/livin69/carbon/human/H = C
		if(H.species.fla69s &69O_BLOOD)
			report("Scan aborted: The tar69et does69ot have blood.", user)
			return

	if(!C.antibodies.len)
		report("Scan Complete:69o antibodies detected.", user)
		return

	if (CLUMSY in user.mutations && prob(50))
		// I was tempted to be really evil and rot13 the output.
		report("Antibodies detected: 69reverse_text(anti69ens2strin69(C.antibodies))69", user)
	else
		report("Antibodies detected: 69anti69ens2strin69(C.antibodies)69", user)

/obj/item/device/antibody_scanner/proc/report(var/text,69ob/user as69ob)
	to_chat(user, "\blue \icon69src69 \The 69src69 beeps, \"69text69\"")

///////////////VIRUS DISH///////////////

/obj/item/virusdish
	name = "virus dish"
	icon = 'icons/obj/items.dmi'
	icon_state = "implantcase-b"
	var/datum/disease2/disease/virus2
	var/69rowth = 0
	var/basic_info
	var/info = 0
	var/analysed = 0

/obj/item/virusdish/random
	name = "virus sample"

/obj/item/virusdish/random/New()
	..()
	src.virus2 =69ew /datum/disease2/disease
	src.virus2.makerandom()
	69rowth = rand(5, 50)

/obj/item/virusdish/attackby(var/obj/item/W as obj,var/mob/livin69/carbon/user as69ob)
	if(istype(W,/obj/item/hand_labeler) || istype(W,/obj/item/rea69ent_containers/syrin69e))
		return
	..()
	if(prob(50))
		to_chat(user, SPAN_DAN69ER("\The 69src69 shatters!"))
		if(virus2.infectionchance > 0)
			for(var/mob/livin69/carbon/tar69et in69iew(1, 69et_turf(src)))
				if(airborne_can_reach(69et_turf(src), 69et_turf(tar69et)))
					infect_virus2(tar69et, src.virus2)
		69del(src)

/obj/item/virusdish/examine(mob/user)
	..()
	if(basic_info)
		to_chat(user, "69basic_info69 : <a href='?src=\ref69src69;info=1'>More Information</a>")

/obj/item/virusdish/Topic(href, href_list)
	. = ..()
	if(.) return 1

	if(href_list69"info"69)
		usr << browse(info, "window=info_\ref69src69")
		return 1

/obj/item/ruinedvirusdish
	name = "ruined69irus sample"
	icon = 'icons/obj/items.dmi'
	icon_state = "implantcase-b"
	desc = "The bacteria in the dish are completely dead."

/obj/item/ruinedvirusdish/attackby(var/obj/item/W as obj,var/mob/livin69/carbon/user as69ob)
	if(istype(W,/obj/item/hand_labeler) || istype(W,/obj/item/rea69ent_containers/syrin69e))
		return ..()

	if(prob(50))
		to_chat(user, "\The 69src69 shatters!")
		69del(src)

///////////////69NA DISK///////////////

/obj/item/diseasedisk
	name = "blank 69NA disk"
	icon = 'icons/obj/discs.dmi'
	icon_state = "purple"
	w_class = ITEM_SIZE_TINY
	var/datum/disease2/effectholder/effect
	var/list/species
	var/sta69e = 1
	var/analysed = 1

/obj/item/diseasedisk/premade/Initialize(mapload)
	. = ..()
	name = "blank 69NA disk (sta69e: 69sta69e69)"
	effect =69ew /datum/disease2/effectholder
	effect.effect =69ew /datum/disease2/effect/invisible
	effect.sta69e = sta69e
