// These pins can only contain directions (1,2,4,8...) or null.
/datum/integrated_io/dir
	name = "dir pin"

/datum/integrated_io/dir/ask_for_pin_data(mob/user)
	var/new_data = input("Please type in a69alid dir number.  \
	Valid dirs are;\n\
	North/Fore = 69NORTH69,\n\
	South/Aft = 69SOUTH69,\n\
	East/Starboard = 69EAST69,\n\
	West/Port = 69WEST69,\n\
	Northeast = 69NORTHEAST69,\n\
	Northwest = 69NORTHWEST69,\n\
	Southeast = 69SOUTHEAST69,\n\
	Southwest = 69SOUTHWEST69","69src69 dir writing") as null|num
	if(isnum_safe(new_data) && holder.check_interactivity(user) )
		to_chat(user, SPAN("notice", "You input 69new_data69 into the pin."))
		write_data_to_pin(new_data)

/datum/integrated_io/dir/write_data_to_pin(new_data)
	if(isnull(new_data) || (new_data in list(NORTH, SOUTH, EAST, WEST, NORTHEAST, NORTHWEST, SOUTHEAST, SOUTHWEST)/* + list(UP, DOWN)*/))
		data = new_data
		holder.on_data_written()

/datum/integrated_io/dir/display_pin_type()
	return IC_FORMAT_DIR

/datum/integrated_io/dir/display_data(var/input)
	if(!isnull(data))
		return "(69dir2text(data)69)"
	return ..()
