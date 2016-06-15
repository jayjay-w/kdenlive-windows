#script to compile kdenlive on windows
#Step 1: Checkout mxe from github, if not already done
if [ ! -d "mxe" ]; then
	mkdir  ./mxe
	cd ./mxe
	git clone https://github.com/mxe/mxe.git
	cd ..
fi
cd ./mxe
git remote remove vpinon
git remote add vpinon git@git.kde.org:scratch/vpinon/kdenlive-windows
git fetch vpinon
git merge vpinon/kdenlive
#Step 2: compile the needed stuff, mlt, frameworks etc
make mlt
#Step 6: clone and compile kdenlive
