//
//  ViewController.swift
//  UIPageViewControllerSample
//
//  Created by 酒井文也 on 2016/04/02.
//  Copyright © 2016年 just1factory. All rights reserved.
//

import UIKit

//テーブルビューに関係する定数
struct PageSettings {
    
    //UIScrollViewのサイズに関するセッテイング
    static let menuScrollViewY : Int = 20
    static let menuScrollViewH : Int = 40
    static let slidingLabelY : Int = 36
    static let slidingLabelH : Int = 4
    
    //UIScrollViewに表示するボタン名称
    static let pageScrollNavigationList: [String] = [
        "🔖1番目",
        "🔖2番目",
        "🔖3番目",
        "🔖4番目",
        "🔖5番目",
        "🔖6番目"
    ]
    
    //UIPageViewControllerに配置するUIViewControllerクラスの名称
    static let pageControllerIdentifierList : [String] = [
        "FirstViewController",
        "SecondViewController",
        "ThirdViewController",
        "FourthViewController",
        "FifthViewController",
        "SixthViewController"
    ]
    
    //UIPageViewControllerに追加するViewControllerのリストを生成する
    static func generateViewControllerList() -> [UIViewController] {
        
        var viewControllers : [UIViewController] = []
        self.pageControllerIdentifierList.forEach { viewControllerName in
        
            //ViewControllerのIdentifierからViewControllerを作る
            let viewController = UIStoryboard(name: "Main", bundle: nil) .
                instantiateViewControllerWithIdentifier("\(viewControllerName)")

            viewControllers.append(viewController)
        }
        return viewControllers
    }

}

class ViewController: UIViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate, UIScrollViewDelegate {

    //子のViewControllerのindex
    var viewControllerIndex : Int = 0
    
    //動くラベルの設定
    var slidingLabel : UILabel!
    
    //ページ管理用のコントローラー
    var pageViewController : UIPageViewController!
    
    //ページコンテンツのViewController名格納用の配列
    var pageContentsControllerList : [String] = []
    
    //メニュー用のスクロールビュー
    var menuScrollView : UIScrollView!
    
    //メニュー用スクロールビューのX座標のOffset値
    var scrollButtonOffsetX : Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //UIScrollViewの初期化
        self.menuScrollView = UIScrollView()
        
        //UIScrollViewのデリゲート
        self.menuScrollView.delegate = self
        
        //UIScrollViewを配置
        self.view.addSubview(self.menuScrollView)
        
        //動くラベルの初期化
        self.slidingLabel = UILabel()
        
        //UIPageViewControllerの設定
        // * .Scrollだと謎のキャッシュ問題が発生
        self.pageViewController = UIPageViewController(transitionStyle: .PageCurl, navigationOrientation: .Horizontal, options: nil)
        
        //UIPageViewControllerのデリゲート
        self.pageViewController.delegate = self
        self.pageViewController.dataSource = self
        
        //UIPageViewControllerの初期の位置を決める
        self.pageViewController.setViewControllers([PageSettings.generateViewControllerList().first!], direction: .Forward, animated: false, completion: nil)
        
        //UIPageViewControllerを子のViewControllerとして登録
        self.addChildViewController(self.pageViewController)
        
