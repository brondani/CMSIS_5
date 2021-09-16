#!/bin/bash

# header
echo "Generate project from layers"

# usage
usage() {
  echo "Usage:"
  echo "  gen_proj.sh App=<AppLayer>"
  echo "              Device=<DeviceLayer>"
  echo "              Toolchain=<Toolchain>"
  echo "              [--layer=<LayerPath>]"
  echo ""
  echo "  App=<AppLayer>           : Application layer"
  echo "  Device=<DeviceLayer>     : Device layer"
  echo "  Toolchain=<Toolchain>    : Toolchain (AC5, AC6, GCC)"
  echo "  --layer=<LayerPath>      : Layer directory (default=layers)"
}

# silent pushd
pushd () {
  command pushd "$@" > /dev/null
}

# silent popd
popd () {
  command popd "$@" > /dev/null
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
    App=*)
      app="${i#*=}"
      shift
    ;;
    Device=*)
      device="${i#*=}"
      shift
    ;;
    Toolchain=*)
      toolchain="${i#*=}"
      shift
    ;;
    --layer=*)
      layerpath="${i#*=}"
      shift
    ;;
    *)
      usage
      exit 1
    ;;
  esac
done

# check if Application layer is specified
if [ -z ${app} ]
then
  echo "error: missing <AppLayer>"
  usage
  exit 1
fi

# check if Device layer is specified
if [ -z ${device} ]
then
  echo "error: missing <DeviceLayer>"
  usage
  exit 1
fi

# check if Toolchain is specified
if [ -z ${toolchain} ]
then
  echo "error: missing <Toolchain>"
  usage
  exit 1
fi

# set default layer directory if not specified
if [ -z ${layerpath} ]
then
  layerpath="layers"
fi

# check if Application layer exists
if [ ! -d "${layerpath}/App/${app}" ]
then
  echo "error: Application layer <${app}> not found in <${layerpath}/App>"
  exit 1
fi

# set layer and clayer collection
layer=("App")
clayer="../../../${layerpath}/App/${app}/App.clayer"

# check if Device layer exists
if [ ! -d "${layerpath}/Device/${device}.${toolchain}" ]
then
  echo "error: Device layer <${device}.${toolchain}> not found in <${layerpath}/Device>"
  exit 1
fi

# set target name
target="${device}.${toolchain}"

# update Device layer and clayer collection
layer+=("Device")
clayer+=" ../../../${layerpath}/Device/${device}.${toolchain}/Device.clayer"

# create application directory if it does not exist
if [ ! -d "${app}" ]
then
  mkdir -p "projects/${app}"
fi

# go to application directory
pushd "projects/${app}"

# create target directory if it does not exist
if [ ! -d "${target}" ]
then
  mkdir "${target}"
fi

# go to target directory
pushd "${target}"

echo "Output:  projects/${app}/${target}"
echo "Project: ${app}.cprj"

# compose project from layers
cbuildgen compose "${app}.cprj" ${clayer} --toolchain=${toolchain} --quiet
if [ $? -ne 0 ]
  then
  echo "Compose failed!"
  popd
  popd
  exit 1
fi

#remove layer meta files
for item in ${layer[@]}
do
  rm -f "${item}.clayer"
done

popd
popd
exit 0
