//
//  AssignmentGeneration.swift
//  motif_finding
//
//  Created by madison on 11/3/20.
//

import Foundation

class AssignmentGeneration
{
    
    enum InputError: Error {
        case InvalidInput
    }
    
    static func accept_user_input_tnkd() -> (Int, Int, Int, Int) {
        print("how many DNA sequences? (t) ", terminator: " ")
        let generate = readLine().flatMap(Int.init(_:)) // how many sequences to generate is
        guard let t: Int = generate else { print("error in accepting input"); exit(1) }

        print("length of sequences? (n) ", terminator: " ")
        let DNA_length = readLine().flatMap(Int.init(_:))// how long each DNA sequence should be
        guard let n: Int = DNA_length else { print("error in accepting input"); exit(1) }

        print("length of motif? (k) ", terminator: " ")
        let motif_length = readLine().flatMap(Int.init(_:)) // how long the inserted motif should be
        guard let k: Int = motif_length else { print("error in accepting input"); exit(1) }

        print("how many motif substitutions? (d) ", terminator: " ")
        let substitutions = readLine().flatMap(Int.init(_:))// how many mismatches each motif can have
        guard let d: Int = substitutions else { print("error in accepting input"); exit(1) }

        assert(k >= d)
        return (t, n, k, d)
    }
    
    static func generate_sequences(t: Int, n: Int, k: Int, d: Int) -> [String] {
        var sequences: [String] = []
        let motif = generate_motif(length: k)
        print("inserted motif: ", motif)
        
        for _ in 0..<t {
            var s = generate_DNA_sequence(length: n)
            _ = insert_randomized_motif(sequence: &s, motif: motif, n: n, k: k, d: d)
            sequences.append(s)
        }
        return sequences
    }
    
    static func generate_DNA_sequence(length l: Int) -> String {
        var returned: String = ""
        for _ in 0..<l {
            returned += String(alphabet[Int.random(in: 0...3)])
        }
        return returned
    }

    static func generate_motif(length l: Int) -> String {
        return generate_DNA_sequence(length: l)
    }
    
    static func insert_randomized_motif(sequence: inout String, motif: String, n: Int, k: Int, d: Int) -> Int {
        let random_insert_i = Int.random(in: 0...n-k-1)
        let rs = sequence.index(sequence.startIndex, offsetBy: random_insert_i)
        let re = sequence.index(sequence.startIndex, offsetBy: random_insert_i+k)
        sequence.replaceSubrange(rs..<re, with: randomize_motif(motif: motif, length: k, substitutions: d))
        return random_insert_i
    }

    static func randomize_motif(motif: String, length l: Int,substitutions d: Int) -> String {
        var edited_motif: String = motif
        var rand_nucleotide: Character
        var rand_insertion_point: Int
        
        for _ in 0..<d {
            rand_insertion_point = Int.random(in: 0...l-1)
            rand_nucleotide = alphabet[Int.random(in: 0...3)]
            edited_motif = replace(myString: edited_motif, rand_insertion_point, rand_nucleotide)
        }
        
        return edited_motif
    }

    static func replace(myString: String, _ index: Int, _ newChar: Character) -> String {
        var chars = Array(myString)
        chars[index] = newChar
        let modifiedString = String(chars)
        return modifiedString
    }
    
}
