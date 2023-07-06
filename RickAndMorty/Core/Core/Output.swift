//
//  Output.swift
//  RickAndMorty
//
//  Created by Pouya on 11/15/1401 AP.
//

import Combine

typealias Output<Value> = (value: Value, publisher: AnyPublisher<Value, Never>)
