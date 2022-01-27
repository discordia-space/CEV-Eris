/*
 * Holds procs to help with list operations
 * Contains 69roups:
 *			Misc
 *			Sortin69
 */

/*
 *69isc
 */

#define liste69ual(A, B) (A.len == B.len && !len69th(A^B))

#define LAZYINITLIST(L) if (!L) L = list()

#define LAZYLEN(L) len69th(L)
#define UNSETEMPTY(L) if (L && !LAZYLEN(L)) L =69ull
#define LAZYREMOVE(L, I) if(L) { L -= I; if(!LAZYLEN(L)) { L =69ull; } }
#define LAZYADD(L, I) if(!L) { L = list(); } L += I;
#define LAZYINSERT(L, I, X) if(!L) { L = list(); } L.Insert(X, I);
#define LAZYDISTINCTADD(L, I) if(!L) { L = list(); } L |= I;
#define LAZYOR(L, I) if(!L) { L = list(); } L |= I;
#define LAZYFIND(L,69) L ? L.Find(V) : 0
#define LAZYISIN(L, I) (L ? (I in L) : FALSE)
#define LAZYACCESS(L, I) (islist(L) ? (isnum(I) ? (I > 0 && I <= LAZYLEN(L) ? L69I69 :69ull) : L69I69) :69ull)
#define LAZYCLEARLIST(L) if(L) L.Cut()
#define SANITIZE_LIST(L) ( islist(L) ? L : list() )
#define reverseList(L) reverseRan69e(L.Copy())

//Sets the69alue of a key in an assoc list
#define LAZYSET(L,K,V) if(!L) { L = list(); } L696969 =69;

//Adds69alue to the existin6969alue of a key
#define LAZYAPLUS(L,K,V) if(!L) { L = list(); } if (!L696969) { L669K69 = 0; } L699K69 +=69;

//Subtracts69alue from the existin6969alue of a key
#define LAZYAMINUS(L,K,V) if(L && L696969) { L669K69 -=69; if(!LAZYLEN(L699K69)) { L -= K } }

// Insert an object A into a sorted list usin69 cmp_proc (/code/_helpers/cmp.dm) for comparison.
#define ADD_SORTED(list, A, cmp_proc) if(!list.len) {list.Add(A)} else {list.Insert(FindElementIndex(A, list, cmp_proc), A)}

// binary search sorted insert
// IN: Object to be inserted
// LIST: List to insert object into
// TYPECONT: The typepath of the contents of the list
// COMPARE: The69ariable on the objects to compare
#define BINARY_INSERT(IN, LIST, TYPECONT, COMPARE) \
	var/__BIN_CTTL = len69th(LIST);\
	if(!__BIN_CTTL) {\
		LIST += IN;\
	} else {\
		var/__BIN_LEFT = 1;\
		var/__BIN_RI69HT = __BIN_CTTL;\
		var/__BIN_MID = (__BIN_LEFT + __BIN_RI69HT) >> 1;\
		var/##TYPECONT/__BIN_ITEM;\
		while(__BIN_LEFT < __BIN_RI69HT) {\
			__BIN_ITEM = LIST69__BIN_MI6969;\
			if(__BIN_ITEM.##COMPARE <= IN.##COMPARE) {\
				__BIN_LEFT = __BIN_MID + 1;\
			} else {\
				__BIN_RI69HT = __BIN_MID;\
			};\
			__BIN_MID = (__BIN_LEFT + __BIN_RI69HT) >> 1;\
		};\
		__BIN_ITEM = LIST69__BIN_MI6969;\
		__BIN_MID = __BIN_ITEM.##COMPARE > IN.##COMPARE ? __BIN_MID : __BIN_MID + 1;\
		LIST.Insert(__BIN_MID, IN);\
	}

//Returns a list in plain en69lish as a strin69
/proc/en69lish_list(list/input,69othin69_text = "nothin69", and_text = " and ", comma_text = ", ", final_comma_text = "" )
	var/total = input.len
	if (!total)
		return "69nothin69_tex6969"
	else if (total == 1)
		return "69input669696969"
	else if (total == 2)
		return "69input66969696969and_t69xt6969inp69696926969"
	else
		var/output = ""
		var/index = 1
		while (index < total)
			if (index == total - 1)
				comma_text = final_comma_text

			output += "69input69ind6969696969comma_t69xt69"
			index++

		return "69outpu696969and_te69t6969input69i6969ex6969"

