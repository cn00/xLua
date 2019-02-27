
cd $(dirname $0;pwd)

if [ -z "$ANDROID_NDK" ]; then
    export ANDROID_NDK=/usr/local/share/android-ndk
fi

mkdir -p build_and_v7a && cd build_and_v7a
cmake -DANDROID_ABI=armeabi-v7a -DCMAKE_TOOLCHAIN_FILE=../cmake/android.toolchain.cmake -DANDROID_TOOLCHAIN_NAME=arm-linux-androideabi-4.9 -DANDROID_NATIVE_API_LEVEL=android-26 ../
cd ..
cmake --build build_and_v7a --config Release
mkdir -p plugin_lua53/Plugins/Android/libs/armeabi-v7a/
cp build_and_v7a/libxlua.so ../Assets/Plugins/Android/libs/armeabi-v7a/libxlua.so

mkdir -p build_and_x86 && cd build_and_x86
cmake -DANDROID_ABI=x86 -DCMAKE_TOOLCHAIN_FILE=../cmake/android.toolchain.cmake -DANDROID_TOOLCHAIN_NAME=x86-4.9 -DANDROID_NATIVE_API_LEVEL=android-26 ../
cd ..
cmake --build build_and_x86 --config Release
mkdir -p plugin_lua53/Plugins/Android/libs/x86/
cp build_and_x86/libxlua.so ../Assets/Plugins/Android/libs/x86/libxlua.so


