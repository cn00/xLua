

thisdir=$(cd `dirname $0`;pwd)
cd "$thisdir"

build_type="Release" #Debug
mkdir -p $thisdir/build_osx && pushd $_
cmake --clean-first -GXcode ../build
popd
cmake --build build_osx --config ${build_type}

# cmake --install build_osx --prefix ../../cslua/bin/Debug/
# cmake --install build_osx --prefix ../../cslua/bin/Release/

for i in `ls build_osx/bin/${build_type}/`; do 
    install_name_tool -change @executable_path/../lib/liblua.dylib @loader_path/liblua.dylib build_osx/bin/${build_type}/$i;
done

## fixed Killed: 9
/usr/bin/codesign --force --sign - --timestamp=none build_osx/bin/${build_type}/*.dylib

outdir='../cslua/lib/'
mkdir $outdir
# cp -vf build_osx/bin/${build_type}/*.dylib ../lib/
cp -vf build_osx/bin/${build_type}/* ${outdir}
# rm -rf build_osx/bin/${build_type}.bak
# mv -f build_osx/bin/${build_type} build_osx/bin/${build_type}.bak

