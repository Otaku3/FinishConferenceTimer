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
    
    let saveData = UserDefaults.standard
    var AgendaNameList: [String] = []   //UserDefaultから読み込む議題名のString型配列
    var DiscussTimeList: [Int] = []     //UserDefaultから読み込む議論時間のInt型配列(秒)

    var ConferenceNamefrom:String = ""  //ConferenceViewから会議名を受け取る変数
    
    //使用するタイマーの宣言
    var Conferencetimer = Timer()
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
        if Conferencetimer.isValid || AgendaTimer.isValid {
            //停止処理
            Conferencetimer.invalidate()
            AgendaTimer.invalidate()
            PauseButton.setTitle("再開", for: .normal)    //ボタンテキスト変更
            
        }
        else{
            //再開処理
            DiscussTimeList[currentDiscuss] = AgendaLeftTime    //現在の議題の残り時間を更新
            ConferenceTimerStart()  //再スタート
            AgendaTimerStart()      //再スタート
            PauseButton.setTitle("一時停止", for: .normal)  //ボタンテキスト変更
            
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
        Conferencetimer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(updateClabel), userInfo: finishDateC, repeats: true)
    }
    
    //表示を更新させるメソッド
    @objc func updateClabel(_ finishDateC: Timer) {
        let FinishDate: Date = finishDateC.userInfo as! Date
        //残り時間を終了時刻ー現在時刻で取得(秒)
        let ConferenceLeftTime = Int(FinishDate.timeIntervalSinceNow)
        //表示形式に加工
        let minSec = 60
        let leftMin = ConferenceLeftTime / minSec
        let leftSec = ConferenceLeftTime - leftMin * minSec
        let displayString = NSString(format: "%02d:%02d", leftMin, leftSec)
        ConferenceTimerLabel.text = displayString as String
        
        //終了処理
        if ConferenceLeftTime == 0 {
            let soundIDRing: SystemSoundID = 1005
            AudioServicesPlaySystemSound(soundIDRing)
            Conferencetimer.invalidate()
        }
    }

    
    //////////////////////////////////////////議題時間タイマー//////////////////////////////////////////////
    var AgendaLeftTime :Int = 0 //残り秒数
    var currentDiscuss :Int = 0 //現在の議題を取り出すための変数
    
    //タイマーをスタートさせるメソッド
    @objc func AgendaTimerStart() {
        
        //開始時刻を記録
        let startTime = Date()
        //終了時刻を計算
        let finishDateA: Date = Date(timeInterval: TimeInterval(DiscussTimeList[currentDiscuss]), since: startTime as Date)

        //議題名ラベルをセット
        CurrentAgendaNameLabel.text = AgendaNameList[currentDiscuss]
        if(currentDiscuss == AgendaNameList.count - 1){
            NextAgendaNameLabel.text = "会議終了です"
        }else{
            NextAgendaNameLabel.text = AgendaNameList[currentDiscuss + 1]
        }
        
        //countTimerを呼び出す
        AgendaTimer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(countTimer), userInfo: finishDateA, repeats: true)
        
    }
    
    //タイマーを更新するメソッド
    @objc func countTimer(_ finishDateA: Timer) {
        
        let FinishDate: Date = finishDateA.userInfo as! Date
        //残り時間を終了時刻ー現在時刻で取得(秒)
        self.AgendaLeftTime = Int(FinishDate.timeIntervalSinceNow)
        //leftTimeを表示形式に加工
        let minSec = 60
        let leftMin = AgendaLeftTime / minSec
        let leftSec = AgendaLeftTime - leftMin * minSec
        let displayString = NSString(format: "%02d:%02d", leftMin, leftSec)
        AgendaTimerLabel.text = displayString as String
        
        //終了処理
        if AgendaLeftTime == 0 && currentDiscuss == AgendaNameList.count - 1{  //最終終了処理
            AgendaTimer.invalidate()
            let soundIDRing: SystemSoundID = 1005
            AudioServicesPlaySystemSound(soundIDRing)
        }
        else if AgendaLeftTime == 0 {    //終了したらcurrentDiscussを更新してstartTimerを起動し直す
            currentDiscuss += 1
            let soundIDRing: SystemSoundID = 1005
            AudioServicesPlaySystemSound(soundIDRing)
            AgendaTimer.invalidate()
            RepeatTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(AgendaTimerStart), userInfo: nil, repeats: false)
        }
    }
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
