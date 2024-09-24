//
//  AppDelegate.swift
//  AQUA
//
//  Created by Eden on 2024/9/23.
//

import AppKit

class AppDelegate: NSObject, NSApplicationDelegate {
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        Listeners.addNotifyProc()
        MenuBar.shared.setUpMenuBarItem()
    }
}
