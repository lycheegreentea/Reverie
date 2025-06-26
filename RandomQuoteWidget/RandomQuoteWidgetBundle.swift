//
//  RandomQuoteWidgetBundle.swift
//  RandomQuoteWidget
//
//  Created by Lauren Chen on 6/25/25.
//

import WidgetKit
import SwiftUI

@main
struct RandomQuoteWidgetBundle: WidgetBundle {
    var body: some Widget {
        RandomQuoteWidget()
        RandomQuoteWidgetControl()
    }
}
