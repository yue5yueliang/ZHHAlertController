//
//  ZHHExampleViewController.swift
//  ZHHAlertController
//
//  Created by 桃色三岁y on 07/26/2022.
//  Copyright (c) 2022 桃色三岁y. All rights reserved.
//

import UIKit

/// 配置示例页：表单调参 + 底部「显示弹窗」预览
final class ZHHExampleViewController: UIViewController {

    let viewModel = ZHHExampleViewModel()

    private lazy var mainTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.keyboardDismissMode = .onDrag
        tableView.register(ZHHExampleTextCell.self, forCellReuseIdentifier: ZHHExampleTextCell.reuseID)
        tableView.register(ZHHExampleStepperCell.self, forCellReuseIdentifier: ZHHExampleStepperCell.reuseID)
        tableView.register(ZHHExampleSegmentCell.self, forCellReuseIdentifier: ZHHExampleSegmentCell.reuseID)
        return tableView
    }()

    private lazy var showButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("显示弹窗", for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 17)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(showButtonTapped), for: .touchUpInside)
        return button
    }()

    /// 底部固定按钮栏
    private let bottomBar = UIView()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "配置示例"
        viewModel.presentingViewController = self

        bottomBar.backgroundColor = .systemBackground
        view.addSubview(mainTableView)
        view.addSubview(bottomBar)
        bottomBar.addSubview(showButton)

        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let bottomHeight: CGFloat = 64 + view.safeAreaInsets.bottom
        bottomBar.frame = CGRect(x: 0, y: view.bounds.height - bottomHeight, width: view.bounds.width, height: bottomHeight)
        showButton.frame = CGRect(x: 20, y: 10, width: view.bounds.width - 40, height: 44)
        mainTableView.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height - bottomHeight)
        mainTableView.contentInset.bottom = 8
    }

    @objc private func showButtonTapped() {
        view.endEditing(true)
        viewModel.showAlert()
    }

    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
}

// MARK: - UITableViewDataSource & UITableViewDelegate

extension ZHHExampleViewController: UITableViewDataSource, UITableViewDelegate {

    func numberOfSections(in tableView: UITableView) -> Int {
        viewModel.sections.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.sections[section].items.count
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        viewModel.sections[section].title
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let item = viewModel.sections[indexPath.section].items[indexPath.row]
        switch item.type {
        case .segment: return 88
        default: return 44
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = viewModel.sections[indexPath.section].items[indexPath.row]

        switch item.type {
        case .text:
            let cell = tableView.dequeueReusableCell(withIdentifier: ZHHExampleTextCell.reuseID, for: indexPath) as! ZHHExampleTextCell
            cell.configure(
                title: item.title,
                text: viewModel.textValue(at: indexPath) ?? "",
                placeholder: viewModel.placeholder(at: indexPath) ?? ""
            ) { [weak self] text in
                self?.viewModel.updateText(at: indexPath, text: text)
            }
            return cell

        case .slider:
            let cell = tableView.dequeueReusableCell(withIdentifier: ZHHExampleStepperCell.reuseID, for: indexPath) as! ZHHExampleStepperCell
            if case .slider(_, let min, let max, let step) = item.type {
                cell.configure(
                    title: item.title,
                    value: viewModel.sliderValue(at: indexPath) ?? min,
                    min: min,
                    max: max,
                    step: step
                ) { [weak self] value in
                    self?.viewModel.updateSlider(at: indexPath, value: value)
                }
            }
            return cell

        case .segment:
            let cell = tableView.dequeueReusableCell(withIdentifier: ZHHExampleSegmentCell.reuseID, for: indexPath) as! ZHHExampleSegmentCell
            cell.configure(
                title: item.title,
                options: viewModel.segmentOptions(at: indexPath) ?? [],
                selectedIndex: viewModel.segmentValue(at: indexPath) ?? 0
            ) { [weak self] index in
                self?.viewModel.updateSegment(at: indexPath, index: index)
            }
            return cell
        }
    }
}
