//
//  main.swift
//  motif_finding
//
//  Created by madison on 10/27/20.
//

import Foundation

print("BRUTE FORCE...")
print("write BRUTE FORCE sequences to (file path): ")
if let file_path = readLine() {
    let brute = BruteForce(file_name: file_path)
    
    print("write BRUTE FORCE motifs to (file path): ")
    if let motifs_file_path = readLine() {
        let motifs = brute.brute_force_motif_search()
        
        var to_file = ""
        for i in 0..<motifs.count {
            to_file += ">seq\(i)\n" + motifs[i] + "\n\n"
        }
        write_fasta(motifs_file_path, to_file)
    }

}






print("\n\nGIBBS SAMPLING...")
print("write GIBBS SAMPLING sequences to (file path): ")
if let file_path_gibbs = readLine() {
    let gibbs = GibbsSampling(file_name: file_path_gibbs)
    
    print("write GIBBS SAMPLING motifs to (file path): ")
    if let motifs_file_path = readLine() {
        let motifs = gibbs.gibbs_sampling_motif_search()
        
        var to_file = ""
        for i in 0..<motifs.count {
            to_file += ">seq\(i)\n" + motifs[i] + "\n\n"
        }
        write_fasta(motifs_file_path, to_file)
    }
    
}



