<h1 align="center">Scr.app</h1>

<p align="center"><img height=175 src="https://cdn.mckayla.cloud/-/k4h3aeh5ua11v1/Scr.png" /></p>

Absolute bare minimum macOS application, that you can generate yourself, from scratch. No Xcode required.

<!-- prettier-ignore -->
> [!IMPORTANT]
> While I say "No Xcode required", you do need to have it _installed_ if you want to be able to notarize. You just don't need to open it, and you don't need an Xcode project.

Go from nothing to...

- A runnable macOS .app bundle

- A code-signed macOS .app bundle

- A notarized .zip file

## Building

### Creating the .app bundle

You should just need to run the included Build.sh script!

```sh
./Build.sh
```

This will...

- Generate the PkgInfo file used by macOS to identify the bundle folder as an application

  - Every macOS app contains this 8 byte marker file

- Copy the Info.plist metadata file into the bundle

- Build the actual executable, and place it in the bundle

### Code signing

- https://developer.apple.com/account/resources/certificates/list

- Get a "Developer ID Application" certificate

  - Open Keychain Access -> Certificate Assistant -> Request a Certificate From a Certificate Authority...

  - Make sure you don't have a secret key selected 🙃

- Install the provided certificate to your system keychain

  - Make sure you have the certificate for the issuer installed as well: https://www.apple.com/certificateauthority/ (ie. Developer ID - G2)

  - You shouldn't need to fiddle with the trust settings. If you manually trust it, it still won't work. It needs to have a trusted certificate for the issuer.

  - You _might_ be able to get away with just using `--force`, but I haven't tested that

- ```sh
  security find-identity -p codesigning -v
  ```

  - Copy the ID given for your "Developer ID Application: <name> <account id>" certificate

  - Set and export SIGNID env variable

- Look up your "Team ID" https://developer.apple.com/account#MembershipDetailsCard

- Get an API key from https://appstoreconnect.apple.com/access/api

  - ```sh
    xcrun notarytool store-credentials "NOTARY"
    ```

- You should now be able to run Build.sh to sign and notarize everything

```sh
./Build.sh --papers-please
```
