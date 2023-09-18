#!/usr/bin/env swift
//! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! !
//! Run as a script to generate the PkgInfo file macOS relies on to recognize !
//! our app as an actual app, rather than just a directory.                   !
//! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! !

import Foundation


if CommandLine.arguments.count < 2 {
	print("usage: \(CommandLine.arguments[0]) file")
	print("       \(CommandLine.arguments[0]) Build/Intel/Scrapp.app/Contents/PkgInfo")
	exit(64)
}

let path = CommandLine.arguments[1]
let data = Data([0x41, 0x50, 0x50, 0x4c, 0x3f, 0x3f, 0x3f, 0x3f])
try data.write(to: URL(fileURLWithPath: path))
