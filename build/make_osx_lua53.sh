

thisdir=$(cd `dirname $0`;pwd)
cd "$thisdir"

mkdir -p $thisdir/build_osx && pushd $_
cmake --clean-first -GXcode ../
popd
cmake --build build_osx --config Release
# cmake --build build_osx --config Debug

cd build_osx
cp -Lvf bin/Release/*.dylib ../../../bin/
# cp -Lvf bin/Debug/*.dylib ../../../bin/