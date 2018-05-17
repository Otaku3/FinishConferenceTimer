//
//  TimerViewController.swift
//  FinishConferenceTimer
//
//  Created by 大林拓実 on 2018/04/24.
//  Copyright © 2018年 Life is tech. All rights reserved.
//

import UIKit
import AudioToolbox

class TimerViewController: UIViewController {
    
    @IBOutlet var ConferenceNameLabel: UILabel!     //会議名のラベル
    @IBOutlet var CurrentAgendaNameLabel: UILabel!  //今の議題名のラベル
    @IBOutlet var NextAgendaNameLabel: UILabel!     //次の議題名のラベル
    @IBOutlet var ConferenceTimerLabel: UILabel!    //会議時間タイマーのラベル
    @IBOutlet var AgendaTimerLabel: UILabel!        //議題時間タイマーのラベル
    
    @IBOutlet var PauseButton: UIButton!   //一時停止ボタン
    @IBOutlet var SkipButton: UIButton!    //スキップボタン
    
    let saveData = UserDefaults.standard
    var AgendaNameList: [String] = []   //UserDefaultから読み込む議題名のString型配列
    var DiscussTimeList: [Int] = []     //UserDefaultから読み込む議論時間のInt型配列(秒)

    var ConferenceNamefrom:String = ""  //ConferenceViewから会議名を受け取る変数
    
    @IBOutlet var AgendaProgressBar: UIProgressView!
    
    //使用するタイマーの宣言
    var ConferenceTimer = Timer()
    var AgendaTimer = Timer()
    var RepeatTimer = Timer()
    
    
    //会議合計時間(秒)の計算メソッド
    func CalcTotalTime() -> Int{
        var TotalTime: Int = 0
        for i in currentDiscuss..<DiscussTimeList.count {
            TotalTime += DiscussTimeList[i]
        }
        return TotalTime
    }
    
    //一時停止or再開ボタンのメソッド
    @IBAction func tappedPauseButton() {
        if ConferenceTimer.isValid || AgendaTimer.isValid {
            //停止処理
            ConferenceTimer.invalidate()
            AgendaTimer.invalidate()
            PauseButton.setTitle("再開", for: .normal)    //ボタンテキスト変更
            
        }
        else{
            //再開処理
            
            //currentDiscussの行き過ぎ防止
            if currentDiscuss > DiscussTimeList.count{
                currentDiscuss = DiscussTimeList.count - 1
            }
            PastTime +=  (DiscussTimeList[currentDiscuss] -  AgendaLeftTime)   //今までの経過時間を記録
            DiscussTimeList[currentDiscuss] = AgendaLeftTime    //現在の議題の残り時間を更新
            ConferenceTimerStart()  //再スタート
            AgendaTimerStart()      //再スタート
            PauseButton.setTitle("休憩", for: .normal)  //ボタンテキスト変更
            
        }
    }
    
