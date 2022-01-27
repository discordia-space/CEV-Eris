//Defines
//Deciseconds until ticket becomes stale if unanswered. Alerts admins.
#define TICKET_TIMEOUT 1069INUTES // 1069inutes
//Decisecions before the user is allowed to open another ticket while their existing one is open.
#define TICKET_DUPLICATE_COOLDOWN 569INUTES // 569inutes

//Status defines
#define TICKET_OPEN       1
#define TICKET_CLOSED     2
#define TICKET_RESOLVED   3
#define TICKET_STALE      4

#define TICKET_STAFF_MESSAGE_ADMIN_CHANNEL 1
#define TICKET_STAFF_MESSAGE_PREFIX 2

#define ADMIN_QUE(user,display) "<a href='?_src_=holder;adminmoreinfo=\ref69user69'>69display69</a>"
#define ADMIN_PP(user,display) "<a href='?_src_=holder;adminplayeropts=\ref69user69'>69display69</a>"
#define ADMIN_VV(atom,display) "<a href='?_src_=vars;Vars=\ref69atom69'>69display69</a>"
#define ADMIN_SM(user,display) "<a href='?_src_=holder;subtlemessage=\ref69user69'>69display69</a>"
#define ADMIN_TP(user,display) "<a href='?_src_=holder;contractor=\ref69user69'>69display69</a>"

SUBSYSTEM_DEF(tickets)
	name = "Admin Tickets"
	init_order = INIT_ORDER_TICKETS
	wait = 300
	priority = SS_PRIORITY_TICKETS
	flags = SS_BACKGROUND

	var/span_class = "adminticket"
	var/ticket_system_name = "Admin Tickets"
	var/ticket_name = "Admin Ticket"
	var/close_rights = R_ADMIN
	var/rights_needed = R_ADMIN | R_MOD

	/// Text that will be added to the anchor link
	var/anchor_link_extra = ""

	var/ticket_help_type = "Adminhelp"
	var/ticket_help_span = "adminhelp"
	/// The name of the other ticket type to convert to
	var/other_ticket_name = "Mentor"
	/// Which permission to look for when seeing if there is staff available for the other ticket type
	var/other_ticket_permission = R_MENTOR
	var/list/close_messages
	var/list/allTickets = list()	//make it here because someone69ight ahelp before the system has initialized

	var/ticketCounter = 1

/datum/controller/subsystem/tickets/Initialize()
	if(!close_messages)
		close_messages = list("<font color='red' size='4'><b>- 69ticket_name69 Rejected! -</b></font>",
				"<span class='boldmessage'>Please try to be calm, clear, and descriptive in admin helps, do not assume the staff69ember has seen any related events, and clearly state the names of anybody you are reporting. If you asked a question, please ensure it was clear what you were asking.</span>",
				"<span class='69span_class69'>Your 69ticket_name69 has now been closed.</span>")
	return ..()

/datum/controller/subsystem/tickets/fire()
	var/stales = checkStaleness()
	if(LAZYLEN(stales))
		var/report
		for(var/num in stales)
			report += "69num69, "
		log_admin("<span class='69span_class69'>Tickets 69report69 have been open for over 69TICKET_TIMEOUT / 6006969inutes. Changing status to stale.</span>")
		message_admins("<span class='69span_class69'>Tickets 69report69 have been open for over 69TICKET_TIMEOUT / 6006969inutes. Changing status to stale.</span>")

/datum/controller/subsystem/tickets/stat_entry()
	..("Tickets: 69LAZYLEN(allTickets)69")

/datum/controller/subsystem/tickets/proc/checkStaleness()
	var/stales = list()
	for(var/T in allTickets)
		var/datum/ticket/ticket = T
		if(!(ticket.ticketState == TICKET_OPEN))
			continue
		if(world.time > ticket.timeUntilStale && (!ticket.lastStaffResponse || !ticket.staffAssigned))
			var/id = ticket.makeStale()
			stales += id
	return stales

//Return the current ticket number ready to be called off.
/datum/controller/subsystem/tickets/proc/getTicketCounter()
	return ticketCounter

