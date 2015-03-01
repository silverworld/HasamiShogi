//
//  PlayViewController.swift
//  Sample
//
//  Created by NishiLab on 2015/02/09.
//  Copyright (c) 2015年 NishiLab. All rights reserved.
//

import UIKit
import AVFoundation

class PlayViewController:UIViewController{
    var SenteMoveSound = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("senteaction", ofType: "wav")!)
    var GoteMoveSound = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("goteaction", ofType: "wav")!)
    var GetSound = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("get", ofType: "wav")!)
    var CannotMoveSound = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("cannotput", ofType: "wav")!)
    var player = AVAudioPlayer()
    
    var screenwidth:CGFloat = 0
    var screenheight:CGFloat = 0
    
    var TitleBackground:UIImageView?
    var BoardBackground:UIImageView?
    
    var PieceImage:UIImageView?
    
    let masuImg:UIImage! = UIImage(named: "masu.png")
    let senteImg:UIImage! = UIImage(named: "Koma_ho.png")
    let goteImg:UIImage! = UIImage(named: "Koma_to_r.png")
    let areaImg:UIImage! = UIImage(named: "masu_hover.png")
    let senteChooseImg:UIImage! = UIImage(named: "koma_ho_hover.png")
    let goteChooseImg:UIImage! = UIImage(named: "koma_ho_hover_r.png")
    
    let SenteLabel:UILabel! = UILabel()
    let GoteLabel:UILabel! = UILabel()
    
    let TesuLabel:UILabel! = UILabel()
    let TebanLabel:UILabel! = UILabel()
    
    let WaitButton:UIButton! = UIButton()
    
    var Teban = 0
    var Tesu = 0
    var TakePieceNum = [0,0]
    
    var PieceBoard = [
        [2,2,2,2,2,2,2,2,2],
        [0,0,0,0,0,0,0,0,0],
        [0,0,0,0,0,0,0,0,0],
        [0,0,0,0,0,0,0,0,0],
        [0,0,0,0,0,0,0,0,0],
        [0,0,0,0,0,0,0,0,0],
        [0,0,0,0,0,0,0,0,0],
        [0,0,0,0,0,0,0,0,0],
        [1,1,1,1,1,1,1,1,1]]
    
    var CanMovePieceArea = [
        [0,0,0,0,0,0,0,0,0],
        [0,0,0,0,0,0,0,0,0],
        [0,0,0,0,0,0,0,0,0],
        [0,0,0,0,0,0,0,0,0],
        [0,0,0,0,0,0,0,0,0],
        [0,0,0,0,0,0,0,0,0],
        [0,0,0,0,0,0,0,0,0],
        [0,0,0,0,0,0,0,0,0],
        [0,0,0,0,0,0,0,0,0]]
    
    var TapFlag = false
    
    var FromdanPiece = 0
    var FromsujiPiece = 0
    
    var TodanPiece = 0
    var TosujiPiece = 0
    
    var SaveTakePieceNum = [0,0]
    
    //CPU戦用
    var Computerlevel = 0
    var PlayerTeban = 0
    var ComputerTeban = 1
    var ComputerFlag = false
    var ComputerFromToPair = [0,0]
    var RegalCanMove:[[Int]] = []
    var RegalCanMoveCountNum = 0
    
    //AI用
    var PieceBoardForSearch:[[[Int]]] = []
    var BestMove:[[Int]] = []
    var BestMoveInit = [0,0]
    var Dan = 0
    var Suji = 0
    var Weight = [10]
    var Feature = [0]
    var SaveBestValue = 0
    
    //戻るボタン用
    var StepPieceBoard:[[[Int]]] = []
    var StepTakePieceNum:[[Int]] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var ScreenWidth=self.view.bounds.width
        screenwidth=self.view.bounds.width
        var ScreenHeight=self.view.bounds.height
        screenheight=self.view.bounds.height
        
        let titlescreenimage:UIImage! = UIImage(named: "PlayScreen.jpg")
        TitleBackground = UIImageView(image: titlescreenimage)
        TitleBackground!.frame = CGRectMake(0,0,ScreenWidth,ScreenHeight)
        TitleBackground!.center = CGPointMake(ScreenWidth/2, ScreenHeight/2)
        self.view.addSubview(TitleBackground!)
        
        let boardimage:UIImage! = UIImage(named: "ban.png")
        BoardBackground = UIImageView(image: boardimage)
        BoardBackground!.frame = CGRectMake(0,0,boardimage.size.width/2,boardimage.size.height/2)
        BoardBackground!.center = CGPointMake(ScreenWidth/2, ScreenHeight/2)
        self.view.addSubview(BoardBackground!)
        
        for i in 0..<9{
            for j in 0..<9{
                let BoardButton = UIButton()
                BoardButton.frame = CGRectMake(0,0,31,31)
                BoardButton.layer.position = CGPoint(x: ScreenWidth/5.9 + CGFloat(j*31
                    ),y: ScreenHeight/3.19 + CGFloat(i*31))
                BoardButton.addTarget(self, action: "MyPieceTapped:", forControlEvents: .TouchUpInside)
                BoardButton.tag = i*9 + j
                
                switch PieceBoard[i][j] {
                case 1:
                    BoardButton.setImage(senteImg, forState: .Normal)
                case 2:
                    BoardButton.setImage(goteImg, forState: .Normal)
                default:
                    if CanMovePieceArea[i][j] == 1{
                        BoardButton.setImage(areaImg, forState: .Normal)
                    }
                    else{
                        BoardButton.setImage(masuImg, forState: .Normal)
                    }
                }
                self.view.addSubview(BoardButton)
            }
        }
        
        var appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        
        SenteLabel.frame = CGRectMake(0,0,ScreenWidth/2.5,ScreenHeight/20)
        SenteLabel.backgroundColor = UIColor.cyanColor()
        SenteLabel.layer.cornerRadius = 20.0
        SenteLabel.layer.position = CGPoint(x: ScreenWidth/3.25,y: ScreenHeight/1.28)
        SenteLabel.textAlignment = NSTextAlignment.Center
        SenteLabel.text = "先手プレイヤー:"+String(TakePieceNum[0])
        self.view.addSubview(SenteLabel)
        
        GoteLabel.frame = CGRectMake(0,0,ScreenWidth/2.5,ScreenHeight/20)
        GoteLabel.backgroundColor = UIColor.magentaColor()
        GoteLabel.layer.cornerRadius = 20.0
        GoteLabel.layer.position = CGPoint(x: ScreenWidth/1.5,y: ScreenHeight/4.6)
        GoteLabel.textAlignment = NSTextAlignment.Center
        if appDelegate.ComputerBattleFlag == false{
            ComputerFlag = false
            PlayerTeban = 0
            GoteLabel.text = "後手プレイヤー:"+String(TakePieceNum[1])
        }
        else{
            ComputerFlag = true
            ComputerTeban = 1
            GoteLabel.text = "後手Enemyさん:"+String(TakePieceNum[1])
        }
        self.view.addSubview(GoteLabel)
        
        TesuLabel.frame = CGRectMake(0,0,ScreenWidth/5,ScreenHeight/20)
        TesuLabel.backgroundColor = UIColor.orangeColor()
        TesuLabel.layer.cornerRadius = 20.0
        TesuLabel.layer.position = CGPoint(x: ScreenWidth/5,y: ScreenHeight/10)
        TesuLabel.textAlignment = NSTextAlignment.Center
        TesuLabel.text = String(Tesu+1)+"手目"
        self.view.addSubview(TesuLabel)
        
        TebanLabel.frame = CGRectMake(0,0,ScreenWidth/5,ScreenHeight/20)
        TebanLabel.backgroundColor = UIColor.orangeColor()
        TebanLabel.layer.cornerRadius = 20.0
        TebanLabel.layer.position = CGPoint(x: ScreenWidth/1.26,y: ScreenHeight/10)
        TebanLabel.textAlignment = NSTextAlignment.Center
        if Teban == 0{
            TebanLabel.text = "先手番"
        }
        else{
            TebanLabel.text = "後手番"
        }
        self.view.addSubview(TebanLabel)
        
        WaitButton.setTitle("待った", forState: .Normal)
        WaitButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        WaitButton.backgroundColor=UIColor.redColor()
        WaitButton.frame = CGRectMake(0,0,ScreenWidth/5,ScreenHeight/20)
        WaitButton.center = CGPoint(x: ScreenWidth/2, y: ScreenHeight/1.1)
        WaitButton.layer.cornerRadius=5
        WaitButton.addTarget(self, action: "BackBotton", forControlEvents: .TouchUpInside)
        self.view.addSubview(WaitButton)
        
        StepPieceBoard.append(PieceBoard)
        StepTakePieceNum.append(TakePieceNum)
        
        Computerlevel = appDelegate.ComputerLevel!
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func BackBotton(){
        //待ったボタンを押したとき
        if Tesu <= 0  || TapFlag == true || (Teban == ComputerTeban && ComputerFlag == true){
            return
        }
        
        for i in 0..<9{
            for j in 0..<9{
                PieceBoard[i][j] = StepPieceBoard[Tesu-1][i][j]
            }
        }
        for i in 0..<2{
            TakePieceNum[i] = StepTakePieceNum[Tesu-1][i]
        }
        
        if Teban == 0{
            Teban = 1
        }
        else{
            Teban = 0
        }
        
        if ComputerFlag == true && Teban == ComputerTeban{
            //TODO: Enemyの指し手を決定する場所
            CreateRegalCanMove(Teban,SubBoard :PieceBoard)
            ComputerMovePiece()
            CheckTakePiece()
            CheckWin()
            if Teban == 0{
                player = AVAudioPlayer(contentsOfURL: SenteMoveSound, error: nil)
                player.prepareToPlay()
                player.play()
                Teban = 1
            }
            else{
                player = AVAudioPlayer(contentsOfURL: GoteMoveSound, error: nil)
                player.prepareToPlay()
                player.play()
                Teban = 0
            }
            CopyBoard()
            Tesu++
        }
        
        StepPieceBoard.removeLast()
        StepTakePieceNum.removeLast()
        
        Tesu--
        
        UpdateMasu()
    }
    
    func UpdateMasu(){
        for i in 0..<9{
            for j in 0..<9{
                let BoardButton = UIButton()
                BoardButton.frame = CGRectMake(0,0,31,31)
                BoardButton.layer.position = CGPoint(x: screenwidth/5.9 + CGFloat(j*31
                    ),y: screenheight/3.19 + CGFloat(i*31))
                BoardButton.addTarget(self, action: "MyPieceTapped:", forControlEvents: .TouchUpInside)
                BoardButton.tag = i*9 + j
                BoardButton.setImage(masuImg, forState: .Normal)
                self.view.addSubview(BoardButton)
                switch PieceBoard[i][j] {
                case 1:
                    BoardButton.setImage(senteImg, forState: .Normal)
                case 2:
                    BoardButton.setImage(goteImg, forState: .Normal)
                default:
                    if CanMovePieceArea[i][j] == 1{
                        BoardButton.setImage(areaImg, forState: .Normal)
                    }
                    else{
                        BoardButton.setImage(masuImg, forState: .Normal)
                    }
                }
                self.view.addSubview(BoardButton)
            }
        }
        SenteLabel.text = "先手プレイヤー:"+String(TakePieceNum[0])
        if ComputerFlag == true{
            GoteLabel.text = "後手Enemyさん:"+String(TakePieceNum[1])
        }
        else{
            GoteLabel.text = "後手プレイヤー:"+String(TakePieceNum[1])
        }
        self.view.addSubview(SenteLabel)
        self.view.addSubview(GoteLabel)
        
        TesuLabel.text = String(Tesu+1)+"手目"
        self.view.addSubview(TesuLabel)
        
        if Teban == 0{
            TebanLabel.text = "先手番"
        }
        else{
            TebanLabel.text = "後手番"
        }
        
        self.view.addSubview(TebanLabel)
    }
    
    func MyPieceTapped(sender: UIButton){
        if TapFlag == false{
            FromdanPiece = sender.tag/9
            FromsujiPiece = sender.tag%9
            if PieceBoard[sender.tag/9][sender.tag%9] == 1 && TapFlag == false && Teban == 0{
                TapFlag = true
                sender.setImage(senteChooseImg, forState: .Normal)
                CreateCanMovePos(sender)
            }
            else if PieceBoard[sender.tag/9][sender.tag%9] == 2 && TapFlag == false && Teban == 1{
                TapFlag = true
                sender.setImage(goteChooseImg, forState: .Normal)
                CreateCanMovePos(sender)
            }
            else{
                player = AVAudioPlayer(contentsOfURL: CannotMoveSound, error: nil)
                player.prepareToPlay()
                player.play()
            }
        }
            
        else if TapFlag == true && CanMovePieceArea[sender.tag/9][sender.tag%9] == 1{
            MovePiece(sender)
            TodanPiece = sender.tag/9
            TosujiPiece = sender.tag%9
            CheckTakePiece()
            CheckWin()
            if Teban == 0{
                if (TakePieceNum[Teban] - SaveTakePieceNum[Teban]) > 0{
                    player = AVAudioPlayer(contentsOfURL: GetSound, error: nil)
                    player.prepareToPlay()
                    player.play()
                }
                else{
                    player = AVAudioPlayer(contentsOfURL: SenteMoveSound, error: nil)
                    player.prepareToPlay()
                    player.play()
                }
                Teban = 1
            }
            else{
                if (TakePieceNum[Teban] - SaveTakePieceNum[Teban]) > 0{
                    player = AVAudioPlayer(contentsOfURL: GetSound, error: nil)
                    player.prepareToPlay()
                    player.play()
                }
                else{
                    player = AVAudioPlayer(contentsOfURL: GoteMoveSound, error: nil)
                    player.prepareToPlay()
                    player.play()
                }
                Teban = 0
            }
            CopyBoard()
            Tesu++
            TapFlag = false
            InitCreateCanMovePos()
            
            UpdateMasu()
            
            if ComputerFlag == true && Teban == ComputerTeban{
                //TODO: Enemyの指し手を決定する場所
                CreateRegalCanMove(Teban,SubBoard :PieceBoard)
                var appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as AppDelegate
                if RegalCanMoveCountNum == 0{
                    appDelegate.WinnerTeban = Teban - 1
                    var resultview = ResultViewController()
                    resultview.modalTransitionStyle=UIModalTransitionStyle.CrossDissolve
                    self.presentViewController(resultview, animated: true, completion: nil)
                }
                else{
                    ComputerMovePiece()
                    CheckTakePiece()
                    CheckWin()
                    if Teban == 0{
                        if (TakePieceNum[Teban] - SaveTakePieceNum[Teban]) > 0{
                            player = AVAudioPlayer(contentsOfURL: GetSound, error: nil)
                            player.prepareToPlay()
                            player.play()
                        }
                        else{
                            player = AVAudioPlayer(contentsOfURL: SenteMoveSound, error: nil)
                            player.prepareToPlay()
                            player.play()
                        }
                        Teban = 1
                    }
                    else{
                        if (TakePieceNum[Teban] - SaveTakePieceNum[Teban]) > 0{
                            player = AVAudioPlayer(contentsOfURL: GetSound, error: nil)
                            player.prepareToPlay()
                            player.play()
                        }
                        else{
                            player = AVAudioPlayer(contentsOfURL: GoteMoveSound, error: nil)
                            player.prepareToPlay()
                            player.play()
                        }
                        Teban = 0
                    }
                    CopyBoard()
                    Tesu++
                }
            }
        }
        else{
            player = AVAudioPlayer(contentsOfURL: CannotMoveSound, error: nil)
            player.prepareToPlay()
            player.play()
        }
        UpdateMasu()
    }
    
    func CopyBoard(){
        StepPieceBoard.append(PieceBoard)
        StepTakePieceNum.append(TakePieceNum)
    }
    
    func InitCreateCanMovePos(){
        for i in 0..<9{
            for j in 0..<9{
                CanMovePieceArea[i][j] = 0
            }
        }
    }
    
    func CreateCanMovePos(sender: UIButton){
        for i in sender.tag/9+1..<9{
            if PieceBoard[i][sender.tag%9] != 0{
                break
            }
            if PieceBoard[i][sender.tag%9] == 0{
                CanMovePieceArea[i][sender.tag%9] = 1
            }
        }
        for i in 9-sender.tag/9..<9{
            if PieceBoard[9-i-1][sender.tag%9] != 0{
                break
            }
            if PieceBoard[9-i-1][sender.tag%9] == 0{
                CanMovePieceArea[9-i-1][sender.tag%9] = 1
            }
        }
        for i in sender.tag%9+1..<9{
            if PieceBoard[sender.tag/9][i] != 0{
                break
            }
            if PieceBoard[sender.tag/9][i] == 0{
                CanMovePieceArea[sender.tag/9][i] = 1
            }
        }
        for i in 9-sender.tag%9..<9{
            if PieceBoard[sender.tag/9][9-i-1] != 0{
                break
            }
            if PieceBoard[sender.tag/9][9-i-1] == 0{
                CanMovePieceArea[sender.tag/9][9-i-1] = 1
            }
        }
    }
    
    func MovePiece(sender: UIButton){
        var swapPiece = PieceBoard[sender.tag/9][sender.tag%9]
        PieceBoard[sender.tag/9][sender.tag%9] = PieceBoard[FromdanPiece][FromsujiPiece]
        PieceBoard[FromdanPiece][FromsujiPiece] = swapPiece
    }
    
    func ComputerMovePiece(){
        //ランダム手
        if Computerlevel == 1{
            var randNum = Int(arc4random() % UInt32(RegalCanMoveCountNum))
            FromdanPiece = RegalCanMove[randNum][0]/9
            FromsujiPiece = RegalCanMove[randNum][0]%9
            TodanPiece = RegalCanMove[randNum][1]/9
            TosujiPiece = RegalCanMove[randNum][1]%9
        }
            
            //探索手
        else if Computerlevel == 2{
            var BestNum = MinMaxSearch()
            if BestNum == 0{
                BestNum = Int(arc4random() % UInt32(RegalCanMoveCountNum))
            }
            FromdanPiece = RegalCanMove[BestNum][0]/9
            FromsujiPiece = RegalCanMove[BestNum][0]%9
            TodanPiece = RegalCanMove[BestNum][1]/9
            TosujiPiece = RegalCanMove[BestNum][1]%9
        }
        
        else if Computerlevel == 3{
            var teBuf:[[Int]] = []
            var teNum = 0
            CreateRegalCanMove(Teban, SubBoard :PieceBoard)
            teBuf = RegalCanMove
            teNum = RegalCanMoveCountNum
            RegalCanMove.removeAll()
            RegalCanMoveCountNum = 0
            
            var BestValue = 0
            
            var value = 0
            if Teban == 0{
                BestValue = -200
            }
            else{
                BestValue = 200
            }
            
            var BestNodeNum = 0
            
            for i in 0..<teNum{
                var SubBoard:[[Int]] = PieceBoard
                var fromdan = teBuf[i][0]/9
                var fromsuji = teBuf[i][0]%9
                var todan = teBuf[i][1]/9
                var tosuji = teBuf[i][1]%9
                var swapPiece = SubBoard[todan][tosuji]
                SubBoard[todan][tosuji] = SubBoard[fromdan][fromsuji]
                SubBoard[fromdan][fromsuji] = swapPiece
                Dan = todan
                Suji = tosuji
                SubBoard = SeekForBoardFeature(Teban,SubBoard: SubBoard)
                var v = 0
                if Teban == 0{
                    v = MinMAX(1,SubBoard: SubBoard,Depth: 0,DepthMax: 1)
                }
                else{
                    v = MinMAX(0,SubBoard: SubBoard,Depth: 0,DepthMax: 1)
                }
                if (Teban == 0 && BestValue < v || Teban == 1 && BestValue > v){
                    BestValue = v
                    BestNodeNum = i
                }
            }
            CreateRegalCanMove(Teban, SubBoard: PieceBoard)
            
            if Tesu <= 3{
                BestNodeNum = Int(arc4random() % UInt32(teNum))
            }
            
            FromdanPiece = RegalCanMove[BestNodeNum][0]/9
            FromsujiPiece = RegalCanMove[BestNodeNum][0]%9
            TodanPiece = RegalCanMove[BestNodeNum][1]/9
            TosujiPiece = RegalCanMove[BestNodeNum][1]%9
            SaveBestValue = BestValue
        }
        
        var swapPiece = PieceBoard[TodanPiece][TosujiPiece]
        PieceBoard[TodanPiece][TosujiPiece] = PieceBoard[FromdanPiece][FromsujiPiece]
        PieceBoard[FromdanPiece][FromsujiPiece] = swapPiece
        RegalCanMove.removeAll()
        RegalCanMoveCountNum = 0
    }
    
    func CheckTakePiece(){
        var countOpponentPiece = 0
        SaveTakePieceNum[Teban] = TakePieceNum[Teban]
        
        //上下左右に味方の駒で挟まれているかチェック
        for i in TodanPiece+1..<9{
            if (PieceBoard[i][TosujiPiece] == 1 + Teban){
                var MyPiecePlace = i
                for j in TodanPiece+1..<MyPiecePlace{
                    if PieceBoard[j][TosujiPiece] == 0{
                        break
                    }
                    countOpponentPiece++
                }
                if countOpponentPiece == (MyPiecePlace-TodanPiece-1){
                    for k in TodanPiece+1..<MyPiecePlace{
                        PieceBoard[k][TosujiPiece] = 0
                    }
                    TakePieceNum[Teban] += countOpponentPiece
                }
                break
            }
        }
        
        countOpponentPiece = 0
        
        for i in 9-TodanPiece..<9{
            if (PieceBoard[9-i-1][TosujiPiece] == 1 + Teban){
                var MyPiecePlace = i
                for j in 9-TodanPiece..<MyPiecePlace{
                    if PieceBoard[9-j-1][TosujiPiece] == 0{
                        break
                    }
                    countOpponentPiece++
                }
                if countOpponentPiece == (MyPiecePlace-9+TodanPiece){
                    for k in 9-TodanPiece..<MyPiecePlace{
                        PieceBoard[9-k-1][TosujiPiece] = 0
                    }
                    TakePieceNum[Teban] += countOpponentPiece
                }
                break
            }
        }
        
        countOpponentPiece = 0
        
        for i in TosujiPiece+1..<9{
            if (PieceBoard[TodanPiece][i] == 1 + Teban){
                var MyPiecePlace = i
                for j in TosujiPiece+1..<MyPiecePlace{
                    if PieceBoard[TodanPiece][j] == 0{
                        break
                    }
                    countOpponentPiece++
                }
                if countOpponentPiece == (MyPiecePlace-TosujiPiece-1){
                    for k in TosujiPiece+1..<MyPiecePlace{
                        PieceBoard[TodanPiece][k] = 0
                    }
                    TakePieceNum[Teban] += countOpponentPiece
                }
                break
            }
        }
        
        countOpponentPiece = 0
        
        for i in 9-TosujiPiece..<9{
            if (PieceBoard[TodanPiece][9-i-1] == 1 + Teban){
                var MyPiecePlace = i
                for j in 9-TosujiPiece..<MyPiecePlace{
                    if PieceBoard[TodanPiece][9-j-1] == 0{
                        break
                    }
                    countOpponentPiece++
                }
                if countOpponentPiece == (MyPiecePlace-9+TosujiPiece){
                    for k in 9-TosujiPiece..<MyPiecePlace{
                        PieceBoard[TodanPiece][9-k-1] = 0
                    }
                    TakePieceNum[Teban] += countOpponentPiece
                }
                break
            }
        }
        
        //端で相手の駒が挟まれているかチェック
        
        countOpponentPiece = 0
        var kakomiNum = 0
        
        for i in TodanPiece+1..<9{
            if (PieceBoard[i][TosujiPiece] == 2 - Teban){
                countOpponentPiece++
            }
            if (i == 8 && (9 - TodanPiece - 1) == countOpponentPiece){
                if ((TosujiPiece - 1) >= 0 && (TosujiPiece + 1) <= 8){//左右に壁があるとき
                    for j in 0..<countOpponentPiece{
                        if (PieceBoard[TodanPiece + j + 1][TosujiPiece + 1] == 1 + Teban && PieceBoard[TodanPiece + j + 1][TosujiPiece - 1] == 1 + Teban){
                            kakomiNum++
                        }
                    }
                }
                else if ((TosujiPiece - 1) < 0 && (TosujiPiece + 1) <= 8){//左は壁かつ右は壁でないとき
                    for j in 0..<countOpponentPiece{
                        if (PieceBoard[TodanPiece + j + 1][TosujiPiece + 1] == 1 + Teban){
                            kakomiNum++
                        }
                    }
                }
                else if ((TosujiPiece - 1) >= 0 && (TosujiPiece + 1) > 8){//左は壁かつ右は壁でないとき
                    for j in 0..<countOpponentPiece{
                        if (PieceBoard[TodanPiece + j + 1][TosujiPiece - 1] == 1 + Teban){
                            kakomiNum++
                        }
                    }
                }
                if kakomiNum == countOpponentPiece{
                    for k in 0..<kakomiNum{
                        PieceBoard[TodanPiece + 1 + k][TosujiPiece] = 0
                    }
                    TakePieceNum[Teban] += kakomiNum
                    break
                }
            }
        }
        
        countOpponentPiece = 0
        kakomiNum = 0
        
        for i in 9-TodanPiece..<9{
            if (PieceBoard[9 - i - 1][TosujiPiece] == 2 - Teban){
                countOpponentPiece++
            }
            if (i == 8 && TodanPiece == countOpponentPiece ){
                if ((TosujiPiece - 1) >= 0 && (TosujiPiece + 1) <= 8){//左右に壁がないとき
                    for j in 0..<countOpponentPiece{
                        if (PieceBoard[TodanPiece - j - 1][TosujiPiece + 1] == 1 + Teban && PieceBoard[TodanPiece - j - 1][TosujiPiece - 1] == 1 + Teban){
                            kakomiNum++
                        }
                    }
                }
                else if ((TosujiPiece - 1) < 0 && (TosujiPiece + 1) <= 8){//左は壁かつ右は壁でないとき
                    for j in 0..<countOpponentPiece{
                        if (PieceBoard[TodanPiece - j - 1][TosujiPiece + 1] == 1 + Teban){
                            kakomiNum++
                        }
                    }
                }
                else if ((TosujiPiece - 1) >= 0 && (TosujiPiece + 1) > 8){//左は壁かつ右は壁でないとき
                    for j in 0..<countOpponentPiece{
                        if (PieceBoard[TodanPiece - j - 1][TosujiPiece - 1] == 1 + Teban){
                            kakomiNum++
                        }
                    }
                }
                if kakomiNum == countOpponentPiece{
                    for k in 0..<kakomiNum{
                        PieceBoard[TodanPiece - k - 1][TosujiPiece] = 0
                    }
                    TakePieceNum[Teban] += kakomiNum
                    break
                }
            }
        }
        
        countOpponentPiece = 0
        kakomiNum = 0
        
        for i in TosujiPiece+1..<9{
            if (PieceBoard[TodanPiece][i] == 2 - Teban){
                countOpponentPiece++
            }
            if (i == 8 && (9 - TosujiPiece - 1) == countOpponentPiece){
                if ((TodanPiece - 1) >= 0 && (TodanPiece + 1) <= 8){//上下に壁がないとき
                    for j in 0..<countOpponentPiece{
                        if (PieceBoard[TodanPiece + 1][TosujiPiece + j + 1] == 1 + Teban && PieceBoard[TodanPiece - 1][TosujiPiece + j + 1] == 1 + Teban){
                            kakomiNum++
                        }
                    }
                }
                else if ((TodanPiece - 1) < 0 && (TodanPiece + 1) <= 8){//上は壁かつ下は壁でないとき
                    for j in 0..<countOpponentPiece{
                        if (PieceBoard[TodanPiece + 1][TosujiPiece + j + 1] == 1 + Teban){
                            kakomiNum++
                        }
                    }
                }
                else if ((TodanPiece - 1) >= 0 && (TodanPiece + 1) > 8){//下は壁かつ上は壁でないとき
                    for j in 0..<countOpponentPiece{
                        if (PieceBoard[TodanPiece - 1][TosujiPiece + j + 1] == 1 + Teban){
                            kakomiNum++
                        }
                    }
                }
                if kakomiNum == countOpponentPiece{
                    for k in 0..<kakomiNum{
                        PieceBoard[TodanPiece][TosujiPiece + k + 1] = 0
                    }
                    TakePieceNum[Teban] += kakomiNum
                    break
                }
            }
        }
        
        countOpponentPiece = 0
        kakomiNum = 0
        
        for i in 9-TosujiPiece..<9{
            if (PieceBoard[TodanPiece][9 - i - 1] == 2 - Teban){
                countOpponentPiece++
            }
            if (i == 8 && TosujiPiece == countOpponentPiece){
                if ((TodanPiece - 1) >= 0 && (TodanPiece + 1) <= 8){//上下に壁がないとき
                    for j in 0..<countOpponentPiece{
                        if (PieceBoard[TodanPiece + 1][TosujiPiece - j - 1] == 1 + Teban && PieceBoard[TodanPiece - 1][TosujiPiece - j - 1] == 1 + Teban){
                            kakomiNum++
                        }
                    }
                }
                else if ((TodanPiece - 1) < 0 && (TodanPiece + 1) <= 8){//上は壁かつ下は壁でないとき
                    for j in 0..<countOpponentPiece{
                        if (PieceBoard[TodanPiece + 1][TosujiPiece - j - 1] == 1 + Teban){
                            kakomiNum++
                        }
                    }
                }
                else if ((TodanPiece - 1) >= 0 && (TodanPiece + 1) > 8){//下は壁かつ上は壁でないとき
                    for j in 0..<countOpponentPiece{
                        if (PieceBoard[TodanPiece - 1][TosujiPiece - j - 1] == 1 + Teban){
                            kakomiNum++
                        }
                    }
                }
                if kakomiNum == countOpponentPiece{
                    for k in 0..<kakomiNum{
                        PieceBoard[TodanPiece][TosujiPiece - k - 1] = 0
                    }
                    TakePieceNum[Teban] += kakomiNum
                    break
                }
            }
        }
    }
    
    func CreateRegalCanMove(SorE :Int,var SubBoard :[[Int]]){
        RegalCanMoveCountNum = 0
        for i in 0..<9{
            for j in 0..<9{
                if SubBoard[i][j] == SorE + 1{
                    for k in i+1..<9{
                        if PieceBoard[k][j] != 0{
                            break
                        }
                        if SubBoard[k][j] == 0{
                            ComputerFromToPair[0] = i*9 + j
                            ComputerFromToPair[1] = k*9 + j
                            RegalCanMove.append(ComputerFromToPair)
                            RegalCanMoveCountNum++
                        }
                    }
                    for k in 9-i..<9{
                        if SubBoard[9-k-1][j] != 0{
                            break
                        }
                        if SubBoard[9-k-1][j] == 0{
                            ComputerFromToPair[0] = i*9 + j
                            ComputerFromToPair[1] = (9-k-1)*9 + j
                            RegalCanMove.append(ComputerFromToPair)
                            RegalCanMoveCountNum++
                        }
                    }
                    for k in j+1..<9{
                        if SubBoard[i][k] != 0{
                            break
                        }
                        if SubBoard[i][k] == 0{
                            ComputerFromToPair[0] = i*9 + j
                            ComputerFromToPair[1] = i*9 + k
                            RegalCanMove.append(ComputerFromToPair)
                            RegalCanMoveCountNum++
                        }
                    }
                    for k in 9-j..<9{
                        if SubBoard[i][9-k-1] != 0{
                            break
                        }
                        if SubBoard[i][9-k-1] == 0{
                            ComputerFromToPair[0] = i*9 + j
                            ComputerFromToPair[1] = i*9 + (9-k-1)
                            RegalCanMove.append(ComputerFromToPair)
                            RegalCanMoveCountNum++
                        }
                    }
                }
            }
        }
        ComputerFromToPair.removeAll()
        ComputerFromToPair = [0,0]
    }
    
    func MinMaxSearch()-> (Int){
        var Value:[Int] = []
        var BestNum = 0
        for i in 0..<RegalCanMoveCountNum{
            PieceBoardForSearch.append(PieceBoard)
            var swapPiece = PieceBoardForSearch[0][RegalCanMove[i][1]/9][RegalCanMove[i][1]%9]
            PieceBoardForSearch[0][RegalCanMove[i][1]/9][RegalCanMove[i][1]%9] = PieceBoardForSearch[0][RegalCanMove[i][0]/9][RegalCanMove[i][0]%9]
            PieceBoardForSearch[0][RegalCanMove[i][0]/9][RegalCanMove[i][0]%9] = swapPiece
            Dan = RegalCanMove[i][1]/9
            Suji = RegalCanMove[i][1]%9
            SeekBoardFeature()
            Value.append(Weight[0]*Feature[0])
            PieceBoardForSearch.removeLast()
        }
        for i in 1..<RegalCanMoveCountNum{
            if Value[i-1] < Value[i]{
                BestNum = i
            }
        }
        return BestNum
    }
    
    func MinMAX(SorE :Int,var SubBoard :[[Int]],Depth :Int,DepthMax :Int) -> (Int){
        var teBuf:[[Int]] = []
        var teNum = 0
        if Depth >= DepthMax{
            Value(SubBoard)
            return Weight[0]*Feature[0]
        }
        CreateRegalCanMove(SorE, SubBoard :SubBoard)
        teBuf = RegalCanMove
        teNum = RegalCanMoveCountNum
        RegalCanMove.removeAll()
        RegalCanMoveCountNum = 0
        
        if teNum == 0{
            if SorE == 0{
                return -300
            }
            else{
                return 300
            }
        }
        
        var value = 0
        if SorE == 0{
            value = -200
        }
        else{
            value = 200
        }
        for i in 0..<teNum{
            var fromdan = teBuf[i][0]/9
            var fromsuji = teBuf[i][0]%9
            var todan = teBuf[i][1]/9
            var tosuji = teBuf[i][1]%9
            var SubSubBoard = SubBoard
            var swapPiece = SubSubBoard[todan][tosuji]
            SubSubBoard[todan][tosuji] = SubSubBoard[fromdan][fromsuji]
            SubSubBoard[fromdan][fromsuji] = swapPiece
            Dan = todan
            Suji = tosuji
            SubSubBoard = SeekForBoardFeature(SorE,SubBoard: SubSubBoard)
            var v = 0
            if SorE == 0{
                v = MinMAX(1,SubBoard: SubSubBoard,Depth: Depth+1,DepthMax: DepthMax)
            }
            else{
                v = MinMAX(0,SubBoard: SubSubBoard,Depth: Depth+1,DepthMax: DepthMax)
            }
            
            if (SorE == 0 && v > value) || (SorE == 1 && v < value){
                value = v
            }
        }
        return value
    }
    
    func Value(SubBoard :[[Int]]){
        var value = 0
        var SentePieceNum = 0
        var GotePieceNum = 0
        for i in 0..<9{
            for j in 0..<9{
                switch (SubBoard[i][j]){
                case 1:
                    SentePieceNum++
                case 2:
                    GotePieceNum++
                default:
                    break
                }
            }
        }
        Feature[0] = SentePieceNum - GotePieceNum
    }
    
    func SeekBoardFeature(){
        var countOpponentPiece = 0
        var TakePieceNumforSearch:[Int] = [0,0]
        
        //上下左右に味方の駒で挟まれているかチェック
        for i in Dan+1..<9{
            if (PieceBoardForSearch[0][i][Suji] == 1 + Teban){
                var MyPiecePlace = i
                for j in Dan+1..<MyPiecePlace{
                    if PieceBoardForSearch[0][j][Suji] == 0{
                        break
                    }
                    countOpponentPiece++
                }
                if countOpponentPiece == (MyPiecePlace-Dan-1){
                    for k in Dan+1..<MyPiecePlace{
                        PieceBoardForSearch[0][k][Suji] = 0
                    }
                    TakePieceNumforSearch[Teban] += countOpponentPiece
                }
                break
            }
        }
        
        countOpponentPiece = 0
        
        for i in 9-Dan..<9{
            if (PieceBoardForSearch[0][9-i-1][Suji] == 1 + Teban){
                var MyPiecePlace = i
                for j in 9-Dan..<MyPiecePlace{
                    if PieceBoardForSearch[0][9-j-1][Suji] == 0{
                        break
                    }
                    countOpponentPiece++
                }
                if countOpponentPiece == (MyPiecePlace-9+Dan){
                    for k in 9-Dan..<MyPiecePlace{
                        PieceBoardForSearch[0][9-k-1][Suji] = 0
                    }
                    TakePieceNumforSearch[Teban] += countOpponentPiece
                }
                break
            }
        }
        
        countOpponentPiece = 0
        
        for i in Suji+1..<9{
            if (PieceBoardForSearch[0][Dan][i] == 1 + Teban){
                var MyPiecePlace = i
                for j in Suji+1..<MyPiecePlace{
                    if PieceBoardForSearch[0][Dan][j] == 0{
                        break
                    }
                    countOpponentPiece++
                }
                if countOpponentPiece == (MyPiecePlace-Suji-1){
                    for k in Suji+1..<MyPiecePlace{
                        PieceBoardForSearch[0][Dan][k] = 0
                    }
                    TakePieceNumforSearch[Teban] += countOpponentPiece
                }
                break
            }
        }
        
        countOpponentPiece = 0
        
        for i in 9-Suji..<9{
            if (PieceBoardForSearch[0][Dan][9-i-1] == 1 + Teban){
                var MyPiecePlace = i
                for j in 9-Suji..<MyPiecePlace{
                    if PieceBoardForSearch[0][Dan][9-j-1] == 0{
                        break
                    }
                    countOpponentPiece++
                }
                if countOpponentPiece == (MyPiecePlace-9+Suji){
                    for k in 9-Suji..<MyPiecePlace{
                        PieceBoardForSearch[0][Dan][9-k-1] = 0
                    }
                    TakePieceNumforSearch[Teban] += countOpponentPiece
                }
                break
            }
        }
        
        //端で相手の駒が挟まれているかチェック
        
        countOpponentPiece = 0
        var kakomiNum = 0
        
        for i in Dan+1..<9{
            if (PieceBoardForSearch[0][i][Suji] == 2 - Teban){
                countOpponentPiece++
            }
            if (i == 8 && (9 - Dan - 1) == countOpponentPiece){
                if ((Suji - 1) >= 0 && (Suji + 1) <= 8){//左右に壁があるとき
                    for j in 0..<countOpponentPiece{
                        if PieceBoardForSearch[0][Dan + j + 1][Suji + 1] == 1 + Teban{
                            kakomiNum++
                        }
                    }
                }
                else if ((Suji - 1) < 0 && (Suji + 1) <= 8){//左は壁かつ右は壁でないとき
                    for j in 0..<countOpponentPiece{
                        if (PieceBoardForSearch[0][Dan + j + 1][Suji + 1] == 1 + Teban){
                            kakomiNum++
                        }
                    }
                }
                else if ((Suji - 1) >= 0 && (Suji + 1) > 8){//左は壁かつ右は壁でないとき
                    for j in 0..<countOpponentPiece{
                        if (PieceBoardForSearch[0][Dan + j + 1][Suji - 1] == 1 + Teban){
                            kakomiNum++
                        }
                    }
                }
                if kakomiNum == countOpponentPiece{
                    for k in 0..<kakomiNum{
                        PieceBoardForSearch[0][Dan + 1 + k][Suji] = 0
                    }
                    TakePieceNumforSearch[Teban] += kakomiNum
                    break
                }
            }
        }
        
        countOpponentPiece = 0
        kakomiNum = 0
        
        for i in 9-Dan..<9{
            if (PieceBoardForSearch[0][9 - i - 1][Suji] == 2 - Teban){
                countOpponentPiece++
            }
            if (i == 8 && Dan == countOpponentPiece ){
                if ((Suji - 1) >= 0 && (Suji + 1) <= 8){//左右に壁がないとき
                    for j in 0..<countOpponentPiece{
                        if PieceBoardForSearch[0][Dan - j - 1][Suji + 1] == 1 + Teban{
                            kakomiNum++
                        }
                    }
                }
                else if ((Suji - 1) < 0 && (Suji + 1) <= 8){//左は壁かつ右は壁でないとき
                    for j in 0..<countOpponentPiece{
                        if (PieceBoardForSearch[0][Dan - j - 1][Suji + 1] == 1 + Teban){
                            kakomiNum++
                        }
                    }
                }
                else if ((Suji - 1) >= 0 && (Suji + 1) > 8){//左は壁かつ右は壁でないとき
                    for j in 0..<countOpponentPiece{
                        if (PieceBoardForSearch[0][Dan - j - 1][Suji - 1] == 1 + Teban){
                            kakomiNum++
                        }
                    }
                }
                if kakomiNum == countOpponentPiece{
                    for k in 0..<kakomiNum{
                        PieceBoardForSearch[0][Dan - k - 1][Suji] = 0
                    }
                    TakePieceNumforSearch[Teban] += kakomiNum
                    break
                }
            }
        }
        
        countOpponentPiece = 0
        kakomiNum = 0
        
        for i in Suji+1..<9{
            if (PieceBoardForSearch[0][Dan][i] == 2 - Teban){
                countOpponentPiece++
            }
            if (i == 8 && (9 - Suji - 1) == countOpponentPiece){
                if ((Dan - 1) >= 0 && (Dan + 1) <= 8){//上下に壁がないとき
                    for j in 0..<countOpponentPiece{
                        if PieceBoardForSearch[0][Dan + 1][Suji + j + 1] == 1 + Teban{
                            kakomiNum++
                        }
                    }
                }
                else if ((Dan - 1) < 0 && (Dan + 1) <= 8){//上は壁かつ下は壁でないとき
                    for j in 0..<countOpponentPiece{
                        if (PieceBoardForSearch[0][Dan + 1][Suji + j + 1] == 1 + Teban){
                            kakomiNum++
                        }
                    }
                }
                else if ((Dan - 1) >= 0 && (Dan + 1) > 8){//下は壁かつ上は壁でないとき
                    for j in 0..<countOpponentPiece{
                        if (PieceBoardForSearch[0][Dan - 1][Suji + j + 1] == 1 + Teban){
                            kakomiNum++
                        }
                    }
                }
                if kakomiNum == countOpponentPiece{
                    for k in 0..<kakomiNum{
                        PieceBoardForSearch[0][Dan][Suji + k + 1] = 0
                    }
                    TakePieceNumforSearch[Teban] += kakomiNum
                    break
                }
            }
        }
        
        countOpponentPiece = 0
        kakomiNum = 0
        
        for i in 9-Suji..<9{
            if (PieceBoardForSearch[0][Dan][9 - i - 1] == 2 - Teban){
                countOpponentPiece++
            }
            if (i == 8 && Suji == countOpponentPiece){
                if ((Dan - 1) >= 0 && (Dan + 1) <= 8){//上下に壁がないとき
                    for j in 0..<countOpponentPiece{
                        if PieceBoardForSearch[0][Dan + 1][Suji - j - 1] == 1 + Teban{
                            kakomiNum++
                        }
                    }
                }
                else if ((Dan - 1) < 0 && (Dan + 1) <= 8){//上は壁かつ下は壁でないとき
                    for j in 0..<countOpponentPiece{
                        if (PieceBoardForSearch[0][Dan + 1][Suji - j - 1] == 1 + Teban){
                            kakomiNum++
                        }
                    }
                }
                else if ((Dan - 1) >= 0 && (Dan + 1) > 8){//下は壁かつ上は壁でないとき
                    for j in 0..<countOpponentPiece{
                        if (PieceBoardForSearch[0][Dan - 1][Suji - j - 1] == 1 + Teban){
                            kakomiNum++
                        }
                    }
                }
                if kakomiNum == countOpponentPiece{
                    for k in 0..<kakomiNum{
                        PieceBoardForSearch[0][Dan][Suji - k - 1] = 0
                    }
                    TakePieceNumforSearch[Teban] += kakomiNum
                    break
                }
            }
        }
        Feature[0] = TakePieceNumforSearch[1] - TakePieceNumforSearch[0]
    }
    
    func SeekForBoardFeature(SorE :Int,var SubBoard :[[Int]]) -> ([[Int]]){
        var countOpponentPiece = 0
        var TakePieceNumforSearch:[Int] = [0,0]
        
        //上下左右に味方の駒で挟まれているかチェック
        for i in Dan+1..<9{
            if (SubBoard[i][Suji] == 1 + SorE){
                var MyPiecePlace = i
                for j in Dan+1..<MyPiecePlace{
                    if SubBoard[j][Suji] == 0{
                        break
                    }
                    countOpponentPiece++
                }
                if countOpponentPiece == (MyPiecePlace-Dan-1){
                    for k in Dan+1..<MyPiecePlace{
                        SubBoard[k][Suji] = 0
                    }
                    TakePieceNumforSearch[SorE] += countOpponentPiece
                }
                break
            }
        }
        
        countOpponentPiece = 0
        
        for i in 9-Dan..<9{
            if (SubBoard[9-i-1][Suji] == 1 + SorE){
                var MyPiecePlace = i
                for j in 9-Dan..<MyPiecePlace{
                    if SubBoard[9-j-1][Suji] == 0{
                        break
                    }
                    countOpponentPiece++
                }
                if countOpponentPiece == (MyPiecePlace-9+Dan){
                    for k in 9-Dan..<MyPiecePlace{
                        SubBoard[9-k-1][Suji] = 0
                    }
                    TakePieceNumforSearch[SorE] += countOpponentPiece
                }
                break
            }
        }
        
        countOpponentPiece = 0
        
        for i in Suji+1..<9{
            if (SubBoard[Dan][i] == 1 + SorE){
                var MyPiecePlace = i
                for j in Suji+1..<MyPiecePlace{
                    if SubBoard[Dan][j] == 0{
                        break
                    }
                    countOpponentPiece++
                }
                if countOpponentPiece == (MyPiecePlace-Suji-1){
                    for k in Suji+1..<MyPiecePlace{
                        SubBoard[Dan][k] = 0
                    }
                    TakePieceNumforSearch[SorE] += countOpponentPiece
                }
                break
            }
        }
        
        countOpponentPiece = 0
        
        for i in 9-Suji..<9{
            if (SubBoard[Dan][9-i-1] == 1 + SorE){
                var MyPiecePlace = i
                for j in 9-Suji..<MyPiecePlace{
                    if SubBoard[Dan][9-j-1] == 0{
                        break
                    }
                    countOpponentPiece++
                }
                if countOpponentPiece == (MyPiecePlace-9+Suji){
                    for k in 9-Suji..<MyPiecePlace{
                        SubBoard[Dan][9-k-1] = 0
                    }
                    TakePieceNumforSearch[SorE] += countOpponentPiece
                }
                break
            }
        }
        
        //端で相手の駒が挟まれているかチェック
        
        countOpponentPiece = 0
        var kakomiNum = 0
        
        for i in Dan+1..<9{
            if (SubBoard[i][Suji] == 2 - SorE){
                countOpponentPiece++
            }
            if (i == 8 && (9 - Dan - 1) == countOpponentPiece){
                if ((Suji - 1) >= 0 && (Suji + 1) <= 8){//左右に壁があるとき
                    for j in 0..<countOpponentPiece{
                        if SubBoard[Dan + j + 1][Suji + 1] == 1 + SorE{
                            kakomiNum++
                        }
                    }
                }
                else if ((Suji - 1) < 0 && (Suji + 1) <= 8){//左は壁かつ右は壁でないとき
                    for j in 0..<countOpponentPiece{
                        if (SubBoard[Dan + j + 1][Suji + 1] == 1 + SorE){
                            kakomiNum++
                        }
                    }
                }
                else if ((Suji - 1) >= 0 && (Suji + 1) > 8){//左は壁かつ右は壁でないとき
                    for j in 0..<countOpponentPiece{
                        if (SubBoard[Dan + j + 1][Suji - 1] == 1 + SorE){
                            kakomiNum++
                        }
                    }
                }
                if kakomiNum == countOpponentPiece{
                    for k in 0..<kakomiNum{
                        SubBoard[Dan + 1 + k][Suji] = 0
                    }
                    TakePieceNumforSearch[SorE] += kakomiNum
                    break
                }
            }
        }
        
        countOpponentPiece = 0
        kakomiNum = 0
        
        for i in 9-Dan..<9{
            if (SubBoard[9 - i - 1][Suji] == 2 - SorE){
                countOpponentPiece++
            }
            if (i == 8 && Dan == countOpponentPiece ){
                if ((Suji - 1) >= 0 && (Suji + 1) <= 8){//左右に壁がないとき
                    for j in 0..<countOpponentPiece{
                        if SubBoard[Dan - j - 1][Suji + 1] == 1 + SorE{
                            kakomiNum++
                        }
                    }
                }
                else if ((Suji - 1) < 0 && (Suji + 1) <= 8){//左は壁かつ右は壁でないとき
                    for j in 0..<countOpponentPiece{
                        if (SubBoard[Dan - j - 1][Suji + 1] == 1 + SorE){
                            kakomiNum++
                        }
                    }
                }
                else if ((Suji - 1) >= 0 && (Suji + 1) > 8){//左は壁かつ右は壁でないとき
                    for j in 0..<countOpponentPiece{
                        if (SubBoard[Dan - j - 1][Suji - 1] == 1 + SorE){
                            kakomiNum++
                        }
                    }
                }
                if kakomiNum == countOpponentPiece{
                    for k in 0..<kakomiNum{
                        SubBoard[Dan - k - 1][Suji] = 0
                    }
                    TakePieceNumforSearch[SorE] += kakomiNum
                    break
                }
            }
        }
        
        countOpponentPiece = 0
        kakomiNum = 0
        
        for i in Suji+1..<9{
            if (SubBoard[Dan][i] == 2 - SorE){
                countOpponentPiece++
            }
            if (i == 8 && (9 - Suji - 1) == countOpponentPiece){
                if ((Dan - 1) >= 0 && (Dan + 1) <= 8){//上下に壁がないとき
                    for j in 0..<countOpponentPiece{
                        if SubBoard[Dan + 1][Suji + j + 1] == 1 + SorE{
                            kakomiNum++
                        }
                    }
                }
                else if ((Dan - 1) < 0 && (Dan + 1) <= 8){//上は壁かつ下は壁でないとき
                    for j in 0..<countOpponentPiece{
                        if (SubBoard[Dan + 1][Suji + j + 1] == 1 + SorE){
                            kakomiNum++
                        }
                    }
                }
                else if ((Dan - 1) >= 0 && (Dan + 1) > 8){//下は壁かつ上は壁でないとき
                    for j in 0..<countOpponentPiece{
                        if (SubBoard[Dan - 1][Suji + j + 1] == 1 + SorE){
                            kakomiNum++
                        }
                    }
                }
                if kakomiNum == countOpponentPiece{
                    for k in 0..<kakomiNum{
                        SubBoard[Dan][Suji + k + 1] = 0
                    }
                    TakePieceNumforSearch[SorE] += kakomiNum
                    break
                }
            }
        }
        
        countOpponentPiece = 0
        kakomiNum = 0
        
        for i in 9-Suji..<9{
            if (SubBoard[Dan][9 - i - 1] == 2 - SorE){
                countOpponentPiece++
            }
            if (i == 8 && Suji == countOpponentPiece){
                if ((Dan - 1) >= 0 && (Dan + 1) <= 8){//上下に壁がないとき
                    for j in 0..<countOpponentPiece{
                        if SubBoard[Dan + 1][Suji - j - 1] == 1 + SorE{
                            kakomiNum++
                        }
                    }
                }
                else if ((Dan - 1) < 0 && (Dan + 1) <= 8){//上は壁かつ下は壁でないとき
                    for j in 0..<countOpponentPiece{
                        if (SubBoard[Dan + 1][Suji - j - 1] == 1 + SorE){
                            kakomiNum++
                        }
                    }
                }
                else if ((Dan - 1) >= 0 && (Dan + 1) > 8){//下は壁かつ上は壁でないとき
                    for j in 0..<countOpponentPiece{
                        if (SubBoard[Dan - 1][Suji - j - 1] == 1 + SorE){
                            kakomiNum++
                        }
                    }
                }
                if kakomiNum == countOpponentPiece{
                    for k in 0..<kakomiNum{
                        SubBoard[Dan][Suji - k - 1] = 0
                    }
                    TakePieceNumforSearch[SorE] += kakomiNum
                    break
                }
            }
        }
        return SubBoard
    }

    
    func CheckWin(){
        var appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        
        if TakePieceNum[Teban] >= 5{
            //先手もしくは後手勝ち
            appDelegate.WinnerTeban = Teban
            var resultview = ResultViewController()
            resultview.modalTransitionStyle=UIModalTransitionStyle.CrossDissolve
            self.presentViewController(resultview, animated: true, completion: nil)
        }
        if Teban == 0 && (TakePieceNum[1] - TakePieceNum[0]) >= 3{
            //後手勝ち
            appDelegate.WinnerTeban = 1
            var resultview = ResultViewController()
            resultview.modalTransitionStyle=UIModalTransitionStyle.CrossDissolve
            self.presentViewController(resultview, animated: true, completion: nil)
        }
        else if Teban == 1 && (TakePieceNum[0] - TakePieceNum[1]) >= 3{
            //先手勝ち
            appDelegate.WinnerTeban = 0
            var resultview = ResultViewController()
            resultview.modalTransitionStyle=UIModalTransitionStyle.CrossDissolve
            self.presentViewController(resultview, animated: true, completion: nil)
        }
    }
}
