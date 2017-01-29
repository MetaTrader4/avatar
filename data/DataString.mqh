// CODE IS POETRY
// TRADING IS MARTIAL ART
// Kolier.Li <kolier.li@gmail.com> [http://kolier.li]

// Simple data, A String Data

#include <Object.mqh>

#define DATA_STRING 1005


class DataString : public CObject {

public:
    string Data;
    
public:
    DataString( void ) {}
    DataString( string data ) : Data( data ) {}
    ~DataString( void ) {}

    virtual int Type( void ) const {
        return DATA_STRING;
    }
};
