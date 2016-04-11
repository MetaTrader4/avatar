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
// input bool   Input_Stoploss_Trailstop_Virtual = false; // (On/Off) Virtual Mode
input double Input_Stoploss_Trailstop_Start   = 200;   // (Point) Order Profit to Trigger Start
input double Input_Stoploss_Trailstop_Away    = 200;   // (Point) Stoploss Away from the Current Market Price
input double Input_Stoploss_Trailstop_Step    = 0;     // (Point) Minimum Stoploss Change
*/

#include "OrderAction.mqh"

class StoplossTrailstopOrderAction : public OrderAction {

public:
    double Start; // POINT
    double Away; // POINT
    double Step; // POINT
    
    // -------------------------------------
    // Constructor, Destructor
    // -------------------------------------
public:
    //
    StoplossTrailstopOrderAction( void ) : OrderAction( NULL ),
        Start( EMPTY_VALUE ), Away( NULL ), Step( NULL ) {}
    
    //
    StoplossTrailstopOrderAction( Order* &order, double start, double away, double step ) : OrderAction( order ),
        Start( start ), Away( away ), Step( step ) {}
        
    // -------------------------------------
    // Calculation
    // -------------------------------------
    
    double Trailstop( void ) {
        return this.PriceMove( this.PriceToClose(), this.Away * (-1) );
    }
    
    double TrailstopComparison( void ) {
        return this.PriceMove( this.StopLoss(), this.Step );
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
            this.ProfitInPoint() < Start // If reach start point
            || !this.PriceIsOffensive( this.Trailstop(), this.TrailstopComparison(), false ) ) // If Offensive than current stoploss plus step
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
        this.ModifyStoploss( this.Trailstop() );
    }
    
};
