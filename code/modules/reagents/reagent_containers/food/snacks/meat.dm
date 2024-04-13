/obj/item/reagent_containers/food/snacks/meat
	name = "meat"
	desc = "A slab of meat cut from a nondescript animal. The core ingredient in thousands upon thousands of food recipes, in one way or another."
	icon_state = "meat"
	health = 180
	filling_color = "#FF1C1C"
	center_of_mass = list("x"=16, "y"=14)
	bitesize = 3
	matter = list(MATERIAL_BIOMATTER = 20)
	preloaded_reagents = list("protein" = 9)
	taste_tag = list(MEAT_FOOD)
	slice_path = /obj/item/reagent_containers/food/snacks/rawcutlet
	slices_num = 3
	price_tag = 100

/obj/item/reagent_containers/food/snacks/meat/syntiflesh
	name = "synthetic meat"
	desc = "A synthetic slab of flesh. You probably won't not be able to not tell the difference from the real thing maybe!"

// Seperate definitions because some food likes to know if it's human.
// TODO: rewrite kitchen code to check a var on the meat item so we can remove
// all these sybtypes.
/obj/item/reagent_containers/food/snacks/meat/human
	name = "human meat"
	desc = "Fresh long pig. Hopefully you didn't know them."
/obj/item/reagent_containers/food/snacks/meat/monkey
	//same as plain meat

/obj/item/reagent_containers/food/snacks/meat/corgi
	name = "Corgi meat"
	desc = "Tastes like... well, you know."
	price_tag = 25

/obj/item/reagent_containers/food/snacks/meat/pork
	name = "porcine meat"
	desc = "A raw slab of meat from pig or otherwise porcine animal, which you hopefully slaughtered without cruelty." // Always remember to pray Bismillah before, keep it halal.
	icon_state = "meat_pork"
	preloaded_reagents = list("protein" = 8)
	filling_color = "#C28585"
	slice_path = /obj/item/reagent_containers/food/snacks/rawbacon
	slices_num = 4 // Since 2u protein each

/obj/item/reagent_containers/food/snacks/meat/roachmeat/ //Kampfer being "default" roachmeat caused recipe issues
	name = "Roach meat"
	desc = "A slab of sickly-green bubbling meat cut from an unnamed roach. You shouldn't be seeing this."
	icon_state = "meat_xeno"
	filling_color = "#E2FFDE"

/obj/item/reagent_containers/food/snacks/meat/roachmeat/kampfer
	name = "Kampfer meat"
	desc = "A slab of sickly-green bubbling meat cut from a kampfer roach. You swear you can see it still twitching occasionally. Delicious!"
	icon_state = "meat_xeno"
	filling_color = "#E2FFDE"

	bitesize = 6
	preloaded_reagents = list("protein" = 4, "blattedin" = 8, "diplopterum" = 7)

	price_tag = 200

/obj/item/reagent_containers/food/snacks/meat/roachmeat/seuche
	name = "Seuche meat"
	desc = "A slab of sickly-green bubbling meat cut from a seuche roach. You can already taste the hepatitis. Delicious!"
	preloaded_reagents = list("protein" = 4, "seligitillin" = 8, "diplopterum" = 6)

/obj/item/reagent_containers/food/snacks/meat/roachmeat/panzer
	name = "Panzer meat"
	desc = "A slab of sickly-green bubbling meat cut from a panzer roach. Very tough, but crunchy, Delicious!"
	preloaded_reagents = list("protein" = 8, "blattedin" = 12, "starkellin" = 15, "diplopterum" = 4)

/obj/item/reagent_containers/food/snacks/meat/roachmeat/fuhrer
	name = "Fuhrer meat"
	desc = "A glorious slab of sickly-green bubbling meat cut from a fuhrer roach. it emanates an aura of dominance. Delicious!"
	preloaded_reagents = list("protein" = 6, "seligitillin" = 6, "fuhrerole" = 12, "diplopterum" = 6)
	price_tag = 300

/obj/item/reagent_containers/food/snacks/meat/roachmeat/kaiser
	name = "Kaiser meat"
	desc = "A slab of sickly-green meat of a kaiser roach, bubbling with unimaginable power. Delicious!"
	preloaded_reagents = list("protein" = 6, "blattedin" = 12, "seligitillin" = 6, "starkellin" = 15, "fuhrerole" = 4, "diplopterum" = 6, "kaiseraurum" = 16)
	price_tag = 1000

