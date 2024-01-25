//
//  WarfareModel.swift
//  NemaOkupantiv
//
//  Created by SHIN MIKHAIL on 06.01.2024.
//

import Foundation

struct StatsInfo: Codable {
    let aa_warfare_systems: Int
    let armoured_fighting_vehicles: Int
    let artillery_systems: Int
    let atgm_srbm_systems: Int
    let cruise_missiles: Int
    let helicopters: Int
    let mlrs: Int
    let personnel_units: Int
    let planes: Int
    let special_military_equip: Int
    let submarines: Int
    let tanks: Int
    let uav_systems: Int
    let vehicles_fuel_tanks: Int
    let warships_cutters: Int
}

struct IncreaseInfo: Codable {
    let aa_warfare_systems: Int
    let armoured_fighting_vehicles: Int
    let artillery_systems: Int
    let atgm_srbm_systems: Int
    let cruise_missiles: Int
    let helicopters: Int
    let mlrs: Int
    let personnel_units: Int
    let planes: Int
    let special_military_equip: Int
    let submarines: Int
    let tanks: Int
    let uav_systems: Int
    let vehicles_fuel_tanks: Int
    let warships_cutters: Int
}

struct StatsData: Codable {
    let date: String
    let day: Int
    let increase: IncreaseInfo
    let resource: String
    let stats: StatsInfo
}

struct WarfareData: Codable {
    let data: StatsData
}