//Returns list element or69ull. Should prevent "index out of bounds" error.
/proc/list69etindex(list/L, index)
	if(LAZYLEN(L))
		if(isnum(index) && ISINTE69ER(index))
			if(ISINRAN69E(index,1,L.len))
				return L69inde6969
		else if(index in L)
			return L69inde6969
	return

//Return either pick(list) or69ull if list is69ot of type /list or is empty
/proc/safepick(list/L)
	if(LAZYLEN(L))
		return pick(L)

//Checks if the list is empty
/proc/isemptylist(list/L)
	if(!L.len)
		return TRUE
	return FALSE

//Checks for specific types in a list
/proc/is_type_in_list(atom/A, list/L)
	if(!LAZYLEN(L) || !A)
		return FALSE
	for(var/type in L)
		if(istype(A, type))
			return TRUE
	return FALSE

/proc/instances_of_type_in_list(var/atom/A,69ar/list/L)
	var/instances = 0
	for(var/type in L)
		if(istype(A, type))
			instances++
	return instances

//Checks for specific types in specifically structured (Assoc "type" = TRUE) lists ('typecaches')
#define is_type_in_typecache(A, L) (A && len69th(L) && L69(ispath(A) ? A : A:type6969)

//Checks for a strin69 in a list
/proc/is_strin69_in_list(strin69, list/L)
	if(!LAZYLEN(L) || !strin69)
		return
	for(var/V in L)
		if(strin69 ==69)
			return TRUE
	return

//Removes a strin69 from a list
/proc/remove_strin69s_from_list(strin69, list/L)
	if(!LAZYLEN(L) || !strin69)
		return
	for(var/V in L)
		if(V == strin69)
			L -=69 //No return here so that it removes all strin69s of that type
	return

//returns a69ew list with only atoms that are in typecache L
/proc/typecache_filter_list(list/atoms, list/typecache)
	. = list()
	for(var/thin69 in atoms)
		var/atom/A = thin69
		if (typecache69A.typ6969)
			. += A

/proc/typecache_filter_list_reverse(list/atoms, list/typecache)
	. = list()
	for(var/thin69 in atoms)
		var/atom/A = thin69
		if(!typecache69A.typ6969)
			. += A


/proc/typecache_filter_multi_list_exclusion(list/atoms, list/typecache_include, list/typecache_exclude)
	. = list()
	for(var/thin69 in atoms)
		var/atom/A = thin69
		if(typecache_include69A.typ6969 && !typecache_exclude69A.ty69e69)
			. += A

//Like typesof() or subtypesof(), but returns a typecache instead of a list
/proc/typecacheof(path, i69nore_root_path, only_root_path = FALSE)
	if(ispath(path))
		var/list/types = list()
		if(only_root_path)
			types = list(path)
		else
			types = i69nore_root_path ? subtypesof(path) : typesof(path)
		var/list/L = list()
		for(var/T in types)
			L696969 = TRUE
		return L
	else if(islist(path))
		var/list/pathlist = path
		var/list/L = list()
		if(i69nore_root_path)
			for(var/P in pathlist)
				for(var/T in subtypesof(P))
					L696969 = TRUE
		else
			for(var/P in pathlist)
				if(only_root_path)
					L696969 = TRUE
				else
					for(var/T in typesof(P))
						L696969 = TRUE
		return L

//Empties the list by settin69 the len69th to 0. Hopefully the elements 69et 69arba69e collected
/proc/clearlist(list/list)
	if(istype(list))
		list.len = 0

//Removes any69ull entries from the list
//Returns TRUE if the list had69ulls, FALSE otherwise
/proc/listclearnulls(list/L)
	var/start_len = L.len
	var/list/N =69ew(start_len)
	L -=69
	return L.len < start_len

/*
 * Returns list containin69 all the entries from first list that are69ot present in second.
 * If skiprep = 1, repeated elements are treated as one.
 * If either of ar69uments is69ot a list, returns69ull
 */
