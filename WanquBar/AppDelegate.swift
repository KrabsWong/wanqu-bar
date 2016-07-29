//
//  AppDelegate.swift
//  WanquBar
//
//  Created by Pang.Xie on 16/7/28.
//  Copyright © 2016年 Pang.Xie. All rights reserved.
//

import Cocoa
import Alamofire

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet weak var wanquMenu: NSMenu!
    @IBOutlet weak var wanquPopover: NSPopover!
    
    let wanquItem = NSStatusBar.systemStatusBar().statusItemWithLength(NSVariableStatusItemLength)
    
    func applicationDidFinishLaunching(aNotification: NSNotification) {
        // Insert code here to initialize your application
        if let button = wanquItem.button {
            let icon = NSImage(named: "wanquIcon")
            icon?.template = true;
            button.image = icon
            button.action = #selector(AppDelegate.togglePopover(_:))
        }
        
        wanquPopover.contentViewController = WanquViewController(nibName: "WanquViewController", bundle: nil)
    }

    func applicationWillTerminate(aNotification: NSNotification) {
        // Insert code here to tear down your application
    }
    
    func showPopover(sender: AnyObject?) {
        if let button = wanquItem.button {
            wanquPopover.showRelativeToRect(button.bounds, ofView: button, preferredEdge: NSRectEdge.MinY)
            Alamofire.request(.POST, "http://bigyoo.me/ns/cmd", parameters: ["type": "wanqu", "action": "getLatest"]).responseJSON {
                response in debugPrint(response)
            }
        }
    }
    
    func closePopover(sender: AnyObject?) {
        wanquPopover.performClose(sender)
    }
    
    func togglePopover(sender: AnyObject?) {
        if wanquPopover.shown {
            closePopover(sender)
        } else {
            showPopover(sender)
        }
    }

}

