/obj/item/integrated_circuit/smart
	category_text = "Smart"

/obj/item/integrated_circuit/smart/basic_pathfinder
	name = "basic pathfinder"
	desc = "This complex circuit is able to determine what direction a given target is."
	extended_desc = "This circuit uses a69initurized, integrated camera to determine where the target is.  If the69achine \
	cannot see the target, it will not be able to calculate the correct direction."
	icon_state = "numberpad"
	complexity = 25
	inputs = list("\<REF\> target")
	outputs = list("\<NUM\> dir")
	activators = list("\<PULSE IN\> calculate dir", "\<PULSE OUT\> on calculated")
	spawn_flags = IC_SPAWN_RESEARCH
	origin_tech = list(TECH_ENGINEERING = 4, TECH_DATA = 5)
	power_draw_per_use = 40

/obj/item/integrated_circuit/smart/basic_pathfinder/do_work()
	var/datum/integrated_io/I = inputs69169
	set_pin_data(IC_OUTPUT, 1, null)

	if(!isweakref(I.data))
		return
	var/atom/A = I.data.resolve()
	if(!A)
		return
	if(!(A in69iew(get_turf(src))))
		return // Can't see the target.
	var/desired_dir = get_dir(get_turf(src), A)

	set_pin_data(IC_OUTPUT, 1, desired_dir)
	push_data()