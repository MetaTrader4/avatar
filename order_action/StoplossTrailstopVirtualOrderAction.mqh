// CODE IS POETRY
// TRADING IS MARTIAL ART
// Kolier.Li <kolier.li@gmail.com> [http://kolier.li]

// Stoploss Trailstop Order Action class
// @settings {
//   Start : "The ProfitInPoint to start Trailstop.",
//   Away  : "The Distance away from the Current Price.",
//   Step  : "The Minimum Movement Distance for each new stoploss modification.",
// }
//
// @input
/*
// Order Action - Stoploss Trailstop
// Continue moving order stoploss.
input string Input_Stoploss_Trailstop         = "--- Trailstop ---"; // Order Trailstop
input bool   Input_Stoploss_Trailstop_On      = false; // (On/Off) Order Trailstop
input bool   Input_Stoploss_Trailstop_Virtual = false; // (On/Off) Virtual Mode
input double Input_Stoploss_Trailstop_Start   = 200;   // (Point) Order Profit to Trigger Start
input double Input_Stoploss_Trailstop_Away    = 200;   // (Point) Stoploss Away from the Current Market Price
input double Input_Stoploss_Trailstop_Step    = 0;     // (Point) Minimum Stoploss Change
*/

#include "../storage/GV.mqh"

#include "StoplossTrailstopOrderAction.mqh"

class StoplossTrailstopVirtualOrderAction : public StoplossTrailstopOrderAction {

protected:
    GV gv;
    double price_trailstop;
    
    // -------------------------------------
    // Constructor, Destructor
    // -------------------------------------
public:
    StoplossTrailstopVirtualOrderAction( void ) : StoplossTrailstopOrderAction() {}
    
    StoplossTrailstopVirtualOrderAction( Order* &order, double start, double away, double step ) :
        StoplossTrailstopOrderAction( order, start, away, step ) {}
        
    ~StoplossTrailstopVirtualOrderAction( void ) {
        this.Clear();
    }
    
protected:
    void initialize( void ) {
        this.gv.Prefix( typename( this ) );
    }
    
    // -------------------------------------
    // Utility
    // -------------------------------------
public:
    string GvKey( void ) {
        return (string)this.Ticket();
    }
    
    double GvTrailstop( void ) {
        return this.gv.Get( this.GvKey() );
    }
 
    datetime GvTrailstop( double value ) {
        return this.gv.Set( this.GvKey(), value );
    }
    
    void GvUpdate( void ) {
        this.price_trailstop = this.Trailstop();
        this.GvTrailstop( this.price_trailstop );
    }
    
    bool GvDel( void ) {
        return this.gv.Del( this.GvKey() );
    }
    
    double VirtualTrailstopComparison( void ) {
        return this.PriceMove( this.price_trailstop, this.Step );
    }
        
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
            || this.Routine() == ORDER_PEND )
            return false;
        //
        if ( Start == EMPTY_VALUE )
            return false;
        
        //
        return true;
    }
    
    //
    virtual void Execute( void ) {
        // Use GV to store the value
        if ( this.price_trailstop == NULL ) {
            // Try to load
            this.price_trailstop = this.GvTrailstop();
            // Need to check trigger and log
            if ( this.price_trailstop == NULL
                && this.ProfitInPoint() >= this.Start
            ) {
                this.GvUpdate();
            }
        }
        // Already triggered trailstop condition
        if ( this.price_trailstop != NULL ) {
            // Check update
            if ( this.PriceIsOffensive( this.Trailstop(), this.VirtualTrailstopComparison() ) ) {
                this.GvUpdate();
            }
            // Check close
            if ( this.PriceIsDefensive( this.PriceToClose(), this.price_trailstop, false ) )
                this.Close();
        }

    }
    
    // Delete the GV if the order is closed
    virtual void Clear( void ) {
        if ( this.IsClosed() )
            this.GvDel();
    }
    
    // -------------------------------------
    // Daemon Task
    // -------------------------------------
    
    // Look through all GVs, math the 
    static void Cleaner( void ) {
        int total = GlobalVariablesTotal();
        string prefix = "StoplossTrailstopVirtualOrderAction|";
        string pattern = prefix + "*";
        string name;
        int ticket;
        for ( int i = 0; i < total; i++ ) {
            name = GlobalVariableName( i );
            if ( StringMatch( pattern, name ) ) {
                ticket = (int)StringSubstr( name, StringLen( prefix ) );
                if ( OrderIsClosed( ticket ) ) {
                    GlobalVariableDel( name );
                    // Re-run, not modify total because other process could tame GV at the same time
                    StoplossTrailstopVirtualOrderAction::Cleaner();
                }
            }
        }
    }

};
