//
//  ChooseViewController.swift
//  API
//
//  Created by imac-1682 on 2023/8/16.
//

import UIKit

class ChooseViewController: UIViewController {
    
    // MARK: - IBOutlet
    @IBOutlet weak var chooseTableView: UITableView!

    
    // MARK: - Variables
    var leftBarButton_cancle: UIBarButtonItem?
    let areaArray: [String] = ["基隆市", "臺北市", "新北市", "桃園市", "新竹市", "新竹縣", "苗栗縣", "臺中市", "彰化縣", "南投縣", "雲林縣", "嘉義市", "嘉義縣", "臺南市", "高雄市", "屏東縣", "宜蘭縣", "花蓮縣", "臺東縣", "澎湖縣", "金門縣", "連江縣"]
    var saveArea: String = ""
    var recieveArea: String = ""
    var SendArea: SendArea?
    var reloadAView: ReloadTableViewDelegate?
    var reloadAPI: ReloadAPI?
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupNavigation()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super .viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super .viewDidAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        Task {
            await reloadAPI?.reloadAPI(area: self.saveArea)
        }
        SendArea?.sendArea(Area: saveArea)
        reloadAView?.reloadtableview()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    // MARK: - UI Settings
    
    func setupUI() {
        
        chooseTableView.delegate = self
        chooseTableView.dataSource = self
        chooseTableView.register(UINib(nibName: "ChooseTableViewCell", bundle: nil), forCellReuseIdentifier: ChooseTableViewCell.identifier)
        chooseTableView.backgroundView = UIImageView(image: UIImage(named: "weather.png"))
        chooseTableView.backgroundView?.alpha = 0.2
    }
    
    func setupNavigation() {
        
        navigationController?.navigationBar.barTintColor = .systemTeal
        leftBarButton_cancle = UIBarButtonItem(title: "取消", style: .done, target: self, action: #selector(cancle_BTN))
        navigationItem.leftBarButtonItem = leftBarButton_cancle
        navigationItem.leftBarButtonItem?.tintColor = .white
        title = "選擇縣市"
    }
    
    
    // MARK: - IBAction
    
    @objc func cancle_BTN() {
        
        dismiss(animated: true, completion: nil)
    }
}
// MARK: - Extension

extension ChooseViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return areaArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = chooseTableView.dequeueReusableCell(withIdentifier: ChooseTableViewCell.identifier, for: indexPath) as! ChooseTableViewCell
        cell.backgroundColor = .clear
        cell.Area.text = areaArray[indexPath.row]
        let checkmarkView = UIImageView(image: UIImage(systemName: "checkmark"))
        cell.accessoryView = nil
        
        if cell.isSelected {
            cell.accessoryView = checkmarkView
        }
        
        if recieveArea != "" {
            var register_index: Int!
            for (i, n) in areaArray.enumerated() {
                if recieveArea == n {
                    register_index = i
                }
            }
            if indexPath.row == register_index {
                cell.accessoryView = checkmarkView
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let selectedCell = chooseTableView.cellForRow(at: indexPath)
        for cell in chooseTableView.visibleCells {
            if cell != selectedCell {
                cell.accessoryView = nil
            }
        }
        let checkmarkView = UIImageView(image: UIImage(systemName: "checkmark"))
        selectedCell?.accessoryView = checkmarkView
        saveArea = areaArray[indexPath.row]
        
    }
    
}
// MARK: - Protocol

protocol SendArea {
    func sendArea(Area: String)
}