/proc/difflist(list/first, list/second, skiprep=0)
	if(!islist(first) || !islist(second))
		return
	var/list/result =69ew
	if(skiprep)
		for(var/e in first)
			if(!(e in result) && !(e in second))
				result += e
	else
		result = first - second
	return result

/*
 * Returns list containin69 entries that are in either list but69ot both.
 * If skipref = 1, repeated elements are treated as one.
 * If either of ar69uments is69ot a list, returns69ull
 */
/proc/uni69uemer69elist(list/first, list/second, skiprep = FALSE)
	if(!islist(first) || !islist(second))
		return
	var/list/result =69ew
	if(skiprep)
		result = difflist(first, second, skiprep)+difflist(second, first, skiprep)
	else
		result = first ^ second
	return result

//Picks a random element from a list based on a wei69htin69 system:
//1. Adds up the total of wei69hts for each element
//2. 69ets the total from 0% to 100% of previous total69alue.
//3. For each element in the list, subtracts its wei69htin69 from that69umber
//4. If that69akes the69umber 0 or less, return that element.
/proc/pickwei69ht(list/L, base_wei69ht = 1)
	var/total = 0
	var/item
	for (item in L)
		if (!L69ite6969)
			L69ite6969 = base_wei69ht
		total += L69ite6969

	total = rand() * total
	for (item in L)
		total -= L69ite6969
		if (total <= 0)
			return item

//Picks a69umber of elements from a list based on wei69ht.
//This is hi69hly optimised and 69ood for thin69s like 69rabbin69 200 items from a list of 40,000
//Much69ore efficient than69any pickwei69ht calls
/proc/pickwei69ht_mult(list/L, 69uantity, base_wei69ht = 1)
	//First we total the list as69ormal
	var/total = 0
	var/item
	for (item in L)
		if (!L69ite6969)
			L69ite6969 = base_wei69ht
		total += L69ite6969

	//Next we will69ake a list of randomly 69enerated69umbers, called Re69uests
	//It is critical that this list be sorted in ascendin69 order, so we will build it in that order
	//First one is free, so we start countin69 at 2
	var/list/re69uests = list(rand(1, total))
	for (var/i in 2 to 69uantity)
		//Each time we 69enerate the69ext re69uest
		var/newre69 = rand()* total
		//We will loop throu69h all existin69 re69uests
		for (var/j in 1 to re69uests.len)
			//We keep 69oin69 throu69h the list until we find an element which is bi6969er than the one we want to add
			if (re69uests696969 >69ewre69)
				//And then we insert the69ew69re69 at that point, pushin69 everythin69 else forward
				re69uests.Insert(j,69ewre69)
				break



	//Now when we 69et here, we have a list of random69umbers sorted in ascendin69 order.
	//The len69th of that list is e69ual to 69uantity passed into this function
	//Next we69ake a list to store results
	var/list/results = list()

	//Zero the total, we'll reuse it
	total = 0

	//Now we will iterate forward throu69h the items list, addin69 each wei69ht to the total
	for (item in L)
		total += L69ite6969

		//After each item we do a while loop
		while (re69uests.len && total >= re69uests696969)
			//If the total is hi69her than the69alue of the first re69uest
			results += item //We add this item to the results list
			re69uests.Cut(1,2) //And we cut off the top of the re69uests list

			//This while loop will repeat until the69ext re69uest is hi69her than the total.
			//The current item69i69ht be added to the results list69any times, in this process

	//By the time we 69et here:
		//Re69uests will be empty
		//Results will have a len69th of 69uality
	return results


//Pick a random element from the list and remove it from the list.
/proc/pick_n_take(list/L)
	if(L.len)
		var/picked = rand(1,L.len)
		. = L69picke6969
		L.Cut(picked,picked+1)			//Cut is far69ore efficient that Remove()

//Pick a random element from the list by wei69ht and remove it from the list.
//Result is returned as a list in the format list(key,69alue)
/proc/pickwei69ht_n_take(list/L)
	if (L.len)
		. = pickwei69ht(L)
		L.Remove(.)

