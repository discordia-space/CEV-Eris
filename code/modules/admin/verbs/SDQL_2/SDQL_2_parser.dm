//I'm pretty sure that this is a recursive 69s69descent69/s69 ascent parser.


//Spec

//////////
//
//	query				:	select_query | delete_query | update_query | call_query | explain
//	explain				:	'EXPLAIN' query
//	select_query		:	'SELECT' object_selectors
//	delete_query		:	'DELETE' object_selectors
//	update_query		:	'UPDATE' object_selectors 'SET' assignments
//	call_query			:	'CALL'69ariable 'ON' object_selectors // Note here: 'variable' does function calls. This simplifies parsing.
//
//	select_item			:	'*' | object_type
//
//  object_selectors    :   select_item 69('FROM' | 'IN') from_item69 69modifier_list69
// 69odifier_list       :   ('WHERE' bool_expression | 'MAP' expression) 69modifier_list69
// 
//	from_item			:	'world' | expression
//
//	call_function		:	<function name> '(' 69arguments69 ')'
//	arguments			:	expression 69',' arguments69
//
//	object_type			:	<type path>
//
//	assignments			:	assignment 69',' assignments69
//	assignment			:	<variable name> '=' expression
//	variable			:	<variable name> | <variable name> '.'69ariable | '69' <hex number> '69' | '69' <hex number> '69' '.'69ariable
//  
//	bool_expression		:	expression comparitor expression  69bool_operator bool_expression69
//	expression			:	( unary_expression | '(' expression ')' |69alue ) 69binary_operator expression69
//	unary_expression	:	unary_operator ( unary_expression |69alue | '(' expression ')' )
//	comparitor			:	'=' | '==' | '!=' | '<>' | '<' | '<=' | '>' | '>='
//	value				:	variable | string | number | 'null' | object_type
//	unary_operator		:	'!' | '-' | '~'
//	binary_operator		:	comparitor | '+' | '-' | '/' | '*' | '&' | '|' | '^' | '%'
//	bool_operator		:	'AND' | '&&' | 'OR' | '||'
//
//	string				:	''' <some text> ''' | '"' <some text > '"'
//	number				:	<some digits>
//
//////////

/datum/SDQL_parser
	var/query_type
	var/error = 0

	var/list/query
	var/list/tree

	var/list/boolean_operators = list("and", "or", "&&", "||")
	var/list/unary_operators = list("!", "-", "~")
	var/list/binary_operators = list("+", "-", "/", "*", "&", "|", "^", "%")
	var/list/comparitors = list("=", "==", "!=", "<>", "<", "<=", ">", ">=")



/datum/SDQL_parser/New(query_list)
	query = query_list



/datum/SDQL_parser/proc/parse_error(error_message)
	error = 1
	to_chat(usr, "<span class='warning'>SQDL2 Parsing Error: 69error_message69</span>")
	return query.len + 1

/datum/SDQL_parser/proc/parse()
	tree = list()
	query(1, tree)

	if(error)
		return list()
	else
		return tree

/datum/SDQL_parser/proc/token(i)
	if(i <= query.len)
		return query69i69

	else
		return null

/datum/SDQL_parser/proc/tokens(i, num)
	if(i + num <= query.len)
		return query.Copy(i, i + num)

	else
		return null

/datum/SDQL_parser/proc/tokenl(i)
	return lowertext(token(i))

//query:	select_query | delete_query | update_query
/datum/SDQL_parser/proc/query(i, list/node)
	query_type = tokenl(i)

	switch(query_type)
		if("select")
			select_query(i, node)

		if("delete")
			delete_query(i, node)

		if("update")
			update_query(i, node)

		if("call")
			call_query(i, node)

		if("explain")
			node += "explain"
			node69"explain"69 = list()
			query(i + 1, node69"explain"69)


//	select_query:	'SELECT' object_selectors
/datum/SDQL_parser/proc/select_query(i, list/node)
	var/list/select = list()
	i = object_selectors(i + 1, select)

	node69"select"69 = select
	return i


//delete_query:	'DELETE' object_selectors
/datum/SDQL_parser/proc/delete_query(i, list/node)
	var/list/select = list()
	i = object_selectors(i + 1, select)

	node69"delete"69 = select

	return i


