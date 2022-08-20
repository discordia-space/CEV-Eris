#!/bin/bash
set -euo pipefail

#nb: must be bash to support shopt globstar
shopt -s globstar

st=0

if grep -El '^\".+\" = \(.+\)' maps/**/*.dmm;	then
    echo "ERROR: Non-TGM formatted map detected. Please convert it using Map Merger!"
    st=1
fi;
# todo: fixme
# if grep -P '^\ttag = \"icon' maps/**/*.dmm;	then
#     echo "ERROR: tag vars from icon state generation detected in maps, please remove them."
#     st=1
# fi;
if grep -P 'step_[xy]' maps/**/*.dmm;	then
    echo "ERROR: step_x/step_y variables detected in maps, please remove them."
    st=1
fi;
if grep -P 'pixel_[^xy]' maps/**/*.dmm;	then
    echo "ERROR: incorrect pixel offset variables detected in maps, please remove them."
    st=1
fi;
# echo "Checking for cable varedits"
# if grep -P '/obj/structure/cable(/\w+)+\{' maps/**/*.dmm;	then
#     echo "ERROR: vareditted cables detected, please remove them."
#     st=1
# fi;
# if grep -P '^/area/.+[\{]' maps/**/*.dmm;	then
#     echo "ERROR: Vareditted /area path use detected in maps, please replace with proper paths."
#     st=1
# fi;
if grep -P '\W\/turf\s*[,\){]' maps/**/*.dmm; then
    echo "ERROR: base /turf path use detected in maps, please replace with proper paths."
    st=1
fi;
# this is gonna block out the sun
# if grep -P '^/*var/' code/**/*.dm; then
#     echo "ERROR: Unmanaged global var use detected in code, please use the helpers."
#     st=1
# fi;
# echo "Checking for space indentation"
# if grep -P '(^ {2})|(^ [^ * ])|(^    +)' code/**/*.dm; then
#     echo "space indentation detected"
#     st=1
# fi;
# echo "Checking for mixed indentation"
# if grep -P '^\t+ [^ *]' code/**/*.dm; then
#     echo "mixed <tab><space> indentation detected"
#     st=1
# fi;
# nl='
# '
# nl=$'\n'
# while read f; do
#     t=$(tail -c2 "$f"; printf x); r1="${nl}$"; r2="${nl}${r1}"
#     if [[ ! ${t%x} =~ $r1 ]]; then
#         echo "file $f is missing a trailing newline"
#         st=1
#     fi;
# done < <(find . -type f -name '*.dm')
# todo: fixme
# if grep -P '^/[\w/]\S+\(.*(var/|, ?var/.*).*\)' code/**/*.dm; then
#     echo "changed files contains proc argument starting with 'var'"
#     st=1
# fi;
if grep -i 'centcomm' code/**/*.dm; then
    echo "ERROR: Misspelling(s) of CENTCOM detected in code, please remove the extra M(s)."
    st=1
fi;
if grep -i 'centcomm' maps/**/*.dmm; then
    echo "ERROR: Misspelling(s) of CENTCOM detected in maps, please remove the extra M(s)."
    st=1
fi;
if grep -ni 'nanotransen' code/**/*.dm; then
    echo "Misspelling(s) of nanotrasen detected in code, please remove the extra N(s)."
    st=1
fi;
if grep -ni 'nanotransen' maps/**/*.dmm; then
    echo "Misspelling(s) of nanotrasen detected in maps, please remove the extra N(s)."
    st=1
fi;
# if ls maps/*.json | grep -P "[A-Z]"; then
#     echo "Uppercase in a map json detected, these must be all lowercase."
#     st=1
# fi;
if grep -i '/obj/effect/mapping_helpers/custom_icon' maps/**/*.dmm; then
    echo "Custom icon helper found. Please include dmis as standard assets instead for built-in maps."
    st=1
fi;
# for json in maps/*.json
# do
#     map_path=$(jq -r '.map_path' $json)
#     while read map_file; do
#         filename="maps/$map_path/$map_file"
#         if [ ! -f $filename ]
#         then
#             echo "found invalid file reference to $filename in maps/$json"
#             st=1
#         fi
#     done < <(jq -r '[.map_file] | flatten | .[]' $json)
# done

exit $st
