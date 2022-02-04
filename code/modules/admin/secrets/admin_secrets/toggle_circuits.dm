/datum/admin_secret_item/admin_secret/toggle_circuits
	name = "Toggle Circuits"

/datum/admin_secret_item/admin_secret/toggle_circuits/execute(mob/user)
	if(!(. = ..()))
		return
	var/choice = alert(user, "Circuits are currently [SScircuit_components.can_fire ? "enabled" : "disabled"].","Toggle Circuits", SScircuit_components.can_fire ? "Disable" : "Enable","Cancel")
	if(choice == "Disable")
		SScircuit_components.can_fire = FALSE
	else if(choice == "Enable")
		SScircuit_components.can_fire = TRUE
