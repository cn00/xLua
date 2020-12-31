

thisdir=$(cd `dirname $0`;pwd)
cd "$thisdir"

build_type="Release" #Debug
mkdir -p $thisdir/build.OSX && pushd $_
cmake --clean-first -GXcode ../build  -DOSX=TRUE # -DCMAKE_TOOLCHAIN_FILE=../build/cmake/ios.toolchain.cmake -DPLATFORM="macosx"
popd
cmake --build build.OSX --config ${build_type} #--target xlua lfs lfb expat luasql lsqlite3 nslua libmariadb p7zip

# cmake --install build.OSX --prefix ../../cslua/bin/Debug/
# cmake --install build.OSX --prefix ../../cslua/bin/Release/

for i in `ls build.OSX/bin/${build_type}/`; do 
    install_name_tool -id @loader_path/$i build.OSX/bin/${build_type}/$i;
    install_name_tool -change @executable_path/../lib/liblua.dylib @loader_path/liblua.dylib build.OSX/bin/${build_type}/$i;
done

## fixed Killed: 9
/usr/bin/codesign --force --sign - --timestamp=none build.OSX/bin/${build_type}/*.dylib

outdir='Assets/Plugins/OSX/'
mkdir -p ${outdir}
cp -vf build.OSX/bin/${build_type}/* ${outdir}

outdir='./lib/'
mkdir $outdir
# cp -vf build.OSX/bin/${build_type}/*.dylib ../lib/
cp -vf build.OSX/bin/${build_type}/* ${outdir}
# rm -rf build.OSX/bin/${build_type}.bak
# mv -f build.OSX/bin/${build_type} build.OSX/bin/${build_type}.bak

