#script to compile kdenlive on windows
#setup the build dirs
#SOURCE_DIR is the location where our custon *.mk files are stored
#BUILD_DIR is the location where all the built files will be stored
#MXE_DIR is the location where mxe resides. 
SOURCE_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
echo "Source path is $SOURCE_DIR" 
BUILD_DIR=~/src/kdenlinve-win
MXE_DIR=$SOURCE_DIR/mxe/mxe

#Step 1: Checkout mxe from github, if not already done
if [ ! -d "$MXE_DIR" ]; then
        echo "Fetching MXE sources"
	git clone https://github.com/mxe/mxe.git $MXE_DIR
	cd ..
else
    echo "MXE folder already exists. Pulling latest changes."
    cd $MXE_DIR
    #git pull #we can enable pulling later, right not it causes many packages to rebuild if they have been changed upstream
    #Apply our patch to index.html
fi
cd $MXE_DIR
#Apply our MXE patches
cp $SOURCE_DIR/*.patch . -f
git am *.patch
#Copy our custom .mk files
cp $SOURCE_DIR/*.mk ./src/ -f
#Step 2: compile the needed MLT framework
echo "Compiling MLT and its dependencies using MXE"

#Copy our MXE settings file to enable shared builds
mv $SOURCE_DIR/mxe_settings ./settings.mk

make libxml2 libxslt qt5 qtwinextras nsis mlt
#Step 6: clone and compile kde frameworks
FRAMEWORK_VER_MAJOR=5.23
FRAMEWORK_VER_MINOR=0
mkdir $BUILD_DIR/frameworks -p
function buildFramework {
    cd $BUILD_DIR/frameworks
    echo "Compiling KDE framework ($1)"
    #Download the code
    TAR_FILE_NAME=$1-$FRAMEWORK_VER_MAJOR.$FRAMEWORK_VER_MINOR.tar.xz
    rm $TAR_FILE_NAME
    if [ ! -f $TAR_FILE_NAME ]; then
        wget http://download.kde.org/stable/frameworks/$FRAMEWORK_VER_MAJOR/$TAR_FILE_NAME
    fi
    rm $1-$FRAMEWORK_VER_MAJOR.$FRAMEWORK_VER_MINOR -rf
    tar xvf $TAR_FILE_NAME
    mkdir -p $BUILD_DIR/frameworks/$1-$FRAMEWORK_VER_MAJOR.$FRAMEWORK_VER_MINOR-build
    cd $BUILD_DIR/frameworks/$1-$FRAMEWORK_VER_MAJOR.$FRAMEWORK_VER_MINOR-build
    $MXE_DIR/usr/bin/i686-w64-mingw32.shared-cmake $BUILD_DIR/frameworks/$1-$FRAMEWORK_VER_MAJOR.$FRAMEWORK_VER_MINOR \
        -DCMAKE_BUILD_TYPE=Release \
        -DKDE_INSTALL_USE_QT_SYS_PATHS=ON \
        -DBUILD_TESTING=OFF
    make
    make install
}


# buildFramework sonnet #Success
# buildFramework karchive #Success
# buildFramework kconfig #Success
# buildFramework kcoreaddons #Success
# buildFramework ki18n #Success
# buildFramework kdbusaddons #Success
# buildFramework kwidgetsaddons #Success
# buildFramework kwindowsystem #Success
# buildFramework kcrash #Success
# buildFramework kservice #Success
# buildFramework kguiaddons #Success
# buildFramework kcompletion #Success
# buildFramework kauth #Success
# buildFramework kcodecs #Success
# buildFramework kguiaddons #Success
# buildFramework kconfigwidgets #Success
# buildFramework kitemviews #Success
# buildFramework kiconthemes #Success
# buildFramework ktextwidgets #Success
# buildFramework attica #Success
# buildFramework kglobalaccel #Success
# buildFramework kxmlgui #Success
# buildFramework kdoctools #Failing
# buildFramework kio #Depends on kdoctools
# buildFramework knewstuff #Pending
# buildFramework knotifications #Pending
# buildFramework knotifyconfig #Pending
