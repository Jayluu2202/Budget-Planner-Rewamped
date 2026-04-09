//
//  FontEnum.swift
//  BudgetPlannerTUF
//
//  Created by Admin on 06/04/26.
//

import SwiftUI

enum Boska: String {
    case black = "Boska-Black"
    case bold = "Boska-Bold"
    case medium = "Boska-Medium"
    case regular = "Boska-Regular"
    
    func font(size: CGFloat) -> Font {
        .custom(self.rawValue, size: size)
    }
}

enum Poppins: String {
    case black = "Poppins-Black"
    case bold = "Poppins-Bold"
    case medium = "Poppins-Medium"
    case regular = "Poppins-Regular"
    
    func font(size: CGFloat) -> Font {
        .custom(self.rawValue, size: size)
    }
}
