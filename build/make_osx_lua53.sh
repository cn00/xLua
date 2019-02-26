
cd $(dirname $0;pwd)

mkdir -p build_osx && cd build_osx
cmake -GXcode ../
cd ..
cmake --build build_osx --config Release
mkdir -p plugin_lua53/Plugins/xlua.bundle/Contents/MacOS/
cp -r build_osx/Release/xlua.bundle ../Assets/Plugins

