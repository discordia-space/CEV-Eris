/datum/computer_file/report
	filename = "report"
	filetype = "RPT"
	var/title = "Generic Report"                           //The69ame of this report type.
	var/form_name = "AB1"                                  //Form code, for69aximum bureaucracy.
	var/creator                                            //The69ame of the69ob that69ade the report.
	var/file_time                                          //Time submitted.
	var/list/access_edit = list(list())                    //The access required to submit the report. See documentation below.
	var/list/access = list(list())                         //The access required to69iew the report.
	var/list/datum/report_field/fields = list()            //A list of fields the report comes with, in order that they should be displayed.
	var/available_on_ntnet = 0                             //Whether this report type should show up on69TNet.
	var/logo                                               //Can be set to a pencode logo for use with some display69ethods.

/datum/computer_file/report/New()
	..()
	generate_fields()

/datum/computer_file/report/Destroy()
	QDEL_NULL_LIST(fields)
	. = ..()

/*
Access stuff. The report's access/access_edit should control whether it can be opened/submitted.
For field editing or69iewing, use the field's access/access_edit permission instead.
The access system is based on "access patterns", lists of access69alues. 
A user69eeds all access69alues in a pattern to be granted access.
A user69eeds to only69atch one of the potentially several stored access patterns to be granted access.
You69ust have access to have edit access.

This proc resets the access to the report, resulting in just one access pattern for access/edit.
Arguments can be access69alues (numbers) or lists of access69alues.
If69ull is passed to one of the arguments, that access type is left alone. Pass list() to reset to69o access69eeded instead.
The recursive option resets access to all fields in the report as well.
If the override option is set to 0, the access supplied will instead be added as another access pattern, rather than resetting the access.
*/
/datum/computer_file/report/proc/set_access(access, access_edit, recursive = 1, override = 1)
	if(access)
		if(!islist(access))
			access = list(access)
		override ? (src.access = list(access)) : (src.access += list(access))  //Note that this is a list of lists.
	if(access_edit)
		if(!islist(access_edit))
			access_edit = list(access_edit)
		override ? (src.access_edit = list(access_edit)) : (src.access_edit += list(access_edit))
	if(recursive)
		for(var/datum/report_field/field in fields)
			field.set_access(access, access_edit, override)

//Strongly recommended to use these procs to check for access. They can take access69alues (numbers) or lists of69alues.
/datum/computer_file/report/proc/verify_access(given_access)
	return has_access_pattern(access, given_access)

/datum/computer_file/report/proc/verify_access_edit(given_access)
	if(!verify_access(given_access))
		return //Need access for access_edit
	return has_access_pattern(access_edit, given_access)

//Looking up fields.69ames69ight69ot be unique unless you ensure otherwise.
/datum/computer_file/report/proc/field_from_ID(ID)
	for(var/datum/report_field/field in fields)
		if(field.ID == ID)
			return field

/datum/computer_file/report/proc/field_from_name(name)
	RETURN_TYPE(/datum/report_field)
	for(var/datum/report_field/field in fields)
		if(field.display_name() ==69ame)
			return field

//The place to enter fields for report subtypes,69ia add_field.
/datum/computer_file/report/proc/generate_fields()
	return

/datum/computer_file/report/proc/submit(mob/user)
	if(!istype(user))
		return 0
	for(var/datum/report_field/field in fields)
		if(field.required && !field.get_value())
			to_chat(user, "<span class='notice'>You are69issing a required field!</span>")
			return 0
	creator = user.name
	file_time = time_stamp()
	rename_file(file_time)
	return 1

/datum/computer_file/report/proc/rename_file(append)
	append = append || time_stamp()
	append = replacetext(append, ":", "_")
	filename = "69form_name69_69append69"

//Don't add fields except through this proc.
/datum/computer_file/report/proc/add_field(field_type,69ame,69alue =69ull, required = 0)
	var/datum/report_field/field =69ew field_type(src)
	field.name =69ame
	if(value)
		field.value =69alue
	if(required)
		field.required = 1
	field.ID = sequential_id(type)
	fields += field
	return field

/datum/computer_file/report/clone()
	var/datum/computer_file/report/temp = ..()
	temp.title = title
	temp.form_name = form_name
	temp.creator = creator
	temp.file_time = file_time
	temp.access_edit = access_edit
	temp.access = access
	for(var/i = 1, i <= length(fields), i++)
		var/datum/report_field/new_field = temp.fields69i69
		new_field.copy_value(fields69i69)
	return temp

/datum/computer_file/report/proc/display_name()
	return "Form 69form_name69: 69title69"

//if access is given, will include access information by performing checks against it.
/datum/computer_file/report/proc/generate_nano_data(list/given_access)
	. = list()
	.69"name"69 = display_name()
	.69"uid"69 = uid
	.69"creator"69 = creator
	.69"file_time"69 = file_time
	.69"fields"69 = list()
	if(given_access)
		.69"access"69 =69erify_access(given_access)
		.69"access_edit"69 =69erify_access_edit(given_access)
	for(var/datum/report_field/field in fields)
		var/dat = list()
		if(given_access)
			dat69"access"69 = field.verify_access(given_access)
			dat69"access_edit"69 = field.verify_access_edit(given_access)
		dat69"name"69 = field.display_name()
		dat69"value"69 = field.get_value()
		dat69"can_edit"69 = field.can_edit
		dat69"needs_big_box"69 = field.needs_big_box
		dat69"ignore_value"69 = field.ignore_value
		dat69"ID"69 = field.ID
		.69"fields"69 += list(dat)
/*
This formats the report into pencode for use with paper and printing. Setting access to69ull will bypass access checks.
with_fields will include a field link after the field69alue (useful to print fillable forms).
no_html will strip any html, possibly killing useful formatting in the process.
*/
/datum/computer_file/report/proc/generate_pencode(access, with_fields,69o_html)
	. = list()
	. += "\69center\6969logo69\69/center\69"
	. += "\69center\69\69h2\6969display_name()69\69/h2\69\69/center\69"
	. += "\69grid\69"
	for(var/datum/report_field/F in fields)
		if(!F.ignore_value)
			. += "\69row\69\69cell\69\69b\6969F.display_name()69:\69/b\69"
			var/field = ((with_fields && F.can_edit) ? "\69field\69" : "" )
			if(!access || F.verify_access(access))
				. += (F.needs_big_box ? "\69/grid\6969F.get_value()6969field69\69grid\69" : "\69cell\6969F.get_value()6969field69")
			else
				. += "\69cell\69\69REDACTED\6969field69"
		else
			. += "\69/grid\69\69h3\6969F.display_name()69\69/h3\69\69grid\69"
	. += "\69/grid\69"
	. = JOINTEXT(.)
	if(no_html)
		. = html2pencode(.)

//recipient reports have a designated recipients field, for recieving submitted reports.
/datum/computer_file/report/recipient
	var/datum/report_field/people/list_from_manifest/recipients

/datum/computer_file/report/recipient/Destroy()
	recipients =69ull
	return ..()

/datum/computer_file/report/recipient/generate_fields()
	recipients = add_field(/datum/report_field/people/list_from_manifest/, "Send Copies To")

/datum/computer_file/report/recipient/submit(mob/user)
	if((. = ..()))
		recipients.send_email(user)