    //次の議題へスキップするメソッド
    @IBAction func skipButton() {
        if currentDiscuss == DiscussTimeList.count - 1{    //最後の議題の場合：終了処理
            //アラートを出してタイトル画面へ戻る
            let alert: UIAlertController = UIAlertController(title: "終了しますか？", message: "タイトル画面へ戻ります", preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "はい", style: .default, handler: {(action: UIAlertAction!)in
                //アラートが消えるのと重ならないように0.5秒後に遷移
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){
                    self.performSegue(withIdentifier: "toTitleView", sender: nil)
                }
            }
            )
            let cancelAction: UIAlertAction = UIAlertAction(title: "いいえ", style: .destructive, handler: nil)
            alert.addAction(okAction)
            alert.addAction(cancelAction)
            self.present(alert, animated: true, completion: nil)
        }
        else if currentDiscuss < DiscussTimeList.count - 1{  //スキップ処理
            currentDiscuss += 1
            ConferenceTimer.invalidate()
            AgendaTimer.invalidate()
            AgendaLeftTime = 0
            ConferenceTimerStart()
            AgendaTimerStart()
            PauseButton.setTitle("休憩", for: .normal)
        }
    }
    
    //////////////////////////////////////////会議時間タイマー///////////////////////////////////////////////
    
    //タイマーをスタートさせるメソッド
    func ConferenceTimerStart(){
        //開始時刻を記録
        let startTime = Date()
        //終了時刻を計算
        let finishDateC = Date(timeInterval: TimeInterval(CalcTotalTime()), since: startTime as Date)
        //0.01秒ごとにupdatelabel()を呼び出す      //finishDateを引数でupdatelabelに渡したいけど直接じゃ無理ぽいのでuserinfo経由
        ConferenceTimer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(updateClabel), userInfo: finishDateC, repeats: true)
    }
    
    //表示を更新させるメソッド
    @objc func updateClabel(_ finishDateC: Timer) {
        let FinishDate: Date = finishDateC.userInfo as! Date
        //残り時間を終了時刻ー現在時刻で取得(秒)
        let ConferenceLeftTime = Int(FinishDate.timeIntervalSinceNow)
        //表示形式に加工
        let leftHour = ConferenceLeftTime / (60 * 60)
        let leftMin = (ConferenceLeftTime - leftHour * 60 * 60) / 60
//        let leftSec = ConferenceLeftTime - leftMin * minSec
//        let displayString = NSString(format: "%02d:%02d", leftMin, leftSec)
        let displayString = String(leftHour) + " 時間 " + String(leftMin) + " 分"
        ConferenceTimerLabel.text = displayString as String
        
        //終了処理
        if ConferenceLeftTime == 0 {
            let soundIDRing: SystemSoundID = 1005
            AudioServicesPlaySystemSound(soundIDRing)
            ConferenceTimer.invalidate()
        }
    }

    
    //////////////////////////////////////////議題時間タイマー//////////////////////////////////////////////
    var AgendaLeftTime :Int = 0 //残り秒数
    var currentDiscuss :Int = 0 //現在の議題を取り出すための変数
    var PastTime :Int = 0   //経過時間記録(progress bar用，一時停止した際に分母を一定にするため利用する)
    var ProgressLeft :Float = 1.0 // progress bar用，分子を独立して記録させる
    var ProgressStandard :Int = 0 // progress bar用，分母
    
    //タイマーをスタートさせるメソッド
    @objc func AgendaTimerStart() {
        
        //開始時刻を記録
        let startTime = Date()
        //終了時刻を計算
        let finishDateA: Date = Date(timeInterval: TimeInterval(DiscussTimeList[currentDiscuss]), since: startTime as Date)
        
        //議題名ラベルをセット
        CurrentAgendaNameLabel.text = AgendaNameList[currentDiscuss]
        
        //次の議題ラベルをセット
        if(currentDiscuss == AgendaNameList.count - 1){ //最後の議題だった場合
            NextAgendaNameLabel.text = "会議終了です"
            SkipButton.setTitle("終了", for: .normal) //スキップボタンを終了ボタンに
        }else{  //途中の議題だった場合
            NextAgendaNameLabel.text = AgendaNameList[currentDiscuss + 1]
        }
        
        //countTimerを呼び出す
        AgendaTimer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(countTimer), userInfo: finishDateA, repeats: true)
        
    }
    
    //タイマーを更新するメソッド
    @objc func countTimer(_ finishDateA: Timer) {
        
        let FinishDate: Date = finishDateA.userInfo as! Date
        //残り時間を終了時刻ー現在時刻で取得(秒)
        AgendaLeftTime = Int(FinishDate.timeIntervalSinceNow)
        //leftTimeを表示形式に加工
        let leftHour = AgendaLeftTime / (60 * 60)
        let leftMin = (AgendaLeftTime - leftHour * 60 * 60) / 60
        let leftSec = AgendaLeftTime - leftHour * 60 * 60 - leftMin * 60
        let displayString = NSString(format: "%02d:%02d:%02d", leftHour, leftMin, leftSec)
        AgendaTimerLabel.text = displayString as String
        
        //progress barの更新
        ProgressStandard = DiscussTimeList[currentDiscuss] + PastTime    //分母
        ProgressLeft += 0.01    //分子
        AgendaProgressBar.setProgress( ProgressLeft / Float(ProgressStandard), animated: false)
        
        //終了処理
            //最終終了処理
        if AgendaLeftTime == 0 && currentDiscuss >= AgendaNameList.count - 1{
            AgendaTimer.invalidate()
            PauseButton.isEnabled = false
            let soundIDRing: SystemSoundID = 1005
            AudioServicesPlaySystemSound(soundIDRing)
            
            //アラートを出してタイトル画面へ戻る
            let alert: UIAlertController = UIAlertController(title: "会議終了", message: "お疲れ様でした！タイトル画面へ戻ります", preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "OK", style: .default, handler: {(action: UIAlertAction!)in
                    //アラートが消えるのと重ならないように0.5秒後に遷移
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){
                        self.performSegue(withIdentifier: "toTitleView", sender: nil)
                    }
                }
            )
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
        }
            //次の議題へ行く場合の処理　//終了したらcurrentDiscussを更新してstartTimerを起動し直す
        else if AgendaLeftTime == 0 {
            currentDiscuss += 1
            
            // progress bar用の変数はリセット
            PastTime = 0
            ProgressLeft = 1.0
            ProgressStandard  = 0
            
            //通知音
            let soundIDRing: SystemSoundID = 1005
            AudioServicesPlaySystemSound(soundIDRing)
            
            //タイマー停止
            AgendaTimer.invalidate()
            //リスタート．動き続けてる会議タイマーとずれるのを防止するために1秒待たせる
            RepeatTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(AgendaTimerStart), userInfo: nil, repeats: false)
        }
    }
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //progress barを太く
        AgendaProgressBar.transform = CGAffineTransform(scaleX: 1.0, y: 10)
        
        //Userdefaultからの読み込み
        if saveData.array(forKey: "AGENDA") != nil{
            AgendaNameList = saveData.array(forKey: "AGENDA") as! [String]
        }
        if saveData.array(forKey: "TIME") != nil{
            DiscussTimeList = saveData.array(forKey: "TIME") as! [Int]
        }
        
        ConferenceNameLabel.text = ConferenceNamefrom   //ConferenceViewから受け取った会議名をラベルに代入
        PauseButton.setTitle("一時停止", for: .normal)    //一時停止ボタンにテキストセット
        ConferenceTimerStart()
        AgendaTimerStart()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        ConferenceTimer.invalidate()
        AgendaTimer.invalidate()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
