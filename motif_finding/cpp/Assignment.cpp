//
//  write_fasta.cpp
//  motif_finding
//
//  Created by madison on 11/1/20.
//
#include "Assignment.hpp"
#include <iostream>
#include <fstream>
#include <filesystem>

void Assignment::write_fasta(const char* file_path, const char* text) {
    std::ofstream file;
    std::cout<<file_path<<std::endl;
    file.open(file_path);
    
    file << text;
    file.close();
}

char** Assignment::read_fasta(const char* file_path) {
    char** sequences = new char*();
    std::string line;
    std::ifstream input(file_path);
    int i = 0;
    
    while(std::getline(input, line)) {
        if(line.empty() || line[0] == '>')
            continue;
        else {
            sequences[i] = (char*)calloc(line.length() + 1, sizeof(char)); // allocate memory
            strcpy(sequences[i], &line[0]);
            i++;
        }
    }
    input.close();
    return sequences;
}
