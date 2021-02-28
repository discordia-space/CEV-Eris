//Verbs

ADMIN_VERB_ADD(/client/proc/openAdminTicketUI, R_ADMIN, FALSE)
/client/proc/openAdminTicketUI()

	set name = "Open Admin Ticket Interface"
	set category = "Admin"

	if(!check_rights(R_ADMIN))
		return

	SStickets.showUI(usr)

ADMIN_VERB_ADD(/client/proc/resolveAllAdminTickets, R_ADMIN, FALSE)
/client/proc/resolveAllAdminTickets()
	set name = "Resolve All Open Admin Tickets"
	set category = null

	if(!check_rights(R_ADMIN))
		return

	if(alert("Are you sure you want to resolve ALL open admin tickets?","Resolve all open admin tickets?","Yes","No") != "Yes")
		return

	SStickets.resolveAllOpenTickets()

ADMIN_VERB_ADD(/client/verb/openAdminUserUI, R_ADMIN, FALSE)
/client/verb/openAdminUserUI()
	set name = "My Admin Tickets"
	set category = "Admin"
	SStickets.userDetailUI(usr)
