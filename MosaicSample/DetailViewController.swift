//
//  DetailViewController.swift
//  MosaicSample
//
//  Created by SFurlani on 8/14/15.
//  Copyright © 2015 Strong Fortress. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet var paletteView: PaletteView!

    @IBOutlet var leftSpace: UIBarButtonItem!
    @IBOutlet var reverseButton: UIBarButtonItem!
    @IBOutlet var fixedSpace: UIBarButtonItem!
    @IBOutlet var verticalButton: UIBarButtonItem!
    @IBOutlet var bayesianButton: UIBarButtonItem!
    @IBOutlet var circleButton: UIBarButtonItem!
    @IBOutlet var rightSpace: UIBarButtonItem!
    
    var palette: Palette? {
        didSet {
            // Update the view.
            
            configureView()
        }
    }

    func configureView() {
        // Update the user interface for the detail item.

        title = palette?.title
        setupToolbarItems(traitCollection)
        
        reverseButton?.enabled = true
        verticalButton?.enabled = true
        bayesianButton?.enabled = true
        circleButton?.enabled = true
        
        paletteView?.palette = palette
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        configureView()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        paletteView.setNeedsDisplay()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func willTransitionToTraitCollection(newCollection: UITraitCollection, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        setupToolbarItems(newCollection)
    }

    @IBAction func bayesian(sender: UIBarButtonItem?) {
        paletteView?.strategy = paletteView.bayesianStrategy
    }
    
    @IBAction func vertical(sender: UIBarButtonItem?) {
        paletteView?.strategy = paletteView.verticalStrategy
    }
    
    @IBAction func circular(sender: UIBarButtonItem?) {
        paletteView?.strategy = paletteView.circularStrategy
    }
    
    @IBAction func reverse(sender: UIBarButtonItem?) {
        paletteView?.reverse = !paletteView.reverse
    }
    
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

