//
//  Listeners.swift
//  AQUA
//
//  Created by Eden on 2024/9/23.
//

import AppKit

func addNotifyProc() {
    let error = CGSRegisterNotifyProc(unresponsiveAppNotifyProc, kCGSEventNotificationAppIsUnresponsive, nil)
    if error != .success {
        print("Add unresponsive app notify proc failed: \(error)")
    }
}

func unresponsiveAppNotifyProc(type: CGSEventType, data: UnsafeMutableRawPointer?, dataLength: UInt32, userData: UnsafeMutableRawPointer?) {
    guard let data,
          type == kCGSEventNotificationAppIsUnresponsive,
          dataLength >= MemoryLayout<CGSProcessNotificationData>.size
    else {
        return
    }

    let noteData = data.assumingMemoryBound(to: CGSProcessNotificationData.self).pointee
    guard let unresponsiveProcess = NSRunningApplication(processIdentifier: noteData.pid) else {
        return
    }

    print("Force quit unresponsive app: \(unresponsiveProcess.localizedName ?? "Unknown")")
    if !unresponsiveProcess.forceTerminate() {
        print("Force quit failed.")
    }
}
