mkdir -p build_ios-sim && cd build_ios-sim
cmake -DIOS_PLATFORM=SIMULATOR -DCMAKE_TOOLCHAIN_FILE=../cmake/iOS.cmake  -GXcode ../
cd ..
cmake --build build_ios-sim --config Release
mkdir -p plugin_lua53/Plugins/iOS/
cp build_ios-sim/Release-iphonesimulator/libxlua.a plugin_lua53/Plugins/iOS/libxlua-sim.a