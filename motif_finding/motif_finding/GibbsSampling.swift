//
//  GibbsSampling.swift
//  motif_finding
//
//  Created by madison on 11/5/20.
//
import Foundation

class GibbsSampling {
    var profile: [[Int]] // profiles randomly selected motifs
    let (t, n, k, d): (Int, Int, Int, Int)
    let sequences: [String]
    var unique_nums: [Int]
    
    init(num_sequences: Int? = nil, sequence_length: Int? = nil, motif_length: Int? = nil, motif_substitutions: Int? = nil, sequences: [String]? = nil, file_name: String) {
        
        if num_sequences == nil && sequence_length == nil && motif_length == nil && motif_substitutions == nil { // if parameters passed arent nil
            (self.t, self.n, self.k, self.d) = AssignmentGeneration.accept_user_input_tnkd()
            self.sequences = AssignmentGeneration.generate_sequences(t: t, n: n, k: k, d: d)
        } else if num_sequences == nil || sequence_length == nil || motif_length == nil || motif_substitutions == nil {
            exit(1)
        }
        else {
            t = num_sequences != nil ? num_sequences! : 0
            n = sequence_length != nil ? sequence_length! : 0
            k = motif_length != nil ? motif_length! : 0
            d = motif_substitutions != nil ? motif_substitutions! : 0
            self.sequences = sequences != nil ? sequences! : []
        }
        profile = [[Int]](repeating: [Int](repeating: 1, count: k)
                          , count: 4)
        unique_nums = Array(0..<t)
        
        var to_file = ""
        for i in 0..<self.sequences.count {
            to_file += ">seq\(i)\n" + self.sequences[i] + "\n\n"
        }
        write_fasta(file_name, to_file)
    }


    func gibbs_sampling_motif_search() -> [String] {
        var profiled = 0
        var prev_max_motifs: [String] = [""]
        var max_motif = "A"
        
        // initially pick random motifs out of the list of t - 1 sequences
        var motifs = generate_initial_random_motifs()
        generate_profile_matrix(from_motifs: motifs)
        
        while ( prev_max_motifs != motifs || profiled < 2*t ) {
            
            prev_max_motifs = motifs
            
            // randomly choose a motif to exclude from profiling
            let rand_element_i_sequence = unique_random()
            let rand_remove_sequence = sequences[rand_element_i_sequence]
            let rand_remove_motif = motifs[rand_element_i_sequence]
            
            unprofile_motif(rand_remove_motif) // remove affect from the profile matrix (only does so if applicable)
            
            let p = profile_each_motif(in: sequences[rand_element_i_sequence])
            let max_probability_index = random_with_distribution(p)
    
            let s = rand_remove_sequence.index(rand_remove_sequence.startIndex, offsetBy: max_probability_index)
            let e = rand_remove_sequence.index(rand_remove_sequence.startIndex, offsetBy: max_probability_index + k)
            max_motif = String(rand_remove_sequence[s..<e])
            motifs[rand_element_i_sequence] = max_motif
            profile_motif(max_motif)
            
            profiled+=1
        }
        
        return motifs
    }
    
    
    func profile_each_motif(in sequence: String) -> [Float] {
        var probabilities: [Float] = []
        for i in 0...n - k {
            let start_index = sequence.index(sequence.startIndex, offsetBy: i)
            let end_index = sequence.index(sequence.startIndex, offsetBy: i + k)
            let motif = sequence[start_index..<end_index]
            probabilities.append(calc_probability_of_motif(String(motif)))
        }
        return probabilities
    }
    
    func calc_probability_of_motif(_ motif: String) -> Float {
        var motif_probability: Float = 1.0
        for i in 0..<k {
            let nucleotide = motif[motif.index(motif.startIndex, offsetBy: i)]
            guard let alphabet_index = alphabet.firstIndex(of: nucleotide) else { return 0.0 }
            motif_probability *= ( Float(profile[alphabet_index][i]) / Float(t) )
        }
        return motif_probability
    }
    
    func generate_initial_random_motifs() -> [String] {
        var initial_motifs: [String] = []
        for i in 0..<t {
            let random_index = Int.random(in: 0..<n-k)
            let start_index = sequences[i].index(sequences[i].startIndex, offsetBy: random_index)
            let end_index = sequences[i].index(sequences[i].startIndex, offsetBy: random_index + k)
            let motif_to_be_profiled = sequences[i][start_index..<end_index]
            initial_motifs.append(String(motif_to_be_profiled))
        }
        return initial_motifs
    }
    
    func generate_profile_matrix(from_motifs motifs: [String]) {
        motifs.forEach { profile_motif($0) }
    }
    
    func profile_motif(_ motif: String) {
        for j in 0..<k { // each letter in the motif
            let nucleotide = motif[motif.index(motif.startIndex, offsetBy: j)]
            guard let alphabet_index = alphabet.firstIndex(of: nucleotide) else { return }
            profile[alphabet_index][j] += profile[alphabet_index][j] == t + 1 ? 0 : 1 // dont > t
        }
    }
    
    func unprofile_motif(_ motif: String) {
        for j in 0..<k { // each letter in the motif
            let nucleotide = motif[motif.index(motif.startIndex, offsetBy: j)]
            guard let alphabet_index = alphabet.firstIndex(of: nucleotide) else { return }
            profile[alphabet_index][j] -= profile[alphabet_index][j] == 1 ? 0 : 1 // dont go <1
        }
    }
    
    func unique_random() -> Int {
        if unique_nums.count == 0 { unique_nums = Array(0..<t) }
        return unique_nums.remove(at: Int.random(in: 0..<unique_nums.count)) 
    }
    
    
    func random_with_distribution(_ distr: [Float]) -> Int {
        let sum = distr.reduce(0, +)
        if sum == 0.0 { return (Int.random(in: 0..<distr.count)) }
            let rnd = Float.random(in: 0.0 ..< sum)
        var accum: Float = 0.0
            for (i, p) in distr.enumerated() {
                accum += p
                if rnd <= accum {
                    return i
                }
            }
            return (Int.random(in: 0..<distr.count))
    }
    
}


// TODO maybe try to start the profilifn matrix with 1 in each posistion. theres an issue where when the motif is found (and edited with d=1) the resulting profile with it and some other irrelevant "motifs" could create a 0 probability for another correct motif in another sequence where the d=1 in a different position / different nucleotide substitution.
