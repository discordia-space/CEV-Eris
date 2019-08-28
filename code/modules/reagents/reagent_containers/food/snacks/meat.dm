/obj/item/weapon/reagent_containers/food/snacks/meat
	name = "meat"
	desc = "A slab of meat."
	icon_state = "meat"
	health = 180
	filling_color = "#FF1C1C"
	center_of_mass = list("x"=16, "y"=14)
	bitesize = 3
	matter = list(MATERIAL_BIOMATTER = 20)
	preloaded_reagents = list("protein" = 9)

/obj/item/weapon/reagent_containers/food/snacks/meat/attackby(obj/item/I, mob/user)
	if(QUALITY_CUTTING in I.tool_qualities)
		if(I.use_tool(user, src, WORKTIME_NORMAL, QUALITY_CUTTING, FAILCHANCE_ZERO, required_stat = STAT_BIO))
			to_chat(user, SPAN_NOTICE("You cut the meat into thin strips."))
			new /obj/item/weapon/reagent_containers/food/snacks/rawcutlet(src)
			new /obj/item/weapon/reagent_containers/food/snacks/rawcutlet(src)
			new /obj/item/weapon/reagent_containers/food/snacks/rawcutlet(src)
			qdel(src)
	else
		..()

/obj/item/weapon/reagent_containers/food/snacks/meat/syntiflesh
	name = "synthetic meat"
	desc = "A synthetic slab of flesh."

// Seperate definitions because some food likes to know if it's human.
// TODO: rewrite kitchen code to check a var on the meat item so we can remove
// all these sybtypes.
/obj/item/weapon/reagent_containers/food/snacks/meat/human
/obj/item/weapon/reagent_containers/food/snacks/meat/monkey
	//same as plain meat

/obj/item/weapon/reagent_containers/food/snacks/meat/corgi
	name = "Corgi meat"
	desc = "Tastes like... well, you know."

/obj/item/weapon/reagent_containers/food/snacks/meat/roachmeat
	desc = "Gross piece of roach meat."
	icon_state = "xenomeat"
	filling_color = "#E2FFDE"

	bitesize = 6
	preloaded_reagents = list("protein" = 4, "blattedin" = 8, "diplopterum" = 7)

/obj/item/weapon/reagent_containers/food/snacks/meat/roachmeat/seuche
	preloaded_reagents = list("protein" = 4, "seligitillin" = 8, "diplopterum" = 6)

/obj/item/weapon/reagent_containers/food/snacks/meat/roachmeat/panzer
	preloaded_reagents = list("protein" = 8, "blattedin" = 12, "starkellin" = 15, "diplopterum" = 4)

/obj/item/weapon/reagent_containers/food/snacks/meat/roachmeat/fuhrer
	preloaded_reagents = list("protein" = 6, "seligitillin" = 6, "fuhrerole" = 12, "diplopterum" = 6)

/obj/item/weapon/reagent_containers/food/snacks/meat/roachmeat/jager
	preloaded_reagents = list("protein" = 6, "blattedin" = 6, "gewaltine" = 8, "diplopterum" = 2)

/obj/item/weapon/reagent_containers/food/snacks/meat/spider
	desc = "Bloaty piece of spider meat."
	icon_state = "xenomeat"
	filling_color = "#E2FFDE"

	bitesize = 6
	preloaded_reagents = list("protein" = 7, "pararein" = 12)

/obj/item/weapon/reagent_containers/food/snacks/meat/spider/hunter
	desc = "Bloaty piece of spider meat."
	icon_state = "xenomeat"
	filling_color = "#E2FFDE"

	bitesize = 6
	preloaded_reagents = list("protein" = 9, "aranecolmin" = 8, "pararein" = 2)

/obj/item/weapon/reagent_containers/food/snacks/meat/spider/nurse
	desc = "Bloaty piece of spider meat."
	icon_state = "xenomeat"
	filling_color = "#E2FFDE"

	bitesize = 6
	preloaded_reagents = list("protein" = 8, "stoxin" = 8)

/obj/item/weapon/reagent_containers/food/snacks/meat/carp
	name = "carp fillet"
	desc = "Juicy carp fillet."
	icon_state = "fishfillet"
	filling_color = "#FFDEFE"
	center_of_mass = list("x"=17, "y"=13)
	bitesize = 6
	preloaded_reagents = list("protein" = 8, "carpotoxin" = 8)

/obj/item/weapon/reagent_containers/food/snacks/meat/bearmeat
	name = "bear meat"
	desc = "A very manly slab of meat."
	icon_state = "bearmeat"
	filling_color = "#DB0000"
	bitesize = 3
	center_of_mass = list("x"=16, "y"=10)
	preloaded_reagents = list("protein" = 12, "hyperzine" = 5)

/obj/item/weapon/reagent_containers/food/snacks/meat/xenomeat
	name = "meat"
	desc = "A slab of green meat. Smells like acid."
	icon_state = "xenomeat"
	filling_color = "#43DE18"
	bitesize = 6
	center_of_mass = list("x"=16, "y"=10)
	preloaded_reagents = list("protein" = 6, "pacid" = 6)
