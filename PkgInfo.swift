#!/usr/bin/env swift
//! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! !
//! Run as a script to generate the PkgInfo file macOS relies on to recognize !
//! our app as an actual app, rather than just a directory.                   !
//! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! !

import Foundation


let data = Data([0x41, 0x50, 0x50, 0x4c, 0x3f, 0x3f, 0x3f, 0x3f])
try data.write(to: URL(fileURLWithPath: "Build/Unsigned/Scrapp.app/Contents/PkgInfo"))
