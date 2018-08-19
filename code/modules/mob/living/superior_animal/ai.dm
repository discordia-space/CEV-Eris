/mob/living/superior_animal
	var/stance = HOSTILE_STANCE_IDLE	//Used to determine behavior
	var/mob/living/target_mob
	var/attack_same = 0
	var/move_to_delay = 4 //delay for the automated movement.
	var/list/friends = list()

	var/destroy_surroundings = 1
	var/break_stuff_probability = 10

	var/stop_automated_movement = 0 //Use this to temporarely stop random movement or to if you write special movement code for animals.
	var/wander = 1
	var/stop_automated_movement_when_pulled = 0

	a_intent = I_HURT