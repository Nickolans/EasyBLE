//
//  File.swift
//  
//
//  Created by Nickolans Griffith on 1/26/23.
//

import Foundation

@available(iOS 13.0, *)
public enum LoadType {
    case peripheral(Peripheral)
    case services([Service])
    case characteristics([Characteristic])
    case descriptors([Descriptor])
}
