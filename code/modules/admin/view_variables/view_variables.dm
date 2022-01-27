
//69ariables to not even show in the list.
// step_* and bound_* are here because they literally break the game and do nothing else.
// parent_type is here because it's pointless to show in69V.
/var/list/view_variables_hide_vars = list("bound_x", "bound_y", "bound_height", "bound_width", "bounds", "parent_type", "step_x", "step_y", "step_size", "queued_priority", "gc_destroyed", "is_processing")
//69ariables not to expand the lists of.69ars is pointless to expand, and overlays/underlays cannot be expanded.
/var/list/view_variables_dont_expand = list("overlays", "underlays", "vars")
//69ariables that runtime if you try to test associativity of the lists they contain by indexing
/var/list/view_variables_no_assoc = list("verbs", "contents","screen","images", "vis_contents", "vis_locs")

// Acceptable 'in world', as69V would be incredibly hampered otherwise
ADMIN_VERB_ADD(/client/proc/debug_variables, R_ADMIN | R_MOD, FALSE)
//allows us to -see- the69ariables of any instance in the game. +VAREDIT needed to69odify
/client/proc/debug_variables(datum/D in world)
	set category = "Debug"
	set name = "View69ariables"

	if(!check_rights(0))
		return

	if(!D)
		return

	var/icon/sprite
	if(istype(D, /atom))
		var/atom/A = D
		if(A.icon && A.icon_state)
			sprite = icon(A.icon, A.icon_state)
			usr << browse_rsc(sprite, "view_vars_sprite.png")

	usr << browse_rsc('code/js/view_variables.js', "view_variables.js")

	var/html = {"
		<html>
		<head>
			<script src='view_variables.js'></script>
			<title>69D69 (\ref69D69 - 69D.type69)</title>
			<style>
				body { font-family:69erdana, sans-serif; font-size: 9pt; }
				.value { font-family: "Courier New",69onospace; font-size: 8pt; }
			</style>
		</head>
		<body onload='selectTextField(); updateSearch()'; onkeyup='updateSearch()'>
			<div align='center'>
				<table width='100%'><tr>
					<td width='50%'>
						<table align='center' width='100%'><tr>
							69sprite ? "<td><img src='view_vars_sprite.png'></td>" : ""69
							<td><div align='center'>69D.get_view_variables_header()69</div></td>
						</tr></table>
						<div align='center'>
							<b><font size='1'>69replacetext("69D.type69", "/", "/<wbr>")69</font></b>
							69holder.marked_datum() == D ? "<br/><font size='1' color='red'><b>Marked Object</b></font>" : ""69
						</div>
					</td>
					<td width='50%'>
						<div align='center'>
							<a href='?_src_=vars;datumrefresh=\ref69D69'>Refresh</a>
							<form>
								<select name='file'
								        size='1'
								        onchange='loadPage(this.form.elements\690\69)'
								        target='_parent._top'
								        onmouseclick='this.focus()'
								        style='background-color:#ffffff'>
									<option>Select option</option>
									<option />
									<option69alue='?_src_=vars;mark_object=\ref69D69'>Mark Object</option>
									<option69alue='?_src_=vars;call_proc=\ref69D69'>Call Proc</option>
									69D.get_view_variables_options()69
								</select>
							</form>
						</div>
					</td>
				</tr></table>
			</div>
			<hr/>
			<font size='1'>
				<b>E</b> - Edit, tries to determine the69ariable type by itself.<br/>
				<b>C</b> - Change, asks you for the69ar type first.<br/>
				<b>M</b> -69ass69odify: changes this69ariable for all objects of this type.<br/>
			</font>
			<hr/>
			<table width='100%'><tr>
				<td width='20%'>
					<div align='center'>
						<b>Search:</b>
					</div>
				</td>
				<td width='80%'>
					<input type='text'
					       id='filter'
					       name='filter_text'
					      69alue=''
					       style='width:100%;' />
				</td>
			</tr></table>
			<hr/>
			<ol id='vars'>
				69make_view_variables_var_list(D)69
			</ol>
		</body>
		</html>
		"}

	usr << browse(html, "window=variables\ref69D69;size=475x650")


/proc/make_view_variables_var_list(datum/D)
	. = ""
	var/list/variables = list()
	for(var/x in D.vars)
		if(x in69iew_variables_hide_vars)
			continue
		variables += x
	variables = sortList(variables)
	for(var/x in69ariables)
		. +=69ake_view_variables_var_entry(D, x, D.vars69x69)

/proc/make_view_variables_value(value,69arname = "*")
	var/vtext = ""
	var/extra = list()
	if(isnull(value))
		vtext = "null"
	else if(istext(value))
		vtext = "\"69value69\""
	else if(isicon(value))
		vtext = "69value69"
	else if(isfile(value))
		vtext = "'69value69'"
	else if(istype(value, /datum))
		var/datum/DA =69alue
		if("69DA69" == "69DA.type69" || !"69DA69")
			vtext = "<a href='?_src_=vars;Vars=\ref69DA69'>\ref69DA69</a> - 69DA.type69"
		else
			vtext = "<a href='?_src_=vars;Vars=\ref69DA69'>\ref69DA69</a> - 69DA69 (69DA.type69)"
	else if(istype(value, /client))
		var/client/C =69alue
		vtext = "<a href='?_src_=vars;Vars=\ref69C69'>\ref69C69</a> - 69C69 (69C.type69)"
	else if(islist(value))
		var/list/L =69alue
		vtext = "/list (69L.len69)"
		if(!(varname in69iew_variables_dont_expand) && L.len > 0 && L.len < 100)
			extra += "<ul>"
			for (var/index = 1 to L.len)
				var/entry = L69index69
				if(!isnum(entry) && !isnull(entry) && !(varname in69iew_variables_no_assoc) && L69entry69 != null)
					extra += "<li>69index69: 69make_view_variables_value(entry)69 -> 69make_view_variables_value(L69entry69)69</li>"
				else
					extra += "<li>69index69: 69make_view_variables_value(entry)69</li>"
			extra += "</ul>"
	else
		vtext = "69value69"

	return "<span class=value>69vtext69</span>69jointext(extra, null)69"

/proc/make_view_variables_var_entry(datum/D,69arname,69alue, level=0)
	var/ecm = null

	if(D)
		ecm = {"
			(<a href='?_src_=vars;datumedit=\ref69D69;varnameedit=69varname69'>E</a>)
			(<a href='?_src_=vars;datumchange=\ref69D69;varnamechange=69varname69'>C</a>)
			(<a href='?_src_=vars;datummass=\ref69D69;varnamemass=69varname69'>M</a>)
			"}

	var/valuestr =69ake_view_variables_value(value,69arname)

	return "<li>69ecm6969varname69 = 69valuestr69</li>"
