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
cd $BUILD_DIR
echo "Compiling KDE framework ($1)"
#check if folder already exists and pull, if not, clone
if [ ! -d "$1" ]; then
    echo "Cloning $1"
    git clone git://anongit.kde.org/$1.git $1
else
    echo "Pulling $1"
    cd $1
    git pull
fi

cd $BUILD_DIR
mkdir -p $1_win
cd $1_win
cmake $BUILD_DIR/$1 \
    -DCMAKE_TOOLCHAIN_FILE=~/src/mxe/usr/i686-w64-mingw32.shared/share/cmake/mxe-conf.cmake \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_INSTALL_PREFIX=$BUILD_DIR/usr \
    -DLIB_INSTALL_DIR=$BUILD_DIR/lib \
    -DLIBEXEC_INSTALL_DIR=$BUILD_DIR/lib \
    -DKDE_INSTALL_USE_QT_SYS_PATHS=ON \
    -DBUILD_TESTING=OFF
    
    cmake $BUILD_DIR/$1 \
    -DCMAKE_TOOLCHAIN_FILE=~/src/mxe/usr/i686-w64-mingw32.shared/share/cmake/mxe-conf.cmake \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_INSTALL_PREFIX=$BUILD_DIR/usr \
    -DLIB_INSTALL_DIR=$BUILD_DIR/lib \
    -DLIBEXEC_INSTALL_DIR=$BUILD_DIR/lib \
    -DKDE_INSTALL_USE_QT_SYS_PATHS=ON \
    -DBUILD_TESTING=OFF

    cmake $BUILD_DIR/$1 \
    -DCMAKE_TOOLCHAIN_FILE=~/src/mxe/usr/i686-w64-mingw32.shared/share/cmake/mxe-conf.cmake \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_INSTALL_PREFIX=$BUILD_DIR/usr \
    -DLIB_INSTALL_DIR=$BUILD_DIR/lib \
    -DLIBEXEC_INSTALL_DIR=$BUILD_DIR/lib \
    -DKDE_INSTALL_USE_QT_SYS_PATHS=ON \
    -DBUILD_TESTING=OFF
    
    cmake $BUILD_DIR/$1 \
    -DCMAKE_TOOLCHAIN_FILE=~/src/mxe/usr/i686-w64-mingw32.shared/share/cmake/mxe-conf.cmake \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_INSTALL_PREFIX=$BUILD_DIR/usr \
    -DLIB_INSTALL_DIR=$BUILD_DIR/lib \
    -DLIBEXEC_INSTALL_DIR=$BUILD_DIR/lib \
    -DKDE_INSTALL_USE_QT_SYS_PATHS=ON \
    -DKF5Archive_DIR=$BUILD_DIR/lib/cmake/KF5Archive \
    -DKF5Config_DIR=$BUILD_DIR/lib/cmake/KF5Config \
    -DKF5CoreAddons_DIR=$BUILD_DIR/lib/cmake/KF5CoreAddons \
    -DKF5DBusAddons_DIR=$BUILD_DIR/lib/cmake/KF5DBusAddons \
    -DKF5I18n_DIR=$BUILD_DIR/lib/cmake/KF5I18n \
    -DKF5Service_DIR=$BUILD_DIR/lib/cmake/KF5Service \
    -DKF5Crash_DIR=$BUILD_DIR/lib/cmake/KF5Crash \
    -DKF5WindowSystem_DIR=$BUILD_DIR/lib/cmake/KF5WindowSystem \
    -DBUILD_TESTING=OFF


make
make INSTALL_ROOT=$BUILD_DIR/lib install
sudo make install
}

buildFramework karchive
buildFramework kconfig
buildFramework kcoreaddons
buildFramework kdbusaddons
buildFramework ki18n
buildFramework kwindowsystem
buildFramework kcrash
buildFramework kservice
buildFramework kio
buildframework kguiaddons
buildFramework kwidgetsaddons
buildframework kxmlgui
buildFramework ktextwidgets
buildFramework kiconthemes
buildFramework knotifications
buildframework knotifyconfig
buildframework knewstuff