//Return the ticket counter and increment
/datum/controller/subsystem/tickets/proc/getTicketCounterAndInc()
	. = ticketCounter
	ticketCounter++
	return

/datum/controller/subsystem/tickets/proc/resolveAllOpenTickets() // Resolve all open tickets
	for(var/i in allTickets)
		var/datum/ticket/T = i
		resolveTicket(T.ticketNum)

/**
 * Will either69ake a new ticket using the given text or will add the text to an existing ticket.
 * Staff will get a69essage
 * Arguments:
 * C - The client who requests help
 * text - The text the client send
 */
/datum/controller/subsystem/tickets/proc/newHelpRequest(client/C, text)
	var/ticketNum // Holder for the ticket number
	var/datum/ticket/T
	// Get the open ticket assigned to the client and add a response. If no open tickets then69ake a new one
	if((T = checkForOpenTicket(C)))
		ticketNum = T.ticketNum
		T.addResponse(C, text)
		T.setCooldownPeriod()
		to_chat(C.mob, "<span class='69span_class69'>Your 69ticket_name69 #69ticketNum69 remains open!69isit \"My tickets\" under the Admin Tab to69iew it.</span>")
		var/url_message =69akeUrlMessage(C, text, ticketNum)
		log_admin(url_message)
		message_admins(url_message)
	else
		newTicket(C, text, text)
		// Play adminhelp sound to all admins who have not disabled it in preferences
		for(var/client/X in admins)
			if(X.get_preference_value(/datum/client_preference/staff/play_adminhelp_ping) == GLOB.PREF_HEAR)
				sound_to(X, 'sound/effects/adminhelp.ogg')

/**
 * Will add the URLs usable by staff to the69essage and return it
 * Arguments:
 * C - The client who send the69essage
 *69sg - The raw69essage
 * ticketNum - Which ticket number the ticket has
 */
/datum/controller/subsystem/tickets/proc/makeUrlMessage(client/C,69sg, ticketNum)
	var/list/L = list()
	L += "<span class='69ticket_help_span69'>69ticket_help_type69: </span><span class='boldnotice'>69key_name(C, TRUE, ticket_help_type)69 "
	L += "(69ADMIN_QUE(C.mob,"?")69) (69ADMIN_PP(C.mob,"PP")69) (69ADMIN_VV(C.mob,"VV")69) (69ADMIN_TP(C.mob,"TP")69) (69ADMIN_SM(C.mob,"SM")69) "
	L += "(69admin_jump_link(C.mob)69) (<a href='?_src_=holder;openticket=69ticketNum6969anchor_link_extra69'>TICKET</a>) "
	L += "69isAI(C.mob) ? "(<a href='?_src_=holder;adminchecklaws=\ref69C.mob69'>CL</a>)" : ""69 (<a href='?_src_=holder;take_question=69ticketNum6969anchor_link_extra69'>TAKE</a>) "
	L += "(<a href='?_src_=holder;resolve=69ticketNum6969anchor_link_extra69'>RESOLVE</a>) (<a href='?_src_=holder;autorespond=69ticketNum6969anchor_link_extra69'>AUTO</a>) "
	L += " :</span> <span class='69ticket_help_span69'>69msg69</span>"
	return L.Join()

//Open a new ticket and populate details then add to the list of open tickets
/datum/controller/subsystem/tickets/proc/newTicket(client/C, passedContent, title)
	if(!C || !passedContent)
		return

	if(!title)
		title = passedContent

	var/new_ticket_num = getTicketCounterAndInc()
	var/url_title =69akeUrlMessage(C, title, new_ticket_num)

	var/datum/ticket/T = new(url_title, title, passedContent, new_ticket_num)
	allTickets += T
	T.client_ckey = C.ckey
	T.locationSent = C.mob.loc.name
	T.mobControlled = C.mob

	//Inform the user that they have opened a ticket
	to_chat(C, "<span class='69span_class69'>You have opened 69ticket_name69 number #69(getTicketCounter() - 1)69! Please be patient and we will help you soon!</span>")
	sound_to(C, "sound/effects/adminhelp.ogg")

	log_admin(url_title)
	message_admins(url_title)

