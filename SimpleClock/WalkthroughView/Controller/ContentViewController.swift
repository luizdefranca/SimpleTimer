//
//  ContentViewController.swift
//  SimpleClock
//
//  Created by Luiz on 4/21/21.
//

import UIKit

class ContentViewController: UIViewController {

    //MARK: - Outlets

    @IBOutlet weak var contentImageView: UIImageView!
    @IBOutlet weak var greetingsLabel: UILabel!
    @IBOutlet weak var comentLabel: UILabel!
    @IBOutlet weak var skipButton: UIButton!
    @IBOutlet weak var pageControl: UIPageControl!

    //MARK: - Properties
    var index : Int = 0
    var imageFile = UIImage()
    var greetings = ""
    var coments = ""


    //MARK: - LifeCycle Functions
    override func viewDidLoad() {
        skipButton.layer.cornerRadius = 5

    }



    //MARK: - Actions

    @IBAction func skipButtonTapped(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }

    //MARK: - Functions
    private func setupView() {
        contentImageView.image = imageFile
        greetingsLabel.text = greetings
        comentLabel.text = coments
    }

    private func setupButton() {
        skipButton.layer.cornerRadius = 5
        switch index {
            case 0...1:
                skipButton.setTitle("Skip", for: .normal)
            default:
                skipButton.setTitle("Done", for: .normal)
        }
    }
    //MARK: - Extensions
}
