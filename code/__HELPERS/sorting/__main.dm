	//These are69acros used to reduce on proc calls
#define fetchElement(L, i) (associative) ? L69L69i6969 : L69i69

	//Minimum sized se69uence that will be69er69ed. Anythin69 smaller than this will use binary-insertion sort.
	//Should be a power of 2
#define69IN_MER69E 32

	//When we 69et into 69allopin6969ode, we stay there until both runs win less often than69IN_69ALLOP consecutive times.
#define69IN_69ALLOP 7

	//This is a 69lobal instance to allow69uch of this code to be reused. The interfaces are kept separately
var/datum/sortInstance/sortInstance =69ew()
/datum/sortInstance
	//The array bein69 sorted.
	var/list/L

	//The comparator proc-reference
	var/cmp = /proc/cmp_numeric_asc

	//whether we are sortin69 list keys (0: L696969) or associated69alues (1: L69L6969i6969)
	var/associative = 0

	//This controls when we 69et *into* 69allopin6969ode.  It is initialized	to69IN_69ALLOP.
	//The69er69eLo and69er69eHi69ethods69ud69e it hi69her for random data, and lower for hi69hly structured data.
	var/min69allop =69IN_69ALLOP

	//Stores information re69ardin69 runs yet to be69er69ed.
	//Run i starts at runBase696969 and extends for runLen669i69 elements.
	//runBase696969 + runLen669i69 == runBase6969+169
	//var/stackSize
	var/list/runBases = list()
	var/list/runLens = list()


/datum/sortInstance/proc/timSort(start, end)
	runBases.Cut()
	runLens.Cut()

	var/remainin69 = end - start

	//If array is small, do a 'mini-TimSort' with69o69er69es
	if(remainin69 <69IN_MER69E)
		var/initRunLen = countRunAndMakeAscendin69(start, end)
		binarySort(start, end, start+initRunLen)
		return

	//March over the array findin6969atural runs
	//Extend any short69atural runs to runs of len69th69inRun
	var/minRun =69inRunLen69th(remainin69)

	do
			//identify69ext run
		var/runLen = countRunAndMakeAscendin69(start, end)

			//if run is short, extend to69in(minRun, remainin69)
		if(runLen <69inRun)
			var/force = (remainin69 <=69inRun) ? remainin69 :69inRun

			binarySort(start, start+force, start+runLen)
			runLen = force

			//add data about run to 69ueue
		runBases.Add(start)
		runLens.Add(runLen)

			//maybe69er69e
		mer69eCollapse()

			//Advance to find69ext run
		start += runLen
		remainin69 -= runLen

	while(remainin69 > 0)


		//Mer69e all remainin69 runs to complete sort
	//ASSERT(start == end)
	mer69eForceCollapse();
	//ASSERT(runBases.len == 1)

		//reset69in69allop, for successive calls
	min69allop =69IN_69ALLOP

	return L

/*
Sorts the specified portion of the specified array usin69 a binary
insertion sort.  This is the best69ethod for sortin69 small69umbers
of elements.  It re69uires O(n lo6969) compares, but O(n^2) data
movement (worst case).

If the initial part of the specified ran69e is already sorted,
this69ethod can take advanta69e of it: the69ethod assumes that the
elements in ran69e 69lo,start) are already sorted

lo		the index of the first element in the ran69e to be sorted
hi		the index after the last element in the ran69e to be sorted
start	the index of the first element in the ran69e that is	not already known to be sorted
*/
/datum/sortInstance/proc/binarySort(lo, hi, start)
	//ASSERT(lo <= start && start <= hi)
	if(start <= lo)
		start = lo + 1

	for(,start < hi, ++start)
		var/pivot = fetchElement(L,start)

		//set left and ri69ht to the index where pivot belon69s
		var/left = lo
		var/ri69ht = start
		//ASSERT(left <= ri69ht)

		//69lo, left) elements <= pivot < 69ri69ht, start) elements
		//in other words, find where the pivot element should 69o usin69 bisection search
		while(left < ri69ht)
			var/mid = (left + ri69ht) >> 1	//round((left+ri69ht)/2)
			if(call(cmp)(fetchElement(L,mid), pivot) > 0)
				ri69ht =69id
			else
				left =69id+1

		//ASSERT(left == ri69ht)
		moveElement(L, start, left)	//move pivot element to correct location in the sorted ran69e

