//
//  BaseContentsController.swift
//  ContainerViewSample
//
//  Created by 酒井文也 on 2016/04/04.
//  Copyright © 2016年 just1factory. All rights reserved.
//

import UIKit

//スクロールビューのタグに使用するenum
enum ScrollViewTag : Int {
    case MenuScroll, MainScroll
    
    //状態に対応する値を返す
    func returnValue() -> Int {
        return self.rawValue
    }
}

//定数設定などその他
struct ControllersSettings {
    
    //ScrollViewに表示するボタン名称
    static let pageScrollNavigationList: [String] = [
        "🔖1番目",
        "🔖2番目",
        "🔖3番目",
        "🔖4番目",
        "🔖5番目",
        "🔖6番目"
    ]
    
}

class BaseContentsController: UIViewController, UIScrollViewDelegate {

    //ボタンスクロール時の移動量
    var scrollButtonOffsetX: Int!
    
    //Outlet接続した部品一覧（ScrollView）
    @IBOutlet var menuScrollView: UIScrollView!
    @IBOutlet var mainScrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //スクロールビューデリゲート
        self.menuScrollView.delegate = self
        self.mainScrollView.delegate = self
    }
    
    //レイアウト処理が完了した際の処理
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        //スクロールビューの定義
        self.initMenuScrollViewDefinition()
        self.initMainScrollViewDefinition()
        
        //mainScrollViewの中にContainerを一列に並べて配置する
        for i in 0...(ControllersSettings.pageScrollNavigationList.count - 1) {
            
            //メニュー用のスクロールビューにボタンを配置
            let buttonElement: UIButton! = UIButton()
            self.menuScrollView.addSubview(buttonElement)
            
            buttonElement.frame = CGRectMake(
                CGFloat(Int(self.menuScrollView.frame.width) / 3 * i),
                CGFloat(0),
                CGFloat(Int(self.menuScrollView.frame.width) / 3),
                self.menuScrollView.frame.height
            )
            buttonElement.backgroundColor = UIColor.clearColor()
            buttonElement.setTitle(ControllersSettings.pageScrollNavigationList[i], forState: .Normal)
            buttonElement.titleLabel!.font = UIFont(name: "Bold", size: CGFloat(16))
            buttonElement.tag = i
            buttonElement.addTarget(self, action: #selector(BaseContentsController.buttonTapped(_:)), forControlEvents: .TouchUpInside)
            
        }
        
        self.mainScrollView.backgroundColor = UIColor.lightGrayColor()
        self.mainScrollView.contentSize = CGSizeMake(
            CGFloat(Int(self.mainScrollView.frame.width) * ControllersSettings.pageScrollNavigationList.count),
            self.mainScrollView.frame.height - (self.menuScrollView.frame.origin.y + self.menuScrollView.frame.height)
        )
        
        self.menuScrollView.contentSize = CGSizeMake(
            CGFloat(Int(self.menuScrollView.frame.width) * ControllersSettings.pageScrollNavigationList.count / 3),
            self.menuScrollView.frame.height
        )
        
    }

    //Menu用のUIScrollViewの初期化を行う
    func initMenuScrollViewDefinition() {
        
        self.menuScrollView.tag = ScrollViewTag.MenuScroll.returnValue()
        self.menuScrollView.pagingEnabled = false
        self.menuScrollView.scrollEnabled = true
        self.menuScrollView.directionalLockEnabled = false
        self.menuScrollView.showsHorizontalScrollIndicator = false
        self.menuScrollView.showsVerticalScrollIndicator = false
        self.menuScrollView.bounces = false
        self.menuScrollView.scrollsToTop = false
    }
    
    //Main用のUIScrollViewの初期化を行う
    func initMainScrollViewDefinition() {
        
        self.mainScrollView.tag = ScrollViewTag.MainScroll.returnValue()
        self.mainScrollView.pagingEnabled = true
        self.mainScrollView.scrollEnabled = true
        self.mainScrollView.directionalLockEnabled = false
        self.mainScrollView.showsHorizontalScrollIndicator = true
        self.mainScrollView.showsVerticalScrollIndicator = false
        self.mainScrollView.bounces = false
        self.mainScrollView.scrollsToTop = false
    }
    
    //スクロールが発生した際に行われる処理
    func scrollViewDidScroll(scrollview: UIScrollView) {
        
        //コンテンツのスクロールのみ検知
        if scrollview.tag == ScrollViewTag.MainScroll.returnValue() {
            
            //現在表示されているページ番号を判別する
            let pageWidth: CGFloat = self.mainScrollView.frame.width
            let fractionalPage: Double = Double(self.mainScrollView.contentOffset.x / pageWidth)
            let page: NSInteger = lround(fractionalPage)
            
            //ボタン配置用のスクロールビューもスライドさせる
            self.moveFormNowButtonContentsScrollView(page)
            
        }
        
    }
    
    //ボタンをタップした際に行われる処理
    func buttonTapped(button: UIButton){
        
        //押されたボタンのタグを取得
        let page: Int = button.tag
        
        //コンテンツを押されたボタンに応じて移動する
        self.moveFormNowDisplayContentsScrollView(page)
        self.moveFormNowButtonContentsScrollView(page)
    }
    
    //ボタン押下でコンテナをスライドさせる
    func moveFormNowDisplayContentsScrollView(page: Int) {
        
        UIView.animateWithDuration(0.2, delay: 0, options: [], animations: {
            self.mainScrollView.contentOffset = CGPointMake(
                CGFloat(Int(self.mainScrollView.frame.width) * page),
                CGFloat(0)
            )
        }, completion: nil)
        
    }
    
    //ボタンのスクロールビューをスライドさせる
    func moveFormNowButtonContentsScrollView(page: Int) {
        
        //Case1. ボタンを内包しているスクロールビューの位置変更をする
        if page > 0 && page < (ControllersSettings.pageScrollNavigationList.count - 1) {
            
            self.scrollButtonOffsetX = Int(self.menuScrollView.frame.width) / 3 * (page - 1)
            
        //Case2. 一番最初のpage番号のときの移動量
        } else if page == 0 {
            
            self.scrollButtonOffsetX = 0
            
        //Case3. 一番最後のpage番号のときの移動量
        } else if page == (ControllersSettings.pageScrollNavigationList.count - 1) {
            
            self.scrollButtonOffsetX = Int(self.menuScrollView.frame.width)
        }
        
        UIView.animateWithDuration(0.2, delay: 0, options: [], animations: {
            self.menuScrollView.contentOffset = CGPointMake(
                CGFloat(self.scrollButtonOffsetX),
                CGFloat(0.0)
            )
        }, completion: nil)
        
    }
    
    //@todo:ハンバーガーボタンを押下した際のアクション
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
