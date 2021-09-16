#!/bin/bash

# header
echo "Compose projects from layers and build them"

./gen_proj_list.sh ProjectList.txt
./build_proj_list.sh BuildList.txt

exit 0