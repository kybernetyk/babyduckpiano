//
//  ViewController.swift
//  Baby Duck Piano
//
//  Created by jls on 21.11.22.
//

import UIKit

class MainViewController: UIViewController {
	@IBOutlet var pianoAnchor: UIView!
	var pianoViewController: PianoViewController!

	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view.

		self.pianoViewController = PianoViewController(nibName: "PianoViewController", bundle: nil)
		self.pianoAnchor.addSubview(self.pianoViewController.view)
		self.pianoViewController.view.frame = self.pianoAnchor.bounds
	}

	override var prefersStatusBarHidden: Bool {
		return true
	}

	@IBAction func someAction(_ sender: Any?) {
		NSLog("honk")
	}
}

