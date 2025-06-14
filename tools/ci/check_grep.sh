#!/bin/bash
set -euo pipefail

#nb: must be bash to support shopt globstar
shopt -s globstar extglob

#ANSI Escape Codes for colors to increase contrast of errors
RED="\033[0;31m"
GREEN="\033[0;32m"
BLUE="\033[0;34m"
NC="\033[0m" # No Color

st=0

# check for ripgrep
if command -v rg >/dev/null 2>&1; then
	grep=rg
	pcre2_support=1
	if [ ! rg -P '' >/dev/null 2>&1 ] ; then
		pcre2_support=0
	fi
	code_files="code/**/**.dm"
	map_files="_maps/**/**.dmm"
	shuttle_map_files="_maps/shuttles/**.dmm"
	code_x_515="code/**/!(__byond_version_compat).dm"
else
	pcre2_support=0
	grep=grep
	code_files="-r --include=code/**/**.dm"
	map_files="-r --include=_maps/**/**.dmm"
	shuttle_map_files="-r --include=_maps/shuttles/**.dmm"
	code_x_515="-r --include=code/**/!(__byond_version_compat).dm"
fi

echo -e "${BLUE}Using grep provider at $(which $grep)${NC}"

part=0
section() {
	echo -e "${BLUE}Checking for $1${NC}..."
	part=0
}

part() {
	part=$((part+1))
	padded=$(printf "%02d" $part)
	echo -e "${GREEN} $padded- $1${NC}"
}

section "whitespace issues"
part "space indentation"
if $grep '(^ {2})|(^ [^ * ])|(^    +)' $code_files; then
	echo
    echo -e "${RED}ERROR: Space indentation detected, please use tab indentation.${NC}"
    st=1
fi;
part "mixed indentation"
if $grep '^\t+ [^ *]' $code_files; then
	echo
    echo -e "${RED}ERROR: Mixed <tab><space> indentation detected, please stick to tab indentation.${NC}"
    st=1
fi;

section "516 Href Styles"
part "byond href styles"
if $grep "href[\s='\"\\\\]*\?" $code_files ; then
    echo
    echo -e "${RED}ERROR: BYOND requires internal href links to begin with \"byond://\".${NC}"
    st=1
fi;

section "common mistakes"
part "global vars"
if $grep '^/*var/' $code_files; then
	echo
	echo -e "${RED}ERROR: Unmanaged global var use detected in code, please use the helpers.${NC}"
	st=1
fi;

part "proc args with var/"
if $grep '^/[\w/]\S+\(.*(var/|, ?var/.*).*\)' $code_files; then
	echo
	echo -e "${RED}ERROR: Changed files contains a proc argument starting with 'var'.${NC}"
	st=1
fi;

part "improperly pathed static lists"
if $grep -i 'var/list/static/.*' $code_files; then
	echo
	echo -e "${RED}ERROR: Found incorrect static list definition 'var/list/static/', it should be 'var/static/list/' instead.${NC}"
	st=1
fi;


part "ensure proper span usage"
# lowertext() is a BYOND-level proc, so it can be used in any sort of code... including the TGS DMAPI which we don't manage in this repository.
# basically, we filter out any results with "tgs" in it to account for this edgecase without having to enforce this rule in that separate codebase.
# grepping the grep results is a bit of a sad solution to this but it's pretty much the only option in our existing linter framework
if $grep -i 'lowertext\(.+\)' $code_files | $grep -v 'UNLINT\(.+\)' | $grep -v '\/modules\/tgs\/'; then
	echo
	echo -e "${RED}ERROR: Found a lowertext() proc call. Please use the LOWER_TEXT() macro instead. If you know what you are doing, wrap your text (ensure it is a string) in UNLINT().${NC}"
	st=1
fi;

part "balloon_alert sanity"
if $grep 'balloon_alert\(".*"\)' $code_files; then
	echo
	echo -e "${RED}ERROR: Found a balloon alert with improper arguments.${NC}"
	st=1
fi;

if $grep 'balloon_alert(.*span_)' $code_files; then
	echo
	echo -e "${RED}ERROR: Balloon alerts should never contain spans.${NC}"
	st=1
fi;

