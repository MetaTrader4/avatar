// CODE IS POETRY
// TRADING IS MARTIAL ART
// Kolier.Li <kolier.li@gmail.com> [http://kolier.li]

// Close on Price Section Order Action class
// @settings {
//   Takeprofit : "Takeprofit price.",
//   Stoploss   : "Stoploss price.",
// }

/*
// Order Action - Virtual TP/SL
// Whether TakeProfit and StopLoss in Virtual Mode, hiding from the broker. Can explictly set above but truely use below secretly.
input string Input_TPSL            = "--- Virtual TP/SL ---"; // Order Virtual TP/SL
input bool   Input_TPSL_On         = false; // (On/Off) Order Virtual TP/SL
input double Input_TPSL_Takeprofit = 100;   // (Point Unit) Takeprofit
input double Input_TPSL_Stoploss   = 100;   // (Point Unit) Stoploss
*/

#include "OrderAction.mqh"

class TpslOrderAction : public OrderAction {

public:
    double Takeprofit;
    double Stoploss;

    // -------------------------------------
    // Constructor, Destructor
    // -------------------------------------
public:
    TpslOrderAction( void ) : OrderAction( NULL ),
        Takeprofit( NULL ), Stoploss( NULL ) {}
    TpslOrderAction( Order* &order, double takeprofit, double stoploss ) : OrderAction( order ),
        Takeprofit( takeprofit ), Stoploss( stoploss ) {}

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
        if ( this.Takeprofit == NULL
            && this.Stoploss == NULL )
            return false;
        //
        return true;
    }
    
    //
    virtual void Execute( void ) {
        if ( this.Takeprofit > 0
            && this.PriceIsOffensive( this.PriceToClose(), this.Takeprofit, false ) )
            this.Close();
        if ( this.Stoploss > 0
            && this.PriceIsDefensive( this.PriceToClose(), this.Stoploss, false ) )
            this.Close();
    }


};
