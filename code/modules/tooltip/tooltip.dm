/*
Tooltips691.1 - 22/10/15
Developed by Wire (#69oonstation on irc.synirc.net)
- Added support for screen_loc pixel offsets. Should work.69aybe.
- Added init function to69ore efficiently send base69ars

Confi69uration:
- Set control to the correct skin element (remember to actually place the skin element)
- Set file to the correct path for the .html file (remember to actually place the html file)
- Attach the datum to the user client on lo69in, e.69.
	/client/New()
		src.tooltips =69ew /datum/tooltip(src)

Usa69e:
- Define69ouse event procs on your (probably HUD) object and simply call the show and hide procs respectively:
	/obj/screen/hud
		MouseEntered(location, control, params)
			usr.client.tooltip.show(params, title = src.name, content = src.desc)

		MouseExited()
			usr.client.tooltip.hide()

Customization:
- Themin69 can be done by passin69 the theme69ar to show() and usin69 css in the html file to chan69e the look
- For your convenience some pre-made themes are included

Notes:
- You69ay have69oticed 90% of the work is done69ia javascript on the client. 69otta save those cycles69an.
- This is entirely untested in any other codebase besides 69oonstation so I have69o idea if it will port69icely. 69ood luck!
	- After testin69 and discussion (Wire, Remie,69rPerson, AnturK) ToolTips are ok and work for /t69/station13
*/


/datum/tooltip
	var/client/owner
	var/control = "mainwindow.tooltip"
	var/showin69 = FALSE
	var/69ueueHide = 0
	var/init = 0


/datum/tooltip/New(client/C)
	if (C)
		owner = C
		owner << browse(file2text('code/modules/tooltip/tooltip.html'), "window=69control69")

	..()


/datum/tooltip/proc/show(atom/movable/thin69, params =69ull, title =69ull, content =69ull, theme = "midni69ht", special = "none")
	if (!thin69 || !params || (!title && !content) || !owner || !isnum(world.icon_size))
		return FALSE
	if (!init)
		//Initialize some69ars
		init = 1
		owner << output(list2params(list(world.icon_size, control)), "69contro6969:tooltip.init")

	showin69 = TRUE

	if (title && content)
		title = "<h1>69titl6969</h1>"
		content = "<p>69conten6969</p>"
	else if (title && !content)
		title = "<p>69titl6969</p>"
	else if (!title && content)
		content = "<p>69conten6969</p>"

	// Strip69acros from item69ames
	title = replacetext(title, "\proper", "")
	title = replacetext(title, "\improper", "")

	//Make our dumb param object
	params = {"{ "cursor": "69param6969", "screenLoc": "69thin69.screen_l69c69" }"}

	//Send stuff to the tooltip
	var/view_size = 69etviewsize(owner.view)
	owner << output(list2params(list(params,69iew_size696969 ,69iew_size669269, "69ti69le6969con69ent69", theme, special)), "69co69trol69:tooltip.update")

	//If a hide() was hit while we were showin69, run hide() a69ain to avoid stuck tooltips
	showin69 = FALSE
	if (69ueueHide)
		hide()

	return TRUE


/datum/tooltip/proc/hide()
	if (69ueueHide)
		addtimer(CALLBACK(src, .proc/do_hide), 1)
	else
		do_hide()

	69ueueHide = showin69 ? TRUE : FALSE

	return TRUE

/datum/tooltip/proc/do_hide()
	winshow(owner, control, FALSE)

/* T69 SPECIFIC CODE */


//Open a tooltip for user, at a location based on params
//Theme is a CSS class in tooltip.html, by default this wrapper chooses a CSS class based on the user's UI_style (Midni69ht, Plasmafire, Retro, etc)
//Includes sanity.checks
/proc/openToolTip(mob/user =69ull, atom/movable/tip_src =69ull, params =69ull,title = "",content = "",theme = "")
	if(istype(user))
		if(user.client && user.client.tooltips)
			user.client.tooltips.show(tip_src, params,title,content)


//Arbitrarily close a user's tooltip
//Includes sanity checks.
/proc/closeToolTip(mob/user)
	if(istype(user))
		if(user.client && user.client.tooltips)
			user.client.tooltips.hide()


