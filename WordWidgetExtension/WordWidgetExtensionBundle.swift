//
//  WordWidgetExtensionBundle.swift
//  WordWidgetExtension
//
//  Created by Lauren Chen on 6/5/25.
//

import WidgetKit
import SwiftUI

@main
struct WordWidgetExtensionBundle: WidgetBundle {
    var body: some Widget {
        WordWidgetExtension()
        WordWidgetExtensionControl()
    }
}
