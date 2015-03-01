//
//  ViewController.swift
//  Sample
//
//  Created by NishiLab on 2015/02/09.
//  Copyright (c) 2015年 NishiLab. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var TitleBackground:UIImageView?
    var TitleImage:UIImageView?
    
    let PlayButton = UIButton()
    let ComputerButton = UIButton()
    
    override func viewDidLoad() {
        var ScreenWidth=self.view.bounds.width
        var ScreenHeight=self.view.bounds.height
        
        var level = 0
        
        
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let titlescreenimage:UIImage! = UIImage(named: "TitleScreen.jpg")
        TitleBackground = UIImageView(image: titlescreenimage)
        TitleBackground!.frame = CGRectMake(0,0,ScreenWidth,ScreenHeight)
        TitleBackground!.center = CGPointMake(ScreenWidth/2, ScreenHeight/2)
        self.view.addSubview(TitleBackground!)
        
        let titleimage:UIImage! = UIImage(named: "HasamiShogiTitle.png")
        TitleImage = UIImageView(image: titleimage)
        TitleImage!.frame = CGRectMake(0,0,titleimage.size.width,titleimage.size.height)
        TitleImage!.center = CGPointMake(ScreenWidth/2, ScreenHeight/4)
        self.view.addSubview(TitleImage!)
        
        PlayButton.setTitle("対人戦", forState: .Normal)
        PlayButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        PlayButton.backgroundColor=UIColor.grayColor()
        PlayButton.frame = CGRectMake(0,0,ScreenWidth/5,ScreenHeight/20)
        PlayButton.layer.position = CGPoint(x: ScreenWidth/2, y: ScreenHeight/1.5)
        PlayButton.layer.cornerRadius=5
        PlayButton.addTarget(self, action: "MoveToPlayerView", forControlEvents: .TouchUpInside)
        self.view.addSubview(PlayButton)
        
        ComputerButton.setTitle("CPU戦", forState: .Normal)
        ComputerButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        ComputerButton.backgroundColor=UIColor.grayColor()
        ComputerButton.frame = CGRectMake(0,0,ScreenWidth/5,ScreenHeight/20)
        ComputerButton.layer.position = CGPoint(x: ScreenWidth/2, y: ScreenHeight/1.3)
        ComputerButton.layer.cornerRadius=5
        ComputerButton.addTarget(self, action: "MoveToComputerView", forControlEvents: .TouchUpInside)
        self.view.addSubview(ComputerButton)
        
    }

    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func MoveToPlayerView(){
        var appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        appDelegate.ComputerBattleFlag = false
        appDelegate.ComputerLevel = 0
        var playview = PlayViewController()
        playview.modalTransitionStyle=UIModalTransitionStyle.CrossDissolve
        self.presentViewController(playview, animated: true, completion: nil)
    }
    
    func MoveToComputerView(){
        
        let alert: UIAlertController = UIAlertController(title: "難易度", message: "選択して下さい", preferredStyle: UIAlertControllerStyle.Alert)
        
        let FirstAction: UIAlertAction = UIAlertAction(title: "素人",style: UIAlertActionStyle.Default,handler:{
            (action:UIAlertAction!) -> Void in
            var appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as AppDelegate
            appDelegate.ComputerBattleFlag = true
            appDelegate.ComputerLevel = 1
            var playview = PlayViewController()
            playview.modalTransitionStyle=UIModalTransitionStyle.CrossDissolve
            self.presentViewController(playview, animated: true, completion: nil)
        })
        
        let SecondAction: UIAlertAction = UIAlertAction(title: "普通",style: UIAlertActionStyle.Destructive,handler:{
            (action:UIAlertAction!) -> Void in 
            var appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as AppDelegate
            appDelegate.ComputerBattleFlag = true
            appDelegate.ComputerLevel = 2
            var playview = PlayViewController()
            playview.modalTransitionStyle=UIModalTransitionStyle.CrossDissolve
            self.presentViewController(playview, animated: true, completion: nil)
        })
        
        let ThirdAction: UIAlertAction = UIAlertAction(title: "神様",style: UIAlertActionStyle.Cancel,handler:{
            (action:UIAlertAction!) -> Void in
            var appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as AppDelegate
            appDelegate.ComputerBattleFlag = true
            appDelegate.ComputerLevel = 3
            var playview = PlayViewController()
            playview.modalTransitionStyle=UIModalTransitionStyle.CrossDissolve
            self.presentViewController(playview, animated: true, completion: nil)
        })
        
        alert.addAction(FirstAction)
        alert.addAction(SecondAction)
        alert.addAction(ThirdAction)
        
        self.presentViewController(alert, animated: true,completion: nil)
        
//        var appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as AppDelegate
//        appDelegate.ComputerBattleFlag = true
//        var playview = PlayViewController()
//        playview.modalTransitionStyle=UIModalTransitionStyle.CrossDissolve
//        self.presentViewController(playview, animated: true, completion: nil)
    }
    
    
}

