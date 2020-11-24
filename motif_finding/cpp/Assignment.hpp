//
//  Assignment.hpp
//  motif_finding
//
//  Created by madison on 11/1/20.
//

#ifndef Assignment_hpp
#define Assignment_hpp
#include <stdio.h>

class Assignment {
    public:
        static void write_fasta(const char* file_path, const char* text);
        static char** read_fasta(const char* file_path);
};


#endif /* Assignment_hpp */
