cd $(dirname $0;pwd)

build_target='iOS'
build_dir="build.${build_target}"
mkdir -p ${build_dir} && cd $_
# build_type="Release"
build_type="Debug"
cmake --clean-first -DCMAKE_TOOLCHAIN_FILE=../build/cmake/ios.toolchain.cmake -DPLATFORM="OS64COMBINED" -DENABLE_BITCODE=FALSE \
      -DCMAKE_XCODE_ATTRIBUTE_DEVELOPMENT_TEAM="D2JNH2GMKP" -GXcode ../build
cd ..

# gsed -e '
#     s#/Applications/Xcode.app/Contents/Developer/Platforms/iPhone.*.platform/Developer/SDKs/iPhone.*.sdk/usr/lib/libobjc.tbd#-lobjc#g
#     s#/Applications/Xcode.app/Contents/Developer/Platforms/iPhone.*.platform/Developer/SDKs/iPhone.*.sdk/usr/lib/libz.tbd#-lz#g
#     s#/Applications/Xcode.app/Contents/Developer/Platforms/iPhone.*.platform/Developer/SDKs/iPhone.*.sdk/usr/lib/libiconv.tbd#-liconv#g
# ' -i ${build_dir}/XLua.xcodeproj/project.pbxproj

# set -x

rm -rf ${build_dir}/bin/${build_type}/*

OTHER_SDK_TO_BUILD="iphonesimulator" # -> fat
# OTHER_SDK_TO_BUILD="iphoneos"
# specific targets https://stackoverflow.com/questions/47553569/how-can-i-build-multiple-targets-using-cmake-build
cmake --build ${build_dir} --config ${build_type} --target xlua lfs lfb expat lsqlite3 libmariadb luasql p7zip --  -sdk "${OTHER_SDK_TO_BUILD}"

for i in `ls ${build_dir}/bin/${build_type}/*.dylib`; do
    echo $i
    install_name_tool -id @loader_path/${i##*\/} $i;
    install_name_tool -change @executable_path/../lib/liblua.dylib @loader_path/liblua.dylib $i;
done
/usr/bin/codesign --force --sign - --timestamp=none ${build_dir}/bin/${build_type}/*.dylib
lipo -i ${build_dir}/bin/${build_type}/*.dylib

outdir="Assets/XLua/Plugins/${build_target}/"
mkdir -p ${outdir}
cp -vf ${build_dir}/bin/${build_type}/* ${outdir}