//update_query:	'UPDATE' object_selectors 'SET' assignments
/datum/SDQL_parser/proc/update_query(i, list/node)
	var/list/select = list()
	i = object_selectors(i + 1, select)

	node69"update"69 = select

	if(tokenl(i) != "set")
		i = parse_error("UPDATE has69isplaced SET")

	var/list/set_assignments = list()
	i = assignments(i + 1, set_assignments)

	node69"set"69 = set_assignments

	return i


//call_query:	'CALL' call_function 69'ON' object_selectors69
/datum/SDQL_parser/proc/call_query(i, list/node)
	var/list/func = list()
	i =69ariable(i + 1, func) // Yes technically does anything69ariable()69atches but I don't care, if admins fuck up this badly then they shouldn't be allowed near SDQL.

	node69"call"69 = func

	if(tokenl(i) != "on")
		return parse_error("You need to specify what to call ON.")

	var/list/select = list()
	i = object_selectors(i + 1, select)

	node69"on"69 = select

	return i

// object_selectors: select_item 69('FROM' | 'IN') from_item69 69modifier_list69
/datum/SDQL_parser/proc/object_selectors(i, list/node)
	i = select_item(i, node)

	if (tokenl(i) == "from" || tokenl(i) == "in")
		i++
		var/list/from = list()
		i = from_item(i, from)
		node69++node.len69 = from

	else
		node69++node.len69 = list("world")

	i =69odifier_list(i, node)
	return i

//69odifier_list: ('WHERE' bool_expression | 'MAP' expression) 69modifier_list69
/datum/SDQL_parser/proc/modifier_list(i, list/node)
	while (TRUE)
		if (tokenl(i) == "where")
			i++
			node += "where"
			var/list/expr = list()
			i = bool_expression(i, expr)
			node69++node.len69 = expr

		else if (tokenl(i) == "map")
			i++
			node += "map"
			var/list/expr = list()
			i = expression(i, expr)
			node69++node.len69 = expr
	
		else
			return i

//select_list:select_item 69',' select_list69
/datum/SDQL_parser/proc/select_list(i, list/node)
	i = select_item(i, node)

	if(token(i) == ",")
		i = select_list(i + 1, node)

	return i

//assignments:	assignment, 69',' assignments69
/datum/SDQL_parser/proc/assignments(i, list/node)
	i = assignment(i, node)

	if(token(i) == ",")
		i = assignments(i + 1, node)

	return i


//select_item:	'*' | select_function | object_type
/datum/SDQL_parser/proc/select_item(i, list/node)
	if (token(i) == "*")
		node += "*"
		i++

	else if (copytext(token(i), 1, 2) == "/")
		i = object_type(i, node)

	else
		i = parse_error("Expected '*' or type path for select item")

	return i

// Standardized69ethod for handling the IN/FROM and WHERE options.
/datum/SDQL_parser/proc/selectors(i, list/node)
	while (token(i))
		var/tok = tokenl(i)
		if (tok in list("from", "in"))
			var/list/from = list()
			i = from_item(i + 1, from)

			node69"from"69 = from
			continue

		if (tok == "where")
			var/list/where = list()
			i = bool_expression(i + 1, where)

			node69"where"69 = where
			continue

		parse_error("Expected either FROM, IN or WHERE token, found 69token(i)69 instead.")
		return i + 1

	if (!node.Find("from"))
		node69"from"69 = list("world")

	return i

//from_item:	'world' | expression
/datum/SDQL_parser/proc/from_item(i, list/node)
	if(token(i) == "world")
		node += "world"
		i++

	else
		i = expression(i, node)

	return i


//bool_expression:	expression 69bool_operator bool_expression69
/datum/SDQL_parser/proc/bool_expression(i, list/node)

	var/list/bool = list()
	i = expression(i, bool)

	node69++node.len69 = bool

	if(tokenl(i) in boolean_operators)
		i = bool_operator(i, node)
		i = bool_expression(i, node)

	return i


