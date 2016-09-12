//
//  ShipLocationViewController.swift
//  Battleship
//
//  Created by Sam Burnstone on 14/07/2016.
//  Copyright © 2016 ShinobiControls. All rights reserved.
//

import UIKit

class ShipLocationViewController: UIViewController {

    @IBOutlet weak var gameBoard: GameBoardView!
    @IBOutlet weak var remainingLabel: UILabel!
    @IBOutlet weak var finishedButton: UIButton!
    
    var onLocationSelectionComplete: ((_ model : GameModel, _ image : UIImage) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateLabels()
        
        gameBoard.onCellSelection = {
            
            [unowned self]
            cellLocation in
            
            // Only alter the cell style if we have ships left to position or we're toggling a cell that currently contains a ship
            guard self.shipsLeftToPosition > 0 ||
                self.gameBoard.selectedCells.contains(cellLocation) else {
                return
            }
            
            self.gameBoard.toggleCellStyle(at: cellLocation)
            self.updateLabels()
        }
    }
    
    @IBAction func completedShipLocationSelection(_ sender: AnyObject) {
        let model = GameModel(shipLocations: gameBoard.selectedCells, isComplete: false)
        
        // Clear screen for snapshot (we don't want to give away where we've located our ships!)
        gameBoard.reset()
        
        onLocationSelectionComplete?(model, UIImage.snapshot(from: gameBoard))
    }
}

extension ShipLocationViewController {
    var shipsLeftToPosition: Int {
        return GameConstants.totalShipCount - self.gameBoard.selectedCells.count
    }
    
    func updateLabels() {
        remainingLabel.text = "Ships to Place: \(shipsLeftToPosition)"
        finishedButton.isEnabled = shipsLeftToPosition == 0
    }
}
