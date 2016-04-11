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
// input bool   Input_Stoploss_Breakeven_Virtual   = false; // (On/Off) Virtual Mode
input double Input_Stoploss_Breakeven_Start     = 200;   // (Point) Order Profit to Trigger Start
input double Input_Stoploss_Breakeven_Deviation = 0;     // (Point) Deviation to the Order Open Price
*/

#include "OrderAction.mqh"

class StoplossBreakevenOrderAction : public OrderAction {

public:
    double Start; // POINT
    double Deviation; // POINT
    
    // -------------------------------------
    // Constructor, Destructor
    // -------------------------------------
public:
    //
    StoplossBreakevenOrderAction( void ) : OrderAction( NULL ),
        Start( EMPTY_VALUE ), Deviation( NULL ) {}
    
    //
    StoplossBreakevenOrderAction( Order* &order, double start, double deviation ) : OrderAction( order ),
        Start( start ), Deviation( deviation ) {}
        
    // -------------------------------------
    // Calculation
    // ------------------------------------- 
    
    // Dynamic calculate the breakeven value in case the order routine change from pend to market
    double Breakeven( void ) {
        return this.PriceMove( this.OpenPrice(), this.Deviation );
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
        if (
            this.ProfitInPoint() < this.Start // If reach start point
            || !this.PriceIsOffensive( this.Breakeven(), this.StopLoss() ) ) // If Offensive than current stoploss
            return false;
        
        //
        return true;
    }
    
    //
    virtual void Execute( void ) {
        // Preliminary check
        if ( !this.Test() )
            return;
        
        // Action
        this.ModifyStoploss( this.Breakeven() );
    }
    
};
