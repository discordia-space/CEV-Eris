/datum/stack
	var/list/stack
	var/max_elements = 0

/datum/stack/New(list/elements, max)
	..()
	stack = elements ? elements.Copy() : list()
	if(max)
		max_elements = max

/datum/stack/Destroy()
	clear()
	return ..()

/datum/stack/proc/pop()
	if(!is_empty())
		. = stack[stack.len]
		stack.Cut(stack.len, 0)

/datum/stack/proc/push(element)
	if((max_elements == 0) || (stack.len < max_elements))
		stack += element

/datum/stack/proc/top()
	if(!is_empty())
		return stack[stack.len]

/datum/stack/proc/is_empty()
	return stack.len == 0

/datum/stack/proc/copy()
	var/datum/stack/S = new()
	S.stack = stack.Copy()
	S.max_elements = max_elements
	return S

/datum/stack/proc/clear()
	LAZYCLEARLIST(stack)
