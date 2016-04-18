// CODE IS POETRY
// TRADING IS MARTIAL ART
// Kolier.Li <kolier.li@gmail.com> [http://kolier.li]

// Stoploss Breakeven Order Action class
// @settings {
//   Start     : "The ProfitInPoint to start breakeven.",
//   Deviation : "Instead of set StopLoss exactly to OpenPrice, deviation is a modifier.",
// }
//
// @input
/*
// Order Action - Stoploss Breakeven
// Move Order stoploss to order open price when gain a setting profit.
input string Input_Stoploss_Breakeven           = "--- Breakeven ---"; // Order Breakeven
input bool   Input_Stoploss_Breakeven_On        = false; // (On/Off) Order Breakeven
input bool   Input_Stoploss_Breakeven_Virtual   = false; // (On/Off) Virtual Mode
input double Input_Stoploss_Breakeven_Start     = 200;   // (Point) Order Profit to Trigger Start
input double Input_Stoploss_Breakeven_Deviation = 0;     // (Point) Deviation to the Order Open Price
*/

#include "../storage/GV.mqh"

#include "StoplossBreakevenOrderAction.mqh"

class StoplossBreakevenVirtualOrderAction : public StoplossBreakevenOrderAction {

protected:
    GV gv;
    double price_breakeven;
    
    // -------------------------------------
    // Constructor, Destructor
    // -------------------------------------
public:
    //
    StoplossBreakevenVirtualOrderAction( void ) : StoplossBreakevenOrderAction() {
        this.initialize();
    }
    
    //
    StoplossBreakevenVirtualOrderAction( Order* &order, double start, double deviation ) : StoplossBreakevenOrderAction( order, start, deviation ) {
        this.initialize();
    }
    
    //
    ~StoplossBreakevenVirtualOrderAction( void ) {
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
    
    double GvBreakeven( void ) {
        return this.gv.Get( this.GvKey() );
    }
 
    datetime GvBreakeven( double value ) {
        return this.gv.Set( this.GvKey(), value );
    }
    
    void GvUpdate( void ) {
        this.price_breakeven = this.Breakeven();
        this.GvBreakeven( this.price_breakeven );
    }
    
    bool GvDel( void ) {
        return this.gv.Del( this.GvKey() );
    }
    
    // -------------------------------------
    // Implementation
    // -------------------------------------
public:
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
        if ( this.price_breakeven == NULL ) {
            // Try to load
            this.price_breakeven = this.GvBreakeven();
            // Need to check trigger and log
            if ( this.price_breakeven == NULL && this.ProfitInPoint() >= this.Start ) {
                this.GvUpdate();
            }
        }
        // May from class or just loaded from GV
        if ( this.price_breakeven != NULL ) {
            // Already triggered breakeven condition, check close
            if ( this.PriceIsDefensive( this.PriceToClose(), this.price_breakeven, false ) )
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
        string prefix = "StoplossBreakevenVirtualOrderAction|";
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
                    StoplossBreakevenVirtualOrderAction::Cleaner();
                }
            }
        }
    }
    
};
