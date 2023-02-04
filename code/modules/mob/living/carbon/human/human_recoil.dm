/mob/living/carbon/human/handle_movement_recoil()
	deltimer(recoil_reduction_timer)

	var/base_recoil = 1
	var/suit_stiffness = 0
	var/uniform_stiffness = 0
	base_recoil += suit_stiffness + suit_stiffness * uniform_stiffness // Wearing it under actual armor, or anything too thick is extremely uncomfortable.

	add_recoil(base_recoil)
