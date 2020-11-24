//
//  cpp_wrapper.cpp
//  motif_finding
//
//  Created by madison on 11/1/20.
//

#include <stdio.h>
#include "Assignment.hpp"

extern "C" void write_fasta(const char* file, const char* text) {
    Assignment::write_fasta(file, text);
};

extern "C" char** read_fasta(const char* file) {
    return Assignment::read_fasta(file);
};
