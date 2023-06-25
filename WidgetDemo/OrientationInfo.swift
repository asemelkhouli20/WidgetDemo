//
//  OrientationInfo.swift
//  WidgetDemo
//
//  Created by Asem on 25/06/2023.
//

import SwiftUI
final class OrientationInfo: ObservableObject {
    @Published var isPortrait: Bool
    private var _observer: NSObjectProtocol?
    init() {
        //Defualt Value
        self.isPortrait = !(UIDevice.current.orientation.isLandscape)
        //Set _observer for orientationDidChangeNotification
        _observer = NotificationCenter.default.addObserver(forName: UIDevice.orientationDidChangeNotification,object: nil,queue: nil) { [unowned self] note in
            guard let device = note.object as? UIDevice else {return}
            if device.orientation.isPortrait {self.isPortrait = true}
            else if device.orientation.isLandscape {self.isPortrait = false}
        }
    }
    deinit {if let observer = _observer {NotificationCenter.default.removeObserver(observer)}}
}
