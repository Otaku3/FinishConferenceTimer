//
//  ConferenceViewController.swift
//  FinishConferenceTimer
//
//  Created by 大林拓実 on 2018/04/24.
//  Copyright © 2018年 Life is tech. All rights reserved.
//

import UIKit

class ConferenceViewController: UIViewController, UITableViewDataSource {
    
    //////////////////////////////////////////demo////////////////////////////////////////////////////////////////////
    //表示データ
    var dataList = ["青山", "阿部", "加藤", "佐藤", "田中"]
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TestCell", for: indexPath)
        
            cell.textLabel?.text = dataList[indexPath.row]
        return cell
    }
    
    ///////////////////////////////////////////////////////////////////////////////////////////////////////////

    @IBOutlet var conferenceName: UILabel!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        conferenceName.text = conferenceName

        // Do any additional setup after loading the view.
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
