//
//  PianoViewController.swift
//  Baby Duck Piano
//
//  Created by jls on 21.11.22.
//

import UIKit
import AVFoundation

class PianoViewController: UIViewController {
	@IBOutlet var pianoView: PianoView!

	override func viewDidLoad() {
		super.viewDidLoad()
		self.pianoView.delegate = self
	}


	var players: [AVAudioPlayer] = []

	func playSound(index: Int) {
		guard let url = Bundle.main.url(forResource: "\(index)", withExtension: "aif") else { return }

		do {
			try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
			try AVAudioSession.sharedInstance().setActive(true)

			/* The following line is required for the player to work on iOS 11. Change the file type accordingly*/
			let player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.aiff.rawValue)
			player.delegate = self
			self.players.append(player)

			player.play()
		} catch let error {
			print(error.localizedDescription)
		}
	}
}

extension PianoViewController : AVAudioPlayerDelegate {
	func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer,
									 successfully flag: Bool) {
		self.players.removeAll(where: { $0 == player })
	}
}

extension PianoViewController : PianoViewDelegate {
	func andrzejDidPressKey(keyIndex: Int) {
		playSound(index: keyIndex)
	}

	func andrzejDidReleaseKey(keyIndex: Int) {

	}
}
