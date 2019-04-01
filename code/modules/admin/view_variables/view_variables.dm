
// Variables to not even show in the list.
// step_* and bound_* are here because they literally break the game and do nothing else.
// parent_type is here because it's pointless to show in VV.
/var/list/view_variables_hide_vars = list("bound_x", "bound_y", "bound_height", "bound_width", "bounds", "parent_type", "step_x", "step_y", "step_size", "queued_priority", "gc_destroyed", "is_processing")
// Variables not to expand the lists of. Vars is pointless to expand, and overlays/underlays cannot be expanded.
/var/list/view_variables_dont_expand = list("overlays", "underlays", "vars")
// Variables that runtime if you try to test associativity of the lists they contain by indexing
/var/list/view_variables_no_assoc = list("verbs", "contents","screen","images")

// Acceptable 'in world', as VV would be incredibly hampered otherwise
ADMIN_VERB_ADD(/client/proc/debug_variables, R_ADMIN | R_MOD, FALSE)
//allows us to -see- the variables of any instance in the game. +VAREDIT needed to modify
/client/proc/debug_variables(datum/D in world)
	set category = "Debug"
	set name = "View Variables"

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
			<title>[D] (\ref[D] - [D.type])</title>
			<style>
				body { font-family: Verdana, sans-serif; font-size: 9pt; }
				.value { font-family: "Courier New", monospace; font-size: 8pt; }
			</style>
		</head>
		<body onload='selectTextField(); updateSearch()'; onkeyup='updateSearch()'>
			<div align='center'>
				<table width='100%'><tr>
					<td width='50%'>
						<table align='center' width='100%'><tr>
							[sprite ? "<td><img src='view_vars_sprite.png'></td>" : ""]
							<td><div align='center'>[D.get_view_variables_header()]</div></td>
						</tr></table>
						<div align='center'>
							<b><font size='1'>[replacetext("[D.type]", "/", "/<wbr>")]</font></b>
							[holder.marked_datum() == D ? "<br/><font size='1' color='red'><b>Marked Object</b></font>" : ""]
						</div>
					</td>
					<td width='50%'>
						<div align='center'>
							<a href='?_src_=vars;datumrefresh=\ref[D]'>Refresh</a>
							<form>
								<select name='file'
								        size='1'
								        onchange='loadPage(this.form.elements\[0\])'
								        target='_parent._top'
								        onmouseclick='this.focus()'
								        style='background-color:#ffffff'>
									<option>Select option</option>
									<option />
									<option value='?_src_=vars;mark_object=\ref[D]'>Mark Object</option>
									<option value='?_src_=vars;call_proc=\ref[D]'>Call Proc</option>
									[D.get_view_variables_options()]
								</select>
							</form>
						</div>
					</td>
				</tr></table>
			</div>
			<hr/>
			<font size='1'>
				<b>E</b> - Edit, tries to determine the variable type by itself.<br/>
				<b>C</b> - Change, asks you for the var type first.<br/>
				<b>M</b> - Mass modify: changes this variable for all objects of this type.<br/>
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
					       value=''
					       style='width:100%;' />
				</td>
			</tr></table>
			<hr/>
			<ol id='vars'>
				[make_view_variables_var_list(D)]
			</ol>
		</body>
		</html>
		"}

	usr << browse(html, "window=variables\ref[D];size=475x650")


/proc/make_view_variables_var_list(datum/D)
	. = ""
	var/list/variables = list()
	for(var/x in D.vars)
		if(x in view_variables_hide_vars)
			continue
		variables += x
	variables = sortList(variables)
	for(var/x in variables)
		. += make_view_variables_var_entry(D, x, D.vars[x])

/proc/make_view_variables_value(value, varname = "*")
	var/vtext = ""
	var/extra = list()
	if(isnull(value))
		vtext = "null"
	else if(istext(value))
		vtext = "\"[value]\""
	else if(isicon(value))
		vtext = "[value]"
	else if(isfile(value))
		vtext = "'[value]'"
	else if(istype(value, /datum))
		var/datum/DA = value
		if("[DA]" == "[DA.type]" || !"[DA]")
			vtext = "<a href='?_src_=vars;Vars=\ref[DA]'>\ref[DA]</a> - [DA.type]"
		else
			vtext = "<a href='?_src_=vars;Vars=\ref[DA]'>\ref[DA]</a> - [DA] ([DA.type])"
	else if(istype(value, /client))
		var/client/C = value
		vtext = "<a href='?_src_=vars;Vars=\ref[C]'>\ref[C]</a> - [C] ([C.type])"
	else if(islist(value))
		var/list/L = value
		vtext = "/list ([L.len])"
		if(!(varname in view_variables_dont_expand) && L.len > 0 && L.len < 100)
			extra += "<ul>"
			for (var/index = 1 to L.len)
				var/entry = L[index]
				if(!isnum(entry) && !isnull(entry) && !(varname in view_variables_no_assoc) && L[entry] != null)
					extra += "<li>[index]: [make_view_variables_value(entry)] -> [make_view_variables_value(L[entry])]</li>"
				else
					extra += "<li>[index]: [make_view_variables_value(entry)]</li>"
			extra += "</ul>"
	else
		vtext = "[value]"

	return "<span class=value>[vtext]</span>[jointext(extra, null)]"