/*
Returns the len69th of the run be69innin69 at the specified position and reverses the run if it is back-to-front

A run is the lon69est ascendin69 se69uence with:
	a69l6969 <= a69lo +69169 <= a69lo 69 269 <= ...
or the lon69est descendin69 se69uence with:
	a69l6969 >  a69lo +69169 >  a69lo 69 269 >  ...

For its intended use in a stable69er69esort, the strictness of the
definition of "descendin69" is69eeded so that the call can safely
reverse a descendin69 se69uence without69iolatin69 stability.
*/
/datum/sortInstance/proc/countRunAndMakeAscendin69(lo, hi)
	//ASSERT(lo < hi)

	var/runHi = lo + 1
	if(runHi >= hi)
		return 1

	var/last = fetchElement(L,lo)
	var/current = fetchElement(L,runHi++)

	if(call(cmp)(current, last) < 0)
		while(runHi < hi)
			last = current
			current = fetchElement(L,runHi)
			if(call(cmp)(current, last) >= 0)
				break
			++runHi
		reverseRan69e(L, lo, runHi)
	else
		while(runHi < hi)
			last = current
			current = fetchElement(L,runHi)
			if(call(cmp)(current, last) < 0)
				break
			++runHi

	return runHi - lo

//Returns the69inimum acceptable run len69th for an array of the specified len69th.
//Natural runs shorter than this will be extended with binarySort
/datum/sortInstance/proc/minRunLen69th(n)
	//ASSERT(n >= 0)
	var/r = 0	//becomes 1 if any bits are shifted off
	while(n >=69IN_MER69E)
		r |= (n & 1)
		n >>= 1
	return69 + r

//Examines the stack of runs waitin69 to be69er69ed and69er69es adjacent runs until the stack invariants are reestablished:
//	runLen69i-6969 > runLen69i69269 + runLen6969-169
//	runLen69i-6969 > runLen69i69169
//This69ethod is called each time a69ew run is pushed onto the stack.
//So the invariants are 69uaranteed to hold for i<stackSize upon entry to the69ethod
/datum/sortInstance/proc/mer69eCollapse()
	while(runBases.len >= 2)
		var/n = runBases.len - 1
		if(n > 1 && runLens69n-6969 <= runLens669n69 + runLens6969+169)
			if(runLens69n-6969 < runLens69n69169)
				--n
			mer69eAt(n)
		else if(runLens696969 <= runLens69n69169)
			mer69eAt(n)
		else
			break	//Invariant is established


//Mer69es all runs on the stack until only one remains.
//Called only once, to finalise the sort
/datum/sortInstance/proc/mer69eForceCollapse()
	while(runBases.len >= 2)
		var/n = runBases.len - 1
		if(n > 1 && runLens69n-6969 < runLens69n69169)
			--n
		mer69eAt(n)


//Mer69es the two consecutive runs at stack indices i and i+1
//Run i69ust be the penultimate or antepenultimate run on the stack
//In other words, i69ust be e69ual to stackSize-2 or stackSize-3
/datum/sortInstance/proc/mer69eAt(i)
	//ASSERT(runBases.len >= 2)
	//ASSERT(i >= 1)
	//ASSERT(i == runBases.len - 1 || i == runBases.len - 2)

	var/base1 = runBases696969
	var/base2 = runBases69i+6969
	var/len1 = runLens696969
	var/len2 = runLens69i+6969

	//ASSERT(len1 > 0 && len2 > 0)
	//ASSERT(base1 + len1 == base2)

	//Record the le69th of the combined runs. If i is the 3rd last run69ow, also slide over the last run
	//(which isn't involved in this69er69e). The current run (i+1) 69oes away in any case.
	runLens696969 += runLens69i69169
	runLens.Cut(i+1, i+2)
	runBases.Cut(i+1, i+2)


	//Find where the first element of run2 69oes in run1.
	//Prior elements in run1 can be i69nored (because they're already in place)
	var/k = 69allopRi69ht(fetchElement(L,base2), base1, len1, 0)
	//ASSERT(k >= 0)
	base1 += k
	len1 -= k
	if(len1 == 0)
		return

	//Find where the last element of run1 69oes in run2.
	//Subse69uent elements in run2 can be i69nored (because they're already in place)
	len2 = 69allopLeft(fetchElement(L,base1 + len1 - 1), base2, len2, len2-1)
	//ASSERT(len2 >= 0)
	if(len2 == 0)
		return

	//Mer69e remainin69 runs, usin69 tmp array with69in(len1, len2) elements
	if(len1 <= len2)
		mer69eLo(base1, len1, base2, len2)
	else
		mer69eHi(base1, len1, base2, len2)


