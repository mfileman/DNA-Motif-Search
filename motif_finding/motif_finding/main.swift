//
//  main.swift
//  motif_finding
//
//  Created by madison on 10/27/20.
//

import Foundation

let alphabet: [Character] = ["A", "C", "T", "G"]
var randomInt = Int.random(in: 0...3)

func generate_DNA_sequence(length l: Int) -> String {
    var returned: String = ""
    for _ in 0..<l {
        returned += String(alphabet[Int.random(in: 0...3)])
    }
    return returned
}

func generate_motif(length l: Int) -> String {
    return generate_DNA_sequence(length: l)
}

func insert_randomized_motif(sequence: inout String, motif: String, n: Int, k: Int, d: Int) -> Int {
    let random_insert_i = Int.random(in: 0...n-k-1)
    let rs = sequence.index(sequence.startIndex, offsetBy: random_insert_i)
    let re = sequence.index(sequence.startIndex, offsetBy: random_insert_i+k)
    sequence.replaceSubrange(rs..<re, with: randomize_motif(motif: motif, length: k, substitutions: d))
    return random_insert_i
}

func randomize_motif(motif: String, length l: Int,substitutions d: Int) -> String {
    var edited_motif: String = motif
    var rand_nucleotide: Character
    var rand_insertion_point: Int
    var nucleotide_at_insertion_point: Character = "A"
    var filtered_alphabet: [Character]
    
    for _ in 0..<d {
        rand_insertion_point = Int.random(in: 0...l-1)
        nucleotide_at_insertion_point = edited_motif[edited_motif.index(edited_motif.startIndex, offsetBy: rand_insertion_point)];
        filtered_alphabet = alphabet.filter { $0 != nucleotide_at_insertion_point }
        rand_nucleotide = filtered_alphabet[Int.random(in: 0...2)]
        edited_motif = replace(myString: edited_motif, rand_insertion_point, rand_nucleotide)
    }
    
    return edited_motif
}

func replace(myString: String, _ index: Int, _ newChar: Character) -> String {
    var chars = Array(myString)
    chars[index] = newChar
    let modifiedString = String(chars)
    return modifiedString
}

func accept_user_input_tnkd() -> [String]{
    print("how many DNA sequences? (t) ", terminator: " ")
    guard let t = readLine().flatMap(Int.init(_:)) else { return [] }// how many sequences to generate is

    print("length of sequences? (n) ", terminator: " ")
    guard let n = readLine().flatMap(Int.init(_:)) else { return [] }// how long each DNA sequence should be

    print("length of motif? (k) ", terminator: " ")
    guard let k = readLine().flatMap(Int.init(_:)) else { return [] }// how long the inserted motif should be

    print("how many motif substitutions? (d) ", terminator: " ")
    guard let d = readLine().flatMap(Int.init(_:)) else { return [] }// how many mismatches each motif can have

    assert(k > d)
    var sequences: [String] = []
    let m = generate_motif(length: k)
    for _ in 0..<t {
        var s = generate_DNA_sequence(length: n)
        _ = insert_randomized_motif(sequence: &s, motif: m, n: n, k: k, d: d)
        sequences.append(s)
    }
    
    return sequences
}

accept_user_input_tnkd()
