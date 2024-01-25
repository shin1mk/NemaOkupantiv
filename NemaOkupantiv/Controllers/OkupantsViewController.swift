//
//  OkupantsViewController.swift
//  NemaOkupantiv
//
//  Created by SHIN MIKHAIL on 05.01.2024.
//

import UIKit
import SnapKit
import SafariServices

final class OkupantsViewController: UIViewController {
    //MARK: - Properties
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.SFUITextBold(ofSize: 25)
        label.text = "Загальні бойові втрати російського окупанта"
        label.textAlignment = .center
        label.textColor = .systemGray2
        label.numberOfLines = 0
        return label
    }()
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(aa_warfare_systems_Cell.self, forCellReuseIdentifier: "aa_warfare_systems_Cell")
        tableView.register(armoured_fighting_vehicles_Cell.self, forCellReuseIdentifier: "armoured_fighting_vehicles_Cell")
        tableView.register(artillery_systems_Cell.self, forCellReuseIdentifier: "artillery_systems_Cell")
        tableView.register(personnel_units_Cell.self, forCellReuseIdentifier: "personnel_units_Cell")
        tableView.register(tanks_Cell.self, forCellReuseIdentifier: "tanks_Cell")
        tableView.register(mlrs_Cell.self, forCellReuseIdentifier: "mlrs_Cell")
        tableView.register(planes_Cell.self, forCellReuseIdentifier: "planes_Cell")
        tableView.register(helicopters_Cell.self, forCellReuseIdentifier: "helicopters_Cell")
        tableView.register(vehicles_fuel_tanks_Cell.self, forCellReuseIdentifier: "vehicles_fuel_tanks_Cell")
        tableView.register(warships_cutters_Cell.self, forCellReuseIdentifier: "warships_cutters_Cell")
        tableView.register(cruise_missiles_Cell.self, forCellReuseIdentifier: "cruise_missiles_Cell")
        tableView.register(uav_systems_Cell.self, forCellReuseIdentifier: "uav_systems_Cell")
        tableView.register(special_military_equip_Cell.self, forCellReuseIdentifier: "special_military_equip_Cell")
        tableView.register(atgm_srbm_systems_Cell.self, forCellReuseIdentifier: "atgm_srbm_systems_Cell")
        tableView.register(submarines_Cell.self, forCellReuseIdentifier: "submarines_Cell")
        return tableView
    }()
    private let bottomMarginView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        return view
    }()
    private let refreshControl = UIRefreshControl()
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupConstraints()
        setupTableView()
        addTarget()
    }
    // повторный запуск
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(appWillEnterForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
        animateTableAppearance()
    }

    @objc private func appWillEnterForeground() {
        animateTableAppearance()
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    // функция плавного появления таблицы
    private func animateTableAppearance() {
        tableView.alpha = 0.0
        UIView.animate(withDuration: 0.6) {
            self.tableView.alpha = 1.0
        }
    }
    
    private func addTarget() {
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
    }
    // обновление
    @objc private func refreshData() {
        WarshipAPIManager.shared.fetchWarfareData { result in
            sleep(1) // задержка
            
            switch result {
            case .success(let data):
                print("Data fetched successfully.")
                do {
                    _ = try JSONDecoder().decode(WarfareData.self, from: data)
                } catch {
                    print("Error decoding JSON: \(error)")
                }
            case .failure(let error):
                print("Error fetching data: \(error)")
            }
            DispatchQueue.main.async {
                self.refreshControl.endRefreshing()
            }
        }
    }
    // methods
    private func setupConstraints() {
        view.backgroundColor = .black
        // title
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(0)
            make.leading.equalToSuperview().offset(10)
            make.trailing.equalToSuperview().offset(-10)
        }
        // table view
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.leading.trailing.bottom.equalToSuperview()
        }
        // подложка
        view.addSubview(bottomMarginView)
        bottomMarginView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.height.greaterThanOrEqualTo(5)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.bottomMargin).offset(-5)
        }
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.refreshControl = refreshControl
    }
}
extension OkupantsViewController: UITableViewDelegate, UITableViewDataSource {
    // количество ячеек
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 15
    }
    // высота ячеек
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    // при нажатии ничего
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    // ячейки кастомные
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cellIdentifier = "aa_warfare_systems_Cell"
            let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! aa_warfare_systems_Cell
            return cell
        case 1:
            let cellIdentifier = "armoured_fighting_vehicles_Cell"
            let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! armoured_fighting_vehicles_Cell
            return cell
        case 2:
            let cellIdentifier = "artillery_systems_Cell"
            let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! artillery_systems_Cell
            return cell
        case 3:
            let cellIdentifier = "personnel_units_Cell"
            let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! personnel_units_Cell
            return cell
        case 4:
            let cellIdentifier = "tanks_Cell"
            let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! tanks_Cell
            return cell
        case 5:
            let cellIdentifier = "mlrs_Cell"
            let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! mlrs_Cell
            return cell
        case 6:
            let cellIdentifier = "planes_Cell"
            let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! planes_Cell
            return cell
        case 7:
            let cellIdentifier = "helicopters_Cell"
            let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! helicopters_Cell
            return cell
        case 8:
            let cellIdentifier = "vehicles_fuel_tanks_Cell"
            let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! vehicles_fuel_tanks_Cell
            return cell
        case 9:
            let cellIdentifier = "warships_cutters_Cell"
            let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! warships_cutters_Cell
            return cell
        case 10:
            let cellIdentifier = "cruise_missiles_Cell"
            let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! cruise_missiles_Cell
            return cell
        case 11:
            let cellIdentifier = "uav_systems_Cell"
            let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! uav_systems_Cell
            return cell
        case 12:
            let cellIdentifier = "special_military_equip_Cell"
            let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! special_military_equip_Cell
            return cell
        case 13:
            let cellIdentifier = "atgm_srbm_systems_Cell"
            let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! atgm_srbm_systems_Cell
            return cell
        case 14:
            let cellIdentifier = "submarines_Cell"
            let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! submarines_Cell
            return cell
        default:
            let cellIdentifier = "aa_warfare_systems_Cell"
            let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! aa_warfare_systems_Cell
            return cell
        }
    }
}
