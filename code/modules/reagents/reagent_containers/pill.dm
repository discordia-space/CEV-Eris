////////////////////////////////////////////////////////////////////////////////
/// Pills.
////////////////////////////////////////////////////////////////////////////////
/obj/item/reagent_containers/pill
	name = "pill"
	desc = "A pill."
	icon = 'icons/obj/chemical.dmi'
	icon_state =69ull
	item_state = "pill"
	possible_transfer_amounts =69ull
	w_class = ITEM_SIZE_TINY
	slot_flags = SLOT_EARS
	volume = 60
	matter = list(MATERIAL_BIOMATTER = 1)
	bad_type = /obj/item/reagent_containers/pill

/obj/item/reagent_containers/pill/Initialize()
	. = ..()
	if(!icon_state)
		icon_state = "pill69rand(1, 20)69"


/obj/item/reagent_containers/pill/attack(mob/M as69ob,69ob/user as69ob, def_zone)
	standard_feed_mob(user,69)

/obj/item/reagent_containers/pill/self_feed_message(var/mob/user)
	to_chat(user, SPAN_NOTICE("You swallow \the 69src69."))

/obj/item/reagent_containers/pill/other_feed_message_start(var/mob/user,69ar/mob/target)
	user.visible_message("<span class='warning'>69user69 attempts to force 69target69 to swallow \the 69src69.</span>")

/obj/item/reagent_containers/pill/other_feed_message_finish(var/mob/user,69ar/mob/target)
	user.visible_message("<span class='warning'>69user69 forces 69target69 to swallow \the 69src69.</span>")

/obj/item/reagent_containers/pill/afterattack(obj/target,69ob/user, proximity)
	if(!proximity) return

	..()

	if(target.is_refillable())
		if(!target.reagents.total_volume)
			to_chat(user, SPAN_NOTICE("69target69 is empty. Can't dissolve \the 69src69."))
			return
		to_chat(user, SPAN_NOTICE("You dissolve \the 69src69 in 69target69."))

		user.attack_log += text("\6969time_stamp()69\69 <font color='red'>Spiked \a 69target69 with a pill. Reagents: 69reagents.log_list()69</font>")
		msg_admin_attack("69user.name69 (69user.ckey69) spiked \a 69target69 with a pill. Reagents: 69reagents.log_list()69 (INTENT: 69uppertext(user.a_intent)69) (<A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=69user.x69;Y=69user.y69;Z=69user.z69'>JMP</a>)")

		reagents.trans_to(target, reagents.total_volume)
		for(var/mob/O in69iewers(2, user))
			if(!user.stats.getPerk(PERK_FAST_FINGERS))
				O.show_message(SPAN_WARNING("69user69 puts something in \the 69target69."), 1)

		69del(src)


////////////////////////////////////////////////////////////////////////////////
/// Pills. END
////////////////////////////////////////////////////////////////////////////////

//Pills
/obj/item/reagent_containers/pill/antitox
	name = "Anti-toxins pill"
	desc = "Neutralizes69any common toxins."
	icon_state = "pill17"
	preloaded_reagents = list("anti_toxin" = 25)


/obj/item/reagent_containers/pill/tox
	name = "Toxins pill"
	desc = "Highly toxic."
	icon_state = "pill5"
	preloaded_reagents = list("toxin" = 50)


/obj/item/reagent_containers/pill/cyanide
	name = "Cyanide pill"
	desc = "Don't swallow this."
	icon_state = "pill5"
	preloaded_reagents = list("cyanide" = 50)


/obj/item/reagent_containers/pill/adminordrazine
	name = "Adminordrazine pill"
	desc = "It's69agic. We don't have to explain it."
	icon_state = "pill16"
	preloaded_reagents = list("adminordrazine" = 50)

/obj/item/reagent_containers/pill/stox
	name = "Sleeping pill"
	desc = "Commonly used to treat insomnia."
	icon_state = "pill8"
	preloaded_reagents = list("stoxin" = 15)


/obj/item/reagent_containers/pill/kelotane
	name = "Kelotane pill"
	desc = "Used to treat burns."
	icon_state = "pill11"
	preloaded_reagents = list("kelotane" = 15)


/obj/item/reagent_containers/pill/paracetamol
	name = "Paracetamol pill"
	desc = "Tylenol! A painkiller for the ages. Chewables!"
	icon_state = "pill8"
	preloaded_reagents = list("paracetamol" = 15)


/obj/item/reagent_containers/pill/tramadol
	name = "Tramadol pill"
	desc = "A simple painkiller."
	icon_state = "pill8"
	preloaded_reagents = list("tramadol" = 15)

/obj/item/reagent_containers/pill/oxycodone
	name = "Oxycodone pill"
	desc = "The heavy artillery of painkillers."
	icon_state = "pill8"
	preloaded_reagents = list("oxycodone" = 10)


/obj/item/reagent_containers/pill/methylphenidate
	name = "Methylphenidate pill"
	desc = "Improves the ability to concentrate."
	icon_state = "pill8"
	preloaded_reagents = list("methylphenidate" = 15)


/obj/item/reagent_containers/pill/citalopram
	name = "Citalopram pill"
	desc = "Mild anti-depressant."
	icon_state = "pill8"
	preloaded_reagents = list("citalopram" = 15)


