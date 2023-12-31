//
//  AppDependencyContainer.swift
//  RXMVVMC
//
//  Created by Vitalii Shkliar on 04.11.2019.
//  Copyright © 2019 Vitalii Shkliar. All rights reserved.
//

import UIKit
import RxSwift
import Swinject

//It's ok to supress linter here.
//swiftlint:disable force_unwrapping

class AppDependencyContainer {
    private lazy var appDIContainer: Container = {
        Container { container in
            // MARK: UserDataStore
            container.register(UserSessionDataStore.self) { _ in
                UDUserDataSession()
            }.inObjectScope(.container)
            
            // MARK: AuthAPI
            container.register(AuthRemoteAPI.self) { _ in
                TMDBAuthRemoteAPI(router: APIRouter<Auth>(),
                                  accountRouter: APIRouter<Account>(),
                                  responseHandler: AuthRemoteAPIResponseHandler(),
                                  accountResponseHandler: AccountRemoteAPIResponseHandler())
            }
            
            // MARK: MoviesRemoteAPI
            container.register(MoviesRemoteAPI.self) { resolver -> MoviesRemoteAPI in
                TMDBMoviesRemoteAPI(accountRouter: APIRouter<Account>(),
                                    moviesRouter: APIRouter<Movies>(),
                                     accResponseHandler: AuthRemoteAPIResponseHandler(),
                                     movieResonseHandler: MoviesRemoteAPIResponseHandler(),
                                     userSessionDataStore: resolver.resolve(UserSessionDataStore.self)!)
            }
            
            // MARK: UserRepo
            container.register(UserSessionRepository.self) { resolver in
                TMDBUserSessionRepository(dataStore: resolver.resolve(UserSessionDataStore.self)!,
                                          remoteAPI: resolver.resolve(AuthRemoteAPI.self)!)
            }.inObjectScope(.container)
            
            // MARK: MoviesRepo
            container.register(MoviesRepository.self) { resolver -> MoviesRepository in
                TMDBMoviesRepository(moviesAPI: resolver.resolve(MoviesRemoteAPI.self)!)
            }.inObjectScope(.weak)
           
            // MARK: BEConfigRepo
            container.register(BEConfigurationDataStore.self) { _ -> BEConfigurationDataStore in
                UDBEConfigurationDataStore()
            }
            
            container.register(BEConfigurationRemoteAPI.self) { _ -> BEConfigurationRemoteAPI in
                TMDBBEConfigurationRemoteAPI(router: APIRouter<BEConfiguration>())
            }
            
            container.register(BEConfigurationRepository.self) { resolver -> BEConfigurationRepository in
                TMDBBEConfigurationRepository(dataStore: resolver.resolve(BEConfigurationDataStore.self)!,
                                              remoteAPI: resolver.resolve(BEConfigurationRemoteAPI.self)!)
            }.inObjectScope(.weak)
            
            // MARK: TabBar coordinator
            container.register(TabBarCoordinator.self) { (_, router: RouterType) -> TabBarCoordinator in
                let moviesDIContainer: MoviesDIContainer = MoviesDIContainer(parentContainer: container)
                let profileDIContainer: ProfileDIContainer = ProfileDIContainer(parentContainer: container)
                return TabBarCoordinator(router: router,
                                         moviesCoordinatorFactory: moviesDIContainer.makeMoviesCoordinator,
                                         profileCoordinatorFactory: profileDIContainer.makeProfileCoordinator)
            }
            
            // MARK: AuthorizationCoordinator
            container.register(AuthorizationCoordinator.self) { (resolver, router: RouterType) -> AuthorizationCoordinator in
                let DIContainer = AuthDIContainer(parentContainer: container)
                let repo = resolver.resolve(UserSessionRepository.self)!
                return AuthorizationCoordinator(router: router,
                                                userRepo: repo,
                                                loginVCFactory: DIContainer.makeLoginVC,
                                                signUpVCFactory: DIContainer.makeSignUpVC)
            }
            
            // MARK: AppCoordinator
            container.register(AppCoordinator.self) { resolver in
                let rootVC = UIViewController()
                let navVC = UINavigationController(rootViewController: rootVC)
                 navVC.navigationBar.isTranslucent = true
                let authCoordinatorFactory: (RouterType) -> AuthorizationCoordinator = { router in
                    resolver.resolve(AuthorizationCoordinator.self, argument: router)!
                }
                let tabbarCoordinatorFactory: (RouterType) -> TabBarCoordinator = { router in
                    resolver.resolve(TabBarCoordinator.self, argument: router)!
                }
                let appRouter = Router(navigationController: navVC)
                return AppCoordinator(router: appRouter, userRepo: resolver.resolve(UserSessionRepository.self)!,
                                      authCoordinatorFactory: authCoordinatorFactory,
                                      tabBarCoordinatorFactory: tabbarCoordinatorFactory)
            }.inObjectScope(.weak)
        }
    }()
    
    func makeAppCoordinator() -> AppCoordinator { appDIContainer.resolve(AppCoordinator.self)! }
}
