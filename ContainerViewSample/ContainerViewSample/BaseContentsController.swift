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
    case MenuScroll = 0
    case MainScroll
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

    //メンバ変数
    var basePosition: Int! = 1
    
    //Outlet接続した部品一覧（ScrollView）
    @IBOutlet var menuScrollView: UIScrollView!
    @IBOutlet var mainScrollView: UIScrollView!
    
    //ViewControllerをembed segueでつないでいるContainerの配置
    @IBOutlet var firstContainer: UIView!
    @IBOutlet var secondContainer: UIView!
    @IBOutlet var thirdContainer: UIView!
    @IBOutlet var fourthContainer: UIView!
    @IBOutlet var fifthContainer: UIView!
    @IBOutlet var sixthContainer: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /*
        self.firstContainer.translatesAutoresizingMaskIntoConstraints = true
        self.secondContainer.translatesAutoresizingMaskIntoConstraints = true
        self.thirdContainer.translatesAutoresizingMaskIntoConstraints = true
        self.fourthContainer.translatesAutoresizingMaskIntoConstraints = true
        self.fifthContainer.translatesAutoresizingMaskIntoConstraints = true
        self.sixthContainer.translatesAutoresizingMaskIntoConstraints = true
        */
    }
    
    //レイアウト処理が完了した際の処理
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        //スクロールビューの定義
        self.initMenuScrollViewDefinition()
        self.initMainScrollViewDefinition()
        
        //mainScrollViewの中にContainerを一列に並べて配置する
        for i in 0...(ControllersSettings.pageScrollNavigationList.count - 1){
            
            //各コンテナの位置情報を定義する
            let pX: CGFloat = CGFloat(Int(self.mainScrollView.frame.width) * i)
            let pY: CGFloat = CGFloat(0.0)
            let pW: CGFloat = self.mainScrollView.frame.width
            let pH: CGFloat = self.mainScrollView.frame.height
            
            //各コンテナをコンテンツ用のScrollViewに配置する(もうちょっとエレガントにしたい...)
            if i == 0 {
                
                self.firstContainer.translatesAutoresizingMaskIntoConstraints = true
                self.firstContainer.frame = CGRectMake(pX, pY, pW, pH)
                self.mainScrollView.addSubview(self.firstContainer)
                
            } else if i == 1 {

                self.secondContainer.translatesAutoresizingMaskIntoConstraints = true
                self.secondContainer.frame = CGRectMake(pX, pY, pW, pH)
                self.mainScrollView.addSubview(self.secondContainer)
                
            } else if i == 2 {
                
                self.thirdContainer.translatesAutoresizingMaskIntoConstraints = true
                self.thirdContainer.frame = CGRectMake(pX, pY, pW, pH)
                self.mainScrollView.addSubview(self.thirdContainer)
                
            } else if i == 3 {

                self.fourthContainer.translatesAutoresizingMaskIntoConstraints = true
                self.fourthContainer.frame = CGRectMake(pX, pY, pW, pH)
                self.mainScrollView.addSubview(self.fourthContainer)
                
            } else if i == 4 {
                
                self.fifthContainer.translatesAutoresizingMaskIntoConstraints = true
                self.fifthContainer.frame = CGRectMake(pX, pY, pW, pH)
                self.mainScrollView.addSubview(self.fifthContainer)
                
            } else if i == 5 {
                
                self.sixthContainer.translatesAutoresizingMaskIntoConstraints = true
                self.sixthContainer.frame = CGRectMake(pX, pY, pW, pH)
                self.mainScrollView.addSubview(self.sixthContainer)

            }
            
            //メニュー用のスクロールビューにボタンを配置
            let buttonElement: UIButton! = UIButton()
            self.menuScrollView.addSubview(buttonElement)
            
            buttonElement.frame = CGRectMake(
                CGFloat(Int(self.menuScrollView.frame.width) / 3 * i),
                CGFloat(0.0),
                CGFloat(Int(self.menuScrollView.frame.width) / 3),
                self.menuScrollView.frame.height
            )
            buttonElement.backgroundColor = UIColor.clearColor()
            buttonElement.setTitle(ControllersSettings.pageScrollNavigationList[i], forState: .Normal)
            buttonElement.titleLabel!.font = UIFont(name: "Bold", size: CGFloat(16))
            buttonElement.tag = i
            //buttonElement.addTarget(self, action: #selector(ViewController.buttonTapped(_:)), forControlEvents: .TouchUpInside)
            
        }
        
        self.mainScrollView.backgroundColor = UIColor.lightGrayColor()
        self.mainScrollView.contentSize = CGSizeMake(
            CGFloat(Int(self.mainScrollView.frame.width) * ControllersSettings.pageScrollNavigationList.count),
            CGFloat(self.menuScrollView.frame.height)
        )
        
        self.menuScrollView.contentSize = CGSizeMake(
            CGFloat(Int(self.menuScrollView.frame.width) * ControllersSettings.pageScrollNavigationList.count / 3),
            CGFloat(self.menuScrollView.frame.height)
        )
        
    }

    //Menu用のUIScrollViewの初期化を行う
    func initMenuScrollViewDefinition() {
        
        self.menuScrollView.tag = ScrollViewTag.MenuScroll.rawValue
        self.menuScrollView.pagingEnabled = false
        self.menuScrollView.scrollEnabled = true
        self.menuScrollView.directionalLockEnabled = false
        self.menuScrollView.showsHorizontalScrollIndicator = false
        self.menuScrollView.showsVerticalScrollIndicator = false
        self.menuScrollView.bounces = false
        self.menuScrollView.scrollsToTop = false
        
        //コンテンツサイズの決定
        self.menuScrollView.contentSize = CGSizeMake(
            CGFloat(Int(self.menuScrollView.frame.width) * ControllersSettings.pageScrollNavigationList.count / 3),
            CGFloat(self.menuScrollView.frame.height)
        )
        
    }
    
    //Main用のUIScrollViewの初期化を行う
    func initMainScrollViewDefinition() {
        
        self.mainScrollView.tag = ScrollViewTag.MainScroll.rawValue
        self.mainScrollView.pagingEnabled = true
        self.mainScrollView.scrollEnabled = true
        self.mainScrollView.directionalLockEnabled = false
        self.mainScrollView.showsHorizontalScrollIndicator = true
        self.mainScrollView.showsVerticalScrollIndicator = false
        self.mainScrollView.bounces = false
        self.mainScrollView.scrollsToTop = false
        
        //コンテンツサイズの決定
        self.mainScrollView.backgroundColor = UIColor.lightGrayColor()
        self.mainScrollView.contentSize = CGSizeMake(
            CGFloat(Int(self.mainScrollView.frame.width) * ControllersSettings.pageScrollNavigationList.count),
            CGFloat(self.menuScrollView.frame.height)
        )
        
    }
    
    //ハンバーガーボタンを押下した際のアクション
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
