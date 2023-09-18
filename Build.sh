#!/bin/sh

set -eu

if [ ! -d "Release/" ]; then
	mkdir -p "Release/"
fi

build() {
	ARCH="$1"
	APP="Build/$ARCH/Scrapp.app"

	case "$1" in
	Intel)
		TRIPLE="x86_64-apple-macos13"
		;;
	Apple)
		TRIPLE="aarch64-apple-macos13"
		;;
	*)
		echo "Invalid architecture $ARCH"
		return 64
		;;
	esac

	printf "\033[1;32m==>\033[0m \033[1m$TRIPLE\033[0m\n"
	if [ ! -d "$APP/Contents/MacOS/" ]; then
		mkdir -p "$APP/Contents/MacOS/"
	fi

	./PkgInfo.swift           "$APP/Contents/PkgInfo"
	cp ./Info.plist           "$APP/Contents/Info.plist"
	swiftc ./Program.swift -o "$APP/Contents/MacOS/program" -target $TRIPLE
	(cd "$APP/.."; zip -r "../../Release/Scrapp-$ARCH-Unsigned.zip" Scrapp.app)
}

build "Apple" # Apple Silicon
build "Intel" # Intel
