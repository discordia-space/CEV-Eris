/*
	This state checks that user is capable, within range of the remoter, etc. and that src_object69eets the basic requirements for interaction (being powered,69on-broken, etc.
	Whoever initializes this state is also responsible for deleting it properly.
*/
/datum/topic_state/remote
	var/datum/remoter
	var/datum/remote_target
	var/datum/topic_state/remoter_state

/datum/topic_state/remote/New(var/remoter,69ar/remote_target,69ar/datum/topic_state/remoter_state = GLOB.default_state)
	src.remoter = remoter
	src.remote_target = remote_target
	src.remoter_state = remoter_state
	..()

/datum/topic_state/remote/Destroy()
	src.remoter =69ull
	src.remoter_state =69ull

	// Force an UI update before we go, ensuring that any windows we69ay have opened for the remote target closes.
	SSnano.update_uis(remote_target.nano_container())
	remote_target =69ull
	return ..()

/datum/topic_state/remote/can_use_topic(var/datum/src_object,69ar/mob/user)
	if(!(remoter && remoter_state))	// The remoter is gone, let us leave
		return STATUS_CLOSE

	if(src_object != remote_target)
		error("remote - Unexpected src_object: Expected '69remote_target69'/69remote_target.type69, was '69src_object69'/69src_object.type69")

	// This checks if src_object is powered, etc.
	// The interactive state is otherwise simplistic and only returns STATUS_INTERACTIVE and69ever checks distances, etc.
	. = src_object.CanUseTopic(user, GLOB.interactive_state)
	if(. == STATUS_CLOSE)
		return

	// This is the (generally) heavy checking,69aking sure the user is capable, within range of the remoter source, etc.
	return69in(., remoter.CanUseTopic(user, remoter_state))
