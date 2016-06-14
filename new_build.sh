#Grab shotcut binaries
cd $HOME

if [ ! -f gtk+-bundle_2.24.10-20120208_win32.zip ]; then
	wget https://s3.amazonaws.com/misc.meltymedia/shotcut-build/gtk%2B-bundle_2.24.10-20120208_win32.zip
else
   echo "gtk+-bundle_2.24.10-20120208_win32.zip already exists."
fi

if [ ! -f ladspa_plugins-win-0.4.15.tar.bz2 ]; then
	wget https://s3.amazonaws.com/misc.meltymedia/shotcut-build/ladspa_plugins-win-0.4.15.tar.bz2
else
   echo "ladspa_plugins-win-0.4.15.tar.bz2 already exists"
fi

if [ ! -f mlt-prebuilt-mingw32.tar.bz2 ]; then
	wget https://s3.amazonaws.com/misc.meltymedia/shotcut-build/mlt-prebuilt-mingw32.tar.bz2
else  
  echo  "mlt-prebuilt-mingw32.tar.bz2 already exists"
fi

if [ ! -f qt-5.2.0-mingw48_32.tar.bz2 ]; then
	wget https://s3.amazonaws.com/misc.meltymedia/shotcut-build/qt-5.2.0-mingw48_32.tar.bz2
else
  echo  "qt-5.2.0-mingw48_32.tar.bz2 already exists"
fi

if [ ! -f qt-5.2.0-gcc.tar.bz2 ]; then
	wget https://s3.amazonaws.com/misc.meltymedia/shotcut-build/qt-5.2.0-gcc.tar.bz2
else
    echo "qt-5.2.0-gcc.tar.bz2 already exists"
fi

echo "Exctracting Qt files..."
rm -rf Qt
tar -xjf qt-5.2.0-mingw48_32.tar.bz2

tar -xjf qt-5.2.0-gcc.tar.bz2

printf "[Paths]\nPrefix=$HOME/Qt/5.2.0/gcc\n" >Qt/5.2.0/gcc/bin/qt.conf

##Extract and compile MXE
#mkdir -p /opt
#cd /opt
#git clone -b stable https://github.com/mxe/mxe.git
#make MXE_TARGETS=i686-w64-migw32 winpthreads
#make MXE_TARGETS=1686-w64-ming32 gcc

##The above mxe commands have been complied and archived, so we can just grab the files
if [ ! -f mxe-gcc-4.8.1.tar.bz2 ]; then
    wget https://s3.amazonaws.com/misc.meltymedia/shotcut-build/mxe-gcc-4.8.1.tar.bz2
else
    "mxe-gcc-4.8.1.tar.bz2 already exists"
fi

## The same for x64
if [ ! -f mxe-gcc-4.8.2-x64.tar.bz2 ]; then
    wget https://s3.amazonaws.com/misc.meltymedia/shotcut-build/mxe-gcc-4.8.2-x64.tar.bz2
else
    "mxe-gcc-4.8.2-x64.tar.bz2 already exists"
fi


