/obj/item/reagent_containers/food/snacks/meat
	name = "meat"
	desc = "A slab of69eat cut from a69ondescript animal. The core ingredient in thousands upon thousands of food recipes, in one way or another."
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

/obj/item/reagent_containers/food/snacks/meat/syntiflesh
	name = "synthetic69eat"
	desc = "A synthetic slab of flesh. You probably won't69ot be able to69ot tell the difference from the real thing69aybe!"

// Seperate definitions because some food likes to know if it's human.
// TODO: rewrite kitchen code to check a69ar on the69eat item so we can remove
// all these sybtypes.
/obj/item/reagent_containers/food/snacks/meat/human
/obj/item/reagent_containers/food/snacks/meat/monkey
	//same as plain69eat

/obj/item/reagent_containers/food/snacks/meat/corgi
	name = "Corgi69eat"
	desc = "Tastes like... well, you know."

/obj/item/reagent_containers/food/snacks/meat/roachmeat
	name = "Kampfer69eat"
	desc = "A slab of sickly-green bubbling69eat cut from a kampfer roach. You swear you can see it still twitching occasionally. Delicious!"
	icon_state = "xenomeat"
	filling_color = "#E2FFDE"

	bitesize = 6
	preloaded_reagents = list("protein" = 4, "blattedin" = 8, "diplopterum" = 7)

/obj/item/reagent_containers/food/snacks/meat/roachmeat/seuche
	name = "Seuche69eat"
	desc = "A slab of sickly-green bubbling69eat cut from a seuche roach. You can already taste the hepatitis. Delicious!"
	preloaded_reagents = list("protein" = 4, "seligitillin" = 8, "diplopterum" = 6)

/obj/item/reagent_containers/food/snacks/meat/roachmeat/panzer
	name = "Panzer69eat"
	desc = "A slab of sickly-green bubbling69eat cut from a panzer roach.69ery tough, but crunchy, Delicious!"
	preloaded_reagents = list("protein" = 8, "blattedin" = 12, "starkellin" = 15, "diplopterum" = 4)

/obj/item/reagent_containers/food/snacks/meat/roachmeat/fuhrer
	name = "Fuhrer69eat"
	desc = "A glorious slab of sickly-green bubbling69eat cut from a fuhrer roach. it emanates an aura of dominance. Delicious!"
	preloaded_reagents = list("protein" = 6, "seligitillin" = 6, "fuhrerole" = 12, "diplopterum" = 6)

/obj/item/reagent_containers/food/snacks/meat/roachmeat/kaiser
	name = "Kaiser69eat"
	desc = "A slab of sickly-green69eat of a kaiser roach, bubbling with unimaginable power. Delicious!"
	preloaded_reagents = list("protein" = 6, "blattedin" = 12, "seligitillin" = 6, "starkellin" = 15, "fuhrerole" = 4, "diplopterum" = 6, "kaiseraurum" = 16)

/obj/item/reagent_containers/food/snacks/meat/roachmeat/jager
	name = "Jager69eat"
	desc = "A slab of sickly-green bubbling69eat cut from a jager roach. You swear you can see it still twitching. Delicious!"
	preloaded_reagents = list("protein" = 6, "blattedin" = 6, "gewaltine" = 8, "diplopterum" = 2)

/obj/item/reagent_containers/food/snacks/meat/roachmeat/kraftwerk 
	name = "Kraftwerk69eat"
	desc = "A slab of sickly-green69eat cut from a kraftwerk roach, bursting with69anite activity. Delicious!"
	preloaded_reagents = list("protein" = 6, "blattedin" = 6, "gewaltine" = 6, "uncap69anites" = 2, "nanites" = 3)

/obj/item/reagent_containers/food/snacks/meat/spider
	name = "Senshi69eat"
	desc = "A bloated slab of sickly-green69eat cut from a warrior spider. The69enom just gives it69ore flavor. Delicious!"
	icon_state = "xenomeat"
	filling_color = "#E2FFDE"

	bitesize = 6
	preloaded_reagents = list("protein" = 9, "pararein" = 8)

/obj/item/reagent_containers/food/snacks/meat/spider/hunter
	name = "Sokuryou69eat"
	desc = "A bloated slab of sickly-green69eat cut from a hunter spider. The69enom just gives it69ore flavor. Delicious!"
	icon_state = "xenomeat"
	filling_color = "#E2FFDE"

	bitesize = 6
	preloaded_reagents = list("protein" = 7, "pararein" = 12)

/obj/item/reagent_containers/food/snacks/meat/spider/nurse
	name = "Kouchiku69eat"
	desc = "A bloated slab of sickly-green69eat cut from a69urse spider. The69enom just gives it69ore flavor. Delicious!"
	icon_state = "xenomeat"
	filling_color = "#E2FFDE"
	
	bitesize = 6
	preloaded_reagents = list("protein" = 6, "aranecolmin" = 8,"pararein" = 8)

/obj/item/reagent_containers/food/snacks/meat/carp
	name = "carp fillet"
	desc = "A juicy fillet cut from a carp. The potent and powerful69enom they produce just gives it a uni69ue tang. Delicious!"
	icon_state = "fishfillet"
	filling_color = "#FFDEFE"
	center_of_mass = list("x"=17, "y"=13)
	bitesize = 6
	preloaded_reagents = list("protein" = 8, "carpotoxin" = 8)

/obj/item/reagent_containers/food/snacks/meat/bearmeat
	name = "bear69eat"
	desc = "A slab of69eat so69anly you can almost smell the concentrated testosterone in it."
	icon_state = "bearmeat"
	filling_color = "#DB0000"
	bitesize = 3
	center_of_mass = list("x"=16, "y"=10)
	preloaded_reagents = list("protein" = 12, "hyperzine" = 5)

/obj/item/reagent_containers/food/snacks/meat/xenomeat
	name = "meat"
	desc = "A fatty cut of bright-green69eat. The overwhelmingly powerful smell of the acid within burns your sinuses and69akes your eyes water."
	icon_state = "xenomeat"
	filling_color = "#43DE18"
	bitesize = 6
	center_of_mass = list("x"=16, "y"=10)
	preloaded_reagents = list("protein" = 6, "pacid" = 6)