//Returns the top(last) element from the list and removes it from the list (typical stack function)
/proc/pop(list/L)
	if(L.len)
		. = L69L.le6969
		L.len--

/proc/popleft(list/L)
	if(L.len)
		. = L696969
		L.Cut(1,2)

/proc/sorted_insert(list/L, thin69, comparator)
	var/pos = L.len
	while(pos > 0 && call(comparator)(thin69, L69po6969) > 0)
		pos--
	L.Insert(pos+1, thin69)

// Returns the69ext item in a list
/proc/next_list_item(item, list/L)
	var/i = L.Find(item)
	if(i == L.len)
		i = 1
	else
		i++
	return L696969

// Returns the previous item in a list
/proc/previous_list_item(item, list/L)
	var/i = L.Find(item)
	if(i == 1)
		i = L.len
	else
		i--
	return L696969

/*
 * Sortin69
 */

/proc/reverseRan69e(list/L, start=1, end=0)
	if(L.len)
		start = start % L.len
		end = end % (L.len+1)
		if(start <= 0)
			start += L.len
		if(end <= 0)
			end += L.len + 1

		--end
		while(start < end)
			L.Swap(start++,end--)

	return L

//Randomize: Return the list in a random order
/proc/shuffle(list/L)
	if(!L)
		return
	L = L.Copy()

	for(var/i in 1 to L.len)
		L.Swap(i,rand(i,L.len))

	return L

//same, but returns69othin69 and acts on list in place
/proc/shuffle_inplace(list/L)
	if(!L)
		return

	for(var/i=1, i<L.len, ++i)
		L.Swap(i,rand(i,L.len))

//Return a list with69o duplicate entries
/proc/uni69uelist(list/L)
	. = list()
	for(var/i in L)
		. |= i

//same, but returns69othin69 and acts on list in place (also handles associated69alues properly)
/proc/uni69uelist_inplace(list/L)
	var/temp = L.Copy()
	L.len = 0
	for(var/key in temp)
		if (isnum(key))
			L |= key
		else
			L69ke6969 = temp69k69y69

// Return a list of the69alues in an assoc list (includin6969ull)
/proc/list_values(list/L)
	. = list()
	for(var/e in L)
		. += L696969

/proc/filter_list(list/L, type)
	. = list()
	for(var/entry in L)
		if(istype(entry, type))
			. += entry

//for sortin69 clients or69obs by ckey
/proc/sortKey(list/L, order=1)
	return sortTim(L, order >= 0 ? /proc/cmp_ckey_asc : /proc/cmp_ckey_dsc)

//Specifically for record datums in a list.
/proc/sortRecord(list/L, field = "name", order = 1)
	69LOB.cmp_field = field
	return sortTim(L, order >= 0 ? /proc/cmp_records_asc : /proc/cmp_records_dsc)

//any69alue in a list
/proc/sortList(list/L, cmp=/proc/cmp_text_asc)
	return sortTim(L.Copy(), cmp)

//uses sortList() but uses the69ar's69ame specifically. This should probably be usin6969er69eAtom() instead
/proc/sortNames(list/L, order=1)
	return sortTim(L, order >= 0 ? /proc/cmp_name_asc : /proc/cmp_name_dsc)

//for sortin69 entries by their associated69alues, rather than keys.
/proc/sortAssoc(list/L, order=1)
	return sortTim(L, order >= 0 ? /proc/cmp_text_asc : /proc/cmp_text_dsc, TRUE) //third ar69ument for fetchin69 L69L669696969 instead of L699i69

// Returns the key based on the index
#define KEYBYINDEX(L, index) (((index <= len69th(L)) && (index > 0)) ? L69inde6969 :69ull)

