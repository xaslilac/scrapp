#!/bin/sh

APP="Build/Unsigned/Scrapp.app"

if [ ! -d "$APP/Contents/MacOS/" ]; then
	mkdir -p "$APP/Contents/MacOS/"
fi

./PkgInfo.swift           "$APP/Contents/PkgInfo"
cp ./Info.plist           "$APP/Contents/Info.plist"
swiftc ./Program.swift -o "$APP/Contents/MacOS/program"
