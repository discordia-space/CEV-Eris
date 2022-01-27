
//This proc is the69ost basic of the procs. All it does is69ake a69ew69ob on the same tile and transfer over a few69ariables.
//Returns the69ew69ob
//Note that this proc does69OT do69MI related stuff!
/mob/proc/change_mob_type(var/new_type =69ull,69ar/turf/location =69ull,69ar/new_name =69ull as text,69ar/delete_old_mob = 0 as69um,69ar/subspecies)

	if(isnewplayer(src))
		to_chat(usr, "\red cannot convert players who have69ot entered yet.")
		return

	if(!new_type)
		new_type = input("Mob type path:", "Mob type") as text|null

	if(istext(new_type))
		new_type = text2path(new_type)

	if( !ispath(new_type) )
		to_chat(usr, "Invalid type path (new_type = 69new_type69) in change_mob_type(). Contact a coder.")
		return

	if(69ew_type == /mob/new_player )
		to_chat(usr, "\red cannot convert into a69ew_player69ob type.")
		return

	var/mob/M
	if(isturf(location))
		M =69ew69ew_type( location )
	else
		M =69ew69ew_type( src.loc )

	if(!M || !ismob(M))
		to_chat(usr, "Type path is69ot a69ob (new_type = 69new_type69) in change_mob_type(). Contact a coder.")
		qdel(M)
		return

	if( istext(new_name) )
		M.name =69ew_name
		M.real_name =69ew_name
	else
		M.name = src.name
		M.real_name = src.real_name

	if(src.dna)
		M.dna = src.dna.Clone()

	if(mind)
		mind.transfer_to(M)
	else
		M.key = key

	if(subspecies && ishuman(M))
		var/mob/living/carbon/human/H =69
		H.set_species(subspecies)

	if(delete_old_mob)
		spawn(1)
			qdel(src)
	return69
