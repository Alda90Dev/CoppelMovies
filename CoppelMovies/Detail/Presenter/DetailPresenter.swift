//
//  HomePresenter.swift
//  CoppelMovies
//
//  Created by Aldair Carrillo on 29/12/22.
//

import Foundation
import Combine

/////////////////////// DETAIL PRESENTER PROTOCOL
protocol DetailPresenterProtocol: AnyObject {
    var view: DetailViewProtocol? { get set }
    var interactor: DetailInteractorInputProtocol? { get set }
    var router: DetailRouterProtocol? { get set }
    var movie: Movie? { get set }
    
    func bind(input: DetailPresenterInput) -> DetailPresenterOutput
}

enum TypeDetailRow {
    case space
    case image
    case info
    case productions
}

////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////// DETAIL PRESENTER
///////////////////////////////////////////////////////////////////////////////////////////////////

class DetailPresenter: DetailPresenterProtocol {
    
    weak var view: DetailViewProtocol?
    var interactor: DetailInteractorInputProtocol?
    var router: DetailRouterProtocol?
    var output: DetailPresenterOutput = DetailPresenterOutput()
    var movie: Movie?
    
    private var subscriptions = Set<AnyCancellable>()
    private var rows: [TypeDetailRow] = [.image, .info, .productions, .space]
    
    func bind(input: DetailPresenterInput) -> DetailPresenterOutput {
        
        input.loadMovieDetail.sink { [weak self] in
            if let self = self,
               let movie = self.movie {
                self.output.initDataPublisher.send((movie, self.rows))
                self.interactor?.getMovieDetail(id: movie.id)
            }
        }.store(in: &self.subscriptions)
        
        input.goToVideos.sink { [weak self] in
            if let view = self?.view {
                self?.router?.goToVideos(from: view, id: self?.movie?.id ?? 0)
            }
        }.store(in: &self.subscriptions)
        
        input.setFavorite.sink { [weak self] value in
            if let movie = self?.movie {
                self?.interactor?.setFavorite(isFavorite: value, movie: movie)
            }
        }.store(in: &self.subscriptions)

        return output
    }
    
}

extension DetailPresenter: DetailInteractorOutputProtocol {
    
    func interactorGetDataPresenter(receivedData: Movie?, error: Error?) {
        if let error = error {
            output.detailDataPublisher.send(.failure(error))
        } else if let data = receivedData {
            output.detailDataPublisher.send(.success(data))
        }
    }
    
    func interactorGetFavoriteResult(error: Error?) {
        if let error = error {
            output.resultFavoritePublisher.send(.failure(error))
        } else {
            output.resultFavoritePublisher.send(.success(true))
        }
    }
    
}
