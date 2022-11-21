//
//  PianoViewController.swift
//  Baby Duck Piano
//
//  Created by jls on 21.11.22.
//

import UIKit

class PianoViewController: UIViewController {
	@IBOutlet var pianoView: PianoView!

    override func viewDidLoad() {
        super.viewDidLoad()
		self.pianoView.delegate = self
    }
}

extension PianoViewController : PianoViewDelegate {
	func andrzejDidPressKey(keyIndex: Int) {
		NSLog("key pressed! \(keyIndex)")
	}

	func andrzejDidReleaseKey(keyIndex: Int) {
		NSLog("key released! \(keyIndex)")
	}
}
