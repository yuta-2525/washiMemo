//
//  NextViewController.swift
//  TodoList
//
//  Created by 佐藤勇太 on 2021/09/07.
//

import UIKit

class NextViewController: UIViewController {
    
    var cellText = String()
    
    
    @IBOutlet weak var nextLabel: UILabel!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        nextLabel.text = cellText
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
