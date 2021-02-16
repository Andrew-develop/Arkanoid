//
//  AboutUsViewController.swift
//  Arkanoid
//
//  Created by Sergio Ramos on 17.12.2020.
//

import UIKit

class AboutUsViewController: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    var contentWidth : CGFloat = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for image in 0...2 {
            let imageToDisplay = UIImage(named: "\(image)")
            let imageView = UIImageView(image: imageToDisplay)

            contentWidth += scrollView.frame.width
            scrollView.addSubview(imageView)
            imageView.frame = CGRect(x: scrollView.frame.width * CGFloat(image), y: 0, width: scrollView.frame.width, height: scrollView.frame.height)
        }
        
        scrollView.contentSize = CGSize(width: contentWidth, height: scrollView.frame.height)
    }
    
    
    @IBAction func tapToPageControl(_ sender: UIPageControl) {
        scrollView.contentOffset.x = scrollView.frame.width * CGFloat(sender.currentPage)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        pageControl.currentPage = Int(scrollView.contentOffset.x / scrollView.frame.width)
    }
    
    @IBAction func close(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}
