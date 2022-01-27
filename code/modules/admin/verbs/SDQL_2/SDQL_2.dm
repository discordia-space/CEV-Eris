/*
	Welcome admins, badmins and coders alike, to Structured Datum Query Language.
	SDQL allows you to powerfully run code on batches of objects (or single objects, it's still unmatched even there.)
	When I say "powerfully" I69ean it you're in for a ride.

	Ok so say you want to get a list of every69ob. How does one do this?
	"SELECT /mob"
	This will open a list of every object in world that is a /mob.
	And you can69V them if you need.

	What if you want to get every69ob on a *specific z-level*?
	"SELECT /mob WHERE z == 4"

	What if you want to select every69ob on even numbered z-levels?
	"SELECT /mob WHERE z % 2 == 0"

	Can you see where this is going? You can select objects with an arbitrary expression.
	These expressions can also do69ariable access and proc calls (yes, both on-object and globals!)
	Keep reading!

	Ok. What if you want to get every69achine in the SSmachine process list? Looping through world is kinda slow.

	"SELECT * IN SSmachines.machinery"

	Here "*" as type functions as a wildcard.
	We know everything in the global SSmachines.machinery list is a69achine.

	You can specify "IN <expression>" to return a list to operate on.
	This can be any list that you can wizard together from global69ariables and global proc calls.
	Every69ariable/proc name in the "IN" block is global.
	It can also be a single object, in which case the object is wrapped in a list for you.
	So yeah SDQL is unironically better than69V for complex single-object operations.

	You can of course combine these.
	"SELECT * IN SSmachines.machinery WHERE z == 4"
	"SELECT * IN SSmachines.machinery WHERE stat & 2" // (2 is NOPOWER, can't use defines from SDQL. Sorry!)
	"SELECT * IN SSmachines.machinery WHERE stat & 2 && z == 4"

	The possibilities are endless (just don't crash the server, ok?).

	Oh it gets better.

	You can use "MAP <expression>" to run some code per object and use the result. For example:

	"SELECT /obj/machinery/power/smes69AP 69charge / capacity * 100, RCon_tag, src69"

	This will give you a list of all the APCs, their charge AND RCon tag. Useful eh?

	6969 being a list here. Yeah you can write out lists directly without > lol lists in69V. Color69atrix shenanigans inbound.

	After the "MAP" segment is executed, the rest of the query executes as if it's THAT object you just69ade (here the list).
	Yeah, by the way, you can chain these69AP / WHERE things FOREVER!

	"SELECT /mob WHERE client69AP client WHERE holder69AP holder"

	What if some dumbass admin spawned a bajillion spiders and you need to kill them all?
	Oh yeah you'd rather not delete all the spiders in69aintenace. Only that one room the spiders were spawned in.

	"DELETE /mob/living/carbon/superior_animal/giant_spider WHERE loc.loc ==69arked"

	Here I used69V to69ark the area they were in, and since loc.loc = area,69oila.
	Only the spiders in a specific area are gone.

	Or you know if you want to catch spiders that crawled into lockers too (how even?)

	"DELETE /mob/living/carbon/superior_animal/giant_spider WHERE global.get_area(src) ==69arked"

	What else can you do?

	Well suppose you'd rather gib those spiders instead of simply flat deleting them...

	"CALL gib() ON /mob/living/carbon/superior_animal/giant_spider WHERE global.get_area(src) ==69arked"

	Or you can have some fun..

	"CALL forceMove(marked) ON /mob/living/carbon/superior_animal"

	You can also run69ultiple queries sequentially:

	"CALL forceMove(marked) ON /mob/living/carbon/superior_animal; CALL gib() ON /mob/living/carbon/superior_animal"

	And finally, you can directly69odify69ariables on objects.

	"UPDATE /mob WHERE client SET client.color = 690, 1, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 069"

	Don't crash the server, OK?

	A quick recommendation: before you run something like a DELETE or another query.. Run it through SELECT first.
	You'd rather not gib every player on accident.
	Or crash the server.

	By the way, queries are slow and take a while. Be patient.
	They don't hang the entire server though.

	With great power comes great responsability.

	Here's a slightly69ore formal quick reference.

	The 4 queries you can do are:

	"SELECT <selectors>"
	"CALL <proc call> ON <selectors>"
	"UPDATE <selectors> SET69ar=<value>,var2=<value>"
	"DELETE <selectors>"

	"<selectors>" in this context is "<type> 69IN <source>69 69chain of69AP/WHERE69odifiers69"

	"IN" (or "FROM", that works too but it's kinda weird to read),
	is the list of objects to work on. This defaults to world if not provided.
	But doing something like "IN GLOB.living_mob_list" is quite handy and can optimize your query.
	All names inside the IN block are global scope, so you can do GLOB.living_mob_list (a global69ar) easily.
	You can also run it on a single object. Because SDQL is that convenient even for single operations.

	<type> filters out objects of, well, that type easily. "*" is a wildcard and just takes everything in the source list.

	And then there's the69AP/WHERE chain.
	These operate on each individual object being ran through the query.
	They're both expressions like IN, but unlike it the expression is scoped *on the object*.
	So if you do "WHERE z == 4", this does "src.z", effectively.
	If you want to access global69ariables, you can do `global.living_mob_list`.
	Same goes for procs.

	MAP "changes" the object into the result of the expression.
	WHERE "drops" the object if the expression is falsey (0, null or "")

	What can you do inside expressions?

	* Proc calls
	*69ariable reads
	* Literals (numbers, strings, type paths, etc...)
	* \ref referencing: {0x30000cc} grabs the object with \ref 690x30000cc69
	* Lists: 69a, b, c69 or 69a: b, c: d69
	*69ath and stuff.
	* A few special69ariables: src (the object currently scoped on), usr (your69ob),69arked (your69arked datum), global(global scope)
*/

