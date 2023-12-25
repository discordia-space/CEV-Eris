# General
* Where possible, large projects should be broken up into several smaller pull requests, and/or done in phases over time.
* Pull requests should not contain commented code except TODOs and explanation comments.
* Pull requests should not contain any debug output, variables or procs, unless these are of value to admins/coders for live debugging.
* Pull requests should not contain changes that do not relate with functionality described in commit messages.
* If pull request relates with existing github issue, it should be specified in commit message, for example, "Fix broken floor sprites, close #23" (see https://help.github.com/articles/closing-issues-via-commit-messages/ for additional info).
* If pull request contains map files changes, it should be previously proccessed by mapmerger tool (see /tool/mapmerger/install.txt for additional info). Pull request description should contain screenshots of map changes if it's not obvious from map files diff.
* If pull request contains icon files changes, it should be previously proccessed by icon merger tool (see /tool/dmitool/merging.txt for additional info). Pull request description should contain screenshots of changed icon files.
* If you have the permissions, please set appropriate labels on your PRs. Including, at the very least, Ready for Review to indicate that its done.

# Advice for new recruits
Start small! Make your first couple of PRs focus on bugfixes or small balance tweaks until you get used to the system. The repo is littered with failed projects from people who got overambitious and burned out.

Seek input before starting work on significant features. Your proposal may conflict with existing plans and need modified. Getting the approval of maintainers, and especially the head developer, is important for things which may affect game balance.

Be flexible. Very few submissions are accepted as-is, almost every PR will have some required modifications during the review process, sometimes to how the code works, or often to balance out mechanics. 

Finish what you start. A project is only done when it's merged, not just when the PR is up. After submitting something, try to make some time to be available over the next week or so to fix any requested changes after its reviewed. We won't merge unfinished work.

Ask for help whenever you need it. No man is an island. Don't try to struggle alone, nobody will judge you for asking for help with even silly things.


# Changelog Entries
Any pull requests which add or change user-visible features should have a changelog written up. See example.yml in the html/changelogs directory. Make a copy of it, insert your own name, and write about what you've changed. Include it with your pull request. Not everything needs a changelog, only features that players will notice or care about. Minor bugfixes or code refactors can usually go without.


# Coding Policies
AEV-Oxyd is built under one vision. Make sure to ask any maintainer / repository owner before you start coding out a feature. We might deny it if it doesn't fit our vision.

# Code style
Proc defines should contain full type path.

***Good:***
```
/obj/item/pistol/proc/fire()

/obj/item/pistol/proc/reload()
```
***Bad:***

```
/obj/item/pistol
	proc
	fire()

	proc/reload()
```
***
If, else, for, return, continue and break expressions should not be inline.

***Good:***
```
if(condition)
	foo()
```
```
for(var/object in objects)
	foo(object)
```
***Bad:***
```
if(condition) foo()
```
```
for(var/object in objects) foo(object)
```
***

Spaces are needed between function agruments (declaration and definition). Spaces are needed between the binary operator and arguments. Space is not needed when the operation is unary. Spaces are not needed near brackets. Spaces are needed around assignment operator.

***Good:***
```
/obj/item/pistol/fire(user, target)
	if(can_fire() && target)
		ammo--
		var/corpse = target
```
***Bad:***
```
/obj/item/pistol/fire(user,target)
	if ( can_fire()&&target )
		ammo --
		var/corpset=target
```
***


Don't have unnecessary return calls or return meaningless data.
If there's nothing after a return, and its not returning a specific value, you don't need a return at all.
The . var stores the return of a function and will be returned even without a specific return call.
***Good:***
```
/proc/doThing()
	do_thing
	return result_of_doing_thing
	
/proc/doThing()
	do_thing
	. = result_of_doing_thing
	
/proc/doThing()
	do_thing
	do_other_thing
```
***Bad:***
```
/proc/doThing()
	do_thing
	. = result_of_doing_thing
	return
	
/proc/doThing()
	do_thing
	do_other_thing
	return
```
***


Boolean variables and return values should use TRUE and FALSE constans instead of 1 and 0.
***Good:***
```
/obj/item/pistol/
	var/broken = FALSE

/obj/item/pistol/proc/canFire()
	return TRUE
```
***Bad:***
```
/obj/item/pistol/
	var/broken = 0

/obj/item/pistol/proc/canFire()
	return 1
```
***

Using colon operator (:) for object property and procs access is generally inadvisable.

***Good:***
```
var/obj = new obj()
var/count = obj.count
```
***Bad:***
```
var/obj = new obj()
if(hasvar(obj, "count"))
	var/count = obj:count
```
***

Colorized text outputs should use `to_chat(target, text)` and html tags instead of `<<` and magic color symbols. Make use of our span defines when possible.

***Good:***
```
to_chat(player, SPAN_NOTICE("Everything is OK."))
to_chat(player, SPAN_WARNING("There's something wrong..."))
to_chat(player, SPAN_DANGER("Everything is fucked up!"))
```
***Bad:***
```
player << "\blue Everything is OK."
player << "\red \bold Everything is fucked up!"
```
***

del() usage is deprecated, use qdel() instead.

***Good:***
```
qdel(src)
```
***Bad:***
```
del(src)
```
***



# Naming
Avoid short names for class variables. No acronyms or abbreviations.
These are fine to use for local variables within a proc though.

***Good:***
```
/obj/proximitySensor/updateSprites()
var/count = 0
```
***Bad:***
```
/obj/proxSensor/updSprites()
var/c = 1
```
***


Name your proc parameters properly to prevent name conflicts. If in doubt, use the prefix _ to clearly indicate an input parameter.
Do not use src.var if it can be helped.

***Good:***
```
/obj/set_name(newname)
	name = newname
	
/obj/set_name(_name)
	name = _name
```
***Bad:***
```
/obj/set_name(name)
	name = name
	
/obj/set_name(name)
	src.name = name
```
***

Variables, types and methods should be named in "camel case". Constant values should be in snake-case uppercase. 

***Good:***
```
/proc/redrawIcons()
#define SHIP_NAME "Eris"
```
***Bad:***
```
/proc/Reload_gun()
var/brigArea

/proc/reload_gun()
#define SHIPNAME "Eris"
```
***

Procedure arguments should not contain `var/`. Specified input type e.g. `some_turf as turf` is inadvisable.

***Good:***
```
/proc/renameArea(mob/user, area/A, new_name)

```
***Bad:***
```
/proc/renameArea(var/mob/user as mob, var/area/A as area, var/new_name as text)

```
***
