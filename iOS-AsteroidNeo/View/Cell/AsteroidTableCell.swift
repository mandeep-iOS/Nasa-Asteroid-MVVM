//
//  AsteroidTableCell.swift
//  iOS-AsteroidNeo
//
//  Created by Deep Baath on 12/02/23.
//

import UIKit

//MARK: AsteroidTableCell 
class AsteroidTableCell: UITableViewCell {
    
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var idLbl: UILabel!
    @IBOutlet weak var speedLbl: UILabel!
    @IBOutlet weak var averageLbl: UILabel!
    @IBOutlet weak var cellBgView: UIView!
    @IBOutlet weak var distanceLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        cellBgView.setCornerRadius(radius: 7, borderColor: .white)
    }
    
    func setCellData(cellData: AsteroidDataModelWithDate.NearEarthObject){
        nameLbl.text = cellData.name ?? ""
        idLbl.text = cellData.id ?? ""
        speedLbl.text = cellData.closeApproachData?.first?.relativeVelocity?.kilometersPerHour ?? ""
        distanceLbl.text = cellData.closeApproachData?.first?.missDistance?.kilometers ?? ""
        averageLbl.text = "\(AsteroidDataHelper.averageSize(_data: cellData))"
    }
}
