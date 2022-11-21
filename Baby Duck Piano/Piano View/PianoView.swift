//
//  PianoView.swift
//  Baby Duck Piano
//
//  Created by jls on 21.11.22.
//

import Foundation
import UIKit

protocol PianoViewDelegate : AnyObject {
	func andrzejDidPressKey(keyIndex: Int)
	func andrzejDidReleaseKey(keyIndex: Int)
}

class PianoView : UIView {
	enum KeyState {
		case pressed
		case idle
	}

	var keyCount: Int = 8
	var palette: [UIColor] = [
		UIColor.red,
		UIColor.orange,
		UIColor.yellow,
		UIColor.green,
		UIColor.blue,
		UIColor.purple,
		UIColor.systemPink,
		UIColor.systemTeal
	]
	var keyStateMap: [KeyState] = [
		.idle,
		.idle,
		.idle,
		.idle,
		.idle,
		.idle,
		.idle,
		.idle
	]

	weak var delegate: PianoViewDelegate? = nil
	override init(frame: CGRect) {
		super.init(frame: frame)
		self.isMultipleTouchEnabled = true
	}

	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		self.isMultipleTouchEnabled = true
	}

	override func draw(_ rect: CGRect) {
		UIColor.white.set()
		UIRectFill(self.bounds)

		self.drawKeys()
	}
}

extension PianoView {
	func drawKeys() {
		//first we draw the white keys
		do {
			let keyWidth = self.bounds.width / CGFloat(self.keyCount)
			for k in 0..<keyCount {
				let keyRect = CGRect(x: CGFloat(k) * keyWidth,
									 y: 0,
									 width: keyWidth,
									 height: self.bounds.height)
				var palcol = self.palette[k]
				if self.keyStateMap[k] == .pressed {
					palcol = palcol.lighterColor
				}
				palcol.set()
				UIRectFill(keyRect)

				UIColor.black.set()
				UIRectFrame(keyRect)
			}
		}

		//draw black keys
		do {
			let whiteKeyWidth = self.bounds.width / CGFloat(self.keyCount)
			let blackKeyWidth = whiteKeyWidth * 0.70
			let keyHeight = self.bounds.height / 2

			let indices = [1, 2, 4, 5, 6]
			for i in indices {
				let keyRect = CGRect(x: CGFloat(i) * whiteKeyWidth - blackKeyWidth/2.0,
									 y: 0,
									 width: blackKeyWidth,
									 height: keyHeight)

				UIColor.black.set()
				UIRectFill(keyRect)
			}
		}
	}
}

extension PianoView {
	func keyIndexForClickPoint(point: CGPoint) -> Int? {
		do {
			let keyWidth = self.bounds.width / CGFloat(self.keyCount)
			for k in 0..<keyCount {
				let keyRect = CGRect(x: CGFloat(k) * keyWidth,
									 y: 0,
									 width: keyWidth,
									 height: self.bounds.height)
				if keyRect.contains(point) {
					return k
				}

			}
		}
		return nil
	}

	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		for touch in touches {
			let tapPoint = touch.location(in: self)
			if let keyIndex = self.keyIndexForClickPoint(point: tapPoint) {
				self.keyStateMap[keyIndex] = .pressed
				self.delegate?.andrzejDidPressKey(keyIndex: keyIndex)
			}
		}
		self.setNeedsDisplay()
	}

	override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
		for touch in touches {
			let prevTapPoint = touch.previousLocation(in: self)
			if let prevKeyIndex = self.keyIndexForClickPoint(point: prevTapPoint) {
				let tapPoint = touch.location(in: self)
				if let keyIndex = self.keyIndexForClickPoint(point: tapPoint) {
					if keyIndex != prevKeyIndex {
						self.keyStateMap[prevKeyIndex] = .idle
						self.delegate?.andrzejDidReleaseKey(keyIndex: prevKeyIndex)
						self.keyStateMap[keyIndex] = .pressed
						self.delegate?.andrzejDidPressKey(keyIndex: keyIndex)
					}
				}
			}
		}
		self.setNeedsDisplay()
	}

	override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
		for touch in touches {
			let tapPoint = touch.location(in: self)
			if let keyIndex = self.keyIndexForClickPoint(point: tapPoint) {
				self.keyStateMap[keyIndex] = .idle
				self.delegate?.andrzejDidReleaseKey(keyIndex: keyIndex)
			}
		}
		self.setNeedsDisplay()
	}
}

extension UIColor {

	var lighterColor: UIColor {
		return lighterColor(removeSaturation: 0.5, resultAlpha: -1)
	}

	func lighterColor(removeSaturation val: CGFloat, resultAlpha alpha: CGFloat) -> UIColor {
		var h: CGFloat = 0, s: CGFloat = 0
		var b: CGFloat = 0, a: CGFloat = 0

		guard getHue(&h, saturation: &s, brightness: &b, alpha: &a)
		else {return self}

		return UIColor(hue: h,
					   saturation: max(s - val, 0.0),
					   brightness: b,
					   alpha: alpha == -1 ? a : alpha)
	}
}