/proc/make_view_variables_var_entry(datum/D, varname, value, level=0)
	var/ecm = null

	if(D)
		ecm = {"
			(<a href='?_src_=vars;datumedit=\ref[D];varnameedit=[varname]'>E</a>)
			(<a href='?_src_=vars;datumchange=\ref[D];varnamechange=[varname]'>C</a>)
			(<a href='?_src_=vars;datummass=\ref[D];varnamemass=[varname]'>M</a>)
			"}

	var/valuestr = make_view_variables_value(value, varname)

	return "<li>[ecm][varname] = [valuestr]</li>"

#define VV_HTML_ENCODE(thing) ( sanitize ? html_encode(thing) : thing )
/proc/debug_variable(name, value, level, datum/DA = null, sanitize = TRUE)
	var/header
	if(DA)
		if (islist(DA))
			var/index = name
			if (value)
				name = DA[name] //name is really the index until this line
			else
				value = DA[name]
			header = "<li style='backgroundColor:white'>(<a href='?_src_=vars;[HrefToken()];listedit=[REF(DA)];index=[index]'>E</a>) (<a href='?_src_=vars;[HrefToken()];listchange=[REF(DA)];index=[index]'>C</a>) (<a href='?_src_=vars;[HrefToken()];listremove=[REF(DA)];index=[index]'>-</a>) "
		else
			header = "<li style='backgroundColor:white'>(<a href='?_src_=vars;[HrefToken()];datumedit=[REF(DA)];varnameedit=[name]'>E</a>) (<a href='?_src_=vars;[HrefToken()];datumchange=[REF(DA)];varnamechange=[name]'>C</a>) (<a href='?_src_=vars;[HrefToken()];datummass=[REF(DA)];varnamemass=[name]'>M</a>) "
	else
		header = "<li>"

	var/item
	if (isnull(value))
		item = "[VV_HTML_ENCODE(name)] = <span class='value'>null</span>"

	else if (istext(value))
		item = "[VV_HTML_ENCODE(name)] = <span class='value'>\"[VV_HTML_ENCODE(value)]\"</span>"

	else if (isicon(value))
		#ifdef VARSICON
		var/icon/I = new/icon(value)
		var/rnd = rand(1,10000)
		var/rname = "tmp[REF(I)][rnd].png"
		usr << browse_rsc(I, rname)
		item = "[VV_HTML_ENCODE(name)] = (<span class='value'>[value]</span>) <img class=icon src=\"[rname]\">"
		#else
		item = "[VV_HTML_ENCODE(name)] = /icon (<span class='value'>[value]</span>)"
		#endif

	else if (isfile(value))
		item = "[VV_HTML_ENCODE(name)] = <span class='value'>'[value]'</span>"

	else if (istype(value, /datum))
		var/datum/D = value
		if ("[D]" != "[D.type]") //if the thing as a name var, lets use it.
			item = "<a href='?_src_=vars;[HrefToken()];Vars=[REF(value)]'>[VV_HTML_ENCODE(name)] [REF(value)]</a> = [D] [D.type]"
		else
			item = "<a href='?_src_=vars;[HrefToken()];Vars=[REF(value)]'>[VV_HTML_ENCODE(name)] [REF(value)]</a> = [D.type]"

	else if (islist(value))
		var/list/L = value
		var/list/items = list()

		if (L.len > 0 && !(name == "underlays" || name == "overlays" || L.len > (IS_NORMAL_LIST(L) ? 50 : 150)))
			for (var/i in 1 to L.len)
				var/key = L[i]
				var/val
				if (IS_NORMAL_LIST(L) && !isnum(key))
					val = L[key]
				if (isnull(val))	// we still want to display non-null false values, such as 0 or ""
					val = key
					key = i

				items += debug_variable(key, val, level + 1, sanitize = sanitize)

			item = "<a href='?_src_=vars;[HrefToken()];Vars=[REF(value)]'>[VV_HTML_ENCODE(name)] = /list ([L.len])</a><ul>[items.Join()]</ul>"
		else
			item = "<a href='?_src_=vars;[HrefToken()];Vars=[REF(value)]'>[VV_HTML_ENCODE(name)] = /list ([L.len])</a>"

	else if (name in GLOB.bitfields)
		var/list/flags = list()
		for (var/i in GLOB.bitfields[name])
			if (value & GLOB.bitfields[name][i])
				flags += i
			item = "[VV_HTML_ENCODE(name)] = [VV_HTML_ENCODE(jointext(flags, ", "))]"
	else
		item = "[VV_HTML_ENCODE(name)] = <span class='value'>[VV_HTML_ENCODE(value)]</span>"

	return "[header][item]</li>"

#undef VV_HTML_ENCODE