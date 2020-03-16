cd $(dirname $0;pwd)
mkdir -p build_ios && cd build_ios
# cmake -DCMAKE_TOOLCHAIN_FILE=../cmake/ios.toolchain.cmake -DPLATFORM=OS64 -GXcode ../
# cmake -DCMAKE_TOOLCHAIN_FILE=../cmake/iOS.cmake -GXcode ../
cmake -DCMAKE_TOOLCHAIN_FILE=../cmake/ios.toolchain.cmake -GXcode ../
cd ..
cmake --build build_ios --config Release
# cmake --build build_ios --config Release

