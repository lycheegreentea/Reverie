//
//  RandomQuoteBundle.swift
//  RandomQuote
//
//  Created by Lauren Chen on 6/25/25.
//

import WidgetKit
import SwiftUI

@main
struct RandomQuoteBundle: WidgetBundle {
    var body: some Widget {
        RandomQuote()
        RandomQuoteControl()
    }
}