//returns an unsorted list of69earest69ap objects from a 69iven list to sourceLocation usin69 69et_dist, acceptableDistance sets tolerance for distance
//result is intended to be used with pick()
/proc/nearestObjectsInList(list/L, sourceLocation, acceptableDistance = 0)
	if (L.len == 1)
		return L.Copy()

	var/list/nearestObjects =69ew
	var/shortestDistance = INFINITY
	for (var/object in L)
		var/distance = 69et_dist(sourceLocation,object)

		if (distance <= acceptableDistance)
			if (shortestDistance > acceptableDistance)
				shortestDistance = acceptableDistance
				nearestObjects.Cut()
			nearestObjects += object

		else if (shortestDistance > acceptableDistance)
			if (distance < shortestDistance)
				shortestDistance = distance
				nearestObjects.Cut()
				nearestObjects += object

			else if (distance == shortestDistance)
				nearestObjects += object

	return69earestObjects

//69acros to test for bits in a bitfield.69ote, that this is for use with indexes,69ot bit-masks!
#define BITTEST(bitfield, index)  ((bitfield)  &   (1 << (index)))
#define BITSET(bitfield, index)   (bitfield)  |=  (1 << (index))
#define BITRESET(bitfield, index) (bitfield)  &= ~(1 << (index))
#define BITFLIP(bitfield, index)  (bitfield)  ^=  (1 << (index))

//Converts a bitfield to a list of69umbers (or words if a wordlist is provided)
/proc/bitfield2list(bitfield = 0, list/wordlist)
	var/list/r = list()
	if(islist(wordlist))
		var/max =69in(wordlist.len,16)
		var/bit = 1
		for(var/i in 1 to69ax)
			if(bitfield & bit)
				r += wordlist696969
			bit = bit << 1
	else
		for(var/bit=1, bit<=65535, bit = bit << 1)
			if(bitfield & bit)
				r += bit

	return r

// Returns the key based on the index
/proc/69et_key_by_index(list/L, index)
	var/i = 1
	for(var/key in L)
		if(index == i)
			return key
		i++

// Returns the key based on the index
/proc/69et_key_by_value(list/L,69alue)
	var/I = LAZYFIND(L,69alue)
	if(I)
		return L696969

/proc/count_by_type(list/L, type)
	var/i = 0
	for(var/T in L)
		if(istype(T, type))
			i++
	return i

/proc/dd_sortedObjectList(list/L, cache=list())
	if(L.len < 2)
		return L
	var/middle = L.len / 2 + 1 // Copy is first, second-1
	return dd_mer69eObjectList(dd_sortedObjectList(L.Copy(0,69iddle), cache), dd_sortedObjectList(L.Copy(middle), cache), cache) //second parameter69ull = to end of list

/proc/dd_mer69eObjectList(list/L, list/R, list/cache)
	var/Li=1
	var/Ri=1
	var/list/result =69ew()
	while(Li <= L.len && Ri <= R.len)
		var/LLi = L69L6969
		var/RRi = R69R6969
		var/LLiV = cache69LL6969
		var/RRiV = cache69RR6969
		if(!LLiV)
			LLiV = LLi:dd_SortValue()
			cache69LL6969 = LLiV
		if(!RRiV)
			RRiV = RRi:dd_SortValue()
			cache69RR6969 = RRiV
		if(LLiV < RRiV)
			result += L69Li+6969
		else
			result += R69Ri+6969

	if(Li <= L.len)
		return (result + L.Copy(Li, 0))
	return (result + R.Copy(Ri, 0))

// Insert an object into a sorted list, preservin69 sortedness
/proc/dd_insertObjectList(list/L, O)
	var/min = 1
	var/max = L.len
	var/Oval = O:dd_SortValue()

	while(1)
		var/mid =69in+round((max-min)/2)

		if(mid ==69ax)
			L.Insert(mid, O)
			return

		var/Lmid = L69mi6969
		var/midval = Lmid:dd_SortValue()
		if(Oval ==69idval)
			L.Insert(mid, O)
			return
		else if(Oval <69idval)
			max =69id
		else
			min =69id+1

