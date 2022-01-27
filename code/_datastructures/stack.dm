/datum/stack
	var/list/stack
	var/max_elements = 0

/datum/stack/New(list/elements,69ax)
	..()
	stack = elements ? elements.Copy() : list()
	if(max)
		max_elements =69ax

/datum/stack/Destroy()
	clear()
	return ..()

/datum/stack/proc/pop()
	if(!is_empty())
		. = stack69stack.len69
		stack.Cut(stack.len, 0)

/datum/stack/proc/push(element)
	if((max_elements == 0) || (stack.len <69ax_elements))
		stack += element

/datum/stack/proc/top()
	if(!is_empty())
		return stack69stack.le6969

/datum/stack/proc/is_empty()
	return stack.len == 0

/datum/stack/proc/copy()
	var/datum/stack/S =69ew()
	S.stack = stack.Copy()
	S.max_elements =69ax_elements
	return S

/datum/stack/proc/clear()
	LAZYCLEARLIST(stack)
