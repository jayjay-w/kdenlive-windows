#script to compile kde frameworks on windows
#setup the build dirs
#BUILD_DIR is the location where all the built files will be stored
#MXE_DIR is the location where mxe resides. 
SOURCE_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
echo "Source path is $SOURCE_DIR" 
echo "Compiling KDE framework ($1)"
BUILD_DIR=~/src/kdenlive-win
MXE_DIR=$SOURCE_DIR/mxe/mxe
MXE_INSTALL_PATH=$MXE_DIR/usr/i686-w64-mingw32.shared

FRAMEWORK_VER_MAJOR=5.23
FRAMEWORK_VER_MINOR=0
mkdir $BUILD_DIR/frameworks -p

cd $BUILD_DIR/frameworks
echo "Compiling KDE framework ($1)"
#Download the code
TAR_FILE_NAME=$1-$FRAMEWORK_VER_MAJOR.$FRAMEWORK_VER_MINOR.tar.xz
    
if [ ! -f $TAR_FILE_NAME ]; then
    wget http://download.kde.org/stable/frameworks/$FRAMEWORK_VER_MAJOR/$TAR_FILE_NAME
fi
    
if [ ! -d $1-$FRAMEWORK_VER_MAJOR.$FRAMEWORK_VER_MINOR ]; then
    tar xvf $TAR_FILE_NAME
fi
    
if [ ! -d $BUILD_DIR/frameworks/$1-$FRAMEWORK_VER_MAJOR.$FRAMEWORK_VER_MINOR-build ]; then
    mkdir -p $BUILD_DIR/frameworks/$1-$FRAMEWORK_VER_MAJOR.$FRAMEWORK_VER_MINOR-build
fi
    
cd $BUILD_DIR/frameworks/$1-$FRAMEWORK_VER_MAJOR.$FRAMEWORK_VER_MINOR-build
cmake $BUILD_DIR/frameworks/$1-$FRAMEWORK_VER_MAJOR.$FRAMEWORK_VER_MINOR \
    -DCMAKE_TOOLCHAIN_FILE=$MXE_DIR/usr/i686-w64-mingw32.shared/share/cmake/mxe-conf.cmake \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_PREFIX_PATH=$MXE_DIR/usr/i686-w64-mingw32.shared/qt5 \
    -DKDE_INSTALL_USE_QT_SYS_PATHS=ON \
    -DBUILD_TESTING=OFF
make
make install