// CODE IS POETRY
// TRADING IS MARTIAL ART
// Kolier.Li <kolier.li@gmail.com> [http://kolier.li]

// Array List class
// @module-notready

#include "../lib.mqh"

#include <Arrays/ArrayObj.mqh>

class ArrayObj : public CArrayObj {


    // -------------------------------------
    // Constructor, Destructor
    // -------------------------------------
public:
    ArrayObj( void ) {}
    
    // Set free mode on the fly
    ArrayObj( bool free_mode ) {}

    // -------------------------------------
    // Initialize, Reset
    // -------------------------------------

    void Initialize( void ) {
        // CArray
        this.m_step_resize = 16;
        this.m_data_total = 0;
        this.m_data_max = 0;
        // CArrayObj
        // set default to value comparison
        //this.m_sort_mode = OBJECT_VALUE;
        // Default is self managed
        this.m_free_mode = true;
    }

    //
    void Initialize( ArrayList* obj ) {
        if ( !CheckPointer( obj ) ) return;
        
        // CArray
        this.m_step_resize = obj.Step();
        this.m_data_total = obj.Total();
        this.m_data_max = obj.Max();
        this.m_sort_mode = obj.SortMode();
        // CArrayObj
        this.m_free_mode = obj.FreeMode();
        // ArrayList
        //obj.GetData( this.m_data );
    }
    
    //
    void Reset( void ) {
        this.Resize(0);
    }
    
    // -------------------------------------
    // Behavior
    // -------------------------------------

    

};
