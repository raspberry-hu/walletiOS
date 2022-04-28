//
//  ButtonStyle.swift
//  MEGA
//
//  Created by hu on 2022/04/28.
//  Copyright © 2022 MEGA. All rights reserved.
//

import Foundation
import SwiftUI

struct MintButtonStyle: ButtonStyle {
  func makeBody(configuration: Self.Configuration) -> some View {
    configuration.label
      .frame(width: UIScreen.screenWidth * 0.8, height: UIScreen.screenHeight * 0.03, alignment: .center)
      .padding()
      .foregroundColor(.white)
      .background(configuration.isPressed ? Color.red : Color.blue)
      .cornerRadius(8.0)
  }
}
