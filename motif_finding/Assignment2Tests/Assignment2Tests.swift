//
//  Assignment2Tests.swift
//  Assignment2Tests
//
//  Created by madison on 11/3/20.
//

import XCTest
@testable import motif_finding

class Assignment2Tests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testBruteForceExample() throws {
        let a = BruteForce(num_sequences: 5, sequence_length: 10, motif_length: 3, motif_substitutions: 1, sequences:["TTGATGACGC", "GTCGAATGCA", "CCGGAGCCTT", "ATACTGACCA", "TAAACCATAG"]) // AGA motif
        let b = a.brute_force_motif_search()
        XCTAssert(b == ["TGA", "CGA", "GGA", "TGA", "TAA"])
    }
    
    func testBruteForceExample1() throws {
        let a = BruteForce(num_sequences: 2, sequence_length: 10, motif_length: 3, motif_substitutions: 1, sequences:["AGATTTATAT", "CCATGTATAC", "GGGCTCTACC"]) // AGA motif
        let b = a.brute_force_motif_search()
        XCTAssert(b == ["TAT", "TAT", "TCT"])
    }
    
    func testGibbsSampling() throws {
        let a = GibbsSampling(num_sequences: 3, sequence_length: 10, motif_length: 3, motif_substitutions: 1, sequences:["AGATTTATAT", "CCATGTATAC", "GGGCTCTACC"])
        let b = a.gibbs_sampling_motif_search()
//        XCTAssert(b == ["TAT", "TAT", "TCT"])
    }
    
    func testRandomWithDistribution() {
        let a = GibbsSampling(num_sequences: 0, sequence_length: 0, motif_length: 0, motif_substitutions: 0, sequences:[])
        var b: [Int] = []
        for _ in 0..<100000 {
            b.append(a.random_with_distribution( [0, 0.4, 0.6] ))
        }
        // should be roughly proportional to the distributions given
        
        print( b.filter {$0 != 1 && $0 != 2}.count ) // 0
        print( b.filter {$0 != 0 && $0 != 2}.count ) // 1
        print( b.filter {$0 != 0 && $0 != 1}.count ) // 2
    }

}
