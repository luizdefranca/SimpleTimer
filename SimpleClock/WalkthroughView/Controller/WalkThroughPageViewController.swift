//
//  WalkeThroughPageViewController.swift
//  SimpleClock
//
//  Created by Luiz on 4/21/21.
//


//let isTesting = true
import UIKit


class WalkThroughPageViewController: UIPageViewController {

    //MARK: - Properties

    let pageGreetings = ["Set your time", "See in any position", "Have fun"]
    let pageImages : [UIImage] = [UIImage(named: "time")!, UIImage(named: "landscape")!, UIImage(named: "playcat")!]
    let pageComents = ["Don't forget your tasks. Do every on the sharp.", "Don't worry about your cellphone position. Use in both portrait or ever landscape mode", "The live isn't just work. Enjoy our funny alert :)."]



    //MARK: - LifeCycle Functions
    override func viewDidLoad() {
        super.viewDidLoad()

        dataSource = self
        if let startingViewController = contentViewController(at: 0){
            setViewControllers([startingViewController], direction: .forward, animated: true, completion: nil)

            print("content pageview loaded")

        }
    }

    //MARK: - Actions


    //MARK: - Functions

    private func contentViewController(at index: Int) -> ContentViewController? {
        if index < 0 || index > pageGreetings.count {
            return nil
        }

        let storyBoard = UIStoryboard(name: "WalkthroughScreen", bundle: nil)
        guard let pageContentViewController  =
            storyboard?.instantiateViewController(identifier: "ContentViewController")
            as? ContentViewController else {
            return nil
        }

        pageContentViewController.imageFile = pageImages[index]
        pageContentViewController.greetings = pageGreetings[index]
        pageContentViewController.coments = pageComents[index]
        pageContentViewController.index = index
        return pageContentViewController
    }

    private func forward(for index: Int) {
        if let nextViewController = contentViewController(at: index + 1){
            setViewControllers([nextViewController], direction: .forward, animated: true, completion: nil)
        }
    }

}

//MARK: - Extensions
extension WalkThroughPageViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        var index = (viewController as! ContentViewController).index
        index += 1
        return contentViewController(at: index)
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        var index = (viewController as! ContentViewController).index
        index -= 1
        return contentViewController(at: index)
    }


}
