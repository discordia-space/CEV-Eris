/*The Guide is the default storyteller
It is set as storyteller base in __defines/gamemode.dm
*/

/*
Guide's surge type is The Challange
Storyteller will get points for each event pool and bring total mayhem after a set point of time
*/
/datum/storyteller/guide
	config_tag = "guide"
	name = "The Guide"
	welcome = "Welcome to CEV Eris!"
	description = "Offers a well balanced experience that has a little of everything. Considered the default experience"

	cooloff = 30 MINUTES
	cooloff_variance = 50	//how much time between surges is randomised. 50% in this case
	next_surge = 0	//time when the next surge will happen. Set in set_up()

/*******************
*  Surges Handling
********************/

/datum/storyteller/guide/handle_surge()
	if (world.time < next_surge && !forced)
		//It's not time yet
		return FALSE
	
	if(debug_mode)
		to_chat(world, "<b><font color='red'>Point surge has begun!.</font></b>")

	points[EVENT_LEVEL_MUNDANE] += GLOB.chaos_level * (gain_mult_mundane) * (POOL_THRESHOLD_MUNDANE * rand(4, 8))
	points[EVENT_LEVEL_MODERATE] += GLOB.chaos_level * (gain_mult_moderate) * (POOL_THRESHOLD_MODERATE * rand(2, 4))
	points[EVENT_LEVEL_MAJOR] += GLOB.chaos_level * (gain_mult_major) * (POOL_THRESHOLD_MAJOR) * rand(1, 3)
	points[EVENT_LEVEL_ROLESET] += GLOB.chaos_level * (gain_mult_roleset) * (POOL_THRESHOLD_ROLESET * (rand(50, 100)/100))
	points[EVENT_LEVEL_WEATHER] += GLOB.chaos_level * (gain_mult_weather) * (POOL_THRESHOLD_WEATHER * (rand(50, 100)/100))

	next_surge = world.time + cooloff * rand(cooloff_variance, 100+cooloff_variance)/100
