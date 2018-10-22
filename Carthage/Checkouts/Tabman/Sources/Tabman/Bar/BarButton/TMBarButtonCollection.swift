//
//  TMBarButtonCollection.swift
//  Tabman
//
//  Created by Merrick Sapsford on 03/08/2018.
//  Copyright © 2018 UI At Six. All rights reserved.
//

import UIKit

/// Container for BarButton objects and related controllers.
public final class TMBarButtonCollection<BarButtonType: TMBarButton> {
    
    // MARK: Types
    
    public typealias Customization = (BarButtonType) -> Void
    
    // MARK: Buttons
    
    /// All bar buttons.
    public internal(set) var all = [BarButtonType]() {
        didSet {
            self.stateController = TMBarButtonStateController(for: all)
            self.interactionController = TMBarButtonInteractionController(for: all, handler: self)
            
            for button in all {
                customization?(button)
            }
        }
    }
    
    private var customization: Customization?
    
    /// Controller which handles button state updates.
    internal private(set) var stateController: TMBarButtonStateController!
    /// Controller which handles button interaction.
    internal private(set) var interactionController: TMBarButtonInteractionController!
    
    /// External handler that responds to interaction controller events.
    internal weak var interactionHandler: TMBarButtonInteractionHandler?
    
    // MARK: Init
    
    internal init() {
        self.stateController = TMBarButtonStateController(for: all)
        self.interactionController = TMBarButtonInteractionController(for: all, handler: self)
    }
    
    // MARK: Customization

    /**
     Customize the bar buttons that are added to the bar.
     
     Note: The customization closure is retained and will be called every time a bar button is added/removed.
     
     Parameter customize: The closure in which customization takes place.
     **/
    public func customize(_ customize: @escaping Customization) {
        self.customization = customize
        all.forEach { (button) in
            customize(button)
        }
    }
    
    // MARK: Utility
    
    /// Get a button that is associated with a bar item.
    ///
    /// - Parameter item: Item to search for.
    /// - Returns: Associated bar button.
    public func `for`(item: TMBarItemable) -> BarButtonType? {
        guard let index = all.index(where: { ($0.item === item) }) else {
            return nil
        }
        return all[index]
    }
    
    /// Get buttons associated with bar items.
    ///
    /// - Parameter items: Items to search for.
    /// - Returns: Associated bar buttons.
    public func `for`(items: TMBarItemable...) -> [BarButtonType] {
        return items.compactMap({ self.for(item: $0) })
    }
}

extension TMBarButtonCollection: TMBarButtonInteractionHandler {
    
    func barButtonInteraction(controller: TMBarButtonInteractionController,
                              didHandlePressOf button: TMBarButton,
                              at index: Int) {
        interactionHandler?.barButtonInteraction(controller: controller,
                                                 didHandlePressOf: button,
                                                 at: index)
    }
}