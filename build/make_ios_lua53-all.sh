
cd $(dirname $0;pwd)

./make_ios_lua53.sh 
./make_ios_lua53-sim.sh 

lipo -create plugin_lua53/Plugins/iOS/libxlua*.a -output ../Assets/Plugins/iOS/libxlua.a