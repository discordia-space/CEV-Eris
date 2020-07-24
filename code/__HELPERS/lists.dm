/proc/recursiveLen(list/L)
	. = 0
	if(istext(L))
		L = json_decode(L)
	else if(length(L))
		. += length(L)
		for(var/list/i in L)
			if(islist(i))
				. += recursiveLen(i)
			else if(islist(L[i]))
				. += recursiveLen(L[i])
/*
/proc/recursiveLenWithoutlists(list/L)
	. = 0
	if(istext(L))
		L = json_decode(L)
	if(length(L))
		for(var/list/i in L)
			if(islist(i))
				. += recursiveLenWithoutlists(i)
			else if(islist(L[i]))
				. += recursiveLenWithoutlists(L[i])
			else
				. += 1
*/
