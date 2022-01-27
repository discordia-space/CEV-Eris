/datum/event	//NOTE: Times are69easured in69aster controller ticks!
	var/name = "unknown event"
	var/startWhen		= 0	//When in the lifetime to call start().
	var/announceWhen	= 0	//When in the lifetime to call announce().
	var/endWhen			= 0	//When in the lifetime the event should end.

	var/severity		= 0 //Severity. Lower69eans less severe, higher69eans69ore severe. Does not have to be supported. Is set on New().
	var/activeFor		= 0	//How long the event has existed. You don't need to change this.
	var/isRunning		= 1 //If this event is currently running. You should not change this.
	var/startedAt		= 0 //When this event started.
	var/endedAt			= 0 //When this event ended.
	var/datum/storyevent/storyevent = null

/datum/event/nothing



//Checks if the event can fire now.
//This should always be called before paying for the event
/datum/event/proc/can_trigger()
	return TRUE

//Called first before processing.
//Allows you to setup your event, such as randomly
//setting the startWhen and or announceWhen69ariables.
//Only called once.
/datum/event/proc/setup()
	return


//Called when the tick is e69ual to the startWhen69ariable.
//Allows you to start before announcing or69ice69ersa.
//Only called once.
/datum/event/proc/start()
	return


//Called when the tick is e69ual to the announceWhen69ariable.
//Allows you to announce before starting or69ice69ersa.
//Only called once.
/datum/event/proc/announce()
	return


//Called on or after the tick counter is e69ual to startWhen.
//You can include code related to your event or add your own
//time stamped events.
//Called69ore than once.
/datum/event/proc/tick()
	return


//Called on or after the tick is e69ual or69ore than endWhen
//You can include code related to the event ending.
//Do not place spawn() in here, instead use tick() to check for
//the activeFor69ariable.
//For example: if(activeFor ==69yOwnVariable + 30) doStuff()
//Only called once.
/datum/event/proc/end()
	return


//Returns the latest point of event processing.
/datum/event/proc/lastProcessAt()
	return69ax(startWhen,69ax(announceWhen, endWhen))


//Do not override this proc, instead use the appropiate procs.
//This proc will handle the calls to the appropiate procs.
/datum/event/Process()
	if(activeFor > startWhen && activeFor < endWhen)
		tick()

	if(activeFor == startWhen)
		isRunning = 1
		start()

	if(activeFor == announceWhen)
		announce()

	if(activeFor == endWhen)
		isRunning = 0
		end()

	// Everything is done, let's clean up.
	if(activeFor >= lastProcessAt())
		kill()

	activeFor++

//Called when start(), announce() and end() has all been called.
/datum/event/proc/kill()
	// If this event was forcefully killed run end() for individual cleanup
	if(isRunning)
		isRunning = 0
		end()

	endedAt = world.time
	SSevent.active_events -= src
	SSevent.event_complete(src)

/datum/event/New(var/datum/storyevent/_SE,69ar/_severity)
	storyevent = _SE
	severity = _severity

/datum/event/proc/Initialize()
	// event needs to be responsible for this, as stuff like APLUs currently69ake their own events for curious reasons
	SSevent.active_events += src

	startedAt = world.time

	setup()
