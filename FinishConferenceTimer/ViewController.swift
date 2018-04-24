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
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func startButtonTapped(){
        //テキスト入力アラートの宣言
        let alert: UIAlertController = UIAlertController(
            title: "会議登録",
            message: "会議名を入力してください",
            preferredStyle: .alert
        )
        
        //テキストフィールド追加
        alert.addTextField(configurationHandler: {(textField: UITextField!) -> Void in
            textField.placeholder = "○○会議"
        })
        
        //OKボタンの設定
        let okAction = UIAlertAction(title: "OK", style: .default, handler: {
            (action:UIAlertAction!) -> Void in
            let textFields = alert.textFields
            if textFields?.count != nil{
                //画面遷移の設定(アラートが消えるのと遷移が重ならないように0.5秒後に実行)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){
                    self.performSegue(withIdentifier: "toConferenceView", sender: nil)
                }
            }else{
                //入力催促アラート表示
                let RemindAlert: UIAlertController = UIAlertController(title: "会議名", message: "会議名を入力してください", preferredStyle: .alert)
                
                RemindAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(RemindAlert, animated: true, completion: nil)
            }
            
        })
        alert.addAction(okAction)
        
        //キャンセルボタンの設定
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        
        //アラート表示
        self.present(alert, animated: true, completion: nil)
        
    }
    
    //入力された会議名をConferenceViewに渡す
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if segue.identifier == "toConferenceView" {
            
        }
    }

    
}

