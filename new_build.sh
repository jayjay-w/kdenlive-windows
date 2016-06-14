#Grab shotcut binaries
cd $HOME

if [ ! -f gtk+-bundle_2.24.10-20120208_win32.zip ] then
	wget https://s3.amazonaws.com/misc.meltymedia/shotcut-build/gtk%2B-bundle_2.24.10-20120208_win32.zip
fi

if [ ! -f ladspa_plugins-win-0.4.15.tar.bz2 ] then
	wget https://s3.amazonaws.com/misc.meltymedia/shotcut-build/ladspa_plugins-win-0.4.15.tar.bz2
fi

if [ ! -f mlt-prebuilt-mingw32.tar.bz2 ] then
	wget https://s3.amazonaws.com/misc.meltymedia/shotcut-build/mlt-prebuilt-mingw32.tar.bz2
fi

if [ ! -f qt-5.2.0-mingw48_32.tar.bz2 ] then
	wget https://s3.amazonaws.com/misc.meltymedia/shotcut-build/qt-5.2.0-mingw48_32.tar.bz2
fi

if [ ! -f shotcut-build/qt-5.2.0-gcc.tar.bz2 ]
	wget https://s3.amazonaws.com/misc.meltymedia/shotcut-build/qt-5.2.0-gcc.tar.bz2
fi

tar -xjf qt-5.2.0-mingw48_32.tar.bz2

tar -xjf qt-5.2.0-gcc.tar.bz2

printf "[Paths]\nPrefix=$HOME/Qt/5.2.0/gcc\n" >Qt/5.2.0/gcc/bin/qt.conf

