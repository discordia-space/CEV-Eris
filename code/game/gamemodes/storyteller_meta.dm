//This file contains things - usually global things - which persist between storyteller changes

//Global list of all storyevents. This tracks things like how many times each has been called
//It should persist so that storyteller changes don't reset how many calls have happened for each event
var/global/list/storyevents = list()

//A list of lists, which holds all events that have been scheduled but not fired yet
//Each event is a list in the format..
/*
	list(storyevent datum, event severity/type, timer handle)
*/

var/global/list/scheduled_events = list()

/proc/fill_storyevents_list()
	var/list/base_types = list(/datum/storyevent,
	/datum/storyevent/roleset,
	/datum/storyevent/roleset/faction)

	for(var/type in typesof(/datum/storyevent)-base_types)
		storyevents.Add(new type)


//This is a global thing so that scheduled events won't get lost in a storyteller change
/proc/fire_event(var/datum/storyevent/C, event_type)
	if(!C.can_trigger(event_type))
		//Something has changed, it was valid before but not now
		//This shouldnt happen often
		//We will refund its cost and abort
		C.cancel(event_type, 0.0)
		return
	C.create(event_type)