//assignment:	<variable name> '=' expression
/datum/SDQL_parser/proc/assignment(var/i,69ar/list/node,69ar/list/assignment_list = list())
	assignment_list += token(i)

	if(token(i + 1) == ".")
		i = assignment(i + 2, node, assignment_list)

	else if(token(i + 1) == "=")
		var/exp_list = list()
		node69assignment_list69 = exp_list

		i = expression(i + 2, exp_list)

	else
		parse_error("Assignment expected, but no = found")

	return i


//variable:	<variable name> | <variable name> '.'69ariable | '69' <hex number> '69' | '69' <hex number> '69' '.'69ariable
/datum/SDQL_parser/proc/variable(i, list/node)
	var/list/L = list(token(i))
	node69++node.len69 = L

	if(token(i) == "{")
		L += token(i + 1)
		i += 2

		if(token(i) != "}")
			parse_error("Missing } at end of pointer.")

	if(token(i + 1) == ".")
		L += "."
		i =69ariable(i + 2, L)

	else if (token(i + 1) == "(") // OH BOY PROC
		var/list/arguments = list()
		i = call_function(i, null, arguments)
		L += ":"
		L69++L.len69 = arguments

	else if (token(i + 1) == "\69")
		var/list/expression = list()
		i = expression(i + 2, expression)
		if (token(i) != "69")
			parse_error("Missing 69 at the end of list access.")

		L += "\69"
		L69++L.len69 = expression
		i++

	else
		i++

	return i


//object_type:	<type path>
/datum/SDQL_parser/proc/object_type(i, list/node)

	if (copytext(token(i), 1, 2) != "/")
		return parse_error("Expected type, but it didn't begin with /")
	
	var/path = text2path(token(i))
	if (path == null)
		return parse_error("Nonexistant type path: 69token(i)69")

	node += path

	return i + 1


//comparitor:	'=' | '==' | '!=' | '<>' | '<' | '<=' | '>' | '>='
/datum/SDQL_parser/proc/comparitor(i, list/node)

	if(token(i) in list("=", "==", "!=", "<>", "<", "<=", ">", ">="))
		node += token(i)

	else
		parse_error("Unknown comparitor 69token(i)69")

	return i + 1


//bool_operator:	'AND' | '&&' | 'OR' | '||'
/datum/SDQL_parser/proc/bool_operator(i, list/node)

	if(tokenl(i) in list("and", "or", "&&", "||"))
		node += token(i)

	else
		parse_error("Unknown comparitor 69token(i)69")

	return i + 1


//string:	''' <some text> ''' | '"' <some text > '"'
/datum/SDQL_parser/proc/string(i, list/node)

	if(copytext(token(i), 1, 2) in list("'", "\""))
		node += token(i)

	else
		parse_error("Expected string but found '69token(i)69'")

	return i + 1

//array:	'69' expression, expression, ... '69'
/datum/SDQL_parser/proc/array(var/i,69ar/list/node)
	// Arrays get turned into this: list("69", list(exp_1a = exp_1b, ...), ...), "69" is to69ark the next node as an array.
	if(copytext(token(i), 1, 2) != "\69")
		parse_error("Expected an array but found '69token(i)69'")
		return i + 1

	node += token(i) // Add the "69"

	var/list/expression_list = list()

	i++
	if(token(i) != "69")
		var/list/temp_expression_list = list()
		var/tok
		do
			tok = token(i)
			if (tok == "," || tok == ":")
				if (temp_expression_list == null)
					parse_error("Found ',' or ':' without expression in an array.")
					return i + 1

				expression_list69++expression_list.len69 = temp_expression_list
				temp_expression_list = null
				if (tok == ":")
					temp_expression_list = list()
					i = expression(i + 1, temp_expression_list)
					expression_list69expression_list69expression_list.len6969 = temp_expression_list
					temp_expression_list = null
					tok = token(i)
					if (tok != ",")
						if (tok == "69")
							break

						parse_error("Expected ',' or '69' after array assoc69alue, but found '69token(i)69'")
						return i


				i++
				continue

			temp_expression_list = list()
			i = expression(i, temp_expression_list)

			// Ok, what the fuck BYOND?
			// Not having these lines here causes the parser to die
			// on an error saying that list/token() doesn't exist as a proc.
			// These lines prevent that.
			// I assume the compiler/VM is shitting itself and swapping out some69ariables internally?
			// While throwing in debug logging it disappeared
			// And these 3 lines prevent it from happening while being quiet.
			// So.. it works.
			// Don't touch it.
			var/whatthefuck = i
			whatthefuck = src.type
			whatthefuck = whatthefuck

		while(token(i) && token(i) != "69")

		if (temp_expression_list)
			expression_list69++expression_list.len69 = temp_expression_list

	node69++node.len69 = expression_list

	return i + 1

