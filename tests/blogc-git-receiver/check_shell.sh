#!/bin/bash

set -xe -o pipefail

export LC_ALL=C

TEMP="$(mktemp -d)"
[[ -n "${TEMP}" ]]

trap_func() {
    [[ -e "${TEMP}/output.txt" ]] && cat "${TEMP}/output.txt"
    rm -rf "${TEMP}"
}

trap trap_func EXIT

SELF="${PWD}/blogc-git-receiver"

call_bgr() {
    [[ -n "${VALGRIND}" ]] && export __VALGRIND_ENABLED=1
    SHELL="${SELF}" HOME="${TEMP}" ${TESTS_ENVIRONMENT} "${SELF}" "$@"
}

call_bgr -c "bola 'lol.git'" 2>&1 | tee "${TEMP}/output.txt" || true
grep "error: invalid git-shell command: bola 'lol\.git'" "${TEMP}/output.txt" &> /dev/null

echo 0000 | call_bgr -c "git-receive-pack 'lol.git'" 2>&1 > "${TEMP}/output.txt"
if [[ -n "${VALGRIND}" ]]; then
    grep "git-shell -c \"git-receive-pack '.*repos/lol.git'\"" "${TEMP}/output.txt" &> /dev/null
else
    grep "agent=" "${TEMP}/output.txt" &> /dev/null
fi
[[ -d "${TEMP}/repos/lol.git" ]]
[[ -h "${TEMP}/repos/lol.git/hooks/pre-receive" ]]
[[ "$(readlink "${TEMP}/repos/lol.git/hooks/pre-receive")" == "${SELF}" ]]
[[ -h "${TEMP}/repos/lol.git/hooks/post-receive" ]]
[[ "$(readlink "${TEMP}/repos/lol.git/hooks/post-receive")" == "${SELF}" ]]

cat > "${TEMP}/tmp.txt" <<EOF
blob
mark :1
data 4
bar

reset refs/heads/master
commit refs/heads/master
mark :2
author Rafael G. Martins <rafael@rafaelmartins.eng.br> 1476033730 +0200
committer Rafael G. Martins <rafael@rafaelmartins.eng.br> 1476033888 +0200
data 11
testing...
M 100644 :1 foo

EOF
cd "${TEMP}/repos/lol.git"
git fast-import < "${TEMP}/tmp.txt" &> /dev/null
cd - > /dev/null

echo 0000 | call_bgr -c "git-upload-pack 'lol.git'" 2>&1 > "${TEMP}/output.txt"
if [[ -n "${VALGRIND}" ]]; then
    grep "git-shell -c \"git-upload-pack '.*repos/lol.git'\"" "${TEMP}/output.txt" &> /dev/null
else
    grep "agent=" "${TEMP}/output.txt" &> /dev/null
fi

echo 0000 | call_bgr -c "git-upload-archive 'lol.git'" 2>&1 > "${TEMP}/output.txt" || true
if [[ -n "${VALGRIND}" ]]; then
    grep "git-shell -c \"git-upload-archive '.*repos/lol.git'\"" "${TEMP}/output.txt" &> /dev/null
else
    grep "ACK" "${TEMP}/output.txt" &> /dev/null
fi

rm "${TEMP}/output.txt"
