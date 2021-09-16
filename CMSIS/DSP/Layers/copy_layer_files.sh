#!/bin/bash

# header
echo "Copy application and device files into layer directories"

# usage
usage() {
  echo "Usage:"
  echo "  copy_layer_files.sh <FilesList>.txt"
  echo ""
  echo "  <FilesList>          : Files list (origin destination)"
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
      fileslist=$(basename "$i" .txt)
      shift
    ;;
    *)
      usage
      exit 0
    ;;
  esac
done
 
# check if list is specified
if [ -z ${fileslist} ]
then
  echo "error: missing <FilesList>.txt"
  usage
  exit 1
fi

# ensure linux file endings
dos2unix "${fileslist}.txt"

# call gen_proj.sh for each project
while read line
  do
    [[ $line =~ ^#.* ]] && continue
    directory=$(dirname $(echo $line | awk '{print $2}'))
    echo "copying $line"
    mkdir -p $directory
    cp -T $line
    if [ $? -ne 0 ]
      then
      echo "Copy $line failed!"
      exit 1
    fi
done < "${fileslist}.txt"

exit 0