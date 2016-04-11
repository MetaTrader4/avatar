// CODE IS POETRY
// TRADING IS MARTIAL ART
// Kolier.Li <kolier.li@gmail.com> [http://kolier.li]

// Entry class for Dict

#include <Object.mqh>

#include "../lib.mqh"

#include "../data/DataString.mqh"

// Entry
class DictEntry : public CObject {

private:
    string key_;
    CObject* value_;
    
    // -------------------------------------
    // Constructor, Destructor
    // -------------------------------------
public:
    DictEntry( string key ) : key_( key ), value_( NULL ) {}
    ~DictEntry( void ) {
        if ( CheckPointer( this.value_ ) == POINTER_DYNAMIC ) {
            delete this.value_;
        }
    }
    
    // -------------------------------------
    // Behavior
    // -------------------------------------
    
    void Set( string value ) {
        CObject* data = new DataString( value );
        PointerReplace( this.value_, data );
    }
    
    void Set( CObject* value ) {
        PointerReplace( this.value_, value );
    }

    // -------------------------------------
    // Core
    // -------------------------------------

    virtual int Compare( CObject* node, const int mode = 0 ) const {
        DictEntry* entry = node;
        if ( this.key_ == entry.Key() ) {
            return 0;
        }
        return EMPTY;
    }
    
    // -------------------------------------
    // Getter, Setter
    // -------------------------------------

    string Key( void ) {
        return this.key_;
    }
    
    CObject* Value( void ) {
        return this.value_;
    }
};