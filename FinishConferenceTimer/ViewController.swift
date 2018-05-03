//
//  ViewController.swift
//  FinishConferenceTimer
//
//  Created by 大林拓実 on 2018/04/24.
//  Copyright © 2018年 Life is tech. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var ConferenceName: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ConferenceName.placeholder = "○○会議"
        ConferenceName.clearButtonMode = .always
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        //UserDefaultのデータ削除
        let userDefaults = UserDefaults.standard
        if let domain = Bundle.main.bundleIdentifier {
            userDefaults.removePersistentDomain(forName: domain)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    //スタートボタンタップ時の処理
    @IBAction func startButtonTapped(){
        if ConferenceName.text !=  "" {
            //入力があれば画面遷移
            self.performSegue(withIdentifier: "toConferenceView", sender: nil)
        }else{
            //無ければアラート
            let alert: UIAlertController = UIAlertController(title: "未入力", message: "会議名を入力してください", preferredStyle: .alert)
            alert.addAction(
                UIAlertAction(title: "OK", style: .default, handler: nil)
            )
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    //入力された会議名をConferenceViewに渡す
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if segue.identifier == "toConferenceView" {
            let ConferenceVC = segue.destination as! ConferenceViewController
            ConferenceVC.NamefromVC = ConferenceName.text!
            ConferenceName.text = ""
        }
    }
    
    @IBAction func back (segue: UIStoryboardSegue){
    }

    
}

