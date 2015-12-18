#include <iostream>
#include <fstream>
#include <string>
#include <sstream>
#include <vector>
#include <map>

int main()
{
    std::map<int, std::vector <int> > dados;


    std::vector<std::string> produtos;
    std::ifstream infile("itemlist.txt");

    std::string i;

    while (infile >> i)
    {
        produtos.push_back(i);
    }

    // for (std::string i : produtos)
    //     std::cout << i << std::endl;

     std::ifstream transactions("dotto.txt");

     int id = 0;
     std::vector<int> v;


     while(std::getline(transactions, i))
     {
        std::istringstream iss(i);
        std::string word;

        // 

        while(iss >> word)
        {
            //std::cout << word << std::endl;
            for (int j=0; j < produtos.size(); j++)
                if(word.compare(produtos.at(j)) == 0)
                    v.push_back(j);
        }

        // for(int i : v)
        //     std::cout << i << " ";

        //std::cout << std::endl;

        std::sort(v.begin(), v.end());
        
        dados.insert( std::pair<int, std::vector<int> >(id,v));

        id++;
        v.clear();

        // std::cout << "}" << std::endl;
         //std::cout << "FOI LINHA" << std::endl;
     }

     for(auto const &chave : dados)
     {
        std::cout << "{";
        for(auto const &x : chave.second)
        {
            std::cout << x << " 1,";
        }


        std::cout << "}" << std::endl;
     }

}