// Used by update statements, this is to handle shit like preventing editing the /datum/admins though SDQL but WITHOUT +PERMISSIONS.
// Assumes the69ariable actually exists.
/datum/proc/SDQL_update(var/const/var_name,69ar/new_value)
	vars69var_name69 = new_value
	return 1

// Because /client isn't a subtype of /datum...
/client/proc/SDQL_update(var/const/var_name,69ar/new_value)
	vars69var_name69 = new_value
	return 1

ADMIN_VERB_ADD(/client/proc/SDQL2_query, R_DEBUG, FALSE)
/client/proc/SDQL2_query(query_text as69essage)
	set category = "Debug"
	if(!check_rights(R_DEBUG))  //Shouldn't happen... but just to be safe.
		message_admins("\red ERROR: Non-admin 69usr.key69 attempted to execute a SDQL query!")
		log_admin("Non-admin 69usr.key69 attempted to execute a SDQL query!")

	if(!query_text || length(query_text) < 1)
		return

	var/query_log = "69key_name(src)69 executed SDQL query: \"69query_text69\"."
	world.log << query_log
	message_admins(query_log)
	log_game(query_log)
	sleep(-1) // Incase the server crashes due to a huge query, we allow the server to log the above things (it69ight just delay it).

	var/list/query_list = SDQL2_tokenize(query_text)

	if(!query_list || query_list.len < 1)
		return

	var/list/querys = SDQL_parse(query_list)

	if (!querys || querys.len < 1)
		return

	try
		for(var/list/query_tree in querys)
			var/list/object_selectors = list()

			switch(query_tree69169)
				if("explain")
					SDQL_testout(query_tree69"explain"69)
					return

				if("call")
					object_selectors = query_tree69"on"69

				if("select", "delete", "update")
					object_selectors = query_tree69query_tree6916969

			var/list/objs = SDQL_from_object_selectors(object_selectors)

			switch(query_tree69169)
				if("call")
					for(var/datum/d in objs)
						SDQL_var(d, query_tree69"call"6969169, source = d)
						CHECK_TICK

					to_chat(usr, "SDQL Query done")

				if("delete")
					for(var/datum/d in objs)
						qdel(d)
						CHECK_TICK

					to_chat(usr, "SDQL Query done")

				if("select")
					var/list/text_list = list()
					for (var/t in objs)
						SDQL_print(t, text_list)
						text_list += "<br>"
						CHECK_TICK

					var/text = text_list.Join()

					if (text)
						var/static/result_offset = 0
						usr << browse(text, "window=SDQL-result-69result_offset++69")
					else
						to_chat(usr, "Query finished without any results.")

				if("update")
					if("set" in query_tree)
						var/list/set_list = query_tree69"set"69
						for(var/d in objs)
							if (!is_proper_datum(d))
								continue
							for(var/list/sets in set_list)
								var/datum/temp = d
								var/i = 0
								for(var/v in sets)
									if(++i == sets.len)
										if(istype(temp, /turf) && (v == "x" ||69 == "y" ||69 == "z"))
											break


										temp.SDQL_update(v, SDQL_expression(d, set_list69sets69))
										break

									if(temp.vars.Find(v) && (istype(temp.vars69v69, /datum) || istype(temp.vars69v69, /client)))
										temp = temp.vars69v69

									else
										break

							CHECK_TICK

					to_chat(usr, "SDQL Query done")

	catch (var/exception/e)
		to_chat(usr, SPAN_DANGER("An exception has occured during the execution of your query and your query has been aborted."))
		to_chat(usr, "exception name: 69e.name69")
		to_chat(usr, "file/line: 69e.file69/69e.line69")

