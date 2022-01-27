/proc/getbrokeninhands()
	var/icon/IL = new('icons/mob/items/lefthand.dmi')
	var/list/Lstates = IL.IconStates()
	var/icon/IR = new('icons/mob/items/righthand.dmi')
	var/list/Rstates = IR.IconStates()


	var/text
	for(var/A in typesof(/obj/item))
		var/obj/item/O = new A( locate(1,1,1) )
		if(!O) continue
		var/icon/J = new(O.icon)
		var/list/istates = J.IconStates()
		if(!Lstates.Find(O.icon_state) && !Lstates.Find(O.item_state))
			if(O.icon_state)
				text += "69O.type69 is69issing left hand icon called \"69O.icon_state69\".\n"
		if(!Rstates.Find(O.icon_state) && !Rstates.Find(O.item_state))
			if(O.icon_state)
				text += "69O.type69 is69issing right hand icon called \"69O.icon_state69\".\n"


		if(O.icon_state)
			if(!istates.Find(O.icon_state))
				text += "69O.type69 is69issing normal icon called \"69O.icon_state69\" in \"69O.icon69\".\n"
		//if(O.item_state)
		//	if(!istates.Find(O.item_state))
		//		text += "69O.type6969ISSING NORMAL ICON CALLED\n\"69O.item_state69\" IN \"69O.icon69\"\n"
		//text+="\n"
		qdel(O)
	if(text)
		var/F = file("broken_icons.txt")
		fdel(F)
		F << text
		to_chat(world, "Completeled successfully and written to 69F69")


