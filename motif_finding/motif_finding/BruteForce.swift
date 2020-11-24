//
//  BruteForce.swift
//  motif_finding
//
//  Created by madison on 11/3/20.
//

class BruteForce {
    let (t, n, k, d): (Int, Int, Int, Int)
    let sequences: [String]
    
    init(num_sequences: Int? = nil, sequence_length: Int? = nil, motif_length: Int? = nil, motif_substitutions: Int? = nil, sequences: [String]? = nil, file_name: String) {
        
        if num_sequences == nil && sequence_length == nil && motif_length == nil && motif_substitutions == nil {
            (self.t, self.n, self.k, self.d) = AssignmentGeneration.accept_user_input_tnkd()
            self.sequences = AssignmentGeneration.generate_sequences(t: t, n: n, k: k, d: d)
        }
        else {
            t = num_sequences != nil ? num_sequences! : 0
            n = sequence_length != nil ? sequence_length! : 0
            k = motif_length != nil ? motif_length! : 0
            d = motif_substitutions != nil ? motif_substitutions! : 0
            self.sequences = sequences != nil ? sequences! : []
        }
        
        var to_file = ""
        for i in 0..<self.sequences.count {
            to_file += ">seq\(i)\n" + self.sequences[i] + "\n\n"
        }
        write_fasta(file_name, to_file)
    }
    
    

    

    /*
     * at each possible motif, finds the highest scoring motifs in the remaining (sequences.count - 1) sequences
     */
    func brute_force_motif_search() -> [String] {
        
        var lowest_scoring_motifs : [String] = [String](repeating: "", count: sequences.count)
        var lowest_motif_score = n*t
        var sequence_level_motifs : [String] = [String](repeating: "", count: sequences.count)
        var sequence_level_total_score : Int = 0
        var start_index_curr, end_index_curr: String.Index
        var current_sequence: String
        
        for s in 0..<sequences.count {
            current_sequence = sequences[s]
            
            for i in 0...n - k  { // go thru each possible motif (with length k) in sequences[s]
                
                // getting current motif from current_sequence @ i
                start_index_curr = current_sequence.index(current_sequence.startIndex, offsetBy: i)
                end_index_curr = current_sequence.index(current_sequence.startIndex, offsetBy: i+k-1)
                sequence_level_motifs[s] = String(current_sequence[start_index_curr...end_index_curr])
                
                (sequence_level_total_score, sequence_level_motifs) = lowest_possible_score_with_motif(motif: sequence_level_motifs[s], sequences: sequences)
                
                if sequence_level_total_score < lowest_motif_score {
                    lowest_motif_score = sequence_level_total_score
                    lowest_scoring_motifs = sequence_level_motifs
                    sequence_level_total_score = 0
                }
            }
        }
        return lowest_scoring_motifs
    }
    
    func consensus_motif(_ motifs: [String]) -> String {
        var profile: [[Int]] = [[Int]](repeating: [Int](repeating: 1, count: k)
                                       , count: 4)
        var consensus = ""
        motifs.forEach { profile_motif($0, &profile) }
        
        for each in profile {
            let consensus_nucleotide = alphabet[each.max()!]
            consensus.append(consensus_nucleotide)
        }
        return consensus
        
    }
    
    func profile_motif(_ motif: String, _ profile: inout [[Int]]) {
        for j in 0..<k { // each letter in the motif
            let nucleotide = motif[motif.index(motif.startIndex, offsetBy: j)]
            guard let alphabet_index = alphabet.firstIndex(of: nucleotide) else { return }
            profile[alphabet_index][j] += profile[alphabet_index][j] == t + 1 ? 0 : 1 // dont > t
        }
    }
    
    
    /// for each sequence, a k-length character sequence that most closely matches the passed motif is found and stored.
    /// The sum of each (hamming distance of k-length character sequence & passed motif) is calculated.
    /// Returns the sum and each k-length character sequence
    private func lowest_possible_score_with_motif(motif: String, sequences: [String]) -> (Int, [String]) {
        
        var motif_difference: Int = 0
        var sequence_level_motifs: [String] = [String](repeating: "", count: sequences.count)
        var sequence_level_total_difference = 0
        
        for i in 0..<sequences.count {
            motif_difference = 0
            
            (motif_difference, sequence_level_motifs[i]) = find_min_motif_difference(sequence: sequences[i], motif: motif)
                
            sequence_level_total_difference += motif_difference
            
        } // found the corresponding motifs that minimize total score given "motif" is the motif
        
        return(sequence_level_total_difference, sequence_level_motifs)
    }
    
    /// This function takes one DNA  sequence and one motif. It finds the k-length character sequence in the given sequence (potential motif) that has the smallest hamming distance. Returns said k-length character sequence and its hamming score
    private func find_min_motif_difference(sequence: String, motif: String) -> (Int, String) {
        var start_index: String.Index
        var end_index: String.Index
        var potential_motif: String
        
        var min_difference = sequence.count
        var min_motif: String = ""
        var current_difference = 0
        
        for i in 0...sequence.count - k {
            // calculates next k-length character sequence
            start_index = sequence.index(sequence.startIndex, offsetBy: i)
            end_index = sequence.index(sequence.startIndex, offsetBy: i+k-1)
            potential_motif = String(sequence[start_index...end_index])
            
            // calculates hamming score of the potential_motif against the given motif
            current_difference = hamming_distance(motif, String(potential_motif))
            
            // stores potential_motif who's hamming distance is the smallest
            if current_difference < min_difference {
                min_difference = current_difference
                min_motif = potential_motif
            }
        }
        
        return (min_difference, min_motif)
    }

    private func hamming_distance(_ s1: String, _ s2: String) -> Int {
        assert(s1.count == s2.count && s1.count == k)
        
        var total_differences = 0
        
        for j in 0..<k {
            total_differences += s1[s1.index(s1.startIndex, offsetBy: j)] == s2[s2.index(s2.startIndex, offsetBy: j)] ? 0 : 1
        }
        
        return total_differences
    }
}
