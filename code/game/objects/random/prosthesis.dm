/obj/random/prothesis
	name = "random prosthesis"
	icon_state = "meds-green"

/obj/random/prothesis/one_star
	name = "random one star prosthesis"

/obj/random/prothesis/one_star/item_to_spawn()
	return pick(list(
	/obj/item/organ/external/robotic/one_star/l_arm,\
	/obj/item/organ/external/robotic/one_star/r_arm,\
	/obj/item/organ/external/robotic/one_star/l_leg,\
	/obj/item/organ/external/robotic/one_star/r_leg
	))

