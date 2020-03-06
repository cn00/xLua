if [ -n "$ANDROID_NDK" ]; then
    export NDK=${ANDROID_NDK}
elif [ -n "$ANDROID_NDK_HOME" ]; then
    export NDK=${ANDROID_NDK_HOME}
elif [ -n "$ANDROID_NDK_HOME" ]; then
    export NDK=${ANDROID_NDK_HOME}
else
    export NDK=~/android-ndk-r15c
fi

if [ ! -d "$NDK" ]; then
    echo "Please set ANDROID_NDK environment to the root of NDK."
    exit 1
fi

cd $(dirname $0)

function build() {
    API=$1
    ABI=$2
    TOOLCHAIN_ANME=$3
    BUILD_PATH=build.Android.${ABI}
    cmake -H. -B${BUILD_PATH} -DCMAKE_TOOLCHAIN_FILE=${NDK}/build/cmake/android.toolchain.cmake -DANDROID_NATIVE_API_LEVEL=${API} -DANDROID_TOOLCHAIN=clang -DANDROID_TOOLCHAIN_NAME=${TOOLCHAIN_ANME}
    cmake --build ${BUILD_PATH} --config Release
    mkdir -p plugin_lua53/Plugins/Android/libs/${ABI}/
    # cp ${BUILD_PATH}/libxlua.so ../../Assets/XLua/Plugins/Android/libs/${ABI}/libxlua.so
}

build android-16 armeabi-v7a arm-linux-androideabi-4.9
cp build.Android.armeabi-v7a/*.so ../../Assets/XLua/Plugins/Android/libs/armeabi-v7a/

build android-16 arm64-v8a  arm-linux-androideabi-clang
cp build.Android.arm64-v8a/*.so ../../Assets/XLua/Plugins/Android/libs/arm64-v8a/

build android-16 x86 x86-4.9
cp build.Android.x86/*.so ../../Assets/XLua/Plugins/Android/libs/x86/
