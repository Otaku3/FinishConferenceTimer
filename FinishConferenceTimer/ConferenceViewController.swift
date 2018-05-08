//
//  ConferenceViewController.swift
//  FinishConferenceTimer
//
//  Created by 大林拓実 on 2018/04/24.
//  Copyright © 2018年 Life is tech. All rights reserved.
//

import UIKit

class ConferenceViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    /////////////////////////////////////変数宣言////////////////////////////////////////////////
    //議題データ
    var AgendaNameList: [String] = []   //議題名のString型配列
    var DiscussTimeList: [Int] = []     //議論時間のInt型配列(秒)
    let saveData = UserDefaults.standard
    
    @IBOutlet var ConferenceName: UILabel!  //会議名のラベル
    var NamefromVC = "" //VCからの会議名受け渡し用の変数
    @IBOutlet var ConferenceTime: UILabel!  //会議の合計時間表示のラベル
    
    @IBOutlet var AgendaList: UITableView!

    
    /////////////////////////////////////TableViewの設定/////////////////////////////////////////
    //セクション数決定
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    //セルの個数決定
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return AgendaNameList.count
    }
    
    //表示の設定
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)  //UITableViewCellのインスタンス生成
        
        let agendaname = cell.viewWithTag(1) as! UILabel
        agendaname.text = AgendaNameList[indexPath.row]
        
        let discusstime = cell.viewWithTag(2) as! UILabel
        discusstime.text = String(DiscussTimeList[indexPath.row] / 60) + "分"
        
        //セルを選択不可にする
        self.AgendaList.allowsSelection = false
        
        return cell
    }
    
    //横スワイプで削除動作
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath){
        
        if editingStyle == .delete{
            //ローカルデータ削除
            AgendaNameList.remove(at: indexPath.row)
            DiscussTimeList.remove(at: indexPath.row)
            //TableView上から削除
            AgendaList.deleteRows(at: [indexPath], with: .fade)
            //Userdefaultの情報を更新
                //一度全削除
            if let domain = Bundle.main.bundleIdentifier {
                saveData.removePersistentDomain(forName: domain)
            }
                //再度登録
            saveData.set(AgendaNameList, forKey: "AGENDA")
            saveData.set(DiscussTimeList, forKey: "TIME")
            //合計時間ラベル更新
            if CalcTotalTime().hour == 0{
                ConferenceTime.text = "合計" + String(CalcTotalTime().minute) + "分"
            }else{
                ConferenceTime.text = "合計" + String(CalcTotalTime().hour) + "時間" + String(CalcTotalTime().minute) + "分"
            }
        }
    }
    /////////////////////////////////////////////////////////////////////////////////////////////
    
    //表示用の合計時間の計算メソッド
    func CalcTotalTime() -> (hour: Int, minute: Int) {
        var TotalTime: Int = 0
        for i in DiscussTimeList{
            TotalTime += i
        }
        let hour: Int = TotalTime / (60 * 60)
        let minute: Int = (TotalTime - hour * 60 * 60) / 60
        
        return (hour, minute)
    }
    
    //必要な値をTimerViewに渡すメソッド
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if segue.identifier == "toTimerView" {
            let TimerVC = segue.destination as! TimerViewController
            TimerVC.ConferenceNamefrom = ConferenceName.text!
        }
    }
    
    //スタートボタンタップ時の動作
    @IBAction func tappedStartButton(){
        //何も登録されてなかったら警告
        if AgendaNameList.count == 0 || DiscussTimeList.count == 0{
            let alert: UIAlertController = UIAlertController(title: "議題", message: "＋ボタンから会議内容を追加してください", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }else{
            self.performSegue(withIdentifier: "toTimerView", sender: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        //ViewControllerから渡された会議名を代入
        ConferenceName.text = NamefromVC
        //Userdefaultからの読み込み
        if saveData.array(forKey: "AGENDA") != nil{
            AgendaNameList = saveData.array(forKey: "AGENDA") as! [String]
        }
        if saveData.array(forKey: "TIME") != nil{
            DiscussTimeList = saveData.array(forKey: "TIME") as! [Int]
        }
        //合計時間をラベルに表示
        if CalcTotalTime().hour == 0{
            ConferenceTime.text = "合計" + String(CalcTotalTime().minute) + "分"
        }else{
            ConferenceTime.text = "合計" + String(CalcTotalTime().hour) + "時間" + String(CalcTotalTime().minute) + "分"
        }
        //TableViewをリロード
        AgendaList.reloadData()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //unwind Segue
    @IBAction func backConferenceVC (segue: UIStoryboardSegue){
//        if segue.identifier == "fromTimerView"{
//            let TimerVC = segue.destination as! TimerViewController
//            TimerVC.AgendaTimer.invalidate()
//            TimerVC.ConferenceTimer.invalidate()
//        }
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
