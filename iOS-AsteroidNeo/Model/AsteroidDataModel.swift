//
//  AsteroidDataModelWithDate.swift
//  iOS-AsteroidNeo
//
//  Created by Deep Baath on 12/02/23.
//


import UIKit

// MARK: - AsteroidDataModelWithDate
struct AsteroidDataModelWithDate : Codable{
    let links: AsteroidDataModelWithDateLinks?
    let elementCount: Int?
    let nearEarthObjects: [String: [NearEarthObject]]?
    enum CodingKeys: String, CodingKey {
        case links
        case elementCount = "element_count"
        case nearEarthObjects = "near_earth_objects"
    }
    
    
    // MARK: - AsteroidDataModelWithDateLinks
    struct AsteroidDataModelWithDateLinks: Codable {
        let next, previous, linksSelf: String?
        
        enum CodingKeys: String, CodingKey {
            case next = "next"
            case previous = "previous"
            case linksSelf = "self"
        }
    }
    
    // MARK: - NearEarthObject
    struct NearEarthObject: Codable {
        let links: NearEarthObjectLinks?
        let id, neoReferenceID, name: String?
        let nasaJplURL: String?
        let absoluteMagnitudeH: Double?
        let estimatedDiameter: EstimatedDiameter?
        let isPotentiallyHazardousAsteroid: Bool?
        let closeApproachData: [CloseApproachDatum]?
        let isSentryObject: Bool?
        
        enum CodingKeys: String, CodingKey {
            case links = "links"
            case id = "id"
            case neoReferenceID = "neo_reference_id"
            case name = "name"
            case nasaJplURL = "nasa_jpl_url"
            case absoluteMagnitudeH = "absolute_magnitude_h"
            case estimatedDiameter = "estimated_diameter"
            case isPotentiallyHazardousAsteroid = "is_potentially_hazardous_asteroid"
            case closeApproachData = "close_approach_data"
            case isSentryObject = "is_sentry_object"
        }
    }
    
    // MARK: - CloseApproachDatum
    struct CloseApproachDatum: Codable {
        let closeApproachDate, closeApproachDateFull: String?
        let epochDateCloseApproach: Int?
        let relativeVelocity: RelativeVelocity?
        let missDistance: MissDistance?
        let orbitingBody: OrbitingBody?
        
        enum CodingKeys: String, CodingKey {
            case closeApproachDate = "close_approach_date"
            case closeApproachDateFull = "close_approach_date_full"
            case epochDateCloseApproach = "epoch_date_close_approach"
            case relativeVelocity = "relative_velocity"
            case missDistance = "miss_distance"
            case orbitingBody = "orbiting_body"
        }
    }
    
    // MARK: - MissDistance
    struct MissDistance: Codable {
        let astronomical, lunar, kilometers, miles: String?
        enum CodingKeys: String, CodingKey {
            case astronomical = "astronomical"
            case lunar = "lunar"
            case kilometers = "kilometers"
            case miles = "miles"
        }
    }
    
    enum OrbitingBody: String, Codable {
        case earth = "Earth"
    }
    
    // MARK: - RelativeVelocity
    struct RelativeVelocity: Codable {
        let kilometersPerSecond, kilometersPerHour, milesPerHour: String?
        
        enum CodingKeys: String, CodingKey {
            case kilometersPerSecond = "kilometers_per_second"
            case kilometersPerHour = "kilometers_per_hour"
            case milesPerHour = "miles_per_hour"
        }
    }
    
    // MARK: - EstimatedDiameter
    struct EstimatedDiameter: Codable {
        let kilometers, meters, miles, feet: Feet?
        enum CodingKeys: String, CodingKey {
            case kilometers = "kilometers"
            case meters = "meters"
            case miles = "miles"
            case feet = "feet"
        }
    }
    
    // MARK: - Feet
    struct Feet: Codable {
        let estimatedDiameterMin, estimatedDiameterMax: Double?
        
        enum CodingKeys: String, CodingKey {
            case estimatedDiameterMin = "estimated_diameter_min"
            case estimatedDiameterMax = "estimated_diameter_max"
        }
    }
    
    
    // MARK: - NearEarthObjectLinks
    struct NearEarthObjectLinks: Codable {
        let linksSelf: String?
        
        enum CodingKeys: String, CodingKey {
            case linksSelf = "self"
        }
    }
}

extension AsteroidDataModelWithDate {
    init(data: Data) throws {
        self = try JSONDecoder().decode(AsteroidDataModelWithDate.self, from: data)
    }
}


extension AsteroidDataModelWithDate {
    //MARK: AsteroidDataModelWithDate class also have predefined filterData based on Close and fastest Asteroid object data
    func fastestAsteroidArr() -> [FilterdAsteroidModel] {
        var fastestAsteroidDetailArr : [FilterdAsteroidModel] = []
        var fastestSpeed = Double.greatestFiniteMagnitude
        nearEarthObjects?.values.forEach { asteroids in
            asteroids.forEach { asteroid in
                asteroid.closeApproachData?.forEach { closeApproachData in
                    if let speed = Double(closeApproachData.relativeVelocity?.kilometersPerHour ?? ""), speed < fastestSpeed {
                        fastestSpeed = speed
                        fastestAsteroidDetailArr.append(FilterdAsteroidModel.init(asteroidID: asteroid.id ?? "", speed: fastestSpeed, type: .Fastest))
                    }
                }
            }
        }
        return fastestAsteroidDetailArr
    }
    
    func closestAsteroidArr() -> [FilterdAsteroidModel] {
        var closestAsteroidDetailArr : [FilterdAsteroidModel] = []
        var closestDistance = Double.greatestFiniteMagnitude
        nearEarthObjects?.values.forEach { asteroids in
            asteroids.forEach { asteroid in
                asteroid.closeApproachData?.forEach { closeApproachData in
                    if let distance = Double(closeApproachData.missDistance?.kilometers ?? ""), distance < closestDistance {
                        closestDistance = distance
                        closestAsteroidDetailArr.append(FilterdAsteroidModel.init(asteroidID: asteroid.id ?? "", distance: closestDistance, type: .Closest))
                    }
                }
            }
        }
        return closestAsteroidDetailArr
    }
    
}
