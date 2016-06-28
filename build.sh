#script to compile kdenlive on windows
#setup the build dirs
#SOURCE_DIR is the location where our custon *.mk files are stored
#BUILD_DIR is the location where all the built files will be stored
#MXE_DIR is the location where mxe resides. 
SOURCE_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
echo "Source path is $SOURCE_DIR" 
BUILD_DIR=~/src/kdenlive-win
MXE_DIR=$SOURCE_DIR/mxe/mxe
REBUILD_FRAMEWORKS=OFF
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
cp $SOURCE_DIR/mxe_settings ./settings.mk

make gcc
make libxml2 libxslt qtwinextras nsis mlt
exit
MXE_INSTALL_PATH=$MXE_DIR/usr/i686-w64-mingw32.shared
IS_ON="ON"
if [ $REBUILD_FRAMEWORKS = $IS_ON ]; then
#make docbook-xml
echo "Building docbook xml"
mkdir -p $BUILD_DIR/docbook-xml
cd $BUILD_DIR/docbook-xml
if [ ! -f 'docbook-xml-4.5.zip' ]; then
	wget http://www.docbook.org/xml/4.5/docbook-xml-4.5.zip
fi
unzip -o docbook-xml-4.5.zip
install -v -d -m755 $MXE_INSTALL_PATH/share/xml/docbook/xml-dtd-4.5  &&
install -v -d -m755 $MXE_INSTALL_PATH/etc/xml &&
cp -v -af docbook.cat *.dtd ent/* *.mod \
  $MXE_INSTALL_PATH/share/xml/docbook/xml-dtd-4.5
  
echo "Docbook xml build completed"
#end docbook xml

#build docbook-xsl
echo "Building docbook xsl"
mkdir -p $BUILD_DIR/docbook-xsl
cd $BUILD_DIR/docbook-xsl
DOCBOOK_XSL_VERSION=1.79.1
if [ ! -f 'docbook-xsl-1.79.1.tar.bz2' ]; then
	wget http://downloads.sourceforge.net/docbook/docbook-xsl-1.79.1.tar.bz2
fi

tar -xf docbook-xsl-1.79.1.tar.bz2 --strip-components=1

install -v m755 -d $MXE_INSTALL_PATH/share/xml/docbook/xsl-stylesheets

cp -v -R VERSION assembly common eclipse epub epub3 extensions fo \
	highlighting html htmlhelp images javahelp lib manpages params \
	profiling roundtrip slides template tests tools webhelp website \
	xhtml xhtml-1_1 xhtml5 $MXE_INSTALL_PATH/share/xml/docbook/xsl-stylesheets

ln -sf VERSION $MXE_INSTALL_PATH/share/xml/docbook/xsl-stylesheets/VERSION.xsl

echo "Finished building docbook xsl"
#end docbook xsl
#Step 6: clone and compile kde frameworks
#Build Phonon4Qt5
cd $BUILD_DIR
if [ ! -d phonon ]; then
    mkdir -p phonon
    cd $BUILD_DIR/phonon
    git clone https://github.com/KDE/phonon
else
    cd $BUILD_DIR/phonon
    git pull
fi
mkdir build
cd build
$MXE_DIR/usr/bin/i686-w64-mingw32.shared-cmake ../phonon -DPHONON_BUILD_PHONON4QT5=ON -DPHONON_INSTALL_QT_EXTENSIONS_INTO_SYSTEM_QT=ON -DCMAKE_PREFIX_PATH=$MXE_DIR/usr/i686-w64-mingw32.shared/qt5
make 
make install

FRAMEWORK_VER_MAJOR=5.23
FRAMEWORK_VER_MINOR=0
mkdir $BUILD_DIR/frameworks -p
function buildFramework {
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
}

 buildFramework extra-cmake-modules
 buildFramework sonnet 
 buildFramework karchive 
 buildFramework kconfig 
 buildFramework kcoreaddons 
 buildFramework ki18n 
 buildFramework kdbusaddons 
 buildFramework kwidgetsaddons 
 buildFramework kwindowsystem 
 buildFramework kcrash 
 buildFramework kservice 
 buildFramework kguiaddons 
 buildFramework kcompletion 
 buildFramework kauth 
 buildFramework kcodecs 
 buildFramework kguiaddons 
 buildFramework kconfigwidgets 
 buildFramework kitemviews 
 buildFramework kiconthemes 
 buildFramework ktextwidgets 
 buildFramework attica 
 buildFramework kglobalaccel 
 buildFramework kxmlgui 
buildFramework kdoctools 
 buildFramework solid 
 buildFramework kbookmarks 
 buildFramework kjobwidgets 
 buildFramework kio 
 buildFramework knewstuff 
 buildFramework kfilemetadata
 buildFramework kplotting
 buildFramework knotifyconfig
buildFramework knotifications
fi
#Build kdenlive
cd $BUILD_DIR
if [ ! -d "kdenlive" ]; then
    git clone git://anongit.kde.org/kdenlive $BUILD_DIR/kdenlive
else
    cd $BUILD_DIR/kdenlive
    git pull
fi

cd $BUILD_DIR
if [ ! -d "kdenlive-build" ]; then
    mkdir $BUILD_DIR/kdenlive-build
fi

cd $BUILD_DIR/kdenlive-build

cmake $BUILD_DIR/kdenlive \
        -DCMAKE_TOOLCHAIN_FILE=$MXE_DIR/usr/i686-w64-mingw32.shared/share/cmake/mxe-conf.cmake \
        -DCMAKE_BUILD_TYPE=Release \
        -DKDE_INSTALL_USE_QT_SYS_PATHS=ON \
        -DBUILD_TESTING=OFF \
        -DMLTPP_LIBRARIES=$MXE_DIR/usr/i686-w64-mingw32.shared/lib \
        -DMLT_LIBRARIES=$MXE_DIR/usr/i686-w64-mingw32.shared/lib
    make