/obj/item/reagent_containers/food/snacks/meat/roachmeat/jager
	name = "Jager meat"
	desc = "A slab of sickly-green bubbling meat cut from a jager roach. You swear you can see it still twitching. Delicious!"
	preloaded_reagents = list("protein" = 6, "blattedin" = 6, "gewaltine" = 8, "diplopterum" = 2)

/obj/item/reagent_containers/food/snacks/meat/roachmeat/kraftwerk
	name = "Kraftwerk meat"
	desc = "A slab of sickly-green meat cut from a kraftwerk roach, bursting with nanite activity. Delicious!"
	preloaded_reagents = list("protein" = 6, "blattedin" = 6, "gewaltine" = 6, "uncap nanites" = 2, "nanites" = 3)

/obj/item/reagent_containers/food/snacks/meat/roachmeat/benzin
	name = "Benzin meat"
	desc = "A slab of sickly-green meat cut from a benzin roach. Stinks of welding fuel. Delicious!"
	preloaded_reagents = list("protein" = 4, "blattedin" = 6, "fuel" = 30)

/obj/item/reagent_containers/food/snacks/meat/spider
	name = "Senshi meat"
	desc = "A bloated slab of sickly-green meat cut from a warrior spider. The venom just gives it more flavor. Delicious!"
	icon_state = "meat_xeno"
	filling_color = "#E2FFDE"

	bitesize = 6
	preloaded_reagents = list("protein" = 9, "pararein" = 8)

	price_tag = 200

/obj/item/reagent_containers/food/snacks/meat/spider/hunter
	name = "Sokuryou meat"
	desc = "A bloated slab of sickly-green meat cut from a hunter spider. The venom just gives it more flavor. Delicious!"
	icon_state = "meat_xeno"
	filling_color = "#E2FFDE"

	bitesize = 6
	preloaded_reagents = list("protein" = 7, "pararein" = 12)

/obj/item/reagent_containers/food/snacks/meat/spider/nurse
	name = "Kouchiku meat"
	desc = "A bloated slab of sickly-green meat cut from a nurse spider. The venom just gives it more flavor. Delicious!"
	icon_state = "meat_xeno"
	filling_color = "#E2FFDE"

	bitesize = 6
	preloaded_reagents = list("protein" = 6, "aranecolmin" = 8,"pararein" = 8)

/obj/item/reagent_containers/food/snacks/meat/carp
	name = "carp fillet"
	desc = "A juicy fillet cut from a carp. The potent and powerful venom they produce just gives it a unique tang. Delicious!"
	icon_state = "meat_fish"
	filling_color = "#FFDEFE"
	center_of_mass = list("x"=17, "y"=13)
	bitesize = 6
	preloaded_reagents = list("protein" = 8, "carpotoxin" = 8)

	price_tag = 200

/obj/item/reagent_containers/food/snacks/meat/bearmeat
	name = "bear meat"
	desc = "A slab of meat so manly you can almost smell the concentrated testosterone in it."
	icon_state = "meat_bear"
	filling_color = "#DB0000"
	bitesize = 3
	center_of_mass = list("x"=16, "y"=10)
	preloaded_reagents = list("protein" = 12, "hyperzine" = 5)

	price_tag = 200

/obj/item/reagent_containers/food/snacks/meat/xenomeat
	name = "meat"
	desc = "A fatty cut of bright-green meat. The overwhelmingly powerful smell of the acid within burns your sinuses and makes your eyes water."
	icon_state = "meat_xeno"
	filling_color = "#43DE18"
	bitesize = 6
	center_of_mass = list("x"=16, "y"=10)
	preloaded_reagents = list("protein" = 6, "pacid" = 6)

	price_tag = 200

/obj/item/reagent_containers/food/snacks/meat/chicken
	name = "poultry"
	desc = "Poultry meat, might be chicken or any other avian species."
	icon_state = "meat_bird"
	filling_color = "#EDA897"
	preloaded_reagents = list("protein" = 8)
	slice_path = /obj/item/reagent_containers/food/snacks/chickenbreast
	slices_num = 4
