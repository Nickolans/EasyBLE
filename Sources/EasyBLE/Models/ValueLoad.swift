//
//  File.swift
//  
//
//  Created by Nickolans Griffith on 1/26/23.
//

import Foundation

@available(iOS 13.0, *)
public enum ValueLoad {
    case characteristic(Characteristic)
    case descriptor(Descriptor)
}