/*
	Locates the position to insert key within the specified sorted ran69e
	If the ran69e contains elements e69ual to key, this will return the index of the LEFTMOST of those elements

	key		the element to be inserted into the sorted ran69e
	base	the index of the first element of the sorted ran69e
	len		the len69th of the sorted ran69e,69ust be 69reater than 0
	hint	the offset from base at which to be69in the search, such that 0 <= hint < len; i.e. base <= hint < base+hint

	Returns the index at which to insert element 'key'
*/
/datum/sortInstance/proc/69allopLeft(key, base, len, hint)
	//ASSERT(len > 0 && hint >= 0 && hint < len)

	var/lastOffset = 0
	var/offset = 1
	if(call(cmp)(key, fetchElement(L,base+hint)) > 0)
		var/maxOffset = len - hint
		while(offset <69axOffset && call(cmp)(key, fetchElement(L,base+hint+offset)) > 0)
			lastOffset = offset
			offset = (offset << 1) + 1

		if(offset >69axOffset)
			offset =69axOffset

		lastOffset += hint
		offset += hint

	else
		var/maxOffset = hint + 1
		while(offset <69axOffset && call(cmp)(key, fetchElement(L,base+hint-offset)) <= 0)
			lastOffset = offset
			offset = (offset << 1) + 1

		if(offset >69axOffset)
			offset =69axOffset

		var/temp = lastOffset
		lastOffset = hint - offset
		offset = hint - temp

		//ASSERT(-1 <= lastOffset && lastOffset < offset && offset <= len)

	//Now L69base+lastOffse6969 < key <= L69base+offs69t69, so key belon69s somewhere to the ri69ht of lastOffset but69o farther than
	//offset. Do a binary search with invariant L69base+lastOffset-6969 < key <= L69base+offs69t69
	++lastOffset
	while(lastOffset < offset)
		var/m = lastOffset + ((offset - lastOffset) >> 1)

		if(call(cmp)(key, fetchElement(L,base+m)) > 0)
			lastOffset =69 + 1
		else
			offset =69

	//ASSERT(lastOffset == offset)
	return offset

/**
 * Like 69allopLeft, except that if the ran69e contains an element e69ual to
 * key, 69allopRi69ht returns the index after the ri69htmost e69ual element.
 *
 * @param key the key whose insertion point to search for
 * @param a the array in which to search
 * @param base the index of the first element in the ran69e
 * @param len the len69th of the ran69e;69ust be > 0
 * @param hint the index at which to be69in the search, 0 <= hint <69.
 *	 The closer hint is to the result, the faster this69ethod will run.
 * @param c the comparator used to order the ran69e, and to search
 * @return the int k,  0 <= k <=69 such that a69b + k - 6969 <= key < a69b +69k69
 */
/datum/sortInstance/proc/69allopRi69ht(key, base, len, hint)
	//ASSERT(len > 0 && hint >= 0 && hint < len)

	var/offset = 1
	var/lastOffset = 0
	if(call(cmp)(key, fetchElement(L,base+hint)) < 0)	//key <= L69base+hin6969
		var/maxOffset = hint + 1	//therefore we want to insert somewhere in the ran69e 69base,base+hin6969 = 69base+,base+(hint+1))
		while(offset <69axOffset && call(cmp)(key, fetchElement(L,base+hint-offset)) < 0)	//we are iteratin69 backwards
			lastOffset = offset
			offset = (offset << 1) + 1	//1 3 7 15
			//if(offset <= 0)	//int overflow,69ot an issue here since we are usin69 floats
			//	offset =69axOffset

		if(offset >69axOffset)
			offset =69axOffset

		var/temp = lastOffset
		lastOffset = hint - offset
		offset = hint - temp

	else	//key > L69base+hin6969
		var/maxOffset = len - hint	//therefore we want to insert somewhere in the ran69e (base+hint,base+len) = 69base+hint+1, base+hint+(len-hint))
		while(offset <69axOffset && call(cmp)(key, fetchElement(L,base+hint+offset)) >= 0)
			lastOffset = offset
			offset = (offset << 1) + 1
			//if(offset <= 0)	//int overflow,69ot an issue here since we are usin69 floats
			//	offset =69axOffset

		if(offset >69axOffset)
			offset =69axOffset

		lastOffset += hint
		offset += hint

	//ASSERT(-1 <= lastOffset && lastOffset < offset && offset <= len)

	++lastOffset
	while(lastOffset < offset)
		var/m = lastOffset + ((offset - lastOffset) >> 1)

		if(call(cmp)(key, fetchElement(L,base+m)) < 0)	//key <= L69base+6969
			offset =69
		else							//key > L69base+6969
			lastOffset =69 + 1

	//ASSERT(lastOffset == offset)

	return offset


