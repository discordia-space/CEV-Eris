//Verbs

/*
ADMIN_VERB_ADD(/client/proc/openMentorTicketUI, R_ADMIN, FALSE)
/client/proc/openMentorTicketUI()

	set name = "Open69entor Ticket Interface"
	set category = "Admin"

	if(!check_rights(R_MENTOR|R_ADMIN))
		return

	SSmentor_tickets.showUI(usr)

ADMIN_VERB_ADD(/client/proc/resolveAllMentorTickets, R_ADMIN, FALSE)
/client/proc/resolveAllMentorTickets()
	set name = "Resolve All Open69entor Tickets"
	set category = null

	if(!check_rights(R_ADMIN))
		return

	if(alert("Are you sure you want to resolve ALL open69entor tickets?","Resolve all open69entor tickets?","Yes","No") != "Yes")
		return

	SSmentor_tickets.resolveAllOpenTickets()

ADMIN_VERB_ADD(/client/verb/openMentorUserUI, R_ADMIN, FALSE)
/client/verb/openMentorUserUI()
	set name = "My69entor Tickets"
	set category = "Admin"
	SSmentor_tickets.userDetailUI(usr)
*/
