#!/bin/false

# Not actually intended to be run directly!
# Use this flow as a reference for code-signing and notarization!

rm -rf Build/Signed/

mkdir Build/Signed/
cp -r Build/Unsigned/Scrapp.app Build/Signed/

# Sign with the certificate that we installed to our keychain
codesign --sign $SIGNID \
	--timestamp \
	-o runtime \
	--entitlements app.entitlements \
	Build/Signed/Scrapp.app/

# Debugging code signing:
# codesign -dvv Build/Signed/Scrapp.app/
# codesign -vvv --deep --strict Build/Signed/Scrapp.app/
# spctl -vvv --assess --type exec Build/Signed/Scrapp.app/

# Create a .zip that we can notorize
(cd Build/Signed/; zip -r ../../Scrapp.zip Scrapp.app)

# "Login" to notarytool first:
#   xcrun notarytool store-credentials "NOTARY"

# Notorization!
xcrun notarytool submit Scrapp.zip --wait \
	--keychain-profile "NOTARY"

# Debugging notarization:
# xcrun notarytool log $job_id \
# 	--keychain-profile "NOTARY"

xcrun stapler staple Build/Signed/Scrapp.app/