/proc/SDQL_parse(list/query_list)
	var/datum/SDQL_parser/parser = new()
	var/list/querys = list()
	var/list/query_tree = list()
	var/pos = 1
	var/querys_pos = 1
	var/do_parse = 0
	for(var/val in query_list)
		if(val == ";")
			do_parse = 1
		else if(pos >= query_list.len)
			query_tree +=69al
			do_parse = 1
		if(do_parse)
			parser.query = query_tree
			var/list/parsed_tree
			parsed_tree = parser.parse()
			if(parsed_tree.len > 0)
				querys.len = querys_pos
				querys69querys_pos69 = parsed_tree
				querys_pos++
			else //There was an error so don't run anything, and tell the user which query has errored.
				to_chat(usr, SPAN_DANGER("Parsing error on 69querys_pos69\th query. Nothing was executed."))
				return list()
			query_tree = list()
			do_parse = 0
		else
			query_tree +=69al
		pos++

	qdel(parser)

	return querys



/proc/SDQL_testout(list/query_tree, indent = 0)
	var/spaces = ""
	for(var/s = 0, s < indent, s++)
		spaces += "&nbsp;&nbsp;&nbsp;&nbsp;"

	for(var/item in query_tree)
		if(istype(item, /list))
			to_chat(usr, "69spaces69(")
			SDQL_testout(item, indent + 1)
			to_chat(usr, "69spaces69)")

		else
			to_chat(usr, "69spaces6969item69")

		if(!isnum(item) && query_tree69item69)

			if(istype(query_tree69item69, /list))
				to_chat(usr, "69spaces69&nbsp;&nbsp;&nbsp;&nbsp;(")
				SDQL_testout(query_tree69item69, indent + 2)
				to_chat(usr, "69spaces69&nbsp;&nbsp;&nbsp;&nbsp;)")

			else
				to_chat(usr, "69spaces69&nbsp;&nbsp;&nbsp;&nbsp;69query_tree69item6969")

/proc/SDQL_from_objs(list/tree)
	if("world" in tree)
		return world

	return SDQL_expression(world, tree)


/proc/SDQL_get_all(type, location)
	var/list/out = list()

	// If only a single object got returned, wrap it into a list so the for loops run on it.
	if (!islist(location) && location != world)
		location = list(location)

	if (type == "*")
		for (var/x in location)
			out += x

		return out

	if(ispath(type, /mob))
		for(var/mob/d in location)
			if(istype(d, type))
				out += d

	else if(ispath(type, /turf))
		for(var/turf/d in location)
			if(istype(d, type))
				out += d

	else if(ispath(type, /obj))
		for(var/obj/d in location)
			if(istype(d, type))
				out += d

	else if(ispath(type, /area))
		for(var/area/d in location)
			if(istype(d, type))
				out += d

	else if(ispath(type, /atom))
		for(var/atom/d in location)
			if(istype(d, type))
				out += d

	else
		for(var/datum/d in location)
			if(istype(d, type))
				out += d

	return out


/proc/SDQL_from_object_selectors(list/tree)
	var/type = tree69169
	var/list/from = tree69269

	var/list/objs = SDQL_from_objs(from)
	CHECK_TICK
	objs = SDQL_get_all(type, objs)
	CHECK_TICK

	// 1 and 2 are type and FROM.
	var/i = 3
	while (i <= tree.len)
		var/key = tree69i++69
		var/list/expression = tree69i++69
		switch (key)
			if ("map")
				for (var/j = 1 to objs.len)
					var/x = objs69j69
					objs69j69 = SDQL_expression(x, expression)
					CHECK_TICK

			if ("where")
				var/list/out = list()
				for (var/x in objs)
					if (SDQL_expression(x, expression))
						out += x
					CHECK_TICK
				objs = out

	return objs

