//
//  ZHHHomeViewController.swift
//  ZHHAlertController_Example
//
//  Created by 桃色三岁 on 2022/7/27.
//  Copyright © 2022 桃色三岁y. All rights reserved.
//

import UIKit

/// 示例入口：配置示例（调参预览）/ 样式示例（预设场景）
final class ZHHHomeViewController: UIViewController {

    /// 首页入口项
    private enum Item: Int, CaseIterable {
        case config   // 布局间距、尺寸等可配置项
        case styles   // 内容组合与特殊样式预设

        var title: String {
            switch self {
            case .config: return "配置示例"
            case .styles: return "样式示例"
            }
        }
    }

    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = 50
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "ZHHAlertController"
        view.addSubview(tableView)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
}

// MARK: - UITableViewDataSource & UITableViewDelegate

extension ZHHHomeViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        Item.allCases.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let item = Item.allCases[indexPath.row]
        cell.textLabel?.text = item.title
        cell.accessoryType = .disclosureIndicator
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch Item.allCases[indexPath.row] {
        case .config:
            navigationController?.pushViewController(ZHHExampleViewController(), animated: true)
        case .styles:
            navigationController?.pushViewController(ZHHStylesViewController(), animated: true)
        }
    }
}
