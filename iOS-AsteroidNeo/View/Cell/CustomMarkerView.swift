//
//  CustomMarkerView.swift
//  iOS-AsteroidNeo
//
//  Created by Deep Baath on 12/02/23.
//

import UIKit
import Charts

//MARK: CustomMarkerView used for show info when user tap on Chart bar 
class CustomMarkerView: MarkerView {

    @IBOutlet var contentView: UIView!
    @IBOutlet weak var markerBoard: UIView!
    @IBOutlet weak var rateLabel: UILabel!
    @IBOutlet weak var countryLabel: UILabel!
    @IBOutlet weak var markerStick: UIView!

    override init(frame: CGRect) {
        super.init(frame: frame)
        initUI()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initUI()
    }
    private func initUI() {
        Bundle.main.loadNibNamed("CustomMarkerView", owner: self, options: nil)
        addSubview(contentView)
        markerStick.backgroundColor = .chartHightlightColour
        markerBoard.backgroundColor = .chartHightlightColour
        markerBoard.layer.cornerRadius = 5
        rateLabel.textColor = .white
        countryLabel.textColor = .white

        self.frame = CGRect(x: 0, y: 0, width: 79, height: 73)
        self.offset = CGPoint(x: -(self.frame.width/2), y: -self.frame.height)
    }

}
