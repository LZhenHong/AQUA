//
//  Listeners.swift
//  AQUA
//
//  Created by Eden on 2024/9/23.
//

import AppKit
import Combine

enum Listeners {
    static let listenedPublisher = CurrentValueSubject<Bool, Never>(false)

    static func addNotifyProc() {
        let error = CGSRegisterNotifyProc(unresponsiveAppNotifyProc, kCGSEventNotificationAppIsUnresponsive, nil)
        guard error == .success else {
            print("Add unresponsive app notify proc failed: \(error)")
            return
        }
        listenedPublisher.send(true)
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
