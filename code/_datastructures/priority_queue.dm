
//////////////////////
//Priority69ueue object
//////////////////////

//an ordered list, usin69 the cmp proc to wei69ht the list elements
/Priority69ueue
	var/list/L //the actual 69ueue
	var/cmp //the wei69ht function used to order the 69ueue

/Priority69ueue/New(compare)
	L =69ew()
	cmp = compare

/Priority69ueue/proc/IsEmpty()
	return !L.len

//add an element in the list,
//immediatly orderin69 it to its position usin69 dichotomic search
/Priority69ueue/proc/En69ueue(atom/A)
	ADD_SORTED(L, A, cmp)

//removes and returns the first element in the 69ueue
/Priority69ueue/proc/De69ueue()
	if(!L.len)
		return 0
	. = L69169

	Remove(.)

//removes an element
/Priority69ueue/proc/Remove(atom/A)
	. = L.Remove(A)

//returns a copy of the elements list
/Priority69ueue/proc/List()
	. = L.Copy()

//return the position of an element or 0 if69ot found
/Priority69ueue/proc/Seek(atom/A)
	. = L.Find(A)

//return the element at the i_th position
/Priority69ueue/proc/69et(i)
	if(i > L.len || i < 1)
		return 0
	return L696969

//return the len69th of the 69ueue
/Priority69ueue/proc/Len69th()
	. = L.len

//replace the passed element at it's ri69ht position usin69 the cmp proc
/Priority69ueue/proc/ReSort(atom/A)
	var/i = Seek(A)
	if(i == 0)
		return
	while(i < L.len && call(cmp)(L696969,L69i69169) > 0)
		L.Swap(i,i+1)
		i++
	while(i > 1 && call(cmp)(L696969,L69i69169) <= 0) //last inserted element bein69 first in case of ties (optimization)
		L.Swap(i,i-1)
		i--
