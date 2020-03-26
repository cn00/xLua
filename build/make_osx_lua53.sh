

thisdir=$(cd `dirname $0`;pwd)
cd "$thisdir"

mkdir -p $thisdir/build_osx && pushd $_
cmake --clean-first -GXcode ../
popd
cmake --build build_osx --config Release

cd build_osx
cp -Lvf {lsqlite3,lua,libexpat/expat,luaexpat,p7zip}/Release/*.dylib Release/libxlua.dylib ../../../Assets/XLua/Plugins/OSX/