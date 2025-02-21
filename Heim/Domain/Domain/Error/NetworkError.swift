//
//  NetworkError.swift
//  Domain
//
//  Created by 정지용 on 11/19/24.
//

public enum NetworkError: Error {
  case interalServerError
  case invalidURL
  
  public var description: String {
    switch self {
    case .interalServerError:
      return "네트워크 요청 실패"
    case .invalidURL:
      return "잘못된 URL"
    }
  }
}
