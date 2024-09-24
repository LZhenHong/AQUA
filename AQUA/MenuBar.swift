//
//  MenuBar.swift
//  AQUA
//
//  Created by Eden on 2024/9/24.
//

import AppKit
import Combine

class MenuBar {
    static let shared = MenuBar()

    private(set) var statusItem: NSStatusItem!
    private var cancel: AnyCancellable?

    private init() {}

    func setUpMenuBarItem() {
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem
            .variableLength)
        guard let btn = statusItem.button else {
            return
        }

        statusItem.isVisible = true
        statusItem.behavior = .terminationOnRemoval
        statusItem.menu = createMenu()

        btn.image = NSImage(systemSymbolName: "sos.circle.fill", accessibilityDescription: "AQUA")
        btn.image?.size = NSSize(width: 18, height: 18)
        btn.image?.isTemplate = true
    }

    private func createMenu() -> NSMenu {
        let menu = NSMenu()
        menu.autoenablesItems = false

        let launchItem = NSMenuItem(title: String(localized: "Launch at Login"), action: #selector(launchAtLogin), keyEquivalent: "")
        menu.addItem(launchItem)
        cancel = LaunchAtLogin.enabledPulisher.sink { enabled in
            launchItem.state = enabled ? .on : .off
        }

        menu.addItem(NSMenuItem.separator())

        let quitItem = NSMenuItem(title: String(localized: "Quit"), action: #selector(terminate), keyEquivalent: "q")
        menu.addItem(quitItem)

        return menu
    }

    @objc private func launchAtLogin() {
        LaunchAtLogin.toggle()
    }

    @objc private func terminate() {
        NSApp.terminate(self)
    }
}
