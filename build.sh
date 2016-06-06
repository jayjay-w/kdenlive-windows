#script to compile kdenlive on windows
#Step 1: Checkout mxe from github, if not already done
if [ ! -d "mxe"]
	mkdir  ./mxe
	cd ./mxe
	git clone https://github.com/mxe/mxe.git
	cd ..
fi
cd ./mxe/mxe
#Step 2: compile the needed stuff
make gcc
#Step 3: compile mlt dependencies
#3.a - Copy our custom mk files
cp ../*.mk ./src
make libxml2
make ffmpeg
make fftw
make frei0r #??
make ladspa #??
make cairo2
#Step 4: compile MLT
make mlt #??
#Step 5: compile Qt
make qt
#Step 6: clone and compile kdenlive
