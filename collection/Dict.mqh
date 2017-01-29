// CODE IS POETRY
// TRADING IS MARTIAL ART
// Kolier.Li <kolier.li@gmail.com> [http://kolier.li]

// Dictionary, Hash Table

#include <Arrays\ArrayObj.mqh>

#include "DictEntry.mqh"

// Dictionary
class Dict : public CObject {

protected:
    CArrayObj entries;

    // -------------------------------------
    // Constructor, Destructor
    // -------------------------------------
public:
    Dict( void ) {}
    ~Dict( void ) {}
    
    // -------------------------------------
    // Behavior
    // -------------------------------------

    CObject* Get( string key ) {
        DictEntry* entry = this.GetEntry( key );
        
        if ( CheckPointer( entry ) ) {
            return entry.Value();
        }
        return NULL;
    }
    
    // Try to get string if the value is DictEntryData object
    string GetString( string key ) {
        DictEntry* entry = this.GetEntry( key );
        
        if ( CheckPointer( entry ) ) {
            CObject* value = entry.Value();
            if ( value.Type() == DATA_STRING ) {
                DataString* data = value;
                return data.Data;
            }
        }
        return NULL;
    }
    
    string operator[]( string key ) {
        return this.GetString( key );
    }
    
    DictEntry* GetEntry( string key ) {
        DictEntry entry_tmp( key );
        int pos = -1;
        for ( int i = 0; i < this.entries.Total(); i++ ) {
            DictEntry* entry = this.entries.At( i );
            if ( entry.Compare( GetPointer(entry_tmp) ) == 0 ) {
                pos = i;
                break;
            }
        }
        if ( pos != -1 ) {
            return this.entries.At( pos );
        }
        return NULL;
    }
    
    template<typename T>
    void Set( string key, T value ) {
        DictEntry* entry = this.GetEntry( key );
        if ( CheckPointer( entry ) ) {
            entry.Set( value );
        }
        else {
            entry = new DictEntry( key );
            entry.Set( value );
            this.entries.Add( entry );
        }
    }
    
    // Empty the dict.
    void Reset( void ) {
        this.entries.Resize( 0 );
    }
    
    /* @debug
    void PrintAll( void ) {
        for ( int i = 0; i < this.entries.Total(); i++ ) {
            Print( i );
            DictEntry* entry = this.entries.At( i );
            DictEntryData* value = entry.Value();
            CObject* object = entry.Value();
            Print( "Object type: ", object.Type() );
            Print( "Value type: ", value.Type() );
            Print( value.Data );
        }
    }
    */
};
