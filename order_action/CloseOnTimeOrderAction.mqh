// CODE IS POETRY
// TRADING IS MARTIAL ART
// Kolier.Li <kolier.li@gmail.com> [http://kolier.li]

// Close on Time Section Order Action class
// @settings {
//   "Start"  : "Start time.",
//   "End"    : "End time.",
//   "Logic"  : "Section logic.",
//   "Strict" : "Comparison restriction.",
// }

#include "OrderAction.mqh"

class CloseOnTimeOrderAction : public OrderAction {

public:
    datetime Start;
    datetime End;
    ENUM_LINEAR_SECTION Logic;
    bool Strict;

public:
    // -------------------------------------
    // Constructor, Destructor
    // -------------------------------------
    
    CloseOnTimeOrderAction( void ) : OrderAction( NULL ),
        Start( NULL ), End( NULL ), Logic( SECTION_RIGHT_OF_LEFT ), Strict( false ) {}
    CloseOnTimeOrderAction( Order* &order, datetime start ) : OrderAction( order ),
        Start( start ), End( NULL ), Logic( SECTION_RIGHT_OF_LEFT ), Strict( false ) {}
    CloseOnTimeOrderAction( Order* &order, datetime start, datetime end, ENUM_LINEAR_SECTION logic = SECTION_OUTER, bool strict = false ) : OrderAction( order ),
        Start( start ), End( end ), Logic( logic ), Strict( strict ) {}
    
    // -------------------------------------
    // Implementation
    // -------------------------------------
    
    //
    virtual bool Test( void ) {
        //
        if ( !OrderAction::Test() )
            return false;
        //
        if ( !this.Validate()
            || this.IsClosed()
            // "Close" is only for Market Order
            || this.Routine() == ORDER_PEND )
            return false;
        //
        if ( Start == NULL && End == NULL )
            return false;
        if ( !MathLinearSection( Logic, TimeCurrent(), Start, End, Strict ) )
            return false;
        //
        return true;
    }
    
    //
    virtual void Execute( void ) {
        this.Close();
    }
    
};
