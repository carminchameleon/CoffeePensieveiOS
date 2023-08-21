//
//  WelcomeViewController.swift
//  CoffeePensieve
//
//  Created by Eunji Hwang on 2023/04/18.
//

import UIKit

final class WelcomeViewController: UIViewController {
    
    private var pageViewController: UIPageViewController?
    private let pageControl = UIPageControl()
    private var pages = [UIViewController]()
    private var initialPage = 0
    
    private let appNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Coffee\nPensieve"
        label.font = UIFont.systemFont(ofSize: 18, weight: .heavy)
        label.textColor = .black
        label.numberOfLines = 2
        label.textAlignment = .center
        return label
    }()
    
    private let startButton: UIButton = {
        let button = UIButton(type:.custom)
        button.setTitle("Get Started", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.setTitleColor(UIColor.white, for: .normal)
        button.backgroundColor = .primaryColor500
        button.clipsToBounds = true
        button.layer.cornerRadius = 6
        button.isEnabled = true
        button.addTarget(self, action: #selector(moveToSignUp), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        style()
        setLayout()
    }
}

// MARK: - Default Settings
extension WelcomeViewController {
    
    private func setUp() {
        pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
 
        pageViewController?.dataSource = self
        pageViewController?.delegate = self
      
        //인디케이터 부분 눌렸을 때
        pageControl.addTarget(self, action: #selector(pageControlTapped(_:)), for: .valueChanged)
    
        let firstPage = OnboardingViewController(imageName: "Cloud 1", mainText: "Make Your Coffee Tracker", subText: "How many cups of coffee do you drink a day? \n What made you need a coffee? \n Keep your coffee moment.")
        let secondPage = OnboardingViewController(imageName: "Cloud 3", mainText: "Check Your Feeling And Mood", subText: "How are you really doing? \n Even while drinking coffee, \nlook back on your feeling and mood.")
        let thirdPage = OnboardingViewController(imageName: "Cloud 4", mainText: "Anytime, Anywhere", subText: "Whether it's a cafe, an office, or a home.\n When you get a coffee,\n Always I’m here.")
        
        pages.append(firstPage)
        pages.append(secondPage)
        pages.append(thirdPage)
        
        
        // 처음으로 보여질 페이지를 선택, 배열이지만 단 하나만 보내야 함.
        pageViewController?.setViewControllers([pages[initialPage]], direction: .forward, animated: true)
        addChild(pageViewController!)
        view.addSubview(pageViewController!.view)
        pageViewController?.didMove(toParent: self)
    }
    
    private func style() {
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        pageControl.currentPageIndicatorTintColor = UIColor.primaryColor200
        pageControl.pageIndicatorTintColor = UIColor.primaryColor100
        pageControl.numberOfPages = pages.count
        pageControl.currentPage = initialPage
    }
    
    private func setLayout() {
        

        view.addSubview(appNameLabel)
        appNameLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            appNameLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            appNameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        view.addSubview(pageControl)
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            pageControl.topAnchor.constraint(equalTo: startButton.topAnchor, constant: -48 ),
            pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])

        view.addSubview(startButton)
        startButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            startButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -24),
            startButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 36),
            startButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -36),
            startButton.heightAnchor.constraint(equalToConstant: 48)
        ])
    }
}

extension WelcomeViewController {
    @objc func pageControlTapped(_ sender: UIPageControl) {
        // sender.currentPage : 인디케이터에서 이동하기 위해 누른 페이지를 보여준다.
        pageViewController?.setViewControllers([pages[sender.currentPage]], direction: .forward, animated: true)
    }
    
    // MARK: - 회원 가입 스타트 포인트
    @objc func moveToSignUp(){
        self.dismiss(animated: true)
    }
}

// MARK: - 페이지 뷰 컨트롤러에서 컨텐츠 뷰 컨트롤러를 반환하는 함수
extension WelcomeViewController: UIPageViewControllerDataSource {
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
extension WelcomeViewController: UIPageViewControllerDelegate {
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        
        guard let viewControllers = pageViewController.viewControllers else { return }
        guard let currentIndex = pages.firstIndex(of: viewControllers[0]) else { return }
        
        pageControl.currentPage = currentIndex
    }
}
