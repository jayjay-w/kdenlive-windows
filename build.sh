#script to compile kdenlive on windows
#setup the build dirs
#SOURCE_DIR is the location where our custon *.mk files are stored
#BUILD_DIR is the location where all the built files will be stored
#MXE_DIR is the location where mxe resides. 
SOURCE_DIR=.
BUILD_DIR=~/src/kdenlinve-win
MXE_DIR=~/src/mxe
cp $SOURCE_DIR/*mk $MXE_DIR -f
cp $SOURCE_DIR/*patch $MXE_DIR -f
#Step 1: Checkout mxe from github, if not already done
if [ ! -d "$MXE_DIR" ]; then
        echo "Fetching MXE sources"
	git clone https://github.com/mxe/mxe.git $BUILD_DIR/mxe
	cd ..
else
    echo "MXE folder already exists. Pulling latest changes."
    cd $MXE_DIR
    git pull
    #Apply our patch to index.html
    echo "Patching index.html"
    git am *.patch
fi
cd $MXE_DIR
#Step 2: compile the needed MLT framework
echo "Compiling MLT and its dependencies using MXE"
make qt5 nsis mlt
#Step 6: clone and compile kde frameworks

function buildFramework {
echo "Compiling KDE frameworks - $1"
#check if folder already exists and pull, if not, clone
if [ ! -d "$BUILD_DIR/$1" ]; then
    echo "Cloning $1"
    git clone git://anongit.kde.org/$1.git $BUILD_DIR/$1
else
    echo "Pulling $1"
    cd $BUILD_DIR/$1
    git pull
fi
mkdir -p $BUILD_DIR/$1_win
cd $BUILD_DIR/$1_win
cmake ../$1 \
    -DCMAKE_TOOLCHAIN_FILE=~/src/mxe/usr/i686-w64-mingw32.static/share/cmake/mxe-conf.cmake \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_INSTALL_PREFIX=../usr \
    -DLIB_INSTALL_DIR=../lib \
    -DLIBEXEC_INSTALL_DIR=../lib \
    -DKDE_INSTALL_USE_QT_SYS_PATHS=ON \
    -DBUILD_TESTING=OFF
    
    cmake ../$1 \
    -DCMAKE_TOOLCHAIN_FILE=~/src/mxe/usr/i686-w64-mingw32.static/share/cmake/mxe-conf.cmake \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_INSTALL_PREFIX=../usr \
    -DLIB_INSTALL_DIR=../lib \
    -DLIBEXEC_INSTALL_DIR=../lib \
    -DKDE_INSTALL_USE_QT_SYS_PATHS=ON \
    -DBUILD_TESTING=OFF

    cmake ../$1 \
    -DCMAKE_TOOLCHAIN_FILE=~/src/mxe/usr/i686-w64-mingw32.static/share/cmake/mxe-conf.cmake \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_INSTALL_PREFIX=../usr \
    -DLIB_INSTALL_DIR=../lib \
    -DLIBEXEC_INSTALL_DIR=../lib \
    -DKDE_INSTALL_USE_QT_SYS_PATHS=ON \
    -DBUILD_TESTING=OFF
    
    cmake ../$1 \
    -DCMAKE_TOOLCHAIN_FILE=~/src/mxe/usr/i686-w64-mingw32.static/share/cmake/mxe-conf.cmake \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_INSTALL_PREFIX=../usr \
    -DLIB_INSTALL_DIR=../lib \
    -DLIBEXEC_INSTALL_DIR=../lib \
    -DKDE_INSTALL_USE_QT_SYS_PATHS=ON \
    -DBUILD_TESTING=OFF


make
make INSTALL_ROOT=../lib install

}

buildFramework kcoreaddons
buildframework kguiaddons
buildFramework kwidgetsaddons
buildFramework kdbusaddons
buildframework kxmlgui
buildFramework karchive
buildFramework ktextwidgets
buildFramework kiconthemes
buildFramework knotifications
buildframework knotifyconfig
buildFramework kio
buildFramework kcrash
buildFramework kconfig
buildframework knewstuff