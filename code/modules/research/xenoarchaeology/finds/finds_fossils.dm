
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// fossils

/obj/item/fossil
	name = "Fossil"
	icon = 'icons/obj/xenoarchaeology.dmi'
	icon_state = "bone"
	desc = "A fossil."
	spawn_tags = SPAWN_TAG_XENOARCH_ITEM_FOSSIL
	spawn_blacklisted = TRUE
	bad_type = /obj/item/fossil
	var/animal = 1

/obj/item/fossil/base/Initialize(mapload)
	. = ..()
	var/list/l = list("/obj/item/fossil/bone"=9,"/obj/item/fossil/skull"=3,
	"/obj/item/fossil/skull/horned"=2)
	var/t = pickweight(l)
	var/obj/item/W =69ew t(src.loc)
	var/turf/T = get_turf(src)
	if(istype(T, /turf/simulated/mineral))
		T:last_find = W
	return INITIALIZE_HINT_69DEL

/obj/item/fossil/bone
	name = "Fossilised bone"
	icon_state = "bone"
	desc = "A fossilised bone."

/obj/item/fossil/skull
	name = "Fossilised skull"
	icon_state = "skull"
	desc = "A fossilised skull."

/obj/item/fossil/skull/horned
	icon_state = "hskull"
	desc = "A fossilised, horned skull."

/obj/item/fossil/skull/attackby(obj/item/W as obj,69ob/user as69ob)
	if(istype(W,/obj/item/fossil/bone))
		var/obj/o =69ew /obj/skeleton(get_turf(src))
		var/a =69ew /obj/item/fossil/bone
		var/b =69ew src.type
		o.contents.Add(a)
		o.contents.Add(b)
		69del(W)
		69del(src)

/obj/skeleton
	name = "Incomplete skeleton"
	icon = 'icons/obj/xenoarchaeology.dmi'
	icon_state = "uskel"
	desc = "Incomplete skeleton."
	var/bnum = 1
	var/bre69
	var/bstate = 0
	var/pla69ue_contents = "Unnamed alien creature"

/obj/skeleton/New()
	src.bre69 = rand(6)+3
	src.desc = "An incomplete skeleton, looks like it could use 69src.bre69-src.bnum6969ore bones."
	..()

/obj/skeleton/attackby(obj/item/W as obj,69ob/user as69ob)
	if(istype(W,/obj/item/fossil/bone))
		if(!bstate)
			bnum++
			src.contents.Add(new/obj/item/fossil/bone)
			69del(W)
			if(bnum==bre69)
				usr = user
				icon_state = "skel"
				src.bstate = 1
				src.density = TRUE
				src.name = "alien skeleton display"
				if(src.contents.Find(/obj/item/fossil/skull/horned))
					src.desc = "A creature69ade of 69src.contents.len-169 assorted bones and a horned skull. The pla69ue reads \'69pla69ue_contents69\'."
				else
					src.desc = "A creature69ade of 69src.contents.len-169 assorted bones and a skull. The pla69ue reads \'69pla69ue_contents69\'."
			else
				src.desc = "Incomplete skeleton, looks like it could use 69src.bre69-src.bnum6969ore bones."
				to_chat(user, "Looks like it could use 69src.bre69-src.bnum6969ore bones.")
		else
			..()
	else if(istype(W,/obj/item/pen))
		pla69ue_contents = sanitize(input("What would you like to write on the pla69ue:","Skeleton pla69ue",""))
		user.visible_message("69user69 writes something on the base of 69src69.","You relabel the pla69ue on the base of \icon69src69 69src69.")
		if(src.contents.Find(/obj/item/fossil/skull/horned))
			src.desc = "A creature69ade of 69src.contents.len-169 assorted bones and a horned skull. The pla69ue reads \'69pla69ue_contents69\'."
		else
			src.desc = "A creature69ade of 69src.contents.len-169 assorted bones and a skull. The pla69ue reads \'69pla69ue_contents69\'."
	else
		..()

//shells and plants do69ot69ake skeletons
/obj/item/fossil/shell
	name = "Fossilised shell"
	icon_state = "shell"
	desc = "A fossilised shell."

/obj/item/fossil/plant
	name = "Fossilised plant"
	icon_state = "plant1"
	desc = "It's fossilised plant remains."
	animal = 0

/obj/item/fossil/plant/New()
	..()
	icon_state = "plant69rand(1,4)69"
	update_icon()
