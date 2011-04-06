#ifndef HONDARRAY_FILEIO_H
#define HONDARRAY_FILEIO_H

#include "hoNDArray.h"

#include <iostream>
#include <fstream>
#include <vector>
#include <string.h>

template <class T> int write_nd_array(hoNDArray<T>& a, const char* filename)
{
  int* header = new int[a.get_number_of_dimensions()+1];

  header[0] = static_cast<int>(a.get_number_of_dimensions());
  for (int i = 0; i < header[0]; i++)
  {
    header[i+1] = static_cast<int>(a.get_size(i));
  }

  std::ofstream f(filename,std::ios::out | std::ios::binary);

  if( !f.is_open() ){
    std::cout << "ERROR: Cannot write file " << filename << std::endl;
    return -1;
  }

  f.write(reinterpret_cast<char*>(header),sizeof(int)*(a.get_number_of_dimensions()+1));
  f.write(reinterpret_cast<char*>(a.get_data_ptr()),sizeof(T)*a.get_number_of_elements());
  
  f.close();

  delete [] header;
  
  return 0;
}


template <class T> hoNDArray<T> read_nd_array(const char* filename)
{
  int dimensions,tmp;
  std::vector<unsigned int> dim_array;
  std::ifstream f(filename,std::ios::in | std::ios::binary);

  if( !f.is_open() ){
    std::cout << "ERROR: Cannot open file " << filename << std::endl;
    return hoNDArray<T>();
  }

  f.read(reinterpret_cast<char*>(&dimensions),sizeof(int));
  for (int i = 0; i < dimensions; i++)
  {
    f.read(reinterpret_cast<char*>(&tmp),sizeof(int));
    dim_array.push_back(static_cast<unsigned int>(tmp));
  }

  hoNDArray<T> out;
  out.create(dim_array);

  f.read(reinterpret_cast<char*>(out.get_data_ptr()),sizeof(T)*out.get_number_of_elements());

  return out;
}


#endif