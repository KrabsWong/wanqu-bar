//
//  AppDelegate.swift
//  WanquBar
//
//  Created by Pang.Xie on 16/7/28.
//  Copyright © 2016年 Pang.Xie. All rights reserved.
//

import Cocoa
import Alamofire
import SwiftyJSON

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet weak var wanquMenu: NSMenu!
    
    let wanquItem = NSStatusBar.systemStatusBar().statusItemWithLength(NSVariableStatusItemLength)
    
    func applicationDidFinishLaunching(aNotification: NSNotification) {
        // Insert code here to initialize your application
        
        if let button = wanquItem.button {
            let icon = NSImage(named: "wanquIcon")
            icon?.template = true;
            button.image = icon
        }
        
        Alamofire.request(.POST, "http://bigyoo.me/ns/cmd", parameters: ["type": "wanqu", "action": "getLatest"]).responseJSON {
            response in
            
            let json = JSON(response.result.value!)
            
            let titleItem = NSMenuItem(title: "\(json["data"]["title"])", action: nil, keyEquivalent: "")
            self.wanquMenu.addItem(titleItem)
            self.wanquMenu.addItem(NSMenuItem.separatorItem())
            
            for(_, subJson):(String, JSON) in json["data"]["list"] {
                print(subJson)
                let subItem = NSMenuItem(title: "\(subJson["title"])", action: #selector(AppDelegate.openWanquURL(_:)), keyEquivalent: "")
                subItem.representedObject = "\(subJson["link"])"
                self.wanquMenu.addItem(subItem)
            }
            self.wanquItem.menu = self.wanquMenu
        }
    }
    
    func openWanquURL(sender: AnyObject?) {
        if let url = sender?.representedObject! {
            if let targetURL = NSURL(string: "\(url)") {
                NSWorkspace.sharedWorkspace().openURL(targetURL)
            }
        }
    }
    
    func requestWanquArticles(sender: AnyObject?) {
        NSLog("test")
        Alamofire.request(.POST, "http://bigyoo.me/ns/cmd", parameters: ["type": "wanqu", "action": "getLatest"]).responseJSON {
            response in
            
            let json = JSON(response.result.value!)
            print(json["data"]["title"])
        }
    }
    
    func applicationWillTerminate(aNotification: NSNotification) {
        // Insert code here to tear down your application
    }
    

}