part "balloon_alert idiomatic usage"
if $grep 'balloon_alert\(.*?, ?"[A-Z]' $code_files; then
	echo
	echo -e "${RED}ERROR: Balloon alerts should not start with capital letters. This includes text like 'AI'. If this is a false positive, wrap the text in UNLINT().${NC}"
	st=1
fi;

part "update_icon_updates_onmob element usage"
if $grep 'AddElement\(/datum/element/update_icon_updates_onmob.+ITEM_SLOT_HANDS' $code_files; then
	echo
	echo -e "${RED}ERROR: update_icon_updates_onmob element automatically updates ITEM_SLOT_HANDS, this is redundant and should be removed.${NC}"
	st=1
fi;

part "forceMove sanity"
if $grep 'forceMove\(\s*(\w+\(\)|\w+)\s*,\s*(\w+\(\)|\w+)\s*\)' $code_files; then
	echo
	echo -e "${RED}ERROR: forceMove() call with two arguments - this is not how forceMove() is invoked! It's x.forceMove(y), not forceMove(x, y).${NC}"
	st=1
fi;

part "common spelling mistakes"
if $grep -i 'centcomm' $code_files; then
	echo
    echo -e "${RED}ERROR: Misspelling(s) of CentCom detected in code, please remove the extra M(s).${NC}"
    st=1
fi;
if $grep -ni 'nanotransen' $code_files; then
	echo
    echo -e "${RED}ERROR: Misspelling(s) of NanoTrasen detected in code, please remove the extra N(s).${NC}"
    st=1
fi;
if $grep 'Nanotrasen' $code_files; then
	echo
    echo -e "${RED}ERROR: Misspelling(s) of NanoTrasen detected in code, please capitalize the T(s).${NC}"
    st=1
fi;
if $grep 'Neotheology' $code_files; then
	echo
    echo -e "${RED}ERROR: Misspelling(s) of NeoTheology detected in code, please capitalize the T(s).${NC}"
    st=1
fi;
if $grep 'Hansa' $code_files; then
	echo
    echo -e "${RED}ERROR: Misspelling(s) of Hanza detected in code.${NC}"
    st=1
fi;
# Leaving other factions for now, otherwise we'll have to edit job names and that may mess with the preferences
if $grep -i'eciev' $code_files; then
	echo
    echo -e "${RED}ERROR: Common I-before-E typo detected in code.${NC}"
    st=1
fi;
if $grep 'for \(' $code_files; then
	echo
    echo -e "${RED}ERROR: Spaces are not needed around for() loop brackets.${NC}"
    st=1
fi;
if $grep 'while \(' $code_files; then
	echo
    echo -e "${RED}ERROR: Spaces are not needed around while() loop brackets.${NC}"
    st=1
fi;
if $grep 'if \(' $code_files; then
	echo
    echo -e "${RED}ERROR: Spaces are not needed around if() statement brackets.${NC}"
    st=1
fi;
if $grep 'do \(' $code_files; then
	echo
    echo -e "${RED}ERROR: Spaces are not needed around do() statement brackets.${NC}"
    st=1
fi;

if [ "$pcre2_support" -eq 1 ]; then
	section "regexes requiring PCRE2"
	part "to_chat sanity"
	if $grep -P 'to_chat\((?!.*,).*\)' $code_files; then
		echo
		echo -e "${RED}ERROR: to_chat() missing arguments.${NC}"
		st=1
	fi;
	part "timer flag sanity"
	if $grep -P 'addtimer\((?=.*TIMER_OVERRIDE)(?!.*TIMER_UNIQUE).*\)' $code_files; then
		echo
		echo -e "${RED}ERROR: TIMER_OVERRIDE used without TIMER_UNIQUE.${NC}"
		st=1
	fi
	part "trailing newlines"
	if $grep -PU '[^\n]$(?!\n)' $code_files; then
		echo
		echo -e "${RED}ERROR: File(s) with no trailing newline detected, please add one.${NC}"
		st=1
	fi
fi;

else
	echo -e "${RED}pcre2 not supported, skipping checks requiring pcre2"
	echo -e "if you want to run these checks install ripgrep with pcre2 support.${NC}"
fi

if [ $st = 0 ]; then
    echo
    echo -e "${GREEN}No errors found using $grep!${NC}"
fi;

if [ $st = 1 ]; then
    echo
    echo -e "${RED}Errors found, please fix them and try again.${NC}"
fi;

exit $st
