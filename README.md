# DNA-Motif-Search
This was a project for my bioinformatics class. We studied a couple of motif finding algorithms for finding a potential motif in n many randomly generated DNA sequences. 
This project 
1) randomly generates n many DNA sequences 
2) randomly generates a kmer 
3) edits up to d many positions in that kmer &amp; inserts that kmer (now motif) into each sequence 
From here,
4) blindly reads these sequences (with emplaced motifs) and 
5) brute force searches all n sequences to find n many motifs with the lowest hamming distance from a consensus string
6) Utilizes Gibbs Sampling algorithm (a randomized algorithm) to find the lowest overall hamming distance from a motif profile
Implemented in Swift.