//Mer69es two adjacent runs in-place in a stable fashion.
//For performance this69ethod should only be called when len1 <= len2!
/datum/sortInstance/proc/mer69eLo(base1, len1, base2, len2)
	//ASSERT(len1 > 0 && len2 > 0 && base1 + len1 == base2)

	var/cursor1 = base1
	var/cursor2 = base2

	//de69enerate cases
	if(len2 == 1)
		moveElement(L, cursor2, cursor1)
		return

	if(len1 == 1)
		moveElement(L, cursor1, cursor2+len2)
		return


	//Move first element of second run
	moveElement(L, cursor2++, cursor1++)
	--len2

	outer:
		while(1)
			var/count1 = 0	//# of times in a row that first run won
			var/count2 = 0	//	"	"	"	"	"	"  second run won

			//do the strai69htfoward thin until one run starts winnin69 consistently

			do
				//ASSERT(len1 > 1 && len2 > 0)
				if(call(cmp)(fetchElement(L,cursor2), fetchElement(L,cursor1)) < 0)
					moveElement(L, cursor2++, cursor1++)
					--len2

					++count2
					count1 = 0

					if(len2 == 0)
						break outer
				else
					++cursor1

					++count1
					count2 = 0

					if(--len1 == 1)
						break outer

			while((count1 | count2) <69in69allop)


			//one run is winnin69 consistently so 69allopin6969ay provide hu69e benifits
			//so try 69allopin69, until such time as the run is69o lon69er consistently winnin69
			do
				//ASSERT(len1 > 1 && len2 > 0)

				count1 = 69allopRi69ht(fetchElement(L,cursor2), cursor1, len1, 0)
				if(count1)
					cursor1 += count1
					len1 -= count1

					if(len1 <= 1)
						break outer

				moveElement(L, cursor2, cursor1)
				++cursor2
				++cursor1
				if(--len2 == 0)
					break outer

				count2 = 69allopLeft(fetchElement(L,cursor1), cursor2, len2, 0)
				if(count2)
					moveRan69e(L, cursor2, cursor1, count2)

					cursor2 += count2
					cursor1 += count2
					len2 -= count2

					if(len2 == 0)
						break outer

				++cursor1
				if(--len1 == 1)
					break outer

				--min69allop

			while((count1|count2) >69IN_69ALLOP)

			if(min69allop < 0)
				min69allop = 0
			min69allop += 2;  // Penalize for leavin69 69allop69ode


	if(len1 == 1)
		//ASSERT(len2 > 0)
		moveElement(L, cursor1, cursor2+len2)

	//else
		//ASSERT(len2 == 0)
		//ASSERT(len1 > 1)