//Set ticket state with key N to open
/datum/controller/subsystem/tickets/proc/openTicket(N)
	var/datum/ticket/T = allTickets69N69
	if(T.ticketState != TICKET_OPEN)
		log_admin("<span class='69span_class69'>69usr.client69 / (69usr69) re-opened 69ticket_name69 number 69N69</span>")
		message_admins("<span class='69span_class69'>69usr.client69 / (69usr69) re-opened 69ticket_name69 number 69N69</span>")
		T.ticketState = TICKET_OPEN
		return TRUE

//Set ticket state with key N to resolved
/datum/controller/subsystem/tickets/proc/resolveTicket(N)
	var/datum/ticket/T = allTickets69N69
	if(T.ticketState != TICKET_RESOLVED)
		T.ticketState = TICKET_RESOLVED
		log_admin("<span class='69span_class69'>69usr.client69 / (69usr69) resolved 69ticket_name69 number 69N69</span>")
		message_admins("<span class='69span_class69'>69usr.client69 / (69usr69) resolved 69ticket_name69 number 69N69</span>")
		to_chat_safe(returnClient(N), "<span class='69span_class69'>Your 69ticket_name69 has now been resolved.</span>")
		return TRUE

/datum/controller/subsystem/tickets/proc/convert_to_other_ticket(ticketId)
	if(!check_rights(rights_needed))
		return
	if(alert("Are you sure to convert this ticket to an '69other_ticket_name69' ticket?",,"Yes","No") != "Yes")
		return
	if(!other_ticket_system_staff_check())
		return
	var/datum/ticket/T = allTickets69ticketId69
	if(T.ticket_converted)
		to_chat(usr, "<span class='warning'>This ticket has already been converted!</span>")
		return
	convert_ticket(T)

/datum/controller/subsystem/tickets/proc/other_ticket_system_staff_check()
	var/list/staff = staff_countup(other_ticket_permission)
	if(!staff69169)
		if(alert("No active staff online to answer the ticket. Are you sure you want to convert the ticket?",, "No", "Yes") != "Yes")
			return FALSE
	return TRUE

/datum/controller/subsystem/tickets/proc/convert_ticket(datum/ticket/T)
	T.ticketState = TICKET_CLOSED
	T.ticket_converted = TRUE
	var/client/C = usr.client
	var/client/owner = get_client_by_ckey(T.client_ckey)
	to_chat_safe(owner, list("<span class='69span_class69'>69C69 has converted your ticket to a 69other_ticket_name69 ticket.</span>",\
									"<span class='69span_class69'>Be sure to use the correct type of help next time!</span>"))
	log_admin("<span class='69span_class69'>69C69 has converted ticket number 69T.ticketNum69 to a 69other_ticket_name69 ticket.</span>")
	message_admins("<span class='69span_class69'>69C69 has converted ticket number 69T.ticketNum69 to a 69other_ticket_name69 ticket.</span>")
	create_other_system_ticket(T)

/datum/controller/subsystem/tickets/proc/create_other_system_ticket(datum/ticket/T)
	var/client/C = get_client_by_ckey(T.client_ckey)
	SSmentor_tickets.newTicket(C, T.content, T.raw_title)

