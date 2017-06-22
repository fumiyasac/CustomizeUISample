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
    case menuScroll, mainScroll
    
    //状態に対応する値を返す
    func returnValue() -> Int {
        return self.rawValue
    }
}

struct ScrollMenuSetting {
    
    //動くラベルに関するセッティング
    static let slidingLabelY : Int = 36
    static let slidingLabelH : Int = 4
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
    
    //動くラベルの設定
    var slidingLabel : UILabel!
    
    //ボタンスクロール時の移動量
    var scrollButtonOffsetX: Int!
    
    //Outlet接続した部品一覧（ScrollView）
    @IBOutlet var menuScrollView: UIScrollView!
    @IBOutlet var mainScrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //動くラベルの初期化
        slidingLabel = UILabel()
        
        //スクロールビューデリゲート
        menuScrollView.delegate = self
        mainScrollView.delegate = self
    }
    
    //レイアウト処理が完了した際の処理
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        //スクロールビューの定義
        initMenuScrollViewDefinition()
        initMainScrollViewDefinition()
        
        //mainScrollViewの中にContainerを一列に並べて配置する
        for i in 0...(ControllersSettings.pageScrollNavigationList.count - 1) {
            
            //メニュー用のスクロールビューにボタンを配置
            let buttonElement: UIButton! = UIButton()
            menuScrollView.addSubview(buttonElement)
            
            buttonElement.frame = CGRect(
                x: CGFloat(Int(menuScrollView.frame.width) / 3 * i),
                y: CGFloat(0),
                width: CGFloat(Int(menuScrollView.frame.width) / 3),
                height: menuScrollView.frame.height
            )
            buttonElement.backgroundColor = UIColor.clear
            buttonElement.setTitle(ControllersSettings.pageScrollNavigationList[i], for: UIControlState())
            buttonElement.titleLabel!.font = UIFont(name: "Bold", size: CGFloat(16))
            buttonElement.tag = i
            buttonElement.addTarget(self, action: #selector(BaseContentsController.buttonTapped(_:)), for: .touchUpInside)
            
        }
        
        mainScrollView.backgroundColor = UIColor.lightGray
        mainScrollView.contentSize = CGSize(
            width: CGFloat(Int(self.mainScrollView.frame.width) * ControllersSettings.pageScrollNavigationList.count),
            height: mainScrollView.frame.height - (menuScrollView.frame.origin.y + menuScrollView.frame.height)
        )
        
        menuScrollView.backgroundColor = UIColor.lightGray
        menuScrollView.contentSize = CGSize(
            width: CGFloat(Int(menuScrollView.frame.width) * ControllersSettings.pageScrollNavigationList.count / 3),
            height: menuScrollView.frame.height
        )
        
        //動くラベルの配置
        menuScrollView.addSubview(slidingLabel)
        menuScrollView.bringSubview(toFront: slidingLabel)
        slidingLabel.frame = CGRect(
            x: CGFloat(0),
            y: CGFloat(ScrollMenuSetting.slidingLabelY),
            width: CGFloat(self.view.frame.width / 3),
            height: CGFloat(ScrollMenuSetting.slidingLabelH)
        )
        slidingLabel.backgroundColor = UIColor.darkGray
    }

    //Menu用のUIScrollViewの初期化を行う
    func initMenuScrollViewDefinition() {
        
        menuScrollView.tag = ScrollViewTag.menuScroll.returnValue()
        menuScrollView.isPagingEnabled = false
        menuScrollView.isScrollEnabled = true
        menuScrollView.isDirectionalLockEnabled = false
        menuScrollView.showsHorizontalScrollIndicator = false
        menuScrollView.showsVerticalScrollIndicator = false
        menuScrollView.bounces = false
        menuScrollView.scrollsToTop = false
    }
    
    //Main用のUIScrollViewの初期化を行う
    func initMainScrollViewDefinition() {
        
        mainScrollView.tag = ScrollViewTag.mainScroll.returnValue()
        mainScrollView.isPagingEnabled = true
        mainScrollView.isScrollEnabled = true
        mainScrollView.isDirectionalLockEnabled = false
        mainScrollView.showsHorizontalScrollIndicator = true
        mainScrollView.showsVerticalScrollIndicator = false
        mainScrollView.bounces = false
        mainScrollView.scrollsToTop = false
    }
    
    //スクロールが発生した際に行われる処理
    func scrollViewDidScroll(_ scrollview: UIScrollView) {
        
        //コンテンツのスクロールのみ検知
        if scrollview.tag == ScrollViewTag.mainScroll.returnValue() {
            
            //現在表示されているページ番号を判別する
            let pageWidth: CGFloat = mainScrollView.frame.width
            let fractionalPage: Double = Double(mainScrollView.contentOffset.x / pageWidth)
            let page: NSInteger = lround(fractionalPage)
            
            //ボタン配置用のスクロールビューもスライドさせる
            moveFormNowButtonContentsScrollView(page)
            moveToCurrentButtonLabel(page)
        }
        
    }
    
    //ボタンをタップした際に行われる処理
    func buttonTapped(_ button: UIButton){
        
        //押されたボタンのタグを取得
        let page: Int = button.tag
        
        //コンテンツを押されたボタンに応じて移動する
        moveFormNowDisplayContentsScrollView(page)
        moveFormNowButtonContentsScrollView(page)
        moveToCurrentButtonLabel(page)
    }
    
    //ボタン押下でコンテナをスライドさせる
    func moveFormNowDisplayContentsScrollView(_ page: Int) {
        
        UIView.animate(withDuration: 0.2, delay: 0, options: [], animations: {
            self.mainScrollView.contentOffset = CGPoint(
                x: CGFloat(Int(self.mainScrollView.frame.width) * page),
                y: CGFloat(0)
            )
        }, completion: nil)
        
    }
    
    //ボタンのスクロールビューをスライドさせる
    func moveFormNowButtonContentsScrollView(_ page: Int) {
        
        //Case1. ボタンを内包しているスクロールビューの位置変更をする
        if page > 0 && page < (ControllersSettings.pageScrollNavigationList.count - 1) {
            
            scrollButtonOffsetX = Int(menuScrollView.frame.width) / 3 * (page - 1)
            
        //Case2. 一番最初のpage番号のときの移動量
        } else if page == 0 {
            
            scrollButtonOffsetX = 0
            
        //Case3. 一番最後のpage番号のときの移動量
        } else if page == (ControllersSettings.pageScrollNavigationList.count - 1) {
            
            scrollButtonOffsetX = Int(menuScrollView.frame.width)
        }
        
        UIView.animate(withDuration: 0.2, delay: 0, options: [], animations: {
            self.menuScrollView.contentOffset = CGPoint(
                x: CGFloat(self.scrollButtonOffsetX),
                y: CGFloat(0.0)
            )
        }, completion: nil)
        
    }

    //動くラベルをスライドさせる
    func moveToCurrentButtonLabel(_ page: Int) {
        
        UIView.animate(withDuration: 0.2, delay: 0, options: [], animations: {
            
            self.slidingLabel.frame = CGRect(
                x: CGFloat(Int(self.menuScrollView.frame.width) / 3 * page),
                y: CGFloat(ScrollMenuSetting.slidingLabelY),
                width: CGFloat(Int(self.menuScrollView.frame.width) / 3),
                height: CGFloat(ScrollMenuSetting.slidingLabelH)
            )
            
            }, completion: nil)
    }
    
    //ハンバーガーボタンを押下した際のアクション
    @IBAction func viewControllerOpen(_ sender: AnyObject) {
        let viewController = self.parent as! ViewController
        viewController.judgeSideContainer(SideStatus.opened)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
