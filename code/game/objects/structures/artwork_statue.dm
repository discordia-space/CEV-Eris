#define QUALITY_AWFUL pick(GLOB.quality_awful_descriptors)
#define QUALITY_BAD pick(GLOB.quality_bad_descriptors)
#define QUALITY_BORING pick(GLOB.quality_boring_descriptors)
#define QUALITY_GOOD pick(GLOB.quality_good_descriptors)
#define QUALITY_GREAT pick(GLOB.quality_great_descriptors)

/obj/structure/artwork_statue
	name = "Weird Statue"
	desc = "A work of art that reflects the ideas of its creator."
	icon = 'icons/obj/structures/artwork_statue.dmi'
	icon_state = "artwork_statue_1"
	density = TRUE
	spawn_frequency = 0
	price_tag = 500
	sanity_damage = 0
	var/quality = null
	var/qspan = null//for applying a specific colored span to each type

/obj/structure/artwork_statue/New()
	. = ..()
	name = get_artwork_name(TRUE)
	icon_state = "artwork_statue_[rand(1,6)]"
	var/sanity_value = rand(-5,5) + rand(-1,1)
	sanity_damage = sanity_value /2
	AddComponent(/datum/component/atom_sanity, sanity_value, "")
	switch(sanity_value)
		if(-6 to -4.1)
			price_tag += rand(2500,6500)//people pay better art that is more comforting or unsettling
			quality = QUALITY_GREAT
			qspan = "<span style='color:#d0b050;'>"
		if(4.1 to 6)
			price_tag += rand(2000,6000)
			quality = QUALITY_AWFUL
			qspan = "<span style='color:#32CD32;'>"
		if(-4 to -0.1)
			price_tag += rand(750,3000)
			quality = QUALITY_GOOD
			qspan = "<span style='color:#32CD32;'>"
		if(0.1 to 4)
			price_tag += rand(500,2500)
			quality = QUALITY_BAD
			qspan = "<span class='red'>"
		if(0)
			price_tag += rand(0,1000)
			quality = QUALITY_BORING//this is the truly "bad" art result. Nothing worse then art with no soul
			qspan = "<span class='blue'>"

/obj/structure/artwork_statue/attackby(obj/item/I, mob/living/user)
	if(I.has_quality(QUALITY_BOLT_TURNING))
		if(I.use_tool(user, src, WORKTIME_FAST, QUALITY_BOLT_TURNING, FAILCHANCE_EASY, STAT_MEC))
			user.visible_message(SPAN_WARNING("[user] has [anchored ? "un" : ""]secured \the [src]."), SPAN_NOTICE("You [anchored ? "un" : ""]secure \the [src]."))
			set_anchored(!anchored)
		return
	. = ..()

/obj/structure/artwork_statue/get_item_cost(export)
	. = ..()
	GET_COMPONENT(comp_sanity, /datum/component/atom_sanity)
	. += comp_sanity.affect * 100
