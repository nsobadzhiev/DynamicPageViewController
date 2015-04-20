//  The MIT License (MIT)
//
//  Copyright (c) 2014 Nikola Sobadjiev
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
                            
    var window: UIWindow?
    var pageController:DMDynamicViewController? = nil

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        let viewController1 = UIViewController()
        let viewController2 = UIViewController()
        let viewController3 = UIViewController()
        let viewController4 = UIViewController()
        let viewController5 = UIViewController()
        
        viewController1.view.backgroundColor = UIColor.redColor()
        viewController2.view.backgroundColor = UIColor.greenColor()
        viewController3.view.backgroundColor = UIColor.blueColor()
        viewController4.view.backgroundColor = UIColor.blackColor()
        viewController5.view.backgroundColor = UIColor.yellowColor()
        
        let viewControllers = [viewController1, viewController2, viewController3, viewController4, viewController5]
        pageController = DMDynamicViewController(viewControllers: viewControllers)
        window = UIWindow()
        window?.frame = UIScreen.mainScreen().bounds
        pageController?.view.frame = window!.frame;
        window?.addSubview(pageController!.view)
        window?.rootViewController = pageController
        window?.makeKeyAndVisible()
        
//        var timerRemove = NSTimer.scheduledTimerWithTimeInterval(5.1, target: self, selector: Selector("removeController"), userInfo: nil, repeats: false)
//        var timerAdd = NSTimer.scheduledTimerWithTimeInterval(10.1, target: self, selector: Selector("addController"), userInfo: nil, repeats: false)
        return true
    }
    
    func removeController() {
        self.pageController?.removePage(self.pageController!.viewControllers![0])
    }
    
    func addController() {
        let newController = UIViewController()
        newController.view.backgroundColor = UIColor.purpleColor()
        self.pageController?.insertPage(newController, atIndex: 0)
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

