BUILD_DIR=./mxe/usr/x86_64-w64-mingw32.shared
cd $BUILD_DIR
INSTALL_DIR=./kdenlive-windows
mkdir -p $INSTALL_DIR/{lib,share}

# melt
cp *.dll *.exe $INSTALL_DIR
cp bin/*.dll bin/ff*.exe $INSTALL_DIR

cp qt5/bin/Qt5*.dll $INSTALL_DIR
cp -r qt5/{plugins,qml} $INSTALL_DIR/lib

cp -r lib/ladspa $INSTALL_DIR/lib

cp lib/libdl.dll.a $INSTALL_DIR/

#makensis
../makensis .
