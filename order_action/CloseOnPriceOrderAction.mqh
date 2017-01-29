// CODE IS POETRY
// TRADING IS MARTIAL ART
// Kolier.Li <kolier.li@gmail.com> [http://kolier.li]

// Close on Price Section Order Action class
// @settings {
//   Top    : "Top price.",
//   Bottom : "Bottom price.",
//   Logic  : "Section logic.",
//   Strict : "Comparison restriction.",
// }

#include "OrderAction.mqh"

class CloseOnPriceOrderAction : public OrderAction {

public:
    double Top;
    double Bottom;
    ENUM_LINEAR_SECTION Logic;
    bool Strict;

public:
    // -------------------------------------
    // Constructor, Destructor
    // -------------------------------------
    
    CloseOnPriceOrderAction( void ) : OrderAction( NULL ),
        Top( NULL ), Bottom( NULL ), Logic( SECTION_OUTER ), Strict( false ) {}
    CloseOnPriceOrderAction( Order* &order, double top, double bottom, ENUM_LINEAR_SECTION logic = SECTION_OUTER, bool strict = false ) : OrderAction( order ),
        Top( top ), Bottom( bottom ), Logic( logic ), Strict( strict ) {}
    
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
        if ( Top == NULL
            && Bottom == NULL )
            return false;
        if ( !MathLinearSection( Logic, this.PriceToClose(), Top, Bottom, Strict ) )
            return false;
        //
        return true;
    }
    
    //
    virtual void Execute( void ) {
        this.Close();
    }
    
};
