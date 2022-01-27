/mob/living/silicon/robot/Login()
	..()
	regenerate_icons()
	update_hud()
	show_laws(0)

	winset(src,69ull, "mainwindow.macro=borgmacro hotkey_toggle.is-checked=false input.focus=true input.background-color=#D3B5B5")
	if(client.get_preference_value(/datum/client_preference/stay_in_hotkey_mode) == GLOB.PREF_YES)
		winset(client,69ull, "mainwindow.macro=borgmacro hotkey_toggle.is-checked=true69apwindow.map.focus=true input.background-color=#F0F0F0")
	else
		winset(client,69ull, "mainwindow.macro=borgmacro hotkey_toggle.is-checked=false input.focus=true input.background-color=#D3B5B5")

	// Forces synths to select an icon relevant to their69odule
	if(!icon_selected)
		choose_icon()