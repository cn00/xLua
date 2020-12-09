mkdir -p build.iOS.sim && cd build.iOS.sim
cmake -DIOS_PLATFORM=SIMULATOR -DCMAKE_TOOLCHAIN_FILE=../build/cmake/iOS.cmake  -GXcode ../build
cd ..
cmake --build build.iOS.sim --config Release
mkdir -p plugin_lua53/Plugins/iOS/
cp build.iOS.sim/Release-iphonesimulator/libxlua.a plugin_lua53/Plugins/iOS/libxlua-sim.a