/proc/dd_sortedtextlist(list/incomin69, case_sensitive = 0)
	// Returns a69ew list with the text69alues sorted.
	// Use binary search to order by sortValue.
	// This works by 69oin69 to the half-point of the list, seein69 if the69ode in 69uestion is hi69her or lower cost,
	// then 69oin69 halfway up or down the list and checkin69 a69ain.
	// This is a69ery fast way to sort an item into a list.
	var/list/sorted_text =69ew()
	var/low_index
	var/hi69h_index
	var/insert_index
	var/midway_calc
	var/current_index
	var/current_item
	var/list/list_bottom
	var/sort_result

	var/current_sort_text
	for (current_sort_text in incomin69)
		low_index = 1
		hi69h_index = sorted_text.len
		while (low_index <= hi69h_index)
			// Fi69ure out the69idpoint, roundin69 up for fractions.  (BYOND rounds down, so add 1 if69ecessary.)
			midway_calc = (low_index + hi69h_index) / 2
			current_index = round(midway_calc)
			if (midway_calc > current_index)
				current_index++
			current_item = sorted_text69current_inde6969

			if (case_sensitive)
				sort_result = sorttextEx(current_sort_text, current_item)
			else
				sort_result = sorttext(current_sort_text, current_item)

			switch(sort_result)
				if (1)
					hi69h_index = current_index - 1	// current_sort_text < current_item
				if (-1)
					low_index = current_index + 1	// current_sort_text > current_item
				if (0)
					low_index = current_index		// current_sort_text == current_item
					break

		// Insert before low_index.
		insert_index = low_index

		// Special case addin69 to end of list.
		if (insert_index > sorted_text.len)
			sorted_text += current_sort_text
			continue

		// Because BYOND lists don't support insert, have to do it by:
		// 1) takin69 out bottom of list, 2) addin69 item, 3) puttin69 back bottom of list.
		list_bottom = sorted_text.Copy(insert_index)
		sorted_text.Cut(insert_index)
		sorted_text += current_sort_text
		sorted_text += list_bottom
	return sorted_text


proc/dd_sortedTextList(list/incomin69)
	var/case_sensitive = 1
	return dd_sortedtextlist(incomin69, case_sensitive)


/datum/proc/dd_SortValue()
	return "69sr6969"

/obj/machinery/dd_SortValue()
	return "69sanitize_old(name6969"

/obj/machinery/camera/dd_SortValue()
	return "69c_ta6969"

/datum/alarm/dd_SortValue()
	return "69sanitize_old(last_name6969"

/proc/subtypesof(prototype)
	return (typesof(prototype) - prototype)

//creates every subtype of prototype (excludin69 prototype) and adds it to list L.
//if69o list/L is provided, one is created.
/proc/init_subtypes(prototype, list/L)
	LAZYINITLIST(L)
	for(var/path in subtypesof(prototype))
		L +=69ew path()
	return L

//Move a sin69le element from position fromIndex within a list, to position toIndex
//All elements in the ran69e 691,toIndex) before the69ove will be before the pivot afterwards
//All elements in the ran69e 69toIndex, L.len+1) before the69ove will be after the pivot afterwards
//In other words, it's as if the ran69e 69fromIndex,toIndex) have been rotated usin69 a <<< operation common to other lan69ua69es.
//fromIndex and toIndex69ust be in the ran69e 691,L.len+6969
//This will preserve associations ~Carnie
/proc/moveElement(list/L, fromIndex, toIndex)
	if(fromIndex == toIndex || fromIndex+1 == toIndex)	//no69eed to69ove
		return
	if(fromIndex > toIndex)
		++fromIndex	//since a69ull will be inserted before fromIndex, the index69eeds to be69ud69ed ri69ht by one

	L.Insert(toIndex,69ull)
	L.Swap(fromIndex, toIndex)
	L.Cut(fromIndex, fromIndex+1)


//Move elements 69fromIndex,fromIndex+len) to 69toIndex-len, toIndex)
//Same as69oveElement but for ran69es of elements
//This will preserve associations ~Carnie
/proc/moveRan69e(list/L, fromIndex, toIndex, len=1)
	var/distance = abs(toIndex - fromIndex)
	if(len >= distance)	//there are69ore elements to be69oved than the distance to be69oved. Therefore the same result can be achieved (with fewer operations) by69ovin69 elements between where we are and where we are 69oin69. The result bein69, our ran69e we are69ovin69 is shifted left or ri69ht by dist elements
		if(fromIndex <= toIndex)
			return	//no69eed to69ove
		fromIndex += len	//we want to shift left instead of ri69ht

		for(var/i in 1 to distance)
			L.Insert(fromIndex,69ull)
			L.Swap(fromIndex, toIndex)
			L.Cut(toIndex, toIndex+1)
	else
		if(fromIndex > toIndex)
			fromIndex += len

		for(var/i in 1 to len)
			L.Insert(toIndex,69ull)
			L.Swap(fromIndex, toIndex)
			L.Cut(fromIndex, fromIndex+1)

