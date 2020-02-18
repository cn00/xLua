
cd $(dirname $0;pwd)

./make_ios_lua53.sh 
./make_ios_lua53-sim.sh 

lipo -create plugin_lua53/Plugins/iOS/libxlua*.a -output ../Assets/Plugins/iOS/libxlua.a
lipo -create build_ios-sim/Release-iphonesimulator/libxlua.dylib build_ios/Release-iphoneos/libxlua.dylib -output ../Assets/Plugins/iOS/libxlua.dylib 

mkdir -p ../Assets/Plugins/iOS/lua
cp lua-5.3.4/src/*.h ../Assets/Plugins/iOS/lua/