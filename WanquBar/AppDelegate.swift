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
import PromiseKit

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
        
        when(getLatestArticles(), getRandomArticle()).then {latestArticles, randomArticle -> Void in
            let latestArticlesJSON = JSON(latestArticles)
            let randomArticleJSON = JSON(randomArticle)
            
            // 生成最新一期的文章item列表
            let titleItem = NSMenuItem(title: "最新(\(latestArticlesJSON["data"]["title"]))", action: nil, keyEquivalent: "")
            self.wanquMenu.addItem(titleItem)
            self.wanquMenu.addItem(NSMenuItem.separatorItem())

            
            for(_, subJson):(String, JSON) in latestArticlesJSON["data"]["list"] {
                var displayTitle = "\(subJson["title"])";
                let charCount = displayTitle.characters.count
                
                if charCount > 20 {
                    let endRange = displayTitle.endIndex.advancedBy(-(charCount - 20))
                    displayTitle = "\(displayTitle.substringToIndex(endRange))..."
                }
                
                let subItem = NSMenuItem(title: displayTitle, action: #selector(AppDelegate.openWanquURL(_:)), keyEquivalent: "")
                subItem.representedObject = "\(subJson["link"])"
                subItem.indentationLevel = 1
                subItem.toolTip = "[\(subJson["title"])] - \(subJson["summary"])"
                self.wanquMenu.addItem(subItem)
            }
            
            // 生成随机文章的item
            self.wanquMenu.addItem(NSMenuItem.separatorItem())
            let randomTitleItem = NSMenuItem(title: "随机(\(randomArticleJSON["data"]["title"]))", action: nil, keyEquivalent: "")
            self.wanquMenu.addItem(randomTitleItem)
            self.wanquMenu.addItem(NSMenuItem.separatorItem())
            for(_, subJson):(String, JSON) in randomArticleJSON["data"]["list"] {
                var displayTitle = "\(subJson["title"])";
                let charCount = displayTitle.characters.count
                
                if charCount > 20 {
                    let endRange = displayTitle.endIndex.advancedBy(-(charCount - 20))
                    displayTitle = "\(displayTitle.substringToIndex(endRange))..."
                }
                
                let subItem = NSMenuItem(title: displayTitle, action: #selector(AppDelegate.openWanquURL(_:)), keyEquivalent: "")
                subItem.representedObject = "\(subJson["link"])"
                subItem.indentationLevel = 1
                subItem.toolTip = "[\(subJson["title"])] - \(subJson["summary"])"
                self.wanquMenu.addItem(subItem)
            }
            
            // 添加退出功能
            self.wanquMenu.addItem(NSMenuItem.separatorItem())
            let githubItem = NSMenuItem(title: "Github仓库地址", action: #selector(AppDelegate.openWanquURL(_:)), keyEquivalent: "")
            githubItem.representedObject = "https://github.com/yPangXie/wanqu-bar"
            self.wanquMenu.addItem(githubItem)
            self.wanquMenu.addItem(NSMenuItem(title: "退出", action: #selector(AppDelegate.quit(_:)), keyEquivalent: "Q"))
            self.wanquItem.menu = self.wanquMenu

        }
    }
    
    // 获取最新文章
    func getLatestArticles() -> Promise<AnyObject> {
        return Promise { fulfill, reject in
            // alamofire code that calls either fill or reject
            Alamofire.request(.POST, "http://bigyoo.me/ns/cmd", parameters: ["type": "wanqu", "action": "getLatest"]).responseJSON {
                response in
                
                switch response.result {
                case .Success:
                    fulfill(response.result.value!)
                case .Failure(let error):
                    reject(error)
                }
                
            }
        }
    }
    
    // 随机获取一篇文章
    func getRandomArticle() -> Promise<AnyObject> {
        return Promise { fulfill, reject in
            Alamofire.request(.POST, "http://bigyoo.me/ns/cmd", parameters: ["type": "wanqu", "action": "getRandom", "count": 1]).responseJSON {
                response in
                
                switch response.result {
                case .Success:
                    fulfill(response.result.value!)
                case .Failure(let error):
                    reject(error)
                }
            }
        }
    }
    
    // 使用系统默认的浏览器打开连接
    func openWanquURL(sender: AnyObject?) {
        if let url = sender?.representedObject! {
            if let targetURL = NSURL(string: "\(url)") {
                NSWorkspace.sharedWorkspace().openURL(targetURL)
            }
        }
    }
    
    // 退出
    func quit(sender: AnyObject) {
        NSApplication.sharedApplication().terminate(self)
    }
    
    func applicationWillTerminate(aNotification: NSNotification) {
        // Insert code here to tear down your application
    }
    
    
}

