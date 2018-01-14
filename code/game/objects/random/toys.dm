/obj/random/action_figure
	name = "random action figure"
	icon_state = "box-grey"

/obj/random/action_figure/item_to_spawn()
	return pick(/obj/item/toy/figure/cmo,\
				/obj/item/toy/figure/assistant,\
				/obj/item/toy/figure/atmos,\
				/obj/item/toy/figure/bartender,\
				/obj/item/toy/figure/borg,\
				/obj/item/toy/figure/gardener,\
				/obj/item/toy/figure/captain,\
				/obj/item/toy/figure/cargotech,\
				/obj/item/toy/figure/ce,\
				/obj/item/toy/figure/chaplain,\
				/obj/item/toy/figure/chef,\
				/obj/item/toy/figure/chemist,\
				/obj/item/toy/figure/clown,\
				/obj/item/toy/figure/corgi,\
				/obj/item/toy/figure/detective,\
				/obj/item/toy/figure/dsquad,\
				/obj/item/toy/figure/engineer,\
				/obj/item/toy/figure/geneticist,\
				/obj/item/toy/figure/hop,\
				/obj/item/toy/figure/hos,\
				/obj/item/toy/figure/qm,\
				/obj/item/toy/figure/janitor,\
				/obj/item/toy/figure/agent,\
				/obj/item/toy/figure/librarian,\
				/obj/item/toy/figure/md,\
				/obj/item/toy/figure/mime,\
				/obj/item/toy/figure/miner,\
				/obj/item/toy/figure/ninja,\
				/obj/item/toy/figure/wizard,\
				/obj/item/toy/figure/rd,\
				/obj/item/toy/figure/roboticist,\
				/obj/item/toy/figure/scientist,\
				/obj/item/toy/figure/syndie,\
				/obj/item/toy/figure/secofficer,\
				/obj/item/toy/figure/warden,\
				/obj/item/toy/figure/psychologist,\
				/obj/item/toy/figure/paramedic)


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
