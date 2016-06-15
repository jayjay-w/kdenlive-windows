#script to compile kdenlive on windows
#Step 1: Checkout mxe from github, if not already done
if [ ! -d "mxe" ]; then
        echo "Fetching MXE sources"
	mkdir  ./mxe
	cd ./mxe
	git clone https://github.com/mxe/mxe.git
	cd ..
else
    echo "MXE folder already exists. Pulling latest changes."
    cd ./mxe/mxe
    git pull
    cd ../../
fi
#Copy out makefiles to mxe
echo "Copying our makefiles to mxe"
cp ./*.mk ./mxe/mxe/src -f
cd ./mxe/mxe
#Step 2: compile the needed stuff, mlt, frameworks etc
echo "Compiling MLT and its dependencies"
make mlt
#Step 6: clone and compile kdenlive
