

/var/all_ui_styles = list(
	"ErisStyle"
	)
/proc/ui_style2icon(ui_style)
	if(ui_style in all_ui_styles)
		return all_ui_styles[ui_style]
	return all_ui_styles["White"]

/client/verb/change_ui_format()
	set name = "Change UI format"
	set category = "OOC"
	set desc = "Minimize or maximaze you UI"

	if(!ishuman(usr))
		to_chat(usr, SPAN_WARNING("You must be human to use this verb."))
		return


	prefs.UI_compact_style = !prefs.UI_compact_style

	var/mob/living/carbon/human/H = src.mob
	H.minimalize_HUD()

/client/verb/change_ui()
	set name = "Change UI"
	set category = "OOC"
	set desc = "Configure your user interface"

	if(!ishuman(usr))
		to_chat(usr, SPAN_WARNING("You must be human to use this verb."))
		return
//to:do make normal HUDoption page

	var/UI_style_new = input(usr, "Select a style.") as null|anything in all_ui_styles
	if(UI_style_new)
		prefs.UI_style = UI_style_new

	var/UI_style_alpha_new = input(usr, "Select a new alpha (transparency) parameter for your UI, between 50 and 255","Alpha",prefs.UI_style_alpha) as null|num
	if(UI_style_alpha_new && (UI_style_alpha_new <= 255 && UI_style_alpha_new >= 50))
		prefs.UI_style_alpha = UI_style_alpha_new

	var/UI_style_color_new = input(usr, "Choose your UI color. Dark colors are not recommended!","Select a color",prefs.UI_style_color) as color|null
	if(UI_style_color_new)
		prefs.UI_style_color = UI_style_color_new

	prefs.save_preferences()
	var/mob/living/carbon/human/H = src.mob
	H.regenerate_icons()


