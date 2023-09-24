To start creating our app, we'll create a folder with a name that ends in ".app"

The simplest possible macOS application consists of 3 files:

- Contents/PkgInfo
- Contents/Info.plist
- Contents/MacOS/program

These are the files we'll be adding to our .app folder, which I'll refer to as Scrapp.app. You can name it whatever!

## PkgInfo

The presence of this file tells macOS that Scrapp.app is in fact an application, and not just a folder with a silly name.

- It must always contain the eight bytes `41 50 50 4c 3f 3f 3f 3f`
- The first four bytes are "APPL" in ASCII, the rest is just "proof of knowledge"

You'll need a tool capable of editing files using binary or hex to create this, or you can just write a script that does it. The [PkgInfo.swift](../PkgInfo.swift) file in this repo is a script I wrote to create this file.

## Info.plist

This is an XML file that describes our application to macOS. It contains stuff like the name of our application!

```xml
<key>CFBundleName</key>
  <string>Scrapp</string>
```

It also contains the name of our icon file, an ID that is unique to our app, and a short description that can be displayed to anyone who installs it.

```xml
<key>CFBundleIconFile</key>
  <string>Scr.icns</string>
<key>CFBundleIdentifier</key>
  <string>dev.mckayla.scr</string>
<key>CFBundleGetInfoString</key>
  <string>1.0.0.0 © 2023 McKayla Washburn</string>
```

You can look at [Info.plist](../Info.plist) in this repo for a full example.

## MacOS/program

This is our actual application; our executable which macOS will run when opening the app!

- This file needs to have [execution permission](https://superuser.com/questions/117704/what-does-the-execute-permission-do)

  - You don't really need to worry about this. Your compiler should do this for you!

- The file doesn't need to be named program, but it does need to be in the MacOS/ folder.
  - The important thing is that the name matches the value of `CFBundleExecutable` in the Info.plist file.
    ```xml
    <key>CFBundleExecutable</key>
    	<string>program</string>
    ```

---

As a bonus, we'll talk about one more thing.

## Resources/

Another common thing you'll see in macOS applications is a folder called "Resources". While not strictly necessary, you will need it if you want to have an icon for your app.

To add an icon to the app, we can place our [Scr.icns](../Resources/Scr.icns) into the Resources/ folder, and tell macOS where to look in our Info.plist file.

```xml
<key>CFBundleIconFile</key>
  <string>Scr.icns</string>
```

Now, we should have an app structure that looks like this:

```
└── Contents
    ├── Info.plist
    ├── MacOS
    │   └── program
    ├── PkgInfo
    └── Resources
        └── Scr.icns
```

...and we should be able to double-click our app in Finder to launch it!