/datum/controller/subsystem/tickets/proc/autoRespond(N)
	if(!check_rights(rights_needed))
		return

	var/datum/ticket/T = allTickets69N69
	var/client/C = usr.client
	if((T.staffAssigned && T.staffAssigned != C) || (T.lastStaffResponse && T.lastStaffResponse != C) || ((T.ticketState != TICKET_OPEN) && (T.ticketState != TICKET_STALE))) //if someone took this ticket, is it the same admin who is autoresponding? if so, then skip the warning
		if(alert(usr, "69T.ticketState == TICKET_OPEN ? "Another admin appears to already be handling this." : "This ticket is already69arked as closed or resolved"69 Are you sure you want to continue?", "Confirmation", "Yes", "No") != "Yes")
			return
	T.assignStaff(C)

	var/response_phrases = list("Thanks" = "Thanks, have a good day!",
		"Handling It" = "The issue is being looked into, thanks.",
		"Already Resolved" = "The problem has been resolved already.",
		//"Mentorhelp" = "Please redirect your question to69entorhelp, as they are better experienced with these types of questions.",
		"Happens Again" = "Thanks, let us know if it continues to happen.",
		"Github Discord Issue Report" = "To report a bug, please go to our Github page. Then go to 'Issues'. Then 'New Issue'. Then fill out the report form. If the report would reveal current-round information, file it after the round ends. If you prefer, you can also report it in the Junkyard channel of our Discord.",
		"Clear Cache" = "To fix a blank screen, go to the 'Special69erbs' tab and press 'Reload UI Resources'. If that fails, clear your BYOND cache (instructions provided with 'Reload UI Resources'). If that still fails, please adminhelp again, stating you have already done the following." ,
		"IC Issue" = "This is an In Character (IC) issue and will not be handled by admins. You could speak to IronHammer security forces, a departmental head or any other relevant authority currently aboard the ship.",
		"Reject" = "Reject",
		"Man Up" = "Man Up",
		"Skill Issue" = "Skill Issue",
		"Appeal on the Forums" = "Appealing a ban69ust occur on the forums. Privately69essaging, or adminhelping about your ban will not resolve it."
		)

	var/sorted_responses = list()
	for(var/key in response_phrases)	//build a new list based on the short descriptive keys of the69aster list so we can send this as the input instead of the full paragraphs to the admin choosing which autoresponse
		sorted_responses += key

	var/message_key = input("Select an autoresponse. This will69ark the ticket as resolved.", "Autoresponse") as null|anything in sortTim(sorted_responses, /proc/cmp_text_asc) //use sortTim and cmp_text_asc to sort alphabetically
	var/client/ticket_owner = get_client_by_ckey(T.client_ckey)
	switch(message_key)
		if(null) //they cancelled
			T.staffAssigned = initial(T.staffAssigned) //if they cancel we dont need to hold this ticket anymore
			return
		//if("Mentorhelp")
		//	convert_ticket(T)
		if("Reject")
			if(!closeTicket(N))
				to_chat(C, "Unable to close ticket")
		if("Man Up")
			C.man_up(returnClient(N))
		if("Skill Issue")
			C.skill_issue(returnClient(N))	
		else
			to_chat_safe(returnClient(N), "<span class='69span_class69'>69C69 is autoresponding with: <span/> <span class='adminticketalt'>69response_phrases69message_key6969</span>")//for this we want the full69alue of whatever key this is to tell the player so we do response_phrases69message_key69
	sound_to(returnClient(N), "sound/effects/adminhelp.ogg")
	log_admin("69C69 has auto responded to 69ticket_owner69\'s adminhelp with:<span class='adminticketalt'> 69message_key69 </span>") //we want to use the short named keys for this instead of the full sentence which is why we just do69essage_key
	T.lastStaffResponse = "Autoresponse: 69message_key69"
	resolveTicket(N)

//Set ticket state with key N to closed
/datum/controller/subsystem/tickets/proc/closeTicket(N)
	var/datum/ticket/T = allTickets69N69
	if(T.ticketState != TICKET_CLOSED)
		log_admin("<span class='69span_class69'>69usr.client69 / (69usr69) closed 69ticket_name69 number 69N69</span>")
		message_admins("<span class='69span_class69'>69usr.client69 / (69usr69) closed 69ticket_name69 number 69N69</span>")
		to_chat_safe(returnClient(N), close_messages)
		T.ticketState = TICKET_CLOSED
		return TRUE

//Check if the user already has a ticket open and within the cooldown period.
/datum/controller/subsystem/tickets/proc/checkForOpenTicket(client/C)
	for(var/datum/ticket/T in allTickets)
		if(T.client_ckey == C.ckey && T.ticketState == TICKET_OPEN && (T.ticketCooldown > world.time))
			return T
	return FALSE

