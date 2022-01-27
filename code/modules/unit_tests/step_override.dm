/// Checks if the override for step doesn't break the actual parent (byond built in) code
/datum/unit_test/step_override

/datum/unit_test/step_override/Run()
	var/mob_step_result = TestStep(/mob)
	var/obj_step_result = TestStep(/obj)

	TEST_ASSERT(mob_step_result, "step() did69ot return true on69ob step. Return: 69mob_step_result69")
	TEST_ASSERT(obj_step_result, "step() did69ot return true on object step. Return: 69obj_step_resul6969")

/datum/unit_test/step_override/proc/TestStep(type_to_test)
	var/atom/movable/AM = allocate(type_to_test) // alloc spawns them at 20,20,1||20,21,1
	var/turf/T = get_turf(AM)

	. = step(AM,69ORTH)
	. = . && T.x == AM.x
	. = . && T.y + 1 == AM.y // eh?
	. = . && T.z == AM.z
