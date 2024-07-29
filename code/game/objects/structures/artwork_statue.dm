
/obj/structure/artwork_statue
	name = "Weird Statue"
	desc = "A work of art that reflects the ideas of its creator."
	icon = 'icons/obj/structures/artwork_statue.dmi'
	icon_state = "artwork_statue_1"
	density = TRUE
	spawn_frequency = 0
	price_tag = 500
	sanity_damage = 0
	var/qualitydesc = null

/obj/structure/artwork_statue/Initialize()
	. = ..()
	name = get_artwork_name(TRUE)
	icon_state = "artwork_statue_[rand(1,6)]"

//weighted bell curve from -6 to 6, slight favour to positive numbers
//extremely sanity rending/healing statues are possible but very rare.
	var/sanity_value = clamp((rand(1,4) - rand(1,4)) - (rand(1,4) - rand(1,4)) + rand(0,1), -6, 6)
	sanity_damage = sanity_value
	price_tag += rand(0,5000)
	switch(sanity_value)
		if(4.9 to 6.1)
			price_tag += 1500//there's a market for art so bad it's good
			qualitydesc = " \ <br><br>How <span class='danger'>awful</span>. It's like a car crash- hard to look away."
		if(1 to 4.8)
			price_tag -= 500
			qualitydesc = " \ <br><br>This artwork is quite <span class='warning'>unpleasant</span> to look at."
		if(0)
			price_tag -= 1000//far worse than bad art is uninteresting art
			qualitydesc = " \ <br><br>A very mediocre piece of art."
		if(-4.8 to -1)
			price_tag += 1000
			qualitydesc = " \ <br><br>A <span class='green'>beautiful</span> piece of artwork."
		if(-6.1 to -4.9 )
			price_tag += 2500
			qualitydesc = " \ <br><br>A stunning artwork. Looking at it fills you with <span class='blue'>awe</span>."

/obj/structure/artwork_statue/attackby(obj/item/I, mob/living/user)
	if(I.has_quality(QUALITY_BOLT_TURNING))
		if(I.use_tool(user, src, WORKTIME_FAST, QUALITY_BOLT_TURNING, FAILCHANCE_EASY, STAT_MEC))
			user.visible_message(SPAN_WARNING("[user] has [anchored ? "un" : ""]secured \the [src]."), SPAN_NOTICE("You [anchored ? "un" : ""]secure \the [src]."))
			set_anchored(!anchored)
		return
	. = ..()