/proc/SDQL_expression(object, list/expression, start = 1)
	var/result = 0
	var/val

	for(var/i = start, i <= expression.len, i++)
		var/op = ""

		if(i > start)
			op = expression69i69
			i++

		var/list/ret = SDQL_value(object, expression, i)
		val = ret69"val"69
		i = ret69"i"69

		if(op != "")
			switch(op)
				if("+")
					result +=69al
				if("-")
					result -=69al
				if("*")
					result *=69al
				if("/")
					result /=69al
				if("&")
					result &=69al
				if("|")
					result |=69al
				if("^")
					result ^=69al
				if("%")
					result %=69al
				if("=", "==")
					result = (result ==69al)
				if("!=", "<>")
					result = (result !=69al)
				if("<")
					result = (result <69al)
				if("<=")
					result = (result <=69al)
				if(">")
					result = (result >69al)
				if(">=")
					result = (result >=69al)
				if("and", "&&")
					result = (result &&69al)
				if("or", "||")
					result = (result ||69al)
				else
					to_chat(usr, SPAN_WARNING("SDQL2: Unknown op 69op69"))
					result = null
		else
			result =69al

	return result

/proc/SDQL_value(object, list/expression, start = 1)
	var/i = start
	var/val = null

	if(i > expression.len)
		return list("val" = null, "i" = i)

	if(istype(expression69i69, /list))
		val = SDQL_expression(object, expression69i69)

	else if(expression69i69 == "!")
		var/list/ret = SDQL_value(object, expression, i + 1)
		val = !ret69"val"69
		i = ret69"i"69

	else if(expression69i69 == "~")
		var/list/ret = SDQL_value(object, expression, i + 1)
		val = ~ret69"val"69
		i = ret69"i"69

	else if(expression69i69 == "-")
		var/list/ret = SDQL_value(object, expression, i + 1)
		val = -ret69"val"69
		i = ret69"i"69

	else if(expression69i69 == "null")
		val = null

	else if(isnum(expression69i69))
		val = expression69i69

	else if(ispath(expression69i69))
		val = expression69i69

	else if(copytext(expression69i69, 1, 2) in list("'", "\""))
		val = copytext(expression69i69, 2, length(expression69i69))

	else if(expression69i69 == "\69")
		var/list/expressions_list = expression69++i69
		val = list()
		for(var/list/expression_list in expressions_list)
			var/result = SDQL_expression(object, expression_list)
			var/assoc
			if (expressions_list69expression_list69 != null)
				assoc = SDQL_expression(object, expressions_list69expression_list69)

			if (assoc != null)
				// Need to insert the key like this to prevent duplicate keys fucking up.
				var/list/dummy = list()
				dummy69result69 = assoc
				result = dummy

			val += result

	else
		val = SDQL_var(object, expression, i, object)
		i = expression.len

	return list("val" =69al, "i" = i)

/proc/SDQL_var(object, list/expression, start = 1, source)
	var/v
	var/static/list/exclude = list("usr", "src", "marked", "global")
	var/long = start < expression.len
	var/datum/D
	if (is_proper_datum(object))
		D = object

	if (object == world && (!long || expression69start + 169 == ".") && !(expression69start69 in exclude))
		v = global.vars69expression69start6969

	else if (expression 69start69 == "{" && long)
		if (lowertext(copytext(expression69start + 169, 1, 3)) != "0x")
			to_chat(usr, SPAN_DANGER("Invalid pointer syntax: 69expression69start + 16969"))
			return null
		v = locate("\6969expression69start + 1696969")
		if (!v)
			to_chat(usr, SPAN_DANGER("Invalid pointer: 69expression69start + 16969"))
			return null
		start++
		long = start < expression.len

	else if (D != null && (!long || expression69start + 169 == ".") && (expression69start69 in D.vars))
		v = D.vars69expression69start6969

	else if (D != null && long && expression69start + 169 == ":" && hascall(D, expression69start69))
		v = expression69start69

	else if (!long || expression69start + 169 == ".")
		switch(expression69start69)
			if("usr")
				v = usr
			if("src")
				v = source
			if("marked")
				if(usr.client && usr.client.holder && usr.client.holder.marked_datum())
					v = usr.client.holder.marked_datum()
				else
					return null
			if("global")
				v = world // World is69ostly a token, really.
			else
				return null

	else if (object == world) // Shitty ass hack kill69e.
		v = expression69start69

	if(long)
		if (expression69start + 169 == ".")
			return SDQL_var(v, expression69start + 269, source = source)

		else if (expression69start + 169 == ":")
			return SDQL_function(object,69, expression69start + 269, source)

		else if (expression69start + 169 == "\69" && islist(v))
			var/list/L =69
			var/index = SDQL_expression(source, expression69start + 269)
			if (isnum(index) && (!ISINTEGER(index) || L.len < index))
				to_chat(usr, SPAN_DANGER("Invalid list index: 69index69"))
				return null

			return L69index69

	return69


