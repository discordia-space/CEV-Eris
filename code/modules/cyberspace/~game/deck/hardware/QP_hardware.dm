/obj/item/deck_hardware/Cyberfeeder
	name = "strange power cell"
	desc = "A power cell with green led logo of Aster's Guild and data port."

	SoftName = "Cyberfeeder"
	ActionDescription = "Every 2 minutes generates 1 QP to limit(3QP), you can take generated QP once per minute."

	AdditionalDescription = "How anybody can work without it?"

	Cooldown = 1 MINUTE

	var/stored_QP = 3
	var/QP_limit = 3
	var/QP_generation_speed = 2 MINUTES

	var/tmp/generation_timer

	Installed(obj/item/computer_hardware/deck/_deck)
		. = ..()
		QP_regeneration()

	Uninstalled(obj/item/computer_hardware/deck/_deck)
		. = ..()
		StopQPGeneration()

	proc
		QP_regeneration(need2stop = FALSE)
			if(myDeck?.check_functionality())
				generation_timer = addtimer(CALLBACK(src, .proc/QP_regeneration, FALSE), QP_generation_speed, TIMER_STOPPABLE)
				stored_QP = clamp(stored_QP + 1, 0, QP_limit)

		StopQPGeneration()
			return deltimer(generation_timer)
	Activate(mob/user)
		. = ..()
		var/old_QP = stored_QP
		if(myDeck.SetQP(myDeck.QuantumPoints + stored_QP))
			stored_QP = 0
		else
			var/QP_to_claim = stored_QP - myDeck.GetFreePlaceForQP()
			if(QP_to_claim > 0 && myDeck.SetQP(myDeck.QuantumPoints + QP_to_claim))
				stored_QP -= QP_to_claim

		to_chat(SPAN_WARNING(old_QP > stored_QP ? "[old_QP - stored_QP] QP collected" : "Activation failed"))
