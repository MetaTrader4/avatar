// CODE IS POETRY
// TRADING IS MARTIAL ART
// Kolier.Li <kolier.li@gmail.com> [http://kolier.li]

// GV for Global Variable
// Wrap a presetted prefix

#include <Object.mqh>

#include "../lib.mqh"

class GV : public CObject {

public:
    static string TEST;
protected:
    string prefix_;

public:
    // -------------------------------------
    // Constructor, Destructor
    // -------------------------------------

    GV( void ) {
        if ( IsTesting() )
            this.prefix_ = GV::TEST;
    }
    
    GV( string prefix ) : prefix_( prefix + "|" ) {
        if ( IsTesting() )
            this.prefix_ = GV::TEST + this.prefix_;
    }
    
    //
    //~GV( void ) {}
    
    // -------------------------------------
    // Behavior
    // -------------------------------------
    
    // Get prefixed key
    string Key( string key ) {
        return this.prefix_ + key;
    }
    
    // Combine functionality of Get() and Set()
    double Val( string key ) {
        return Get( key );
    }
    
    datetime Val( string key, double value ) {
        return Set( key, value );
    }
    
    // GlobalVariableGet(), Default value is 0.0, (double)NULL
    double Get( string key ) {
        return GlobalVariableGet( Key( key ) );
    }
    
    bool Get( string key, double &value ) {
        return GlobalVariableGet( Key( key ), value );
    }
    
    // GlobalVariableSet()
    datetime Set( string key, double value ) {
        return GlobalVariableSet( Key( key ), value );
    }
    
    // GlobalVariableDel()
    bool Del( string key ) {
        return GlobalVariableDel( Key( key ) );
    }
    
    // GlobalVariableCheck()
    bool Check( string key ) {
        return GlobalVariableCheck( Key( key ) );
    }
    
    // GlobalVariableDeleteAll()
    int DeleteAll( void ) {
        return GlobalVariablesDeleteAll( this.prefix_ );
    }
    
    // Array like access
    double operator[]( string key ) {
        return this.Get( key );
    }

    // -------------------------------------
    // Getter, Setter
    // -------------------------------------
    
    string Prefix( void ) const {
        return this.prefix_;
    }
    
    void Prefix( string prefix ) {
        this.prefix_ = prefix + "|";
        if ( IsTesting() )
            this.prefix_ = GV::TEST + this.prefix_;
    }
    
    // -------------------------------------
    // Daemon Task
    // -------------------------------------
    
    // Default to delete all in Backtest environment
    static void Cleaner( void ) {
        if ( IsTesting() )
            GlobalVariablesDeleteAll( GV::TEST );
    }
    
};

// Set Backtest environment prefix
static string GV::TEST = "(T)";
