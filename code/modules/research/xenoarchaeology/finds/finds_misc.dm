
// Plasma shards have been moved to code/game/objects/items/weapons/shards.dm

//legacy crystal
/obj/machinery/crystal
	name = "Crystal"
	icon = 'icons/obj/mining.dmi'
	icon_state = "crystal"

/obj/machinery/crystal/New()
	if(prob(50))
		icon_state = "crystal2"

//Talk crystal

/obj/item/weapon/talkingcrystal

	name = "Crystal"
	icon = 'icons/obj/mining.dmi'
	icon_state = "talk_crystal"
	//listening_to_players = 1
	//speaking_to_players = 1

/obj/item/weapon/talkingcrystal/New()
	src.talking_atom = new (src)
	if(prob(50))
		icon_state = "talk_crystal2"
	//START_PROCESSING(SSobj, src)


///obj/item/weapon/crystal/Destroy()
	//..()
	//STOP_PROCESSING(SSobj, src)