//Check if the user has ANY ticket not resolved or closed.
/datum/controller/subsystem/tickets/proc/checkForTicket(client/C)
	var/list/tickets = list()
	for(var/datum/ticket/T in allTickets)
		if(T.client_ckey == C.ckey && (T.ticketState == TICKET_OPEN || T.ticketState == TICKET_STALE))
			tickets += T
	if(tickets.len)
		return tickets
	return FALSE

//return the client of a ticket number
/datum/controller/subsystem/tickets/proc/returnClient(N)
	var/datum/ticket/T = allTickets69N69
	return get_client_by_ckey(T.client_ckey)

/datum/controller/subsystem/tickets/proc/assignStaffToTicket(client/C, N)
	var/datum/ticket/T = allTickets69N69
	if(T.staffAssigned != null && T.staffAssigned != C && alert("Ticket is already assigned to 69T.staffAssigned.ckey69. Are you sure you want to take it?", "Take ticket", "Yes", "No") != "Yes")
		return FALSE
	T.assignStaff(C)
	return TRUE

//Single staff ticket

/datum/ticket
	/// Ticket number.
	var/ticketNum
	/// ckey of the client who opened the ticket.
	var/client_ckey
	/// Time the ticket was opened.
	var/timeOpened
	/// The initial69essage with links.
	var/title
	/// The title without URLs added.
	var/raw_title
	/// Content of the staff help.
	var/list/content
	/// Last staff69ember who responded.
	var/lastStaffResponse
	/// When the staff last responded.
	var/lastResponseTime
	/// The location the player was when they sent the ticket.
	var/locationSent
	/// The69ob the player was controlling when they sent the ticket.
	var/mobControlled
	/// State of the ticket, open, closed, resolved etc.
	var/ticketState
	/// Has the ticket been converted to another type? (Mhelp to Ahelp, etc.)
	var/ticket_converted = FALSE
	/// When the ticket goes stale.
	var/timeUntilStale
	/// Cooldown before allowing the user to open another ticket.
	var/ticketCooldown
	/// Staff69ember who has assigned themselves to this ticket.
	var/client/staffAssigned

/datum/ticket/New(tit, raw_tit, cont, num)
	title = tit
	raw_title = raw_tit
	content = list()
	content += cont
	timeOpened = worldtime2text()
	timeUntilStale = world.time + TICKET_TIMEOUT
	setCooldownPeriod()
	ticketNum = num
	ticketState = TICKET_OPEN

//Set the cooldown period for the ticket. The time when it's created plus the defined cooldown time.
/datum/ticket/proc/setCooldownPeriod()
	ticketCooldown = world.time + TICKET_DUPLICATE_COOLDOWN

//Set the last staff who responded as the client passed as an arguement.
/datum/ticket/proc/setLastStaffResponse(client/C)
	lastStaffResponse = C
	lastResponseTime = worldtime2text()

//Return the ticket state as a colour coded text string.
/datum/ticket/proc/state2text()
	if(ticket_converted)
		return "<font color='yellow'>CONVERTED</font>"
	switch(ticketState)
		if(TICKET_OPEN)
			return "<font color='green'>OPEN</font>"
		if(TICKET_RESOLVED)
			return "<font color='blue'>RESOLVED</font>"
		if(TICKET_CLOSED)
			return "<font color='red'>CLOSED</font>"
		if(TICKET_STALE)
			return "<font color='orange'>STALE</font>"

//Assign the client passed to69ar/staffAsssigned
/datum/ticket/proc/assignStaff(client/C)
	if(!C)
		return
	staffAssigned = C
	return TRUE

/datum/ticket/proc/addResponse(client/C,69sg)
	if(C.holder)
		setLastStaffResponse(C)
	msg = "69C69: 69msg69"
	content +=69sg

/datum/ticket/proc/makeStale()
	ticketState = TICKET_STALE
	return ticketNum

/*

UI STUFF

*/

/datum/controller/subsystem/tickets/proc/returnUI(tab = TICKET_OPEN)
	set name = "Open Ticket Interface"
	set category = "Tickets"

