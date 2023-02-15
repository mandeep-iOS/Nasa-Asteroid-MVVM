//
//  TableGenricDataSource.swift
//  iOS-AsteroidNeo
//
//  Created by Deep Baath on 12/02/23.
//

import UIKit

//MARK: Custom Table Class for handling Datasource and Delegate functionality
class TableGenricDataSource<CELL: UITableViewCell, T, M>: NSObject, UITableViewDataSource, UITableViewDelegate {

    private var cellIdentifier: String
    private var items: [[T]]
    private var headers: [String]
    private var someData: M
    var configureCell: (CELL, T) -> ()
    var didSelectRow: (T) -> () = { _ in }
    
    init(cellIdentifier: String, items: [[T]], headers: [String], someData: M,configureCell: @escaping (CELL, T) -> ()) {
        self.cellIdentifier = cellIdentifier
        self.items =  items
        self.headers = headers
        self.someData = someData
        self.configureCell = configureCell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 177.0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? CELL
        cell?.selectionStyle = .none
        if let cell = cell {
            let item = items[indexPath.section][indexPath.row]
            configureCell(cell, item)
        }
        return cell ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = items[indexPath.section][indexPath.row]
        didSelectRow(item)
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return headers[section]
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        let headerLabel = UILabel(frame: CGRect(x: 0, y: 7, width: tableView.bounds.width, height: 30))
        headerLabel.font = .systemFont(ofSize: 16.0, weight: .semibold, width: .expanded)
        headerLabel.text = headers[section]
        if section == 0 {
            headerLabel.textColor = #colorLiteral(red: 0, green: 0.7705866694, blue: 0, alpha: 1)
        }else{
            headerLabel.textColor = #colorLiteral(red: 1, green: 0, blue: 0, alpha: 1)
        }
        headerLabel.textAlignment = .center
        headerView.addSubview(headerLabel)
        return headerView
    }

    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44.0
    }
}
