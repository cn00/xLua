if [ -z "$ANDROID_NDK" ]; then
    export ANDROID_NDK=~/android-ndk-r15c
fi

set -x

thisdir=$(cd `dirname $0`;pwd)
cd "$thisdir"

distdir="$thisdir/../Assets/XLua"

mkdir -p $thisdir/build_v7a && pushd $_
cmake -Wno-dev -DANDROID_ABI=armeabi-v7a -DCMAKE_TOOLCHAIN_FILE=$ANDROID_NDK/build/cmake/android.toolchain.cmake -DANDROID_TOOLCHAIN_NAME=arm-linux-androideabi-clang -DANDROID_NATIVE_API_LEVEL=android-9 ../
popd
cmake --build $thisdir/build_v7a --config Release
mkdir -p $distdir/Plugins/Android/libs/armeabi-v7a/
cp $thisdir/build_v7a/libxlua.so $distdir/Plugins/Android/libs/armeabi-v7a/libxlua.so



mkdir -p $thisdir/build_v8a && pushd $_
cmake -Wno-dev -DANDROID_ABI=arm64-v8a -DCMAKE_TOOLCHAIN_FILE=$ANDROID_NDK/build/cmake/android.toolchain.cmake -DANDROID_TOOLCHAIN_NAME=arm-linux-androideabi-clang -DANDROID_NATIVE_API_LEVEL=android-9 ../
popd
cmake --build $thisdir/build_v8a --config Release
mkdir -p $distdir/Plugins/Android/libs/arm64-v8a/
cp $thisdir/build_v8a/libxlua.so $distdir/Plugins/Android/libs/arm64-v8a/libxlua.so




mkdir -p $thisdir/build_x86 && pushd $_
cmake -Wno-dev -DANDROID_ABI=x86 -DCMAKE_TOOLCHAIN_FILE=$ANDROID_NDK/build/cmake/android.toolchain.cmake -DANDROID_TOOLCHAIN_NAME=x86-clang -DANDROID_NATIVE_API_LEVEL=android-9 ../
popd
cmake --build $thisdir/build_x86 --config Release
mkdir -p $distdir/Plugins/Android/libs/x86/
cp $thisdir/build_x86/libxlua.so $distdir/Plugins/Android/libs/x86/libxlua.so