/obj/item/reagent_containers/pill/inaprovaline
	name = "Inaprovaline pill"
	desc = "Used to stabilize patients."
	icon_state = "pill20"
	preloaded_reagents = list("inaprovaline" = 30)


/obj/item/reagent_containers/pill/dexalin
	name = "Dexalin pill"
	desc = "Used to treat oxygen deprivation."
	icon_state = "pill16"
	preloaded_reagents = list("dexalin" = 15)


/obj/item/reagent_containers/pill/dexalin_plus
	name = "Dexalin Plus pill"
	desc = "Used to treat extreme oxygen deprivation."
	icon_state = "pill8"
	preloaded_reagents = list("dexalinp" = 15)


/obj/item/reagent_containers/pill/dermaline
	name = "Dermaline pill"
	desc = "Used to treat burn wounds."
	icon_state = "pill12"
	preloaded_reagents = list("dermaline" = 15)


/obj/item/reagent_containers/pill/dylovene
	name = "Dylovene pill"
	desc = "A broad-spectrum anti-toxin."
	icon_state = "pill13"
	preloaded_reagents = list("anti_toxin" = 15)


/obj/item/reagent_containers/pill/inaprovaline
	name = "Inaprovaline pill"
	desc = "Used to stabilize patients."
	icon_state = "pill20"
	preloaded_reagents = list("inaprovaline" = 30)


/obj/item/reagent_containers/pill/bicaridine
	name = "Bicaridine pill"
	desc = "Used to treat physical injuries."
	icon_state = "pill18"
	preloaded_reagents = list("bicaridine" = 20)


/obj/item/reagent_containers/pill/happy
	name = "Happy pill"
	desc = "Happy happy joy joy!"
	icon_state = "pill18"
	preloaded_reagents = list("space_drugs" = 15, "sugar" = 15)


/obj/item/reagent_containers/pill/zoom
	name = "Zoom pill"
	desc = "Zoooom!"
	icon_state = "pill18"
	preloaded_reagents = list("impedrezene" = 10, "synaptizine" = 5, "hyperzine" = 5)


/obj/item/reagent_containers/pill/spaceacillin
	name = "Spaceacillin pill"
	desc = "Contains antiviral agents."
	icon_state = "pill19"
	preloaded_reagents = list("spaceacillin" = 15)


/obj/item/reagent_containers/pill/prosurgeon
	name = "ProSurgeon pill"
	desc = "Contains a stimulating drug that is used to reduce tremor to69inimum."
	icon_state = "pill3"
	preloaded_reagents = list("prosurgeon" = 10)

/obj/item/reagent_containers/pill/meralyne
	name = "Meralyne pill"
	desc = "Contains a powerful69edicine that is used to treat severe physical trauma."
	icon_state = "pill3"
	preloaded_reagents = list("meralyne" = 10)

//Pills with random content
/obj/item/reagent_containers/pill/floorpill
	name = "floor pill"
	desc = "Dare you?"
	rarity_value = 4
	spawn_tags = SPAWN_TAG_JUNK

/obj/item/reagent_containers/pill/floorpill/Initialize()
	. = ..()

	var/random_reagent = pickweight(list(
					list("spaceacillin" = 15) = 2,\
					list("inaprovaline" = 30) = 2,\
					list("anti_toxin" = 15) = 2,\
					list("methylphenidate" = 15) = 2,\
					list("paracetamol" = 15) = 2,\
					list("dexalin" = 15) = 2,\
					list("dexalinp" = 15) = 2,\
					list("impedrezene" = 10, "synaptizine" = 5, "hyperzine" = 5, "citalopram" = 15) = 1,\
					list("space_drugs" = 15, "sugar" = 15) = 1,\
					list("dermaline" = 15, "citalopram" = 15) = 1,\
					list("tramadol" = 15, "spaceacillin" = 15) = 1,\
					list("blattedin" = 15) = 1,\
					list("imidazoline" = 15, "space_drugs" = 15) = 1,\
					list("ethylredoxrazine" = 15, "hyperzine" = 35) = 1,\
					list("potassium_chlorophoride" = 15) = 1,\
					list("mindbreaker" = 15, "synaptizine" = 5) = 1,\
					list("plantbgone" = 15, "cleaner" = 15) = 1,\
					list("coolant" = 50) = 1,\
					list("fuel" = 50) = 1,\
					list("water" = 15) = 1,\
					list("sterilizine" = 50) = 1,\
					list("tramadol" = 15, "sugar" = 15) = 1,\
					list("thermite" = 15) = 1,\
					list("lube" = 50) = 1,\
					list("pacid" = 15) = 1,\
					list("sacid" = 15) = 1,\
					list("hclacid" = 15) = 1,\
					list("impedrezene" = 15, "dexalinp" = 35) = 1,\
					list("virusfood" = 15) = 1,\
					list("leporazine" = 15) = 1,\
					list("anti_toxin" = 15, "zombiepowder" = 10) = 0.5,\
					list("dexalinp" = 35, "cyanide" = 15) = 0.5,\
					list("toxin" = 40, "cyanide" = 10) = 0.5))

	for(var/reagent in random_reagent)
		reagents.add_reagent(reagent, random_reagent69reagent69)