//dat
	var/trStyle = "border-top:2px solid; border-bottom:2px solid; padding-top: 5px; padding-bottom: 5px;"
	var/tdStyleleft = "border-top:2px solid; border-bottom:2px solid; width:150px; text-align:center;"
	var/tdStyle = "border-top:2px solid; border-bottom:2px solid;"
	var/datum/ticket/ticket
	var/dat
	dat += "<head><style>.adminticket{border:2px solid}</style></head>"
	dat += "<body><h1>69ticket_system_name69</h1>"

	dat +="<a href='?src=\ref69src69;refresh=1'>Refresh</a><br /><a href='?src=\ref69src69;showopen=1'>Open Tickets</a><a href='?src=\ref69src69;showresolved=1'>Resolved Tickets</a><a href='?src=\ref69src69;showclosed=1'>Closed Tickets</a>"
	if(tab == TICKET_OPEN)
		dat += "<h2>Open Tickets</h2>"
	dat += "<table style='width:1300px; border: 3px solid;'>"
	dat +="<tr style='69trStyle69'><th style='69tdStyleleft69'>Control</th><th style='69tdStyle69'>Ticket</th></tr>"
	if(tab == TICKET_OPEN)
		for(var/T in allTickets)
			ticket = T
			if(ticket.ticketState == TICKET_OPEN || ticket.ticketState == TICKET_STALE)
				dat += "<tr style='69trStyle69'><td style ='69tdStyleleft69'><a href='?src=\ref69src69;resolve=69ticket.ticketNum69'>Resolve</a><a href='?src=\ref69src69;details=69ticket.ticketNum69'>Details</a> <br /> #69ticket.ticketNum69 (69ticket.timeOpened69) 69ticket.ticketState == TICKET_STALE ? "<font color='red'><b>STALE</font>" : ""69 </td><td style='69tdStyle69'><b>69ticket.title69</td></tr>"
			else
				continue
	else  if(tab == TICKET_RESOLVED)
		dat += "<h2>Resolved Tickets</h2>"
		for(var/T in allTickets)
			ticket = T
			if(ticket.ticketState == TICKET_RESOLVED)
				dat += "<tr style='69trStyle69'><td style ='69tdStyleleft69'><a href='?src=\ref69src69;resolve=69ticket.ticketNum69'>Resolve</a><a href='?src=\ref69src69;details=69ticket.ticketNum69'>Details</a> <br /> #69ticket.ticketNum69 (69ticket.timeOpened69) </td><td style='69tdStyle69'><b>69ticket.title69</td></tr>"
			else
				continue
	else if(tab == TICKET_CLOSED)
		dat += "<h2>Closed Tickets</h2>"
		for(var/T in allTickets)
			ticket = T
			if(ticket.ticketState == TICKET_CLOSED)
				dat += "<tr style='69trStyle69'><td style ='69tdStyleleft69'><a href='?src=\ref69src69;resolve=69ticket.ticketNum69'>Resolve</a><a href='?src=\ref69src69;details=69ticket.ticketNum69'>Details</a> <br /> #69ticket.ticketNum69 (69ticket.timeOpened69) </td><td style='69tdStyle69'><b>69ticket.title69</td></tr>"
			else
				continue

	dat += "</table>"
	dat += "<h1>Resolve All</h1>"
	if(ticket_system_name == "Mentor Tickets")
		dat += "<a href='?src=\ref69src69;resolveall=1'>Resolve All Open69entor Tickets</a></body>"
	else
		dat += "<a href='?src=\ref69src69;resolveall=1'>Resolve All Open Admin Tickets</a></body>"

	return dat

/datum/controller/subsystem/tickets/proc/showUI(mob/user, tab)
	var/dat = null
	dat = returnUI(tab)
	var/datum/browser/popup = new(user, ticket_system_name, ticket_system_name, 1400, 600)
	popup.set_content(dat)
	popup.open()

