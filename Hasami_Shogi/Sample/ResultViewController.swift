//
//  ResultViewController.swift
//  Sample
//
//  Created by NishiLab on 2015/02/11.
//  Copyright (c) 2015年 NishiLab. All rights reserved.
//

import UIKit
import AVFoundation

class ResultViewController:UIViewController{
    var WinSound = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("gamefinish", ofType: "wav")!)
    var player = AVAudioPlayer()
    
    var ResultBackground:UIImageView?
    
    let WinnerLabel = UILabel()
    
    let BackTitleButton = UIButton()
    let RetryButton = UIButton()
    
    override func viewDidLoad() {
        player = AVAudioPlayer(contentsOfURL: WinSound, error: nil)
        player.prepareToPlay()
        player.play()
        
        var appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        
        var ScreenWidth=self.view.bounds.width
        var ScreenHeight=self.view.bounds.height
        
        super.viewDidLoad()
        
        let resultscreenimage:UIImage! = UIImage(named: "PlayScreen.jpg")
        ResultBackground = UIImageView(image: resultscreenimage)
        ResultBackground!.frame = CGRectMake(0,0,ScreenWidth,ScreenHeight)
        ResultBackground!.center = CGPointMake(ScreenWidth/2, ScreenHeight/2)
        self.view.addSubview(ResultBackground!)
        
        WinnerLabel.frame = CGRectMake(0,0,ScreenWidth,ScreenHeight/5)
        WinnerLabel.layer.cornerRadius = 20.0
        WinnerLabel.layer.position = CGPoint(x: ScreenWidth/2,y: ScreenHeight/3)
        WinnerLabel.textColor = UIColor.yellowColor()
        WinnerLabel.textAlignment = NSTextAlignment.Center
        if appDelegate.WinnerTeban == 0{
            WinnerLabel.text = "先手の勝ち!!"
        }
        else{
            WinnerLabel.text = "後手の勝ち!!"
        }
        WinnerLabel.font = UIFont.systemFontOfSize(40)
        self.view.addSubview(WinnerLabel)
        
        BackTitleButton.setTitle("タイトルへ戻る", forState: .Normal)
        BackTitleButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        BackTitleButton.backgroundColor=UIColor.grayColor()
        BackTitleButton.frame = CGRectMake(0,0,ScreenWidth/2,ScreenHeight/20)
        BackTitleButton.layer.position = CGPoint(x: ScreenWidth/2, y: ScreenHeight/1.5)
        BackTitleButton.layer.cornerRadius=5
        BackTitleButton.addTarget(self, action: "MoveToTitleView", forControlEvents: .TouchUpInside)
        self.view.addSubview(BackTitleButton)
        
        RetryButton.setTitle("リトライ", forState: .Normal)
        RetryButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        RetryButton.backgroundColor=UIColor.grayColor()
        RetryButton.frame = CGRectMake(0,0,ScreenWidth/5,ScreenHeight/20)
        RetryButton.layer.position = CGPoint(x: ScreenWidth/2, y: ScreenHeight/1.3)
        RetryButton.layer.cornerRadius=5
        RetryButton.addTarget(self, action: "MoveToPlayView", forControlEvents: .TouchUpInside)
        self.view.addSubview(RetryButton)

    }
    
    func MoveToTitleView(){
        var titleview = ViewController()
        titleview.modalTransitionStyle=UIModalTransitionStyle.CrossDissolve
        self.presentViewController(titleview, animated: true, completion: nil)
    }
    
    func MoveToPlayView(){
        var playview = PlayViewController()
        playview.modalTransitionStyle=UIModalTransitionStyle.CrossDissolve
        self.presentViewController(playview, animated: true, completion: nil)
    }

}