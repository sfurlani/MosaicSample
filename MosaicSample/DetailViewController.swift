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
    
    @IBOutlet var toolbarButtons: [UIBarButtonItem]!
    
    var palette: Palette? {
        didSet {
            // Update the view.
            configureView()
        }
    }

    func configureView() {
        // Update the user interface for the detail item.
        guard let palette = self.palette else {
            print("palette not assigned")
            return
        }
        guard let _ = self.view else {
            print("ViewHeirachy not loaded")
            return
        }
        
        self.title = palette.title
        
        if let svc = splitViewController where svc.collapsed {
            self.toolbarItems = [leftSpace, reverseButton, fixedSpace, bayesianButton, verticalButton, circleButton, rightSpace]
            self.navigationController?.toolbarHidden = false
        }
        else {
            self.navigationItem.rightBarButtonItems = [circleButton, verticalButton, bayesianButton, fixedSpace, reverseButton]
            self.navigationController?.toolbarHidden = true
        }
        
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func willTransitionToTraitCollection(newCollection: UITraitCollection, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        coordinator.animateAlongsideTransition(transitionAnimator, completion: nil)
    }
    
    func transitionAnimator(context: UIViewControllerTransitionCoordinatorContext) {
        configureView()
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
    

}

