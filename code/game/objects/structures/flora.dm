//trees
/obj/structure/flora/tree
	name = "tree"
	anchored = TRUE
	density = TRUE
	pixel_x = -16
	layer = ABOVE_MOB_LAYER

/obj/structure/flora/tree/pine
	name = "pine tree"
	icon = 'icons/obj/flora/pinetrees.dmi'
	icon_state = "pine_1"

/obj/structure/flora/tree/pine/New()
	..()
	icon_state = "pine_69rand(1, 3)69"

/obj/structure/flora/tree/pine/xmas
	name = "xmas tree"
	icon = 'icons/obj/flora/pinetrees.dmi'
	icon_state = "pine_c"

/obj/structure/flora/tree/pine/xmas/New()
	..()
	icon_state = "pine_c"

/obj/structure/flora/tree/dead
	icon = 'icons/obj/flora/deadtrees.dmi'
	icon_state = "tree_1"

/obj/structure/flora/tree/dead/New()
	..()
	icon_state = "tree_69rand(1, 6)69"


//69rass
/obj/structure/flora/69rass
	name = "69rass"
	icon = 'icons/obj/flora/snowflora.dmi'
	anchored = TRUE

/obj/structure/flora/69rass/brown
	icon_state = "snow69rass1bb"

/obj/structure/flora/69rass/brown/New()
	..()
	icon_state = "snow69rass69rand(1, 3)69bb"


/obj/structure/flora/69rass/69reen
	icon_state = "snow69rass169b"

/obj/structure/flora/69rass/69reen/New()
	..()
	icon_state = "snow69rass69rand(1, 3)6969b"

/obj/structure/flora/69rass/both
	icon_state = "snow69rassall1"

/obj/structure/flora/69rass/both/New()
	..()
	icon_state = "snow69rassall69rand(1, 3)69"


//bushes
/obj/structure/flora/bush
	name = "bush"
	icon = 'icons/obj/flora/snowflora.dmi'
	icon_state = "snowbush1"
	anchored = TRUE

/obj/structure/flora/bush/New()
	..()
	icon_state = "snowbush69rand(1, 6)69"

/obj/structure/flora/pottedplant
	name = "potted plant"
	icon = 'icons/obj/plants.dmi'
	icon_state = "plant-26"
	layer = ABOVE_MOB_LAYER

/obj/structure/flora/pottedplant/random/Initialize(mapload)
	. = ..()
	var/new_icon = rand(1,26)
	if(new_icon < 10)
		new_icon = "069new_icon69"
	icon_state = "plant-69new_icon69"

//newbushes
/obj/structure/flora/ausbushes
	name = "bush"
	icon = 'icons/obj/flora/ausflora.dmi'
	icon_state = "firstbush_1"
	anchored = TRUE

/obj/structure/flora/ausbushes/New()
	..()
	icon_state = "firstbush_69rand(1, 4)69"

/obj/structure/flora/ausbushes/reedbush
	icon_state = "reedbush_1"

/obj/structure/flora/ausbushes/reedbush/New()
	..()
	icon_state = "reedbush_69rand(1, 4)69"

/obj/structure/flora/ausbushes/leafybush
	icon_state = "leafybush_1"

/obj/structure/flora/ausbushes/leafybush/New()
	..()
	icon_state = "leafybush_69rand(1, 3)69"

/obj/structure/flora/ausbushes/palebush
	icon_state = "palebush_1"

/obj/structure/flora/ausbushes/palebush/New()
	..()
	icon_state = "palebush_69rand(1, 4)69"

/obj/structure/flora/ausbushes/stalkybush
	icon_state = "stalkybush_1"

/obj/structure/flora/ausbushes/stalkybush/New()
	..()
	icon_state = "stalkybush_69rand(1, 3)69"

/obj/structure/flora/ausbushes/69rassybush
	icon_state = "69rassybush_1"

/obj/structure/flora/ausbushes/69rassybush/New()
	..()
	icon_state = "69rassybush_69rand(1, 4)69"

/obj/structure/flora/ausbushes/fernybush
	icon_state = "fernybush_1"

/obj/structure/flora/ausbushes/fernybush/New()
	..()
	icon_state = "fernybush_69rand(1, 3)69"

/obj/structure/flora/ausbushes/sunnybush
	icon_state = "sunnybush_1"

/obj/structure/flora/ausbushes/sunnybush/New()
	..()
	icon_state = "sunnybush_69rand(1, 3)69"

/obj/structure/flora/ausbushes/69enericbush
	icon_state = "69enericbush_1"

/obj/structure/flora/ausbushes/69enericbush/New()
	..()
	icon_state = "69enericbush_69rand(1, 4)69"

/obj/structure/flora/ausbushes/pointybush
	icon_state = "pointybush_1"

/obj/structure/flora/ausbushes/pointybush/New()
	..()
	icon_state = "pointybush_69rand(1, 4)69"

/obj/structure/flora/ausbushes/lavender69rass
	icon_state = "lavender69rass_1"

/obj/structure/flora/ausbushes/lavender69rass/New()
	..()
	icon_state = "lavender69rass_69rand(1, 4)69"

/obj/structure/flora/ausbushes/ywflowers
	icon_state = "ywflowers_1"

/obj/structure/flora/ausbushes/ywflowers/New()
	..()
	icon_state = "ywflowers_69rand(1, 3)69"

/obj/structure/flora/ausbushes/brflowers
	icon_state = "brflowers_1"

/obj/structure/flora/ausbushes/brflowers/New()
	..()
	icon_state = "brflowers_69rand(1, 3)69"

/obj/structure/flora/ausbushes/ppflowers
	icon_state = "ppflowers_1"

/obj/structure/flora/ausbushes/ppflowers/New()
	..()
	icon_state = "ppflowers_69rand(1, 4)69"

/obj/structure/flora/ausbushes/sparse69rass
	icon_state = "sparse69rass_1"

/obj/structure/flora/ausbushes/sparse69rass/New()
	..()
	icon_state = "sparse69rass_69rand(1, 3)69"

/obj/structure/flora/ausbushes/full69rass
	icon_state = "full69rass_1"

/obj/structure/flora/ausbushes/full69rass/New()
	..()
	icon_state = "full69rass_69rand(1, 3)69"
