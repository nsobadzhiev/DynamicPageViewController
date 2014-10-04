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

protocol DMDynamicPageViewControllerDelegate {
    func pageViewController(pageController: DMDynamicViewController, didSwitchToViewController viewController: UIViewController)
    func pageViewController(pageController: DMDynamicViewController, didChangeViewControllers viewControllers: Array<UIViewController>)
}

class DMDynamicViewController: UIViewController, UIScrollViewDelegate {
    
    var containerScrollView: UIScrollView! = nil
    var pageWidth: CGFloat = 1.0
    var viewControllers:Array<UIViewController>? = nil {
        didSet {
            self.layoutPages()
        }
    }
    var currentPage:Int = 0 {
        didSet {
            if (currentPage >= self.viewControllers?.count)
            {
                self.currentPage = self.viewControllers!.count - 1
            }
            
            containerScrollView.delegate = nil
            containerScrollView.contentOffset = CGPointMake(CGFloat(self.currentPage) * self.view.bounds.size.width, 0.0)
            containerScrollView.delegate = self
            // Set the fully switched page in order to notify the delegates about it if needed.
            self.fullySwitchedPage = self.currentPage;
        }
    }
    var fullySwitchedPage:Int = 0 {
        didSet {
            if (oldValue != self.fullySwitchedPage) {
                // The page is fully switched.
                if (self.fullySwitchedPage < self.viewControllers?.count) {
                    let previousViewController = self.viewControllers?[self.fullySwitchedPage];
                    // Perform the "disappear" sequence of methods manually when the view of
                    // the controller is not visible at all.
                    previousViewController?.willMoveToParentViewController(self)
                    previousViewController?.viewWillDisappear(false)
                    previousViewController?.viewDidDisappear(false)
                    previousViewController?.didMoveToParentViewController(self)
                    previousViewController?.willMoveToParentViewController(self)
                    previousViewController?.viewWillAppear(false)
                    previousViewController?.viewDidAppear(false)
                    previousViewController?.didMoveToParentViewController(self)
                }
            }
        }
    }
    var delegate: DMDynamicPageViewControllerDelegate? = nil
                            
    init(viewControllers: Array<UIViewController>) {
        super.init()
        self.viewControllers = viewControllers
        self.notifyDelegateDidChangeControllers()
    }
    
    required override init(nibName nibNameOrNil: String!, bundle nibBundleOrNil: NSBundle!) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func willMoveToParentViewController() {
        let page = Int((containerScrollView.contentOffset.x - pageWidth / 2.0) / pageWidth) + 1
        if (self.currentPage != page)
        {
            currentPage = page;
            fullySwitchedPage = page;
        }
    }
    
    override func viewDidLayoutSubviews() {
        for var i = 0; i < self.viewControllers?.count; i += 1 {
            let pageX:CGFloat = CGFloat(i) * self.view.bounds.size.width
            self.viewControllers?[i].view.frame = CGRectMake(pageX, 0.0, self.view.bounds.size.width, self.view.bounds.size.height)
        }
        // It is important to set the pageWidth property before the contentSize and contentOffset,
        // in order to use the new width into scrollView delegate methods.
        pageWidth = self.view.bounds.size.width
        containerScrollView.contentSize = CGSizeMake(CGFloat(self.viewControllers!.count) * self.view.bounds.size.width, 1.0)
        containerScrollView.contentOffset = CGPointMake(CGFloat(self.currentPage) * self.view.bounds.size.width, 0.0)
    }
    
    func layoutPages() {
        for pageView in containerScrollView.subviews {
            pageView.removeFromSuperview()
        }
        
        for var i = 0; i < self.viewControllers?.count; i++ {
            let page = self.viewControllers?[i]
            self.addChildViewController(page!)
            let nextFrame:CGRect = CGRectMake(CGFloat(i) * self.view.bounds.size.width, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height)
            page?.view.frame = nextFrame
            containerScrollView.addSubview(page!.view)
            page?.didMoveToParentViewController(self)
        }
        containerScrollView.contentSize = CGSizeMake(self.view.bounds.size.width * CGFloat(self.viewControllers!.count), 1.0)
    }
    
    func insertPage(viewController: UIViewController, atIndex index: Int) {
        self.viewControllers?.insert(viewController, atIndex: index)
        self.layoutPages()
        self.currentPage = index
        self.notifyDelegateDidChangeControllers()
    }
    
    func removePage(viewController: UIViewController) {
        for var i = 0; i < self.viewControllers?.count; i += 1 {
            if (self.viewControllers?[i] == viewController) {
                self.viewControllers?.removeAtIndex(i)
                self.layoutPages()
                self.notifyDelegateDidChangeControllers()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        containerScrollView = UIScrollView(frame: self.view.bounds)
        containerScrollView.pagingEnabled = true
        containerScrollView.alwaysBounceVertical = false
        containerScrollView.showsHorizontalScrollIndicator = false
        containerScrollView.delegate = self
        containerScrollView.backgroundColor = UIColor.grayColor()
        self.pageWidth = self.view.frame.size.width
        self.view.addSubview(containerScrollView)
        self.layoutPages()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func notifyDelegateDidSwitchPage() {
        self.delegate?.pageViewController(self, didSwitchToViewController: self.viewControllers![self.currentPage])
    }
    
    func notifyDelegateDidChangeControllers() {
        self.delegate?.pageViewController(self, didChangeViewControllers: self.viewControllers!)
    }
    
    // MARK: UIScrollViewDelegate
    
    func scrollViewDidScroll(scrollView: UIScrollView!) {
        // Update the page when more than 50% of the previous/next page is visible
        let page = floor((containerScrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1
        if (self.currentPage != Int(page)) {
            // Check the page to avoid "index out of bounds" exception.
            if (page >= 0 && Int(page) < self.viewControllers?.count) {
                self.notifyDelegateDidSwitchPage()
            }
        }
        // Check whether the current view controller is fully presented.
        if (Int(containerScrollView.contentOffset.x) % Int(self.pageWidth) == 0)
        {
            self.fullySwitchedPage = self.currentPage;
        }
    }
}