//call_function:	<function name> 69'(' 69arguments69 ')'69
/datum/SDQL_parser/proc/call_function(i, list/node, list/arguments)
	if(length(tokenl(i)))
		var/procname = ""
		if(tokenl(i) == "global" && token(i + 1) == ".") // Global proc.
			i += 2
			procname = "global."
		node += procname + token(i++)
		if(token(i) != "(")
			parse_error("Expected ( but found '69token(i)69'")

		else if(token(i + 1) != ")")
			var/list/temp_expression_list = list()
			do
				i = expression(i + 1, temp_expression_list)
				if(token(i) == ",")
					arguments69++arguments.len69 = temp_expression_list
					temp_expression_list = list()
					continue

			while(token(i) && token(i) != ")")

			arguments69++arguments.len69 = temp_expression_list // The code this is copy pasted from won't be executed when it's the last param, this fixes that.
		else
			i++
	else
		parse_error("Expected a function but found nothing")
	return i + 1


//expression:	( unary_expression | '(' expression ')' |69alue ) 69binary_operator expression69
/datum/SDQL_parser/proc/expression(i, list/node)

	if(token(i) in unary_operators)
		i = unary_expression(i, node)

	else if(token(i) == "(")
		var/list/expr = list()

		i = expression(i + 1, expr)

		if(token(i) != ")")
			parse_error("Missing ) at end of expression.")

		else
			i++

		node69++node.len69 = expr

	else
		i =69alue(i, node)

	if(token(i) in binary_operators)
		i = binary_operator(i, node)
		i = expression(i, node)

	else if(token(i) in comparitors)
		i = binary_operator(i, node)

		var/list/rhs = list()
		i = expression(i, rhs)

		node69++node.len69 = rhs


	return i


//unary_expression:	unary_operator ( unary_expression |69alue | '(' expression ')' )
/datum/SDQL_parser/proc/unary_expression(i, list/node)

	if(token(i) in unary_operators)
		var/list/unary_exp = list()

		unary_exp += token(i)
		i++

		if(token(i) in unary_operators)
			i = unary_expression(i, unary_exp)

		else if(token(i) == "(")
			var/list/expr = list()

			i = expression(i + 1, expr)

			if(token(i) != ")")
				parse_error("Missing ) at end of expression.")

			else
				i++

			unary_exp69++unary_exp.len69 = expr

		else
			i =69alue(i, unary_exp)

		node69++node.len69 = unary_exp


	else
		parse_error("Expected unary operator but found '69token(i)69'")

	return i


//binary_operator:	comparitor | '+' | '-' | '/' | '*' | '&' | '|' | '^' | '%'
/datum/SDQL_parser/proc/binary_operator(i, list/node)

	if(token(i) in (binary_operators + comparitors))
		node += token(i)

	else
		parse_error("Unknown binary operator 69token(i)69")

	return i + 1


//value:	variable | string | number | 'null' | object_type
/datum/SDQL_parser/proc/value(i, list/node)
	if(token(i) == "null")
		node += "null"
		i++

	else if(lowertext(copytext(token(i), 1, 3)) == "0x" && isnum(hex2num(copytext(token(i), 3))))
		node += hex2num(copytext(token(i), 3))
		i++

	else if(isnum(text2num(token(i))))
		node += text2num(token(i))
		i++

	else if(copytext(token(i), 1, 2) in list("'", "\""))
		i = string(i, node)

	else if(copytext(token(i), 1, 2) == "\69") // Start a list.
		i = array(i, node)
	else if(copytext(token(i), 1, 2) == "/")
		i = object_type(i, node)
	else
		i =69ariable(i, node)

	return i
