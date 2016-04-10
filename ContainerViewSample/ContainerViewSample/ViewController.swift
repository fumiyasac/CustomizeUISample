//
//  ViewController.swift
//  ContainerViewSample
//
//  Created by 酒井文也 on 2016/04/03.
//  Copyright © 2016年 just1factory. All rights reserved.
//

import UIKit

//サイドのコンテナビューに関するenum
enum SideStatus {
    case Opened
    case Closed
}

//定数設定などその他
struct BaseSettings {
    
    //ScrollViewのサイズに関するセッテイング
    static let movedMainX : Int = 280
    static let closedMainX : Int = 0
}

class ViewController: UIViewController {

    //メンバ変数
    var sideStatus : SideStatus! = SideStatus.Closed
    
    //Outlet接続した部品一覧
    @IBOutlet var hiddenButton: UIButton!
    @IBOutlet var mainContainer: UIView!
    @IBOutlet var sideContainer: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //コンテナの初期状態を決定
        self.hiddenButtonSetting(self.sideStatus)
        
        //配置したボタンに押した際のアクションを設定する
        self.hiddenButton.addTarget(self, action: #selector(ViewController.hiddenButtonTapped(_:)), forControlEvents: .TouchUpInside)
    }

    //レイアウト処理が完了した際の処理
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        //AutoLayoutで設定したパーツのX座標・Y座標・幅・高さを再定義する
        self.mainContainer.frame = CGRectMake(
            CGFloat(self.mainContainer.frame.origin.x),
            CGFloat(self.mainContainer.frame.origin.y),
            CGFloat(self.mainContainer.frame.width),
            CGFloat(self.mainContainer.frame.height)
        )
        self.sideContainer.frame = CGRectMake(
            CGFloat(self.sideContainer.frame.origin.x),
            CGFloat(self.sideContainer.frame.origin.y),
            CGFloat(self.sideContainer.frame.width),
            CGFloat(self.sideContainer.frame.height)
        )
    }

    //ボタンタップ時のメソッド
    func hiddenButtonTapped(button: UIButton) {
        self.containerHandlerTapped(SideStatus.Closed)
    }
    
    //コンテナの動きを司るメソッド
    func containerHandlerTapped(status: SideStatus) {
        self.hiddenButtonSetting(status)
        self.judgeSideContainer(status)
    }
    
    //ステータスに応じてメインコンテナの開閉を決定する
    func judgeSideContainer(status: SideStatus) {
        
        if status == SideStatus.Closed {
            
            UIView.animateWithDuration(0.2, delay: 0, options: [], animations: {
                
                self.mainContainer.frame = CGRectMake(
                    CGFloat(BaseSettings.closedMainX),
                    CGFloat(self.mainContainer.frame.origin.y),
                    CGFloat(self.mainContainer.frame.width),
                    CGFloat(self.mainContainer.frame.height)
                )
                self.hiddenButtonSetting(status)
                
            }, completion: nil)
            
        } else {
            
            UIView.animateWithDuration(0.2, delay: 0, options: [], animations: {
                
                self.mainContainer.frame = CGRectMake(
                    CGFloat(BaseSettings.movedMainX),
                    CGFloat(self.mainContainer.frame.origin.y),
                    CGFloat(self.mainContainer.frame.width),
                    CGFloat(self.mainContainer.frame.height)
                )
                self.hiddenButtonSetting(status)
                
            }, completion: nil)
            
        }
        
    }
    
    //コンテナ開閉用ボタンの制御を行う
    func hiddenButtonSetting(status: SideStatus) {
        
        if status == SideStatus.Closed {
            self.hiddenButton.enabled = false
            self.hiddenButton.alpha = 0
        } else {
            self.hiddenButton.enabled = true
            self.hiddenButton.alpha = 1
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


}

