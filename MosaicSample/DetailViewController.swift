//
//  DetailViewController.swift
//  MosaicSample
//
//  Created by SFurlani on 8/14/15.
//  Copyright © 2015 Strong Fortress. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    // MARK: - Propeties
    
    var palette: Palette? {
        didSet {
            configureView()
        }
    }
    
    // MARK: IBOutlets
    
    @IBOutlet var paletteView: PaletteView!

    // maybe make these two IBOutletCollections?  Ordering gets odd...?
    
    @IBOutlet var leftSpace: UIBarButtonItem!
    @IBOutlet var reverseButton: UIBarButtonItem!
    @IBOutlet var fixedSpace: UIBarButtonItem!
    @IBOutlet var verticalButton: UIBarButtonItem!
    @IBOutlet var bayesianButton: UIBarButtonItem!
    @IBOutlet var circleButton: UIBarButtonItem!
    @IBOutlet var rightSpace: UIBarButtonItem!
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        // make sure it re-draws (the circle gets stretched out otherwise)
        paletteView.setNeedsDisplay()
    }
    
    override func willTransitionToTraitCollection(newCollection: UITraitCollection, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        setupToolbarItems(newCollection)
    }

    // MARK: - IBActions
    
    /// Changes drawing strategy of the PaletteView
    @IBAction func bayesian(sender: UIBarButtonItem?) {
        paletteView?.strategy = PaletteView.bayesianStrategy
    }

    /// Changes drawing strategy of the PaletteView
    @IBAction func vertical(sender: UIBarButtonItem?) {
        paletteView?.strategy = PaletteView.verticalStrategy
    }
    
    /// Changes drawing strategy of the PaletteView
    @IBAction func circular(sender: UIBarButtonItem?) {
        paletteView?.strategy = PaletteView.circularStrategy
    }
    
    /// Changes drawing strategy of the PaletteView
    @IBAction func reverse(sender: UIBarButtonItem?) {
        paletteView?.reverse = !paletteView.reverse
    }
    
    // MARK: - Configurations
    
    /// Update the user interface based on the Palette
    func configureView() {
        
        guard let palette = self.palette else {
            return
        }
        
        title = palette.title
        setupToolbarItems(traitCollection)
        
        reverseButton?.enabled = true
        verticalButton?.enabled = true
        bayesianButton?.enabled = true
        circleButton?.enabled = true
        
        paletteView?.palette = palette
    }
    
    /// change the control buttons to either the bottom toolbar, or navigationItem.rightBarButtonItems
    func setupToolbarItems(traitCollection: UITraitCollection) {
        if traitCollection.horizontalSizeClass == .Compact && traitCollection.verticalSizeClass != .Compact {
            navigationItem.rightBarButtonItems = nil
            toolbarItems = [leftSpace, reverseButton, fixedSpace, bayesianButton, verticalButton, circleButton, rightSpace]
            navigationController?.toolbarHidden = false
        }
        else {
            toolbarItems = nil
            navigationItem.rightBarButtonItems = [circleButton, verticalButton, bayesianButton, fixedSpace, reverseButton]
            navigationController?.toolbarHidden = true
        }
    }

}