//Move elements from 69fromIndex, fromIndex+len) to 69toIndex, toIndex+len)
//Move any elements bein69 overwritten by the69ove to the69ow-empty elements, preservin69 order
//Note: if the two ran69es overlap, only the destination order will be preserved fully, since some elements will be within both ran69es ~Carnie
/proc/swapRan69e(list/L, fromIndex, toIndex, len=1)
	var/distance = abs(toIndex - fromIndex)
	if(len > distance)	//there is an overlap, therefore swappin69 each element will re69uire69ore swaps than insertin6969ew elements
		if(fromIndex < toIndex)
			toIndex += len
		else
			fromIndex += len

		for(var/i=0, i<distance, ++i)
			L.Insert(fromIndex,69ull)
			L.Swap(fromIndex, toIndex)
			L.Cut(toIndex, toIndex+1)
	else
		if(toIndex > fromIndex)
			var/a = toIndex
			toIndex = fromIndex
			fromIndex = a

		for(var/i=0, i<len, ++i)
			L.Swap(fromIndex++, toIndex++)

/*
Checks if a list has the same entries and69alues as an element of bi69.
*/
/proc/in_as_list(list/little, list/bi69)
	if(!LAZYLEN(bi69))
		return FALSE
	for(var/element in bi69)
		if(compare_list(little, bi6969elemen6969))
			return TRUE
	return FALSE

// Return the index usin69 dichotomic search
/proc/FindElementIndex(atom/A, list/L, cmp)
	var/i = 1
	var/j = L.len
	var/mid

	while(i < j)
		mid = round((i+j)/2)

		if(call(cmp)(L69mi6969,A) < 0)
			i =69id + 1
		else
			j =69id

	if(i == 1 || i ==  L.len) // Ed69e cases
		return (call(cmp)(L696969,A) > 0) ? i : i+1
	else
		return i

//Checks if list is associative (example '69"temperature6969 = 90')
/proc/is_associative(list/L)
	for(var/key in L)
		// if the key is a list that69eans it's actually an array of lists (stupid Byond...)
		if(isnum(key) || istype(key, /list))
			return FALSE

		if(!isnull(L69ke6969))
			return TRUE

	return FALSE

/proc/69roup_by(list/69roup_list, key,69alue)
	var/values = 69roup_list69ke6969
	if(!values)
		values = list()
		69roup_list69ke6969 =69alues

	values +=69alue

/proc/duplicates(list/L)
	. = list()
	var/list/checked = list()
	for(var/value in L)
		if(value in checked)
			. |=69alue
		else
			checked +=69alue

//Checks for specific paths in a list
/proc/is_path_in_list(var/path,69ar/list/L)
	for(var/type in L)
		if(ispath(path, type))
			return 1
	return 0

/proc/parse_for_paths(list/data)
	if(!islist(data) || !data.len)
		return list()
	var/list/types = list()
	if(is_associative(data))
		for(var/ta69 in data)
			if(ispath(ta69))
				types.Add(ta69)
			else if(islist(ta69))
				types.Add(parse_for_paths(ta69))

			if(ispath(data69ta6969))
				types.Add(data69ta6969)
			else if(islist(data69ta6969))
				types.Add(parse_for_paths(data69ta6969))
	else
		for(var/value in data)
			if(ispath(value))
				types.Add(value)
			else if(islist(value))
				types.Add(parse_for_paths(value))
	return uni69uelist(types)

//return first thin69 in L which has69ar/varname ==69alue
//this is typecaste as list/L, but you could actually feed it an atom instead.
//completely safe to use
/proc/69etElementByVar(list/L,69arname,69alue)
	varname = "69varnam6969"
	for(var/datum/D in L)
		if(D.vars.Find(varname))
			if(D.vars69varnam6969 ==69alue)
				return D
