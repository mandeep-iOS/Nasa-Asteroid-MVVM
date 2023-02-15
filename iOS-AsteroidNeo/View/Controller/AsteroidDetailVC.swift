//
//  AsteroidDetailVC.swift
//  iOS-AsteroidNeo
//
//  Created by Deep Baath on 12/02/23.
//

import UIKit

class AsteroidDetailVC: UIViewController {
    
    //MARK: Outlets
    @IBOutlet weak var detailView: UIView!
    @IBOutlet weak var dateTimeLbl: UILabel!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var idLbl: UILabel!
    @IBOutlet weak var refIdLbl: UILabel!
    @IBOutlet weak var urlLbl: UILabel!
    @IBOutlet weak var absoulteMagLbl: UILabel!
    @IBOutlet weak var minDimtrLbl: UILabel!
    @IBOutlet weak var maxDimtrLbl: UILabel!
    @IBOutlet weak var averageDimtrLbl: UILabel!
    @IBOutlet weak var distanceAstrnoLbl: UILabel!
    @IBOutlet weak var distanceLunarLbl: UILabel!
    @IBOutlet weak var distanceKmLbl: UILabel!
    @IBOutlet weak var distanceMilesLbl: UILabel!
    @IBOutlet weak var velocityKmSecLbl: UILabel!
    @IBOutlet weak var velocityKmHourLbl: UILabel!
    @IBOutlet weak var velocityMilesHourLbl: UILabel!
    @IBOutlet weak var orbitingBodyLbl: UILabel!
    
    //MARK: optional detail object of asteroidData
    var asteroidData: AsteroidDataModelWithDate.NearEarthObject?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.isNavigationBarHidden = true
        //Unwrap optional data
        guard let unwrapData = asteroidData else {return}
        //MARK: Call update Data Method
        updateDataOnUI(safeData: unwrapData)
    }
    
    @IBAction func backBtnAction(_ sender: UIButton){
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK: Setup UI and update data 
    func updateDataOnUI(safeData: AsteroidDataModelWithDate.NearEarthObject){
        dateTimeLbl.text = safeData.closeApproachData?.first?.closeApproachDateFull ?? ""
        nameLbl.text = safeData.name ?? ""
        idLbl.text = safeData.id ?? ""
        refIdLbl.text = safeData.neoReferenceID ?? ""
        urlLbl.text = safeData.nasaJplURL ?? ""
        absoulteMagLbl.text = "\(safeData.absoluteMagnitudeH ?? 0.0)"
        minDimtrLbl.text = "\(safeData.estimatedDiameter?.kilometers?.estimatedDiameterMin ?? 0.0)"
        maxDimtrLbl.text = "\(safeData.estimatedDiameter?.kilometers?.estimatedDiameterMax ?? 0.0)"
        averageDimtrLbl.text = "\(AsteroidDataHelper.averageSize(_data: safeData))"
        distanceAstrnoLbl.text = safeData.closeApproachData?.first?.missDistance?.astronomical ?? ""
        distanceLunarLbl.text = safeData.closeApproachData?.first?.missDistance?.lunar ?? ""
        distanceKmLbl.text = safeData.closeApproachData?.first?.missDistance?.kilometers ?? ""
        distanceMilesLbl.text = safeData.closeApproachData?.first?.missDistance?.miles ?? ""
        velocityKmSecLbl.text = safeData.closeApproachData?.first?.relativeVelocity?.kilometersPerSecond ?? ""
        velocityKmHourLbl.text = safeData.closeApproachData?.first?.relativeVelocity?.kilometersPerHour ?? ""
        velocityMilesHourLbl.text = safeData.closeApproachData?.first?.relativeVelocity?.milesPerHour ?? ""
        orbitingBodyLbl.text = safeData.closeApproachData?.first?.orbitingBody?.rawValue ?? ""
    }
    
}
