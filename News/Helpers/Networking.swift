//
//  Networking.swift
//  News
//
//  Created by Patsicha Tongteeka on 1/10/22.
//

enum Result<T> {
  case success(result: T)
  case failure(error: Error)
}
