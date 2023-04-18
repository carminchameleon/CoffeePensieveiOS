//
//  OnboardingStartView.swift
//  CoffeePensieve
//
//  Created by Eunji Hwang on 2023/04/14.
//

import UIKit

class OnboardingStartView: UIView {

    var pageViewController: UIPageViewController?

    var pages = [UIViewController]()
    private var initialPage = 0
    
    let appNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Coffee \n Pensieve"
        label.font = UIFont.systemFont(ofSize: 18, weight: .heavy)
        label.textColor = .black
        label.numberOfLines = 2
        label.textAlignment = .center
        return label
    }()
    
    let startButton: UIButton = {
        let button = UIButton(type:.custom)
        button.setTitle("Get Started", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.setTitleColor(UIColor.white, for: .normal)
        button.backgroundColor = .primaryColor500
        button.clipsToBounds = true
        button.layer.cornerRadius = 6
        button.isEnabled = true
        return button
    }()
    
    let pageControl = UIPageControl()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addViews()
        makeUI()
        setUp()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    
    func addViews() {
        self.addSubview(appNameLabel)
        self.addSubview(pageControl)
        self.addSubview(startButton)
    }
    
    func makeUI(){
        self.backgroundColor = .white
        pageControl.currentPageIndicatorTintColor = UIColor.primaryColor200
        pageControl.pageIndicatorTintColor = UIColor.primaryColor100

        pageControl.translatesAutoresizingMaskIntoConstraints = false
        appNameLabel.translatesAutoresizingMaskIntoConstraints = false
        startButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            appNameLabel.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 12),
            appNameLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            pageControl.topAnchor.constraint(equalTo: bottomAnchor, constant: -150),
            pageControl.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            startButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            startButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -48),
            startButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 36),
            startButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -36),
            startButton.heightAnchor.constraint(equalToConstant: 48)
        ])
    }
    
    

    private func setUp() {
        pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)

        pageViewController?.dataSource = self
        pageViewController?.delegate = self

        // MARK: - ENUM 으로 만들어 넣을 것
        let firstPage = OnboardingViewController(imageName: "Cloud 1", mainText: "Make Your Coffee Tracker", subText: "how many cups of coffee do you drink a day? \n What made you need a coffee? \n Keep your coffee moment.")
        let secondPage = OnboardingViewController(imageName: "Cloud 3", mainText: "Check Your Feeling And Mood", subText: "How are you really doing? \n Even while drinking coffee, \nlook back on your feeling and mood.")
        let thirdPage = OnboardingViewController(imageName: "Cloud 4", mainText: "Anytime, Anywhere", subText: "Whether it's a cafe, an office, or a home.\n When you get a coffee,\n Always I’m here.")

        pages.append(firstPage)
        pages.append(secondPage)
        pages.append(thirdPage)

        // 처음으로 보여질 페이지를 선택, 배열이지만 단 하나만 보내야 함.
        pageViewController?.setViewControllers([pages[initialPage]], direction: .forward, animated: true)
//        addChild(pageViewController!)
        addSubview(pageViewController!.view)
//        pageViewController?.didMove(toParent: self)
    }
    
    private func configurePageControl() {
        pageControl.numberOfPages = pages.count
        pageControl.currentPage = initialPage
    }
    
    

}


// MARK: - 페이지 뷰 컨트롤러에서 컨텐츠 뷰 컨트롤러를 반환하는 함수
extension OnboardingStartView: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        guard let currentIndex = pages.firstIndex(of: viewController) else { return nil }
        
        // 전페이지가 0이면, 그 전의 페이지는 마지막 페이지 (빙글 빙글 도니까)
        if currentIndex == 0 {
            return pages.last               // wrap to last
        } else {
            return pages[currentIndex - 1]  // go previous
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        guard let currentIndex = pages.firstIndex(of: viewController) else { return nil }
        if currentIndex == pages.count - 1 {
            return pages.first               // wrap to last
        } else {
            return pages[currentIndex + 1]  // go previous
        }
    }
    
}
// MARK: - 페이지 이동에 따라 인디케이터 표시
extension OnboardingStartView: UIPageViewControllerDelegate {
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        
        guard let viewControllers = pageViewController.viewControllers else { return }
        guard let currentIndex = pages.firstIndex(of: viewControllers[0]) else { return }
        
        pageControl.currentPage = currentIndex
    }
}
