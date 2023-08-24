//
//  MainViewController.swift
//  API
//
//  Created by imac-1682 on 2023/8/15.
//

import UIKit

class MainViewController: UIViewController {
    
    // MARK: - IBOutlet
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Variables
    var WeatherData: WeatherResponse?
    var rightBarButton_choose: UIBarButtonItem?
    var catchArea: String = ""
    var reloadDelegate: ReloadTableViewDelegate?
    var reloadAPI: ReloadAPI?
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupNavigation()
        startTimer()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super .viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super .viewDidAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    // MARK: - UI Settings
    
    func setupUI() {
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "MainTableViewCell", bundle: nil),
                                 forCellReuseIdentifier: MainTableViewCell.identifier)
        tableView.backgroundView = UIImageView(image: UIImage(named: "weather.png"))
        tableView.backgroundView?.alpha = 0.2
        tableView.allowsSelection = false


    }
    
    func setupNavigation() {
        
        navigationController?.navigationBar.barTintColor = .systemTeal
        rightBarButton_choose = UIBarButtonItem(title: "選擇", style: .done, target: self, action: #selector(chooseBTN))
        navigationItem.rightBarButtonItem = rightBarButton_choose
        navigationItem.rightBarButtonItem?.tintColor = .white
        title = "天氣"
    }
    
    func fetchWeatherData(LocationName locationName: String) async {
        let authorizationToken = "CWB-B2DBC725-8F48-451C-98B0-E75A0326E789"
        
        do {
            let request = WeatherRequest(Authorization: authorizationToken, locationName: locationName)
            WeatherData = try await requestData(method: .get, path: .thirtySixWeather, parameter: request)
            DispatchQueue.main.async { [self] in
                tableView.reloadData()
            }
            // Use responseData here
            print("Received response data: \(String(describing: WeatherData))")
        } catch {
            // Handle errors here
            print("Error occurred: \(error)")
        }
    }
    
    func startTimer() {
        
        Timer.scheduledTimer(withTimeInterval: 600, repeats: true) { [self] timer in
            // 这里是您想要在每分钟触发时执行的代码
            Task {
                await fetchWeatherData(LocationName: catchArea)
            }
        }
    }
    // MARK: - IBAction
    
    @objc func chooseBTN() {
        
        let chooseVC = ChooseViewController()
        chooseVC.SendArea = self
        chooseVC.reloadAView = self
        chooseVC.reloadAPI = self
        chooseVC.recieveArea = catchArea
        let navigationController = UINavigationController(rootViewController: chooseVC)
        navigationController.isNavigationBarHidden = false
        self.present(navigationController, animated: true, completion: nil)
    }
}
// MARK: - Extension

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MainTableViewCell.identifier, for: indexPath) as! MainTableViewCell
        cell.backgroundColor = .clear

        DispatchQueue.main.async { [self] in
            
            cell.Area.text = WeatherData?.records.location[0].locationName
            cell.Wx.text = WeatherData?.records.location[0].weatherElement[0].time[indexPath.row].parameter.parameterName
            cell.startTime.text = WeatherData?.records.location[0].weatherElement[0].time[indexPath.row].startTime
            cell.endTime.text = WeatherData?.records.location[0].weatherElement[0].time[indexPath.row].endTime
            cell.PoP.text = (WeatherData?.records.location[0].weatherElement[1].time[indexPath.row].parameter.parameterName ?? "")
            cell.MinT.text = (WeatherData?.records.location[0].weatherElement[2].time[indexPath.row].parameter.parameterName ?? "")
            cell.CI.text = WeatherData?.records.location[0].weatherElement[3].time[indexPath.row].parameter.parameterName
            cell.MaxT.text = (WeatherData?.records.location[0].weatherElement[4].time[indexPath.row].parameter.parameterName ?? "")
            if cell.PoP.text != "" {
                cell.PoP.text = cell.PoP.text! + "%"
            }
            if cell.MinT.text != "" {
                cell.MinT.text = cell.MinT.text! + "°"
            }
            if cell.MaxT.text != "" {
                cell.MaxT.text = cell.MaxT.text! + "°"
            }
        }
        return cell
    }
    
}

extension MainViewController: SendArea {
    func sendArea(Area: String) {
        catchArea = Area
    }
}

extension MainViewController: ReloadTableViewDelegate {
    func reloadtableview() {
        tableView.reloadData()
    }
}

extension MainViewController: ReloadAPI {
    
    func reloadAPI(area: String) async {
        await fetchWeatherData(LocationName: area)
    }
}
// MARK: - Protocol

protocol ReloadTableViewDelegate {
    func reloadtableview()
}

protocol ReloadAPI {
    func reloadAPI(area: String) async
}