/datum/controller/subsystem/tickets/proc/showDetailUI(mob/user, ticketID)
	var/datum/ticket/T = allTickets69ticketID69
	var/status = "69T.state2text()69"

	var/dat = "<h1>69ticket_system_name69</h1>"

	dat +="<a href='?src=\ref69src69;refresh=1'>Show All</a><a href='?src=\ref69src69;refreshdetail=69T.ticketNum69'>Refresh</a>"

	dat += "<h2>Ticket #69T.ticketNum69</h2>"

	dat += "<h3>69T.client_ckey69 / 69T.mobControlled69 opened this 69ticket_name69 at 69T.timeOpened69 at location 69T.locationSent69</h3>"
	dat += "<h4>Ticket Status: 69status69"
	dat += "<table style='width:950px; border: 3px solid;'>"
	dat += "<tr><td>69T.title69</td></tr>"

	if(T.content.len > 1)
		for(var/i = 2, i <= T.content.len, i++)
			dat += "<tr><td>69T.content69i6969</td></tr>"

	dat += "</table><br /><br />"
	dat += "<a href='?src=\ref69src69;detailreopen=69T.ticketNum69'>Re-Open</a><a href='?src=\ref69src69;detailresolve=69T.ticketNum69'>Resolve</a><br /><br />"

	if(!T.staffAssigned)
		dat += "No staff69ember assigned to this 69ticket_name69 - <a href='?src=\ref69src69;assignstaff=69T.ticketNum69'>Take Ticket</a><br />"
	else
		dat += "69T.staffAssigned69 is assigned to this Ticket. - <a href='?src=\ref69src69;assignstaff=69T.ticketNum69'>Take Ticket</a> - <a href='?src=\ref69src69;unassignstaff=69T.ticketNum69'>Unassign Ticket</a><br />"

	if(T.lastStaffResponse)
		dat += "<b>Last Staff response Response:</b> 69T.lastStaffResponse69 at 69T.lastResponseTime69"
	else
		dat +="<font color='red'>No Staff Response</font>"

	dat += "<br /><br />"

	dat += "<a href='?src=\ref69src69;detailclose=69T.ticketNum69'>Close Ticket</a>"
	// dat += "<a href='?src=\ref69src69;convert_ticket=69T.ticketNum69'>Convert Ticket</a>"

	var/datum/browser/popup = new(user, "69ticket_system_name69detail", "69ticket_system_name69 #69T.ticketNum69", 1000, 600)
	popup.set_content(dat)
	popup.open()

/datum/controller/subsystem/tickets/proc/userDetailUI(mob/user)
//dat
	var/tickets = checkForTicket(user.client)
	var/dat
	dat += "<h1>Your open 69ticket_system_name69</h1>"
	dat += "<table>"
	for(var/datum/ticket/T in tickets)
		dat += "<tr><td><h2>Ticket #69T.ticketNum69</h2></td></tr>"
		for(var/i = 1, i <= T.content.len, i++)
			dat += "<tr><td>69T.content69i6969</td></tr>"
	dat += "</table>"

	var/datum/browser/popup = new(user, "69ticket_system_name69userticketsdetail", ticket_system_name, 1000, 600)
	popup.set_content(dat)
	popup.open()

//Sends a69essage to the target safely. If the target left the server it won't throw a runtime. Also accepts lists of text
/datum/controller/subsystem/tickets/proc/to_chat_safe(target, text)
	if(!target)
		return FALSE
	if(istype(text, /list))
		for(var/T in text)
			to_chat(target, T)
	else
		to_chat(target, text)
	return TRUE

/**
 * Sends a69essage to the designated staff
 * Arguments:
 *69sg - The69essage being send
 * alt - If an alternative prefix should be used or not. Defaults to TICKET_STAFF_MESSAGE_PREFIX
 * important - If the69essage is important. If TRUE it will ignore the PREF_HEAR preferences,
               send a sound and flash the window. Defaults to FALSE
 */
/datum/controller/subsystem/tickets/proc/message_staff(msg, prefix_type = TICKET_STAFF_MESSAGE_PREFIX, important = FALSE)
	switch(prefix_type)
		if(TICKET_STAFF_MESSAGE_ADMIN_CHANNEL)
			msg = "<span class='admin_channel'>ADMIN TICKET: 69msg69</span>"
		if(TICKET_STAFF_MESSAGE_PREFIX)
			msg = "<span class='adminticket'><span class='prefix'>ADMIN TICKET:</span> 69msg69</span>"
	message_adminTicket(msg, important)

