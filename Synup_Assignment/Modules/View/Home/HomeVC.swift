//
//  HomeVC.swift
//  Synup_Assignment
//
//  Created by cronycle on 25/08/2019.
//  Copyright © 2019 Apoorv. All rights reserved.
//

import UIKit

class HomeVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var loader: UIActivityIndicatorView!
    
    var vm : HomeVM = HomeVM()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        vm.viewDidLoad()
        observables()
    }
    
    private func observables() {
        vm.showHideLoader = {[unowned self](showLoader) in
            if showLoader {
                self.loader.isHidden = false
                self.loader.startAnimating()
            } else {
                self.loader.isHidden = true
                self.loader.stopAnimating()
            }
        }
        vm.refreshUI = {[unowned self] in
            self.tableView.reloadData()
        }
    }
}
extension HomeVC : UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return vm.sectionItems().count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return vm.rowItems(inSection: section).count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = vm.rowCellItems(forSection: indexPath.section)[indexPath.row]
        let cell = tableView.dequeueCell(reuseIdentifier: type(of: item).reuseId, for: indexPath)
        item.configure(cell: cell)
        if vm.selectedVariations.contains(where: {$0.id == item.item.id}) {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        if vm.canSelect(item: item.item) {
            cell.contentView.alpha = 1
        } else {
            cell.contentView.alpha = 0.25
        }
        return cell
    }
}
extension HomeVC : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = vm.rowItems(inSection: indexPath.section)[indexPath.row]
        if vm.canSelect(item: item) {
            vm.select(item: item)
        }
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UIView()
        header.backgroundColor = UIColor.white
        let lbl = UILabel.init(frame: CGRect.init(x: 15, y: 10, width: tableView.bounds.size.width - 30, height: 30))
        lbl.font = UIFont.boldSystemFont(ofSize: 22)
        lbl.text = vm.item(forSection: section).name
        header.addSubview(lbl)
        return header
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
}