        //UIPageViewControllerを配置
        self.view.addSubview(self.pageViewController.view)
    }
    
    //レイアウト処理が完了した際の処理
    override func viewDidLayoutSubviews() {
        
        //UIScrollViewのサイズを変更する
        self.menuScrollView.frame = CGRectMake(
            CGFloat(0),
            CGFloat(PageSettings.menuScrollViewY),
            CGFloat(self.view.frame.width),
            CGFloat(PageSettings.menuScrollViewH)
        )
        
        //UIPageViewControllerのサイズを変更する
        //サイズの想定 →（X座標：0, Y座標：[UIScrollViewのY座標＋高さ], 幅：[おおもとのViewの幅], 高さ：[おおもとのViewの高さ] - [UIScrollViewのY座標＋高さ]）
        self.pageViewController.view.frame = CGRectMake(
            CGFloat(0),
            CGFloat(self.menuScrollView.frame.origin.y + self.menuScrollView.frame.height),
            CGFloat(self.view.frame.width),
            CGFloat(self.view.frame.height - (self.menuScrollView.frame.origin.y + self.menuScrollView.frame.height))
        )
        self.pageViewController.view.backgroundColor = UIColor.grayColor()
        self.menuScrollView.backgroundColor = UIColor.lightGrayColor()
        
        //UIScrollViewの初期設定
        self.initContentsScrollViewSettings()
        
        //UIScrollViewへのボタンの配置
        for i in 0...(PageSettings.pageScrollNavigationList.count - 1){
            self.addButtonToButtonScrollView(i)
        }
        
        //動くラベルの配置
        self.menuScrollView.addSubview(self.slidingLabel)
        self.menuScrollView.bringSubviewToFront(self.slidingLabel)
        self.slidingLabel.frame = CGRectMake(
            CGFloat(0),
            CGFloat(PageSettings.slidingLabelY),
            CGFloat(self.view.frame.width / 3),
            CGFloat(PageSettings.slidingLabelH)
        )
        self.slidingLabel.backgroundColor = UIColor.darkGrayColor()
    }
    
    /**
     * 
     * UIPageViewControllerDataSourceのメソッドを活用
     *
     */
    
    //ページを次にめくった際に実行される処理
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        
        let targetViewControllers : [UIViewController] = PageSettings.generateViewControllerList()
        
        if self.viewControllerIndex == targetViewControllers.count - 1 {
            return nil
        } else {
            self.viewControllerIndex = self.viewControllerIndex + 1
        }
        //スクロールビューとボタンを押されたボタンに応じて移動する
        self.moveToCurrentButtonScrollView(self.viewControllerIndex)
        self.moveToCurrentButtonLabel(self.viewControllerIndex)
        
        return targetViewControllers[self.viewControllerIndex]
    }

    //ページを前にめくった際に実行される処理
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
    
        let targetViewControllers : [UIViewController] = PageSettings.generateViewControllerList()
        
        if self.viewControllerIndex == 0 {
            return nil
        } else {
            self.viewControllerIndex = self.viewControllerIndex - 1
        }
        //スクロールビューとボタンを押されたボタンに応じて移動する
        self.moveToCurrentButtonScrollView(self.viewControllerIndex)
        self.moveToCurrentButtonLabel(self.viewControllerIndex)
        
        return targetViewControllers[self.viewControllerIndex]
    }
    
    /**
     *
     * UIScrollViewに関するセッティング
     *
     */
    
    //コンテンツ配置用Scrollviewの初期セッティング
    func initContentsScrollViewSettings() {
        
        self.menuScrollView.pagingEnabled = false
        self.menuScrollView.scrollEnabled = true
        self.menuScrollView.directionalLockEnabled = false
        self.menuScrollView.showsHorizontalScrollIndicator = false
        self.menuScrollView.showsVerticalScrollIndicator = false
        self.menuScrollView.bounces = false
        self.menuScrollView.scrollsToTop = false
        
        //コンテンツサイズの決定
        self.menuScrollView.contentSize = CGSizeMake(
            CGFloat(Int(self.view.frame.width) * PageSettings.pageScrollNavigationList.count / 3),
            CGFloat(PageSettings.menuScrollViewH)
        )
    }
    
    //ボタンの初期配置を行う
    func addButtonToButtonScrollView(i: Int) {
        
        let buttonElement: UIButton! = UIButton()
        self.menuScrollView.addSubview(buttonElement)
        
        let pX: CGFloat = CGFloat(Int(self.view.frame.width) / 3 * i)
        let pY: CGFloat = CGFloat(0)
        let pW: CGFloat = CGFloat(Int(self.view.frame.width) / 3)
        let pH: CGFloat = CGFloat(self.menuScrollView.frame.height)
        
        buttonElement.frame = CGRectMake(pX, pY, pW, pH)
        buttonElement.backgroundColor = UIColor.clearColor()
        buttonElement.setTitle(PageSettings.pageScrollNavigationList[i], forState: .Normal)
        buttonElement.titleLabel!.font = UIFont(name: "Bold", size: CGFloat(16))
        buttonElement.tag = i
        buttonElement.addTarget(self, action: #selector(ViewController.buttonTapped(_:)), forControlEvents: .TouchUpInside)
    }
    
    //ボタンをタップした際に行われる処理
    func buttonTapped(button: UIButton){
        
        //押されたボタンのタグを取得
        let page: Int = button.tag
        
        //UIPageViewControllerのから表示対象を決定する
        if self.viewControllerIndex != page {
            
            self.pageViewController.setViewControllers([PageSettings.generateViewControllerList()[page]], direction: .Forward, animated: true, completion: nil)
            
            self.viewControllerIndex = page
            
            //スクロールビューとボタンを押されたボタンに応じて移動する
            self.moveToCurrentButtonScrollView(page)
            self.moveToCurrentButtonLabel(page)
        }
    }
    
    //ボタンのスクロールビューをスライドさせる
    func moveToCurrentButtonScrollView(page: Int) {
        
        //Case1. ボタンを内包しているスクロールビューの位置変更をする
        if page > 0 && page < (PageSettings.pageScrollNavigationList.count - 1) {
            
            self.scrollButtonOffsetX = Int(self.view.frame.size.width) / 3 * (page - 1)
            
        //Case2. 一番最初のpage番号のときの移動量
        } else if page == 0 {
            
            self.scrollButtonOffsetX = 0
            
        //Case3. 一番最後のpage番号のときの移動量
        } else if page == (PageSettings.pageScrollNavigationList.count - 1) {
            
            self.scrollButtonOffsetX = Int(self.view.frame.size.width)
        }
        
        UIView.animateWithDuration(0.2, delay: 0, options: [], animations: {
            
            self.menuScrollView.contentOffset = CGPointMake(
                CGFloat(self.scrollButtonOffsetX),
                CGFloat(0)
            )
            
        }, completion: nil)
        
    }
    
    //動くラベルをスライドさせる
    func moveToCurrentButtonLabel(page: Int) {
        
        UIView.animateWithDuration(0.2, delay: 0, options: [], animations: {
            
            self.slidingLabel.frame = CGRectMake(
                CGFloat(Int(self.view.frame.width) / 3 * page),
                CGFloat(PageSettings.slidingLabelY),
                CGFloat(Int(self.view.frame.width) / 3),
                CGFloat(PageSettings.slidingLabelH)
            )
            
        }, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


}

