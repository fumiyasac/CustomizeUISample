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
    case opened
    case closed
}

//定数設定などその他
struct BaseSettings {

    //ScrollViewのサイズに関するセッテイング
    static let movedButtonX : Int = 268
    static let closedButtonX : Int = 0
    
    //ScrollViewのサイズに関するセッテイング
    static let movedMainX : Int = 280
    static let closedMainX : Int = 0
}

class ViewController: UIViewController {

    //メンバ変数
    var sideStatus : SideStatus! = SideStatus.closed
    
    //Outlet接続した部品一覧
    @IBOutlet var hiddenButton: UIButton!
    @IBOutlet var mainContainer: UIView!
    @IBOutlet var sideContainer: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //コンテナの初期状態を決定
        hiddenButton.alpha = 0
        hiddenButton.isEnabled = false
    
        //配置したボタンに押した際のアクションを設定する
        hiddenButton.addTarget(self, action: #selector(ViewController.hiddenButtonTapped(_:)), for: .touchUpInside)
    }

    //レイアウト処理が完了した際の処理
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        //AutoLayoutで設定したパーツのX座標・Y座標・幅・高さを再定義する
        hiddenButton.frame = CGRect(
            x: CGFloat(hiddenButton.frame.origin.x),
            y: CGFloat(hiddenButton.frame.origin.y),
            width: CGFloat(hiddenButton.frame.width),
            height: CGFloat(hiddenButton.frame.height)
        )
        mainContainer.frame = CGRect(
            x: CGFloat(mainContainer.frame.origin.x),
            y: CGFloat(mainContainer.frame.origin.y),
            width: CGFloat(mainContainer.frame.width),
            height: CGFloat(mainContainer.frame.height)
        )
        sideContainer.frame = CGRect(
            x: CGFloat(sideContainer.frame.origin.x),
            y: CGFloat(sideContainer.frame.origin.y),
            width: CGFloat(sideContainer.frame.width),
            height: CGFloat(sideContainer.frame.height)
        )
    }

    //ボタンタップ時のメソッド
    func hiddenButtonTapped(_ button: UIButton) {
        self.containerHandlerTapped(SideStatus.closed)
    }
    
    //コンテナの動きを司るメソッド
    func containerHandlerTapped(_ status: SideStatus) {
        self.judgeSideContainer(status)
    }
    
    //ステータスに応じてメインコンテナの開閉を決定する
    func judgeSideContainer(_ status: SideStatus) {

        if status == SideStatus.closed {
            
            UIView.animate(withDuration: 0.13, delay: 0, options: UIViewAnimationOptions.curveEaseOut, animations: {

                self.mainContainer.frame = CGRect(
                    x: CGFloat(BaseSettings.closedMainX),
                    y: CGFloat(self.mainContainer.frame.origin.y),
                    width: CGFloat(self.mainContainer.frame.width),
                    height: CGFloat(self.mainContainer.frame.height)
                )

                self.hiddenButton.frame = CGRect(
                    x: CGFloat(BaseSettings.closedButtonX),
                    y: CGFloat(self.mainContainer.frame.origin.y),
                    width: CGFloat(self.mainContainer.frame.width),
                    height: CGFloat(self.mainContainer.frame.height)
                )
                self.hiddenButton.alpha = 0
                
            }, completion: { finished in
                
                self.hiddenButton.isEnabled = false
            })
            
        } else {
            
            UIView.animate(withDuration: 0.13, delay: 0, options: UIViewAnimationOptions.curveEaseOut, animations: {

                self.mainContainer.frame = CGRect(
                    x: CGFloat(BaseSettings.movedMainX),
                    y: CGFloat(self.mainContainer.frame.origin.y),
                    width: CGFloat(self.mainContainer.frame.width),
                    height: CGFloat(self.mainContainer.frame.height)
                )

                self.hiddenButton.frame = CGRect(
                    x: CGFloat(BaseSettings.movedButtonX),
                    y: CGFloat(self.mainContainer.frame.origin.y),
                    width: CGFloat(self.mainContainer.frame.width),
                    height: CGFloat(self.mainContainer.frame.height)
                )
                self.hiddenButton.alpha = 0.6
                
            }, completion: { finished in
                
                self.hiddenButton.isEnabled = true
            })
            
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


}

