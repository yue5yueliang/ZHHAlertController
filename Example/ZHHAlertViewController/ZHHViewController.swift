//
//  ZHHViewController.swift
//  ZHHAlertViewController
//
//  Created by 桃色三岁y on 07/26/2022.
//  Copyright (c) 2022 桃色三岁y. All rights reserved.
//

import UIKit

/// 示例列表 View 层（MVVM 中的 View，仅负责 UI 展示与事件转发）
final class ZHHViewController: UIViewController {

    /// ViewModel，提供分组数据并处理弹窗展示
    private let viewModel = ZHHViewModel()

    /// 分组列表示图
    private lazy var mainTableView: UITableView = {
        let tableView = UITableView(frame: view.bounds, style: .insetGrouped)
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = 50
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "ZHHViewController")
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "ZHHAlertViewController 示例"
        view.addSubview(mainTableView)
    }
}

// MARK: - UITableViewDataSource & UITableViewDelegate

extension ZHHViewController: UITableViewDataSource, UITableViewDelegate {

    func numberOfSections(in tableView: UITableView) -> Int {
        viewModel.sections.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.sections[section].items.count
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        viewModel.sections[section].title
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ZHHViewController", for: indexPath)
        cell.textLabel?.text = viewModel.sections[indexPath.section].items[indexPath.row].title
        return cell
    }

    /// 选中行后交给 ViewModel 展示对应示例
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        viewModel.didSelectItem(at: indexPath)
    }
}
