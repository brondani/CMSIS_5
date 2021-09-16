#!/bin/bash

# header
echo "Generate multiple projects from layers specified in a list"

# usage
usage() {
  echo "Usage:"
  echo "  gen_proj_list.sh <ProjectList>.txt [--layer=<LayerPath>]"
  echo ""
  echo "  <ProjectList>        : Project list (format used by gen_proj.sh)"
  echo "  --layer=<LayerPath>  : Layer directory (default=layers)"
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
      projectlist=$(basename "$i" .txt)
      shift
    ;;
    --layer=*)
      layerpath="${i#*=}"
      shift
    ;;
    *)
      usage
      exit 0
    ;;
  esac
done
 
# check if project list is specified
if [ -z ${projectlist} ]
then
  echo "error: missing <ProjectList>.txt"
  usage
  exit 1
fi

# set default layer directory if not specified
if [ -z ${layerpath} ]
then
  layerpath="layers"
fi

# ensure linux file endings
dos2unix "${projectlist}.txt"

# call gen_proj.sh for each project
while read line
  do
    [[ $line =~ ^#.* ]] && continue
    echo $line
    ./gen_proj.sh $line --layer=$layerpath
    if [ $? -ne 0 ]
      then
      echo "CPRJ generation failed!"
      exit 1
    fi
done < "${projectlist}.txt"

exit 0