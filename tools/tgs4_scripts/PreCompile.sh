#!/bin/bash

# REPO MAINTAINERS: KEEP CHANGES TO THIS IN SYNC WITH /tools/LinuxOneShot/SetupProgram/PreCompile.sh
# No ~mso
set -e
set -x

#load dep exports
#need to switch to game dir for Dockerfile weirdness
original_dir=$PWD
cd "$1"
. dependencies.sh
cd "$original_dir"

#find out what we have (+e is important for this)
set +e
has_git="$(command -v git)"
has_cargo="$(command -v ~/.cargo/bin/cargo)"
has_sudo="$(command -v sudo)"
has_curl="$(command -v curl)"
has_pip3="$(command -v pip3)"
set -e

# apt packages, libssl needed by rust-g but not included in TGS barebones install
if ! ( [ -x "$has_git" ] && [ -x "$has_curl" ] && [ -x "$has_pip3" ] && [ -f "/usr/lib/i386-linux-gnu/libssl.so" ] ); then
	echo "Attempting to install apt dependencies..."
	if ! [ -x "$has_sudo" ]; then
		dpkg --add-architecture i386
		apt-get update
		apt-get install -y lib32z1 git pkg-config libssl-dev:i386 libssl-dev zlib1g-dev:i386 curl libclang-dev g++-multilib python3 python3-pip
	else
		sudo dpkg --add-architecture i386
		sudo apt-get update
		sudo apt-get install -y lib32z1 git pkg-config libssl-dev:i386 libssl-dev zlib1g-dev:i386 curl libclang-dev g++-multilib python3 python3-pip
	fi
fi

# install cargo if needed
if ! [ -x "$has_cargo" ]; then
	echo "Installing rust..."
	curl https://sh.rustup.rs -sSf | sh -s -- -y
	. ~/.profile
fi

# install or update yt-dlp when not present, or if it is present with pip3,
# which we assume was used to install it
if ! [ -x "$has_ytdlp" ]; then
	echo "Installing yt-dlp with pip3..."
	pip3 install yt-dlp --break-system-packages
else
	echo "Ensuring yt-dlp is up-to-date with pip3..."
	pip3 install yt-dlp -U --break-system-packages
fi


# update rust-g
if [ ! -d "rust-g" ]; then
	echo "Cloning rust-g..."
	git clone https://github.com/tgstation/rust-g
	cd rust-g
	~/.cargo/bin/rustup target add i686-unknown-linux-gnu
else
	echo "Fetching rust-g..."
	cd rust-g
	git fetch
	~/.cargo/bin/rustup target add i686-unknown-linux-gnu
fi

echo "Deploying rust-g..."
git checkout "$RUST_G_VERSION"
env PKG_CONFIG_ALLOW_CROSS=1 ~/.cargo/bin/cargo build --release --target=i686-unknown-linux-gnu
mv target/i686-unknown-linux-gnu/release/librust_g.so "$1/librust_g.so"
cd ..

# get dependencies for extools
apt-get install -y cmake build-essential gcc-multilib g++-multilib cmake wget

# update extools
if [ ! -d "extools" ]; then
	echo "Cloning extools..."
	git clone https://github.com/MCHSL/extools
	cd extools/byond-extools
else
	echo "Fetching extools..."
	cd extools/byond-extools
	git fetch
fi

echo "Deploying extools..."
git checkout "$EXTOOLS_VERSION"
if [ -d "build" ]; then
	rm -R build
fi
mkdir build
cd build
cmake ..
make
mv libbyond-extools.so "$1/libbyond-extools.so"
cd ../../..

# compile tgui
echo "Compiling tgui..."
cd "$1"
chmod +x tools/bootstrap/node  # Workaround for https://github.com/tgstation/tgstation-server/issues/1167
env TG_BOOTSTRAP_CACHE="$original_dir" TG_BOOTSTRAP_NODE_LINUX=1 CBT_BUILD_MODE="TGS" tools/bootstrap/node tools/build/build.js
