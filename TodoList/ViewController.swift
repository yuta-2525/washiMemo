//
//  ViewController.swift
//  TodoList
//
//  Created by 佐藤勇太 on 2021/08/28.
//

import UIKit
import SwiftConfettiView
import AVFoundation
import NendAd

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,NADViewDelegate {
    
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var nadView: NADView!
    var audioPlayer: AVAudioPlayer?
    
    // テーブルに表示するデータの箱
    var todoList = [String]()
    //UserDefaults
    let userDefalults = UserDefaults.standard

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //外観モードを変更する
        self.overrideUserInterfaceStyle = .light
        
        tableView.delegate = self
        tableView.dataSource = self
        nadView.delegate = self
        //データ読み込み
        if let storedTodoList = userDefalults.array(forKey: "todoList") as? [String] {
            todoList.append(contentsOf: storedTodoList)
        }
        
        //バナー広告
        nadView.setNendID(1043668, apiKey: "8a10a898c683ba54fd390b8af81e7f47e428a0c2")
        nadView.load()
        
        
        // プッシュ通知の許可を依頼する際のコード // このコードを関数にまとめる処理にする
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { (granted, error) in
            if granted {
                // MARK: 通知の中身を設定
                let content: UNMutableNotificationContent = UNMutableNotificationContent()
                content.body = "今日のやることリストを追加しよう"
                content.sound = UNNotificationSound.init(named: UNNotificationSoundName(rawValue: "change.mp3"))
                content.badge = 1
                let notificationCenter = UNUserNotificationCenter.current()
                var dateComponents = DateComponents()
                dateComponents.calendar = Calendar.current
                dateComponents.hour = 12
                dateComponents.minute = 15
                let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
                //                let trigger = UNTimeIntervalNotificationTrigger(timeInterval: (60), repeats: true)
                let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
                
                
                notificationCenter.add(request) { (error) in
                    if error != nil {
                        print(error.debugDescription)
                    }
                }
            } else {
                // 「許可しない」が押された場合
            }
            
        }
        
    }
    
    @IBAction func completion(_ sender: Any) {
        //Viewを生成
        let confettiView = SwiftConfettiView(frame: self.view.bounds)
        //Viewを追加
        self.view.addSubview(confettiView)
        //パーティクルの種類を設定
        confettiView.type = .confetti
        //パーティクルのカラーを設定
        confettiView.colors = [UIColor.purple, UIColor.systemPink, UIColor.blue, UIColor.green]
        //パーティクルの強度を設定
        confettiView.intensity = 0.75
        //紙吹雪をスタート
        confettiView.startConfetti()
        //3秒後に紙吹雪を停止する
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            confettiView.stopConfetti()
        }
        //6秒後にSubviewを削除する
        DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
            confettiView.removeFromSuperview()
        }
        //barTintの色を変える処理
        let randomInt = Int.random(in: 1..<8)
        if randomInt == 1{
            self.navigationController?.navigationBar.barTintColor = UIColor.systemGray
        } else if randomInt == 2{
            self.navigationController?.navigationBar.barTintColor = UIColor.systemGreen
        } else if randomInt == 3{
            self.navigationController?.navigationBar.barTintColor = UIColor.systemTeal
        } else if randomInt == 4{
            self.navigationController?.navigationBar.barTintColor = UIColor.orange
        } else if randomInt == 5{
            self.navigationController?.navigationBar.barTintColor = UIColor.systemYellow
        } else if randomInt == 6{
            self.navigationController?.navigationBar.barTintColor = UIColor.systemPurple
        } else if randomInt == 7{
            self.navigationController?.navigationBar.barTintColor = UIColor.systemRed
        } else if randomInt == 8{
            self.navigationController?.navigationBar.barTintColor = UIColor.systemIndigo
        }
        
        let soundURL = Bundle.main.url(forResource: "change", withExtension: "mp3")
               do {
                   // 効果音を鳴らす
                audioPlayer = try AVAudioPlayer(contentsOf: soundURL!)
                audioPlayer?.play()
               } catch {
                   print("error...")
               }
        
        
        
    }
    
    @IBAction func addBtnAction(_ sender: Any) {
        let alertController = UIAlertController(title: "メモを追加", message: "タスクを入力してください。", preferredStyle: UIAlertController.Style.alert)
        alertController.addTextField(configurationHandler: nil)
        let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) { (acrion: UIAlertAction) in
            //OKをタップした時の処理
            if let textField = alertController.textFields?.first {
                if textField.text == ""{
                    return
                }
                self.todoList.insert(textField.text!, at: 0)
                self.tableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: UITableView.RowAnimation.right)
                //追加した Todoを保存
                self.userDefalults.set(self.todoList, forKey: "todoList")
            }
        }
        alertController.addAction(okAction)
        let cancelButton = UIAlertAction(title: "CANCEL", style: UIAlertAction.Style.cancel, handler: nil)
        alertController.addAction(cancelButton)
        present(alertController, animated: true, completion: nil)
    }
    
    
    // セルの数を指定
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoList.count
    }
    // セルの中身を設定
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let todoTitle = todoList[indexPath.row]
        cell.textLabel?.text = todoTitle
        //        cell.imageView?.image = UIImage(named: "check")
        cell.selectionStyle = .none
        return cell
    }
    //セルの高さを決める
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return view.frame.size.height/14
    }
    
    //セルの削除機能
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCell.EditingStyle.delete {
            todoList.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath as IndexPath], with: UITableView.RowAnimation.automatic)
            //削除した内容を保存
            userDefalults.set(todoList, forKey: "todoList")
        }
    }

    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "削除する"
    }
    
    
    //セルが選択された時の処理
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cellCheck = tableView.cellForRow(at: indexPath)
        let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: (cellCheck?.textLabel?.text)!)
        let attributeCancelString: NSMutableAttributedString =  NSMutableAttributedString(string: (cellCheck?.textLabel?.text)!)
        attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, attributeString.length))
        attributeCancelString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 0, range: NSMakeRange(0, attributeString.length))
        
        if cellCheck?.textLabel?.attributedText != attributeString {
            cellCheck?.textLabel!.attributedText = attributeString
            cellCheck?.textLabel?.textColor = .lightGray
        }else{
            cellCheck?.textLabel?.attributedText = attributeCancelString
            cellCheck?.textLabel?.textColor = .black
        }
    }
}
