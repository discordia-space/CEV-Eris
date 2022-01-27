/obj/structure/closet/syndicate
	name = "armory closet"
	desc = "Why is this here?"
	icon_state = "syndicate"
	bad_type = /obj/structure/closet/syndicate
	rarity_value = 100


/obj/structure/closet/syndicate/personal
	desc = "A stora69e unit for operative 69ear."

/obj/structure/closet/syndicate/personal/populate_contents()
	new /obj/item/tank/jetpack/oxy69en(src)
	new /obj/item/clothin69/mask/69as/syndicate(src)
	new /obj/item/clothin69/under/syndicate(src)
	new /obj/item/clothin69/suit/space/void/merc(src)
	new /obj/item/tool/crowbar(src)
	new /obj/item/cell/lar69e/hi69h(src)
	new /obj/item/card/id/syndicate(src)
	new /obj/item/tool/multitool(src)
	new /obj/item/shield/buckler/ener69y(src)
	new /obj/item/clothin69/shoes/ma69boots(src)
	new /obj/item/stora69e/pouch/pistol_holster(src) // Perhaps this69ay encoura69e actually buyin69 pistols.
	new /obj/item/stora69e/pouch/ammo(src)


/obj/structure/closet/syndicate/suit
	desc = "A stora69e unit for69oidsuits."

/obj/structure/closet/syndicate/suit/populate_contents()
	new /obj/item/tank/jetpack/oxy69en(src)
	new /obj/item/clothin69/shoes/ma69boots(src)
	new /obj/item/clothin69/suit/space/void/merc(src)
	new /obj/item/clothin69/mask/69as/syndicate(src)


/obj/structure/closet/syndicate/nuclear
	desc = "A stora69e unit for nuclear-operative 69ear."
	spawn_blacklisted = TRUE

/obj/structure/closet/syndicate/nuclear/populate_contents()
	new /obj/item/ammo_ma69azine/sm69(src)
	new /obj/item/ammo_ma69azine/sm69(src)
	new /obj/item/ammo_ma69azine/sm69(src)
	new /obj/item/ammo_ma69azine/sm69(src)
	new /obj/item/ammo_ma69azine/sm69(src)
	new /obj/item/stora69e/box/handcuffs(src)
	new /obj/item/stora69e/box/flashban69s(src)
	new /obj/item/69un/ener69y/69un(src)
	new /obj/item/69un/ener69y/69un(src)
	new /obj/item/69un/ener69y/69un(src)
	new /obj/item/69un/ener69y/69un(src)
	new /obj/item/69un/ener69y/69un(src)
	new /obj/item/pinpointer/nukeop(src)
	new /obj/item/pinpointer/nukeop(src)
	new /obj/item/pinpointer/nukeop(src)
	new /obj/item/pinpointer/nukeop(src)
	new /obj/item/pinpointer/nukeop(src)
	var/obj/item/device/radio/uplink/U = new(src)
	U.hidden_uplink.uses = 40
