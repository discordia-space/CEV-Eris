client
	var/manual_focus = 0
	proc
		KeyDown(KeyCode,shift)
		KeyUp(KeyCode,shift)
KeyState
	var/key_repeat = 0
	var/open = TRUE
	proc
		open()
			open = TRUE
			if(client)client.KeyFocus()
		close()
			open = FALSE
			if(client)client<<browse(null,null)