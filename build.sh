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
    #git pull #we can enable pulling later, right not it causes many packages to rebuild if they have been changed upstream
    #Apply our patch to index.html
    echo "Patching index.html"
    git am *.patch
fi
cd $MXE_DIR
#Step 2: compile the needed MLT framework
echo "Compiling MLT and its dependencies using MXE"
make libxml2 libxslt qt5 qtwinextras nsis mlt
#Step 6: clone and compile kde frameworks

#Build sonnet
# echo "Building sonnet"
# git clone git://anongit.kde.org/sonnet.git $BUILD_DIR/sonnet
# cd $BUILD_DIR/sonnet
# sed -i 's,$<TARGET_FILE:KF5::parsetrigrams>,/usr/bin/parsetrigrams,' data/CMakeLists.txt
# mkdir $BUILD_DIR/sonnet_win
# cd $BUILD_DIR/sonnet_win
# cmake ../sonnet \
#     -DCMAKE_TOOLCHAIN_FILE=~/src/mxe/usr/i686-w64-mingw32.shared/share/cmake/mxe-conf.cmake \
#     -DCMAKE_BUILD_TYPE=Release \
#     -DKDE_INSTALL_USE_QT_SYS_PATHS=ON \
#     -DBUILD_TESTING=OFF
#make
#make install

function buildFramework {
    cd $BUILD_DIR
    echo "Compiling KDE framework ($1)"
    #check if folder already exists and pull, if not, clone
    FRAMEWORK_GIT_URL=git://anongit.kde.org/$1.git
    if [ ! -d "$1" ]; then
        echo "Cloning $1 from $FRAMEWORK_GIT_URL"
        git clone $FRAMEWORK_GIT_URL $BUILD_DIR/frameworks/$1
    else
        echo "Pulling $1 from $FRAMEWORK_GIT_URL"
        cd $BUILD_DIR/frameworks/$1
        git pull
    fi

    mkdir -p $BUILD_DIR/frameworks/$1_win
    cd $BUILD_DIR/frameworks/$1_win
    cmake $BUILD_DIR/frameworks/$1 \
        -DCMAKE_TOOLCHAIN_FILE=~/src/mxe/usr/i686-w64-mingw32.shared/share/cmake/mxe-conf.cmake \
        -DCMAKE_BUILD_TYPE=Release \
        -DKDE_INSTALL_USE_QT_SYS_PATHS=ON \
        -DBUILD_TESTING=OFF
    make
    make install
}

buildFramework karchive #Success
buildFramework kconfig #Success
buildFramework kcoreaddons #Success
buildFramework ki18n #Success
buildFramework kdbusaddons #Success
buildFramework kwidgetsaddons #Success
buildFramework kwindowsystem #Success
buildFramework kcrash #Success
buildFramework kservice #Success
buildFramework kguiaddons #Success
buildFramework kcompletion #Success
buildFramework kauth #Success
buildFramework kcodecs #Success
buildFramework kguiaddons #Success
buildFramework kconfigwidgets #Success
buildFramework kitemviews #Success
buildFramework kiconthemes #Success
# buildFramework kdoctools #Failing
# buildFramework kio #Depends on kdoctools
# buildFramework knewstuff #Pending
# buildFramework ktextwidgets
# buildFramework kxmlgui #Pending----
# buildFramework ktextwidgets #Pending
# buildFramework kiconthemes #Pending
# buildFramework knotifications #Pending
# buildFramework knotifyconfig #Pending