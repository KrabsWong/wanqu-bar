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
                var displayTitle = "\(subJson["title"])";
                let charCount = displayTitle.characters.count
                
                if charCount > 20 {
                    let endRange = displayTitle.endIndex.advancedBy(-(charCount - 20))
                    displayTitle = "\(displayTitle.substringToIndex(endRange))..."
                }

                let subItem = NSMenuItem(title: displayTitle, action: #selector(AppDelegate.openWanquURL(_:)), keyEquivalent: "")
                subItem.representedObject = "\(subJson["link"])"
                subItem.toolTip = "[\(subJson["title"])] - \(subJson["summary"])"
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

