#!/usr/bin/env bash

set +x

mvn spotless:apply validate -DlicenseUpdateHeaders=true -Pags,all-tas-tests > /dev/null || true

all_nonconformant_files=$(git diff --name-only --diff-filter=ACMR)

for file in ${all_nonconformant_files}
do
  revert=1
  for modified_file in ${modified_files}
  do
    if [[ "${modified_file}" == "${file}" ]]
    then
      revert=0
      break
    fi
  done
  if [[ ${revert} == 1 ]]
  then
    git checkout -- "${file}"
  fi
done

set -x