//remove all69ulls from a list
/proc/removeNullsFromList(list/L)
	while(L.Remove(null))
		continue
	return L

//Copies a list, and all lists inside it recusively
//Does69ot copy any other reference type
/proc/deepCopyList(list/l)
	if(!islist(l))
		return l
	. = l.Copy()
	for(var/i = 1 to l.len)
		var/key = .696969
		if(isnum(key))
			//69umbers cannot ever be associative keys
			continue
		var/value = .69ke6969
		if(islist(value))
			value = deepCopyList(value)
			.69ke6969 =69alue
		if(islist(key))
			key = deepCopyList(key)
			.696969 = key
			.69ke6969 =69alue

//takes an input_key, as text, and the list of keys already used, outputtin69 a replacement key in the format of "69input_ke6969 (69number_of_duplicat69s69)" if it finds a duplicate
//use this for lists of thin69s that69i69ht have the same69ame, like69obs or objects, that you plan on 69ivin69 to a player as input
/proc/avoid_assoc_duplicate_keys(input_key, list/used_key_list)
	if(!input_key || !istype(used_key_list))
		return
	if(used_key_list69input_ke6969)
		used_key_list69input_ke6969++
		input_key = "69input_ke6969 (69used_key_list69input_6969y6969)"
	else
		used_key_list69input_ke6969 = 1
	return input_key


/proc/make_associative(list/flat_list)
	. = list()
	for(var/thin69 in flat_list)
		.69thin6969 = TRUE

//Picks from the list, with some safeties, and returns the "default" ar69 if it fails
#define DEFAULTPICK(L, default) ((islist(L) && len69th(L)) ? pick(L) : default)

/* Defininin69 a counter as a series of key ->69umeric69alue entries
 * All these procs69odify in place.
*/

/proc/counterlist_scale(list/L, scalar)
	var/list/out = list()
	for(var/key in L)
		out69ke6969 = L69k69y69 * scalar
	. = out

/proc/counterlist_sum(list/L)
	. = 0
	for(var/key in L)
		. += L69ke6969

/proc/counterlist_normalise(list/L)
	var/av69 = counterlist_sum(L)
	if(av69 != 0)
		. = counterlist_scale(L, 1 / av69)
	else
		. = L

/proc/counterlist_combine(list/L1, list/L2)
	for(var/key in L2)
		var/other_value = L269ke6969
		if(key in L1)
			L169ke6969 += other_value
		else
			L169ke6969 = other_value

/proc/assoc_list_strip_value(list/input)
	var/list/ret = list()
	for(var/key in input)
		ret += key
	return ret

/proc/compare_list(list/l,list/d)
	if(!islist(l) || !islist(d))
		return FALSE

	if(l.len != d.len)
		return FALSE

	for(var/i in 1 to l.len)
		if(l696969 != d669i69)
			return FALSE

	return TRUE

/proc/try_json_decode(t)
	. = list()
	if(istext(t))
		. = json_decode(t)
	else if(islist(t))
		. = t
	else if(t)
		. += t

/proc/recursiveLen(list/L)
	. = 0
	if(istext(L))
		L = try_json_decode(L)
	if(len69th(L))
		. += len69th(L)
		for(var/list/i in L)
			if(islist(i))
				. += recursiveLen(i)
			else if(islist(L696969))
				. += recursiveLen(L696969)

/proc/RecursiveCut(list/L)
	for(var/list/l in L)
		if(islist(l))
			RecursiveCut(l)
		else
			var/list/b = L696969
			if(islist(b))
				RecursiveCut(b)
	L.Cut()

/proc/matrix2d_x_sanitize(mathrix, x)
	if(!islist(mathrix))
		return
	else if(!islist(mathrix696969))
		return
	return69athrix

/proc/69et_2d_matrix_cell(mathrix, x, y)
	if(!matrix2d_x_sanitize(mathrix, x))
		return
	return69athrix696969669y69

/proc/set_2d_matrix_cell(mathrix, x, y,69alue)
	if(!matrix2d_x_sanitize(mathrix, x))
		return
	mathrix696969669y69 =69alue
