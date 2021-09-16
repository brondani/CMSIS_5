#!/bin/bash

# header
echo "Build CPRJs in the list"

# usage
usage() {
  echo "Usage:"
  echo "  build_proj_list.sh <BuildList>.txt"
  echo ""
  echo "  <BuildList>          : Build list (format used by cbuild.sh)"
}

# arguments
if [ $# -eq 0 ]
then
  usage
  exit 0
fi

for i in "$@"
do
  case $i in
    *.txt)
      buildlist=$(basename "$i" .txt)
      shift
    ;;
    *)
      usage
      exit 0
    ;;
  esac
done
 
# check if list is specified
if [ -z ${buildlist} ]
then
  echo "error: missing <BuildList>.txt"
  usage
  exit 1
fi

# ensure linux file endings
dos2unix "${buildlist}.txt"

# call gen_proj.sh for each project
while read line
  do
    [[ $line =~ ^#.* ]] && continue
    echo "building $line"
    cbuild.sh $line --quiet --cmake="Unix Makefiles"
    if [ $? -ne 0 ]
      then
      echo "Build $line failed!"
      exit 1
    fi
done < "${buildlist}.txt"

exit 0