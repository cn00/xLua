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

echo "NDK=$NDK"
cd $(dirname $0)
androidapi='android-21'

function build() {
    API=${androidapi}
    export ABI=$1
    export ANDROID_ABI=${ABI}
    TOOLCHAIN_NAME=$2
    BUILD_PATH=build.Android.${ABI}
    cmake -Hbuild -B${BUILD_PATH} -DCMAKE_TOOLCHAIN_FILE=${NDK}/build/cmake/android.toolchain.cmake -DANDROID_NATIVE_API_LEVEL=${API} -DANDROID_TOOLCHAIN=clang -DANDROID_TOOLCHAIN_NAME=${TOOLCHAIN_ANME} -DANDROID_ABI=${ABI}
    cmake --build ${BUILD_PATH} --config Release
    mkdir -p Assets/XLua/Plugins/Android/libs/${ABI}/
    cp -v ${BUILD_PATH}/bin/*.so Assets/XLua/Plugins/Android/libs/${ABI}/
}

build armeabi-v7a arm-linux-androideabi-4.9

# build arm64-v8a  arm-linux-androideabi-clang

# build x86 x86-4.9

# build x86_64 x86_64-4.9
