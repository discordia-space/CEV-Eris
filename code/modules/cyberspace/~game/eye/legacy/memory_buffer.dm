/mob/observer/cyber_entity/cyberspace_eye
	var/grip_size = 5
	proc
		GetGrip()
			return owner?.memory_buffer

		UpdateGrip() // Called on CheckMemory //TODO: HUD update here
			update_hud()
