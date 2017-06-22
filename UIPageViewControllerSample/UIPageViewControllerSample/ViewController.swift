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
                instantiateViewController(withIdentifier: "\(viewControllerName)")

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
        menuScrollView = UIScrollView()
        
        //UIScrollViewのデリゲート
        menuScrollView.delegate = self
        
        //UIScrollViewを配置
        self.view.addSubview(menuScrollView)
        
        //動くラベルの初期化
        slidingLabel = UILabel()
        
        //UIPageViewControllerの設定
        pageViewController = UIPageViewController(transitionStyle: .pageCurl, navigationOrientation: .horizontal, options: nil)
        
        //UIPageViewControllerのデリゲート
        pageViewController.delegate = self
        pageViewController.dataSource = self
        
        //UIPageViewControllerの初期の位置を決める
        pageViewController.setViewControllers([PageSettings.generateViewControllerList().first!], direction: .forward, animated: false, completion: nil)
        
        //UIPageViewControllerを子のViewControllerとして登録
        self.addChildViewController(pageViewController)
        
        //UIPageViewControllerを配置
        self.view.addSubview(pageViewController.view)
    }
    
    //レイアウト処理が完了した際の処理
    override func viewDidLayoutSubviews() {

        //UIScrollViewのサイズを変更する
        menuScrollView.frame = CGRect(
            x: CGFloat(0),
            y: CGFloat(PageSettings.menuScrollViewY),
            width: CGFloat(self.view.frame.width),
            height: CGFloat(PageSettings.menuScrollViewH)
        )
        
        //UIPageViewControllerのサイズを変更する
        //サイズの想定 →（X座標：0, Y座標：[UIScrollViewのY座標＋高さ], 幅：[おおもとのViewの幅], 高さ：[おおもとのViewの高さ] - [UIScrollViewのY座標＋高さ]）
        pageViewController.view.frame = CGRect(
            x: CGFloat(0),
            y: CGFloat(self.menuScrollView.frame.origin.y + self.menuScrollView.frame.height),
            width: CGFloat(self.view.frame.width),
            height: CGFloat(self.view.frame.height - (self.menuScrollView.frame.origin.y + self.menuScrollView.frame.height))
        )
        pageViewController.view.backgroundColor = UIColor.gray
        menuScrollView.backgroundColor = UIColor.lightGray
        
        //UIScrollViewの初期設定
        initContentsScrollViewSettings()
        
        //UIScrollViewへのボタンの配置
        for i in 0...(PageSettings.pageScrollNavigationList.count - 1){
            self.addButtonToButtonScrollView(i)
        }
        
        //動くラベルの配置
        menuScrollView.addSubview(slidingLabel)
        menuScrollView.bringSubview(toFront: slidingLabel)
        slidingLabel.frame = CGRect(
            x: CGFloat(0),
            y: CGFloat(PageSettings.slidingLabelY),
            width: CGFloat(self.view.frame.width / 3),
            height: CGFloat(PageSettings.slidingLabelH)
        )
        slidingLabel.backgroundColor = UIColor.darkGray
    }

    /**
     *
     * UIPageViewControllerDelegateのメソッドを活用
     *
     */
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {

        //スワイプアニメーションが完了していない時には処理をさせなくする
        if !completed {
            return
        }

        //スクロールビューとボタンを押されたボタンに応じて移動する
        moveToCurrentButtonScrollView(viewControllerIndex)
        moveToCurrentButtonLabel(viewControllerIndex)
    }
    
    /**
     * 
     * UIPageViewControllerDataSourceのメソッドを活用
     *
     */
    
    //ページを次にめくった際に実行される処理
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {

        let targetViewControllers : [UIViewController] = PageSettings.generateViewControllerList()
        if viewControllerIndex >= targetViewControllers.count - 1 {
            return nil
        }
        viewControllerIndex = viewControllerIndex + 1
        return targetViewControllers[viewControllerIndex]
    }

    //ページを前にめくった際に実行される処理
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {

        let targetViewControllers : [UIViewController] = PageSettings.generateViewControllerList()
        if viewControllerIndex <= 0 {
            return nil
        }
        viewControllerIndex = viewControllerIndex - 1
        return targetViewControllers[viewControllerIndex]
    }
    
    /**
     *
     * UIScrollViewに関するセッティング
     *
     */
    
    //コンテンツ配置用Scrollviewの初期セッティング
    func initContentsScrollViewSettings() {
        
        menuScrollView.isPagingEnabled = false
        menuScrollView.isScrollEnabled = true
        menuScrollView.isDirectionalLockEnabled = false
        menuScrollView.showsHorizontalScrollIndicator = false
        menuScrollView.showsVerticalScrollIndicator = false
        menuScrollView.bounces = false
        menuScrollView.scrollsToTop = false
        
        //コンテンツサイズの決定
        self.menuScrollView.contentSize = CGSize(
            width: CGFloat(Int(self.view.frame.width) * PageSettings.pageScrollNavigationList.count / 3),
            height: CGFloat(PageSettings.menuScrollViewH)
        )
    }
    
    //ボタンの初期配置を行う
    func addButtonToButtonScrollView(_ i: Int) {
        
        let buttonElement: UIButton! = UIButton()
        menuScrollView.addSubview(buttonElement)
        
        let pX: CGFloat = CGFloat(Int(self.view.frame.width) / 3 * i)
        let pY: CGFloat = CGFloat(0)
        let pW: CGFloat = CGFloat(Int(self.view.frame.width) / 3)
        let pH: CGFloat = CGFloat(menuScrollView.frame.height)
        
        buttonElement.frame = CGRect(x: pX, y: pY, width: pW, height: pH)
        buttonElement.backgroundColor = UIColor.clear
        buttonElement.setTitle(PageSettings.pageScrollNavigationList[i], for: UIControlState())
        buttonElement.titleLabel!.font = UIFont(name: "Bold", size: CGFloat(16))
        buttonElement.tag = i
        buttonElement.addTarget(self, action: #selector(ViewController.buttonTapped(_:)), for: .touchUpInside)
    }
    
    //ボタンをタップした際に行われる処理
    func buttonTapped(_ button: UIButton){
        
        //押されたボタンのタグを取得
        let page: Int = button.tag

        //遷移の方向用の変数を用意する
        var targetDirection: UIPageViewControllerNavigationDirection? = nil
        
        //現在位置と遷移先のインデックスの差分から動く方向を設定する
        if viewControllerIndex - page == 0 {
            return
        } else if viewControllerIndex - page > 0 {
            targetDirection = .reverse
        } else if viewControllerIndex - page < 0 {
            targetDirection = .forward
        }

        viewControllerIndex = page

        pageViewController.setViewControllers([PageSettings.generateViewControllerList()[page]], direction: targetDirection!, animated: true, completion: nil)

        //スクロールビューとボタンを押されたボタンに応じて移動する
        moveToCurrentButtonScrollView(viewControllerIndex)
        moveToCurrentButtonLabel(viewControllerIndex)
    }
    
    //ボタンのスクロールビューをスライドさせる
    func moveToCurrentButtonScrollView(_ page: Int) {
        
        //Case1. ボタンを内包しているスクロールビューの位置変更をする
        if page > 0 && page < (PageSettings.pageScrollNavigationList.count - 1) {
            
            scrollButtonOffsetX = Int(self.view.frame.size.width) / 3 * (page - 1)
            
        //Case2. 一番最初のpage番号のときの移動量
        } else if page == 0 {
            
            scrollButtonOffsetX = 0
            
        //Case3. 一番最後のpage番号のときの移動量
        } else if page == (PageSettings.pageScrollNavigationList.count - 1) {
            
            scrollButtonOffsetX = Int(self.view.frame.size.width)
        }
        
        UIView.animate(withDuration: 0.2, delay: 0, options: [], animations: {
            self.menuScrollView.contentOffset = CGPoint(
                x: CGFloat(self.scrollButtonOffsetX),
                y: CGFloat(0)
            )
        }, completion: nil)
        
    }
    
    //動くラベルをスライドさせる
    func moveToCurrentButtonLabel(_ page: Int) {
        
        UIView.animate(withDuration: 0.2, delay: 0, options: [], animations: {
            
            self.slidingLabel.frame = CGRect(
                x: CGFloat(Int(self.view.frame.width) / 3 * page),
                y: CGFloat(PageSettings.slidingLabelY),
                width: CGFloat(Int(self.view.frame.width) / 3),
                height: CGFloat(PageSettings.slidingLabelH)
            )
            
        }, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


}


