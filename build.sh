#script to compile kdenlive on windows
#setup the build dirs
#SOURCE_DIR is the location where our custon *.mk files are stored
#BUILD_DIR is the location where all the built files will be stored
#MXE_DIR is the location where mxe resides. 
SOURCE_DIR=.
BUILD_DIR=~/src/kdenlinve-win
MXE_DIR=~/src/mxe
mkdir $BUILD_DIR
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
echo "Compiling KDE frameworks - KConfig"
#KConfig
git clone git://anongit.kde.org/kconfig.git $BUILD_DIR/kconfig
#Pull to make sure we have latest sources
cd $BUILD_DIR/kconfig
git pull
mkdir $BUILD_DIR/kconfig-build
cd $BUILD_DIR/kconfig-build
cmake $BUILD_DIR/kconfig \
    -DCMAKE_TOOLCHAIN_FILE=~/src/mxe/usr/i686-w64-mingw32.static/share/cmake/mxe-conf.cmake \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_INSTALL_PREFIX=$BUILD_DIR/usr \
    -DLIB_INSTALL_DIR=$BUILD_DIR/lib \
    -DLIBEXEC_INSTALL_DIR=$BUILD_DIR/lib \
    -DKDE_INSTALL_USE_QT_SYS_PATHS=ON \
    -DBUILD_TESTING=OFF
make
make INSTALL_ROOT=$BUILD_DIR/lib install

echo "Compiling KDE frameworks - KArchive"
#KArchive
git clone git://anongit.kde.org/karchive.git $BUILD_DIR/karchive
#Pull to make sure we have latest sources
cd $BUILD_DIR/karchive
git pull
mkdir $BUILD_DIR/karchive_build
cd $BUILD_DIR/karchive_build
cmake $BUILD_DIR/karchive \
    -DCMAKE_TOOLCHAIN_FILE=~/src/mxe/usr/i686-w64-mingw32.static/share/cmake/mxe-conf.cmake \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_INSTALL_PREFIX=$BUILD_DIR/usr \
    -DLIB_INSTALL_DIR=$BUILD_DIR/lib \
    -DKDE_INSTALL_USE_QT_SYS_PATHS=ON \
    -DBUILD_TESTING=OFF
make
make INSTALL_ROOT=$BUILD_DIR/lib install

echo "Compiling KDE frameworks - KIO"
#KIO
git clone git://anongit.kde.org/kio.git $BUILD_DIR/kio
#Pull to make sure we have latest sources
cd $BUILD_DIR/kio
git pull
mkdir $BUILD_DIR/io_build
cd $BUILD_DIR/karchive_build
cmake $BUILD_DIR/kio \
    -DCMAKE_TOOLCHAIN_FILE=~/src/mxe/usr/i686-w64-mingw32.static/share/cmake/mxe-conf.cmake \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_INSTALL_PREFIX=$BUILD_DIR/usr \
    -DLIB_INSTALL_DIR=$BUILD_DIR/lib \
    -DKDE_INSTALL_USE_QT_SYS_PATHS=ON \
    -DBUILD_TESTING=OFF
make
make INSTALL_ROOT=$BUILD_DIR/lib install

