//
//  AppDelegate.swift
//  VManager
//
//  Created by meris on 2018-07-16.
//  Copyright © 2018 meris. All rights reserved.
//

import Cocoa

enum Action {
    case setTemp(temp: Int)
    case setUnknown
}

struct State {
    let temp: Int?
}

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    let store: Store<State, Action> = Store(
        initialState: State(temp: Optional.none),
            reducer: { (_, action: Action) in
                switch action {
                case Action.setTemp(let temp):
                    return State(temp: temp)
                case Action.setUnknown:
                    return State(temp: Optional.none)
                }

            }
        )
    @IBOutlet weak var statusMenu: NSMenu!
    @IBOutlet weak var actionButton: NSMenuItem!
    let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)

    @IBAction func quitClicked(_ sender: NSMenuItem) {
      NSApplication.shared.terminate(self)
    }

    func applicationDidFinishLaunching(_ aNotification: Notification) {
      statusItem.menu = statusMenu
        self.store.subscribe { (state) in
          DispatchQueue.main.async {
            if let temp = state.temp {
            self.actionButton.title = "strain: \(temp)"
              if (temp > 100) {
                self.statusItem.title = "💥 \(temp)"
              } else if (temp > 80) {
                self.statusItem.title = "🌶 \(temp)"
              } else if (temp > 60) {
                self.statusItem.title = "☀️ \(temp)"
              } else if (temp > 40) {
                self.statusItem.title = "🌤 \(temp)"
              } else {
                self.statusItem.title = "❄️ \(temp)"
              }
            } else {
                self.actionButton.title = "Error :("
                self.statusItem.title = "🐒 ???"
            }
          }
        }
      startTimer()
    }

    func applicationWillTerminate(_ aNotification: Notification) {
      timer?.invalidate()
    }

    func checkTemperature() {
        if let temp = getTemperature() {
            self.store.dispatch(action: Action.setTemp(temp: temp))
        } else {
            self.store.dispatch(action: Action.setUnknown)
        }
    }

    weak var timer: Timer?

    func startTimer() {
      self.checkTemperature()
      timer?.invalidate()

      timer = Timer.scheduledTimer(withTimeInterval: 3.0, repeats: true) { _ in
        self.checkTemperature()
      }
    }
}