/datum/controller/subsystem/tickets/Topic(href, href_list)

	if(href_list69"refresh"69)
		showUI(usr)
		return

	if(href_list69"refreshdetail"69)
		var/indexNum = text2num(href_list69"refreshdetail"69)
		showDetailUI(usr, indexNum)
		return

	if(href_list69"showopen"69)
		showUI(usr, TICKET_OPEN)
		return
	if(href_list69"showresolved"69)
		showUI(usr, TICKET_RESOLVED)
		return
	if(href_list69"showclosed"69)
		showUI(usr, TICKET_CLOSED)
		return

	if(href_list69"details"69)
		var/indexNum = text2num(href_list69"details"69)
		showDetailUI(usr, indexNum)
		return

	if(href_list69"resolve"69)
		var/indexNum = text2num(href_list69"resolve"69)
		if(resolveTicket(indexNum))
			showUI(usr)

	if(href_list69"detailresolve"69)
		var/indexNum = text2num(href_list69"detailresolve"69)
		if(resolveTicket(indexNum))
			showDetailUI(usr, indexNum)

	if(href_list69"detailclose"69)
		var/indexNum = text2num(href_list69"detailclose"69)
		if(!check_rights(close_rights))
			to_chat(usr, "<span class='warning'>Not enough rights to close this ticket.</span>")
			return
		if(alert("Are you sure? This will send a negative69essage.",,"Yes","No") != "Yes")
			return
		if(closeTicket(indexNum))
			showDetailUI(usr, indexNum)

	if(href_list69"detailreopen"69)
		var/indexNum = text2num(href_list69"detailreopen"69)
		if(openTicket(indexNum))
			showDetailUI(usr, indexNum)

	if(href_list69"assignstaff"69)
		var/indexNum = text2num(href_list69"assignstaff"69)
		takeTicket(indexNum)
		showDetailUI(usr, indexNum)

	if(href_list69"unassignstaff"69)
		var/indexNum = text2num(href_list69"unassignstaff"69)
		unassignTicket(indexNum)
		showDetailUI(usr, indexNum)

	if(href_list69"autorespond"69)
		var/indexNum = text2num(href_list69"autorespond"69)
		autoRespond(indexNum)

	/*if(href_list69"convert_ticket"69)
		var/indexNum = text2num(href_list69"convert_ticket"69)
		convert_to_other_ticket(indexNum)*/

	if(href_list69"resolveall"69)
		/*if(ticket_system_name == "Mentor Tickets")
			usr.client.resolveAllMentorTickets()
		else*/
		usr.client.resolveAllAdminTickets()

/datum/controller/subsystem/tickets/proc/takeTicket(var/index)
	if(assignStaffToTicket(usr.client, index))
		log_admin("<span class='69span_class69'>69usr.client69 / (69usr69) has taken 69ticket_name69 number 69index69</span>")
		message_admins("<span class='69span_class69'>69usr.client69 / (69usr69) has taken 69ticket_name69 number 69index69</span>")
		to_chat_safe(returnClient(index), "<span class='69span_class69'>Your 69ticket_name69 is being handled by 69usr.client69.</span>")

/datum/controller/subsystem/tickets/proc/unassignTicket(index)
	var/datum/ticket/T = allTickets69index69
	if(T.staffAssigned != null && (T.staffAssigned == usr.client || alert("Ticket is already assigned to 69T.staffAssigned69. Do you want to unassign it?","Unassign ticket","No","Yes") == "Yes"))
		T.staffAssigned = null
		to_chat_safe(returnClient(index), "<span class='69span_class69'>Your 69ticket_name69 has been unassigned. Another staff69ember will help you soon.</span>")
		log_admin("<span class='69span_class69'>69usr.client69 / (69usr69) has unassigned 69ticket_name69 number 69index69</span>")
		message_admins("<span class='69span_class69'>69usr.client69 / (69usr69) has unassigned 69ticket_name69 number 69index69</span>")

#undef TICKET_STAFF_MESSAGE_ADMIN_CHANNEL
#undef TICKET_STAFF_MESSAGE_PREFIX