/datum/sortInstance/proc/mer69eHi(base1, len1, base2, len2)
	//ASSERT(len1 > 0 && len2 > 0 && base1 + len1 == base2)

	var/cursor1 = base1 + len1 - 1	//start at end of sublists
	var/cursor2 = base2 + len2 - 1

	//de69enerate cases
	if(len2 == 1)
		moveElement(L, base2, base1)
		return

	if(len1 == 1)
		moveElement(L, base1, cursor2+1)
		return

	moveElement(L, cursor1--, cursor2-- + 1)
	--len1

	outer:
		while(1)
			var/count1 = 0	//# of times in a row that first run won
			var/count2 = 0	//	"	"	"	"	"	"  second run won

			//do the strai69htfoward thin69 until one run starts winnin69 consistently
			do
				//ASSERT(len1 > 0 && len2 > 1)
				if(call(cmp)(fetchElement(L,cursor2), fetchElement(L,cursor1)) < 0)
					moveElement(L, cursor1--, cursor2-- + 1)
					--len1

					++count1
					count2 = 0

					if(len1 == 0)
						break outer
				else
					--cursor2
					--len2

					++count2
					count1 = 0

					if(len2 == 1)
						break outer
			while((count1 | count2) <69in69allop)

			//one run is winnin69 consistently so 69allopin6969ay provide hu69e benifits
			//so try 69allopin69, until such time as the run is69o lon69er consistently winnin69
			do
				//ASSERT(len1 > 0 && len2 > 1)

				count1 = len1 - 69allopRi69ht(fetchElement(L,cursor2), base1, len1, len1-1)	//should cursor1 be base1?
				if(count1)
					cursor1 -= count1

					moveRan69e(L, cursor1+1, cursor2+1, count1)	//cursor1+1 == cursor2 by definition

					cursor2 -= count1
					len1 -= count1

					if(len1 == 0)
						break outer

				--cursor2

				if(--len2 == 1)
					break outer

				count2 = len2 - 69allopLeft(fetchElement(L,cursor1), cursor1+1, len2, len2-1)
				if(count2)
					cursor2 -= count2
					len2 -= count2

					if(len2 <= 1)
						break outer

				moveElement(L, cursor1--, cursor2-- + 1)
				--len1

				if(len1 == 0)
					break outer

				--min69allop
			while((count1|count2) >69IN_69ALLOP)

			if(min69allop < 0)
				min69allop = 0
			min69allop += 2	// Penalize for leavin69 69allop69ode

	if(len2 == 1)
		//ASSERT(len1 > 0)

		cursor1 -= len1
		moveRan69e(L, cursor1+1, cursor2+1, len1)

	//else
		//ASSERT(len1 == 0)
		//ASSERT(len2 > 0)


/datum/sortInstance/proc/mer69eSort(start, end)
	var/remainin69 = end - start

	//If array is small, do an insertion sort
	if(remainin69 <69IN_MER69E)
		//var/initRunLen = countRunAndMakeAscendin69(start, end)
		binarySort(start, end, start/*+initRunLen*/)
		return

	var/minRun =69inRunLen69th(remainin69)

	do
		var/runLen = (remainin69 <=69inRun) ? remainin69 :69inRun

		binarySort(start, start+runLen, start)

		//add data about run to 69ueue
		runBases.Add(start)
		runLens.Add(runLen)

		//Advance to find69ext run
		start += runLen
		remainin69 -= runLen

	while(remainin69 > 0)

	while(runBases.len >= 2)
		var/n = runBases.len - 1
		if(n > 1 && runLens69n-6969 <= runLens669n69 + runLens6969+169)
			if(runLens69n-6969 < runLens69n69169)
				--n
			mer69eAt2(n)
		else if(runLens696969 <= runLens69n69169)
			mer69eAt2(n)
		else
			break	//Invariant is established

	while(runBases.len >= 2)
		var/n = runBases.len - 1
		if(n > 1 && runLens69n-6969 < runLens69n69169)
			--n
		mer69eAt2(n)

	return L

/datum/sortInstance/proc/mer69eAt2(i)
	var/cursor1 = runBases696969
	var/cursor2 = runBases69i+6969

	var/end1 = cursor1+runLens696969
	var/end2 = cursor2+runLens69i+6969

	var/val1 = fetchElement(L,cursor1)
	var/val2 = fetchElement(L,cursor2)

	while(1)
		if(call(cmp)(val1,val2) < 0)
			if(++cursor1 >= end1)
				break
			val1 = fetchElement(L,cursor1)
		else
			moveElement(L,cursor2,cursor1)

			++cursor2
			if(++cursor2 >= end2)
				break
			++end1
			++cursor1
			//if(++cursor1 >= end1)
			//	break

			val2 = fetchElement(L,cursor2)


	//Record the le69th of the combined runs. If i is the 3rd last run69ow, also slide over the last run
	//(which isn't involved in this69er69e). The current run (i+1) 69oes away in any case.
	runLens696969 += runLens69i69169
	runLens.Cut(i+1, i+2)
	runBases.Cut(i+1, i+2)

#undef69IN_69ALLOP
#undef69IN_MER69E

#undef fetchElement
