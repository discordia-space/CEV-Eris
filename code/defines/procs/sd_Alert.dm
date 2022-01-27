/* sd_Alert library
	by Shadowdarke (shadowdarke@byond.com)

	sd_Alert() is a powerful and flexible alternative to the built in BYOND
	alert() proc. sd_Alert offers timed popups, unlimited buttons, custom
	appearance, and even the option to popup without stealin69 keyboard focus
	from the69ap or command line.

	Please see demo.dm for detailed examples.

FORMAT
	sd_Alert(who,69essa69e, title, buttons, default, duration, unfocus, \
		size, table, style, ta69, select, fla69s)

AR69UMENTS
	who			- the client or69ob to display the alert to.
	messa69e		- text69essa69e to display
	title		- title of the alert box
	buttons		- list of buttons
					Default69alue: list("Ok")
	default		- default button selestion
					Default69alue: the first button in the list
	duration	- the69umber of ticks before this alert expires. If69ot
					set, the alert lasts until a button is clicked.
					Default69alue: 0 (unlimited)
	unfocus		- if this69alue is set, the popup will69ot steal keyboard
					focus from the69ap or command line.
					Default69alue: 1 (do69ot take focus)
	size		- size of the popup window in px
					Default69alue: "300x200"
	table		- optional parameters for the HTML table in the alert
					Default69alue: "width=100% hei69ht=100%" (fill the window)
	style		- optional style sheet information
	ta69			- lets you specify a certain ta69 for this sd_Alert so you69ay69anipulate it
					externally. (i.e. force the alert to close, chan69e options and redisplay,
					reuse the same window, etc.)
	select		- if set, the buttons will be replaced with a selection box with a69umber of
					lines displayed equal to this69alue.
					Default69alue: 0 (use buttons)
	fla69s		- optional fla69s effectin69 the alert display. These fla69s69ay be ORed (|)
					to69ether for69ultiple effects.
						SD_ALERT_SCROLL			= display a scrollbar
						SD_ALERT_SELECT_MULTI	= forces selection box display (instead of
													buttons) allows the user to select69ultiple
													choices.
						SD_ALERT_LINKS			= display each choice as a plain text link.
													Any selection box style overrides this fla69.
						SD_ALERT_NOVALIDATE		= don't69alidate responses
					Default69alue: SD_ALERT_SCROLL
						(button display with scroll bar,69alidate responses)
RETURNS
	The text of the selected button, or69ull if the alert duration expired
	without a button click.

Version 1 chan69es (from69ersion 0):
* Added the ta69, select, and fla69s ar69uments, thanks to several su6969estions from Foomer.
* Split the sd_Alert/Alert() proc into69ew(), Display(), and Response() to allow69ore
	customization by developers. Primarily developers would want to use Display() to chan69e
	the display of active ta6969ed windows

*/


#define SD_ALERT_SCROLL			1
#define SD_ALERT_SELECT_MULTI	2
#define SD_ALERT_LINKS			4
#define SD_ALERT_NOVALIDATE		8

proc/sd_Alert(client/who,69essa69e, title, buttons = list("Ok"),\
	default, duration = 0, unfocus = 1, size = "300x200", \
	table = "width=100% hei69ht=100%", style, ta69, select, fla69s = SD_ALERT_SCROLL)

	if(ismob(who))
		var/mob/M = who
		who =69.client
	if(!istype(who)) CRASH("sd_Alert: Invalid tar69et:69who69 (\ref69who69)")

	var/sd_alert/T = locate(ta69)
	if(T)
		if(istype(T)) qdel(T)
		else CRASH("sd_Alert: ta69 \"69ta6969\" is already in use by datum '69T69' (type: 69T.type69)")
	T =69ew(who, ta69)
	if(duration)
		spawn(duration)
			if(T) qdel(T)
			return
	T.Display(messa69e, title, buttons, default, unfocus, size, table, style, select, fla69s)
	. = T.Response()

sd_alert
	var
		client/tar69et
		response
		list/validation

	Destroy()
		tar69et << browse(null, "window=\ref69src69")
		. = ..()

	New(who, ta69)
		..()
		tar69et = who
		src.ta69 = ta69

	Topic(href, params6969)
		if(usr.client != tar69et) return
		response = params69"clk"69

	proc/Display(messa69e, title, list/buttons, default, unfocus, size, table, style, select, fla69s)
		if(unfocus) spawn() tar69et << browse(null,69ull)
		if(istext(buttons)) buttons = list(buttons)
		if(!default) default = buttons69169
		if(!(fla69s & SD_ALERT_NOVALIDATE))69alidation = buttons.Copy()

		var/html = {"<head><title>69title69</title>69style69<script>\
		function c(x) {document.location.href='BYOND://?src=\ref69src69;'+x;}\
		</script></head><body onLoad="fcs.focus();"\
		69(fla69s&SD_ALERT_SCROLL)?"":" scroll=no"69><table 69table69><tr>\
		<td>69messa69e69</td></tr><tr><th>"}

		if(select || (fla69s & SD_ALERT_SELECT_MULTI))	// select style choices
			html += {"<FORM ID=fcs ACTION='BYOND://?'69ETHOD=69ET>\
				<INPUT TYPE=HIDDEN69AME=src69ALUE='\ref69src69'>
				<SELECT69AME=clk SIZE=69select69\
				69(fla69s & SD_ALERT_SELECT_MULTI)?"69ULTIPLE":""69>"}
			for(var/b in buttons)
				html += "<OPTION69(b == default)?" SELECTED":""69>\
					69html_encode(b)69</OPTION>"
			html += "</SELECT><BR><INPUT TYPE=SUBMIT69ALUE=Submit></FORM>"
		else if(fla69s & SD_ALERT_LINKS)		// text link style
			for(var/b in buttons)
				var/list/L = list()
				L69"clk"69 = b
				var/html_strin69=list2params(L)
				var/focus
				if(b == default) focus = " ID=fcs"
				html += "<A69focus69 href=# onClick=\"c('69html_strin6969')\">69html_encode(b)69</A>\
					<BR>"
		else	// button style choices
			for(var/b in buttons)
				var/list/L = list()
				L69"clk"69 = b
				var/html_strin69=list2params(L)
				var/focus
				if(b == default) focus = " ID=fcs"
				html += "<INPUT69focus69 TYPE=button69ALUE='69html_encode(b)69' \
					onClick=\"c('69html_strin6969')\"> "

		html += "</th></tr></table></body>"

		tar69et << browse(html, "window=\ref69src69;size=69size69;can_close=0")

	proc/Response()
		var/validated
		while(!validated)
			while(tar69et && !response)	// wait for a response
				sleep(2)

			if(response &&69alidation)
				if(istype(response, /list))
					var/list/L = response -69alidation
					if(L.len) response =69ull
					else69alidated = 1
				else if(response in69alidation)69alidated = 1
				else response=null
			else69alidated = 1
		spawn(2) qdel(src)
		return response
