

thisdir=$(cd `dirname $0`;pwd)
cd "$thisdir"

mkdir -p $thisdir/build_osx && pushd $_
cmake -GXcode ../
popd
cmake --build build_osx --config Release
mkdir -p plugin_lua53/Plugins/xlua.bundle/Contents/MacOS/
cp -r build_osx/Release/xlua.bundle ../Assets/Plugins

