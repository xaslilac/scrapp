#!/bin/sh

set -eu

platforms="Apple Intel"


usage() {
	cat <<-EOF
usage: $0 [-build | -sign | -notarize]

       $0 -build
       $0 -sign
       $0 -notarize

    build:
      create unsigned builds of the app

    sign:
      sign those puppies

    notarize:
      notarize them real good

EOF
}


build() {
	if [ ! -d "Release/" ]; then
		mkdir -p "Release/"
	fi

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
		return 70 #SOFTWARE
		;;
	esac

	printf "\033[1;32m==>\033[0m \033[1m-build $ARCH\033[0m\n"
	if [ ! -d "$APP/Contents/MacOS/" ]; then
		mkdir -p "$APP/Contents/MacOS/"
	fi

	./PkgInfo.swift           "$APP/Contents/PkgInfo"
	cp    ./Info.plist        "$APP/Contents/Info.plist"
	cp -r Resources/          "$APP/Contents/Resources/"
	swiftc ./Program.swift -o "$APP/Contents/MacOS/program" -target $TRIPLE
	(cd "$APP/.."; zip -r "../../Release/Scrapp-$ARCH-Unsigned.zip" Scrapp.app) > /dev/null
}


sign() {
	ARCH="$1"
	UNSIGNED_APP="Build/$ARCH/Scrapp.app"
	SIGNED_APP="Build/${ARCH}Signed/Scrapp.app"

	if [ ! -d "$UNSIGNED_APP" ]; then
		echo "No app to sign"
		echo "Did you forget to build it first?"
		echo
		echo "  $ \033[1;36m$0 -build\033[0m"
		echo
		exit 66 #NOINPUT
	fi

	if [ -z "${SIGNID-}" ]; then
		echo "Signing requires that \$SIGNID is set in your environment"
		echo "You can find the value by running..."
		echo
		echo "  $ \033[1;36msecurity find-identity -p codesigning -v\033[0m"
		echo
		exit 78 #CONFIG
	fi

	rm -rf "$SIGNED_APP"
	mkdir -p "$SIGNED_APP"
	cp -r "$UNSIGNED_APP/" "$SIGNED_APP/"

	printf "\033[1;32m==>\033[0m \033[1m-sign $ARCH\033[0m\n"
	# Sign with the certificate that we installed to our keychain
	codesign --sign "$SIGNID" \
		--timestamp \
		-o runtime \
		--entitlements app.entitlements \
		"$SIGNED_APP"

	# Debugging code signing:
	# codesign -dvv Build/Signed/Scrapp.app/
	# codesign -vvv --deep --strict Build/Signed/Scrapp.app/
	# spctl -vvv --assess --type exec Build/Signed/Scrapp.app/

	# Create a .zip that we can notorize
	(cd "$SIGNED_APP/.."; zip -r "../../Release/Scrapp-$ARCH-Signed.zip" Scrapp.app) > /dev/null
}

notarize() {
	ARCH="$1"
	SIGNED_ZIP="Release/Scrapp-$ARCH-Signed.zip"
	# Requires that you "Login" to notarytool first:
	#   xcrun notarytool store-credentials "NOTARY"

	if [ ! -f "$SIGNED_ZIP" ]; then
		echo "The app must be signed before it can be notarized"
		echo "Did you forget to sign it first?"
		echo
		echo "  $ \033[1;36m$0 -build\033[0m"
		echo "  $ \033[1;36m$0 -sign\033[0m"
		echo
		exit 66 #NOINPUT
	fi

	printf "\033[1;32m==>\033[0m \033[1m-notarize $ARCH\033[0m\n"
	# Notorization!
	xcrun notarytool submit "$SIGNED_ZIP" --wait \
		--keychain-profile "NOTARY"

	# Debugging notarization:
	# xcrun notarytool log $job_id \
	# 	--keychain-profile "NOTARY"

	# ...and staple!
	xcrun stapler staple "Build/${ARCH}Signed/Scrapp.app"
}



if [ "$#" -gt 1 ]; then
	usage
	exit 64 #USAGE
fi


go() {
	TASK="$1"
	for platform in $platforms
	do
		"$TASK" "$platform"
	done
}


case "${1-}" in
	"-h" | "help" | "-help" | "--help")
		usage
		exit 0
	;;
	"clean")
		rm -r Build/
		rm -r Release/
	;;
	"-A" | "-all" | "--all")
		go build
		go sign
		go notarize
	;;
	"" | "-B" | "build" | "--build")
		go build
	;;
	"-Pp" | "--papers-please")
		go sign
		go notarize
	;;
	"-P" | "sign" | "-sign" | "--sign")
		go sign
	;;
	"-p" | "notarize" | "-notarize" | "--notarize")
		go notarize
	;;
	*)
		echo "unrecognized option $1"
		usage
		exit 64 #USAGE
	;;
esac
