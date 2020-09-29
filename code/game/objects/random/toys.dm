/obj/random/figure
	name = "random figurine"
	icon_state = "box-grey"

/obj/random/figure/item_to_spawn()
	return pick(subtypesof(/obj/item/toy/figure))

/obj/random/plushie
	name = "random plushie"
	icon_state = "box-grey"

/obj/random/plushie/item_to_spawn()
	return pick(/obj/structure/plushie/ian,\
				/obj/structure/plushie/drone,\
				/obj/structure/plushie/carp,\
				/obj/structure/plushie/beepsky,\
				/obj/item/toy/plushie/mouse,\
				/obj/item/toy/plushie/kitten,\
				/obj/item/toy/plushie/lizard)
