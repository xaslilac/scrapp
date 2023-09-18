#!/bin/sh

set -eu

sign() {
	ARCH="$1"
	UNSIGNED_APP="Build/$ARCH/Scrapp.app"
	SIGNED_APP="Build/${ARCH}Signed/Scrapp.app"

	rm -rf "$SIGNED_APP"
	mkdir -p "$SIGNED_APP"
	cp -r "$UNSIGNED_APP/" "$SIGNED_APP/"

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
	(cd "$SIGNED_APP/.."; zip -r "../../Release/Scrapp-$ARCH-Signed.zip" Scrapp.app)
}

notarize() {
	ARCH="$1"
	# Requires that you "Login" to notarytool first:
	#   xcrun notarytool store-credentials "NOTARY"

	# Notorization!
	xcrun notarytool submit "Release/Scrapp-$ARCH-Signed.zip" --wait \
		--keychain-profile "NOTARY"

	# Debugging notarization:
	# xcrun notarytool log $job_id \
	# 	--keychain-profile "NOTARY"

	# ...and staple!
	xcrun stapler staple "Build/${ARCH}Signed/Scrapp.app"
}

# Sign both first
sign "Apple" # Apple Silicon
sign "Intel" # Intel

# Notarize together
notarize "Apple" # Apple Silicon
notarize "Intel" # Intel