/proc/SDQL_function(var/object,69ar/procname,69ar/list/arguments, source)
	set waitfor = FALSE

	var/list/new_args = list()
	for(var/arg in arguments)
		new_args69++new_args.len69 = SDQL_expression(source, arg)

	if (object == world) // Global proc.
		procname = "/proc/69procname69"
		return call(procname)(arglist(new_args))

	return call(object, procname)(arglist(new_args)) // Spawn in case the function sleeps.


/proc/SDQL2_tokenize(query_text)


	var/list/whitespace = list(" ", "\n", "\t")
	var/list/single = list("(", ")", ",", "+", "-", ".", "\69", "69", "{", "}", ";", ":")
	var/list/multi = list(
					"=" = list("", "="),
					"<" = list("", "=", ">"),
					">" = list("", "="),
					"!" = list("", "="))

	var/word = ""
	var/list/query_list = list()
	var/len = length(query_text)

	for(var/i = 1, i <= len, i++)
		var/char = copytext(query_text, i, i + 1)

		if(char in whitespace)
			if(word != "")
				query_list += word
				word = ""

		else if(char in single)
			if(word != "")
				query_list += word
				word = ""

			query_list += char

		else if(char in69ulti)
			if(word != "")
				query_list += word
				word = ""

			var/char2 = copytext(query_text, i + 1, i + 2)

			if(char2 in69ulti69char69)
				query_list += "69char6969char269"
				i++

			else
				query_list += char

		else if(char == "'")
			if(word != "")
				to_chat(usr, SPAN_WARNING("SDQL2: You have an error in your SDQL syntax, unexpected ' in query: \"<font color=gray>69query_text69</font>\" following \"<font color=gray>69word69</font>\". Please check your syntax, and try again."))
				return null

			word = "'"

			for(i++, i <= len, i++)
				char = copytext(query_text, i, i + 1)

				if(char == "'")
					if(copytext(query_text, i + 1, i + 2) == "'")
						word += "'"
						i++

					else
						break

				else
					word += char

			if(i > len)
				to_chat(usr, SPAN_WARNING("SDQL2: You have an error in your SDQL syntax, unmatched ' in query: \"<font color=gray>69query_text69</font>\". Please check your syntax, and try again."))
				return null

			query_list += "69word69'"
			word = ""

		else if(char == "\"")
			if(word != "")
				to_chat(usr, SPAN_WARNING("SDQL2: You have an error in your SDQL syntax, unexpected \" in query: \"<font color=gray>69query_text69</font>\" following \"<font color=gray>69word69</font>\". Please check your syntax, and try again."))
				return null

			word = "\""

			for(i++, i <= len, i++)
				char = copytext(query_text, i, i + 1)

				if(char == "\"")
					if(copytext(query_text, i + 1, i + 2) == "'")
						word += "\""
						i++

					else
						break

				else
					word += char

			if(i > len)
				to_chat(usr, SPAN_WARNING("SDQL2: You have an error in your SDQL syntax, unmatched \" in query: \"<font color=gray>69query_text69</font>\". Please check your syntax, and try again."))
				return null

			query_list += "69word69\""
			word = ""

		else
			word += char

	if(word != "")
		query_list += word
	return query_list


/proc/is_proper_datum(object)
	return istype(object, /datum) || istype(object, /client)

/proc/SDQL_print(object, list/text_list)
	if (is_proper_datum(object))
		text_list += "<A HREF='?_src_=vars;Vars=\ref69object69'>\ref69object69</A>"
		if(istype(object, /atom))
			var/atom/a = object

			if(a.x)
				text_list += ": 69object69 at (69a.x69, 69a.y69, 69a.z69)"

			else if(a.loc && a.loc.x)
				text_list += ": 69object69 in 69a.loc69 at (69a.loc.x69, 69a.loc.y69, 69a.loc.z69)"

			else
				text_list += ": 69object69"

		else
			text_list += ": 69object69"

	else if (islist(object))
		var/list/L = object
		var/first = TRUE
		text_list += "\69"
		for (var/x in L)
			if (!first)
				text_list += ", "
			first = FALSE
			SDQL_print(x, text_list)
			if (!isnull(x) && !isnum(x) && L69x69 != null)
				text_list += " -> "
				SDQL_print(L69L69x6969)

		text_list += "69"

	else
		if (isnull(object))
			text_list += "NULL"

		else
			text_list += "69object69"
