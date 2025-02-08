//
//  IdentifiableBinding.swift
//  Infinity for Reddit
//
//  Created by Docile Alligator on 2025-02-08.
//

import Foundation
import SwiftUI

struct IdentifiableBinding<T>: Identifiable {
    let id = UUID()
    var binding: Binding<T>
}
