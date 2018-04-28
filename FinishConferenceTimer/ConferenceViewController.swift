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
    //議題データ（とりあえずローカルに持たせとく）
    var AgendaNameList: [String] = ["議題1", "議題2", "議題3"]    //議題名のString型配列
    var DiscussTimeList: [Int] = [20, 15, 30]   //議論時間のInt型配列
    //let saveData = UserDefaults.standard
    
    @IBOutlet var ConferenceName: UILabel!  //会議名のラベル
    var NamefromVC = "" //VCからの会議名受け渡し用の変数
    @IBOutlet var ConferenceTime: UILabel!  //会議の合計時間表示のラベル

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
//        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! AgendaTableViewCell
//        cell.AgendaNameLabel.text = AgendaNameList[indexPath.row]
//        cell.DiscussTimeLabel.text = String(DiscussTimeList[indexPath.row])
//        カスタムセル使おうとした残骸
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)  //UITableViewCellのインスタンス生成
        
        let agendaname = cell.viewWithTag(1) as! UILabel
        agendaname.text = AgendaNameList[indexPath.row]
        
        let discusstime = cell.viewWithTag(2) as! UILabel
        discusstime.text = String(DiscussTimeList[indexPath.row])
        
        return cell
    }
    /////////////////////////////////////////////////////////////////////////////////////////////
    
    //合計時間の計算メソッド
    func CalcTotalTime() -> Int{
        var TotalTime: Int = 0
        for i in DiscussTimeList{
            TotalTime += i
        }
        return TotalTime
    }
    
    //必要な値をTimerViewに渡すメソッド
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if segue.identifier == "toTimerView" {
            let TimerVC = segue.destination as! TimerViewController
            TimerVC.ConferenceNamefrom = ConferenceName.text!
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //ViewControllerから渡された会議名を代入
        ConferenceName.text = NamefromVC
        //合計時間を計算して代入
        ConferenceTime.text = String(CalcTotalTime())
        
        
        //xibを読み込み
//        let view: UIView = UINib(nibName: "AgendaTableViewCell", bundle: nil).instantiate(withOwner: self, options: nil)[0] as! UIView
//        self.view.addSubview(view)
//        tableView.delegate = self
//        tableView.datasource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
//        if saveData.array(forKey: "AGENDA") != nil {
//            AgendaList = saveData.array(forKey: "AGENDA") as! [Dictionary<String, Int>]
//        }
//        self.view.reloadInputViews()
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
