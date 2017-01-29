// CODE IS POETRY
// TRADING IS MARTIAL ART
// Kolier.Li <kolier.li@gmail.com> [http://kolier.li]

// Order Class

#include <Object.mqh>

#include "../lib.mqh"

/// @todo Save, Load
class Order : public CObject {

public:
    static int COMPARE_POINTER;
    static int COMPARE_TICKET;

private:
    int ticket_; // Order ticket

public:

    // -------------------------------------
    // Constructor, Destructor
    // -------------------------------------
    
    //
    Order( void ) : ticket_( NULL ) {}
    Order( int ticket ) : ticket_( ticket ) {}
    
    // For clone
    Order( Order &order ) : ticket_( order.Ticket() ) {}
    
    // -------------------------------------
    // Basic Control
    // -------------------------------------
        
    // Reset the object states
    void Reset(void) { ticket_ = NULL; }
    
    // Select the order's ticket
    bool Select(void) { return OrderSelect( ticket_ ); }
    
    // Validate the order ticket and Select if it's being set
    virtual bool Validate( void ) { return ( ticket_ == NULL || !this.Select() ) ? false : true; }

    // -------------------------------------
    // Order Info
    // -------------------------------------
    
    //
    string Symbol(void) { return OrderSymbol(ticket_); }
    int Magic(void) { return OrderMagic(ticket_); }
    string Comment(void) { return OrderComment(ticket_); }
    int Type(void) { return OrderType(ticket_); }
    double Spread(void) { return OrderSpread(ticket_); }
    double Lots(void) { return OrderLots(ticket_); }
    double Profit(void) { return OrderProfit(ticket_); }
    double ProfitInPoint(void) { return OrderProfitInPoint(ticket_); }
    int PriceDigits(void) { return OrderPriceDigits(ticket_); }
    double PricePoint(void) { return OrderPricePoint(ticket_); }
    double OpenPrice(void) { return OrderOpenPrice(ticket_); }
    double ClosePrice(void) { return OrderClosePrice(ticket_); }
    double StopLoss(void) { return OrderStopLoss(ticket_); }
    double TakeProfit(void) { return OrderTakeProfit(ticket_); }
    datetime OpenTime(void) { return OrderOpenTime(ticket_); }
    datetime CloseTime(void) { return OrderCloseTime(ticket_); }
    datetime Expiration(void) { return OrderExpiration(ticket_); }
    double Commission(void) { return OrderCommission(ticket_); }
    double Swap(void) { return OrderSwap(ticket_); }
    //
    ENUM_ORDER_ROUTINE Routine(void) { return OrderRoutine(ticket_); }
    //
    double PriceToOpen(void) { return OrderPriceToOpen(ticket_); }
    double PriceToClose(void) { return OrderPriceToClose(ticket_); }
    //
    //int PirceToOpenPriceType(void) { return ; }
    //int PirceToClosePriceType(void) { return ; }
    //
    ENUM_TRADE_DIR TradeDir(void) { return OrderTradeDir(ticket_); }
    ENUM_TRADE_DIR TradeDirGroup(void) { return OrderTradeDirGroup(ticket_); }
    ENUM_TRADE_DIR TradeDirGroupReverse(void) { return OrderTradeDirGroupReverse(ticket_); }
    // @todo TradeDirRoutine
    // PriceMove
    double PriceMove(double price, double move) { return TradePriceMove(price, this.TradeDirGroup(), move); }
    // If order is closed
    bool IsClosed(void) { return OrderIsClosed(ticket_); }
    bool IsFilled(void) { return OrderIsFilled(ticket_); }
    // If the order has family
    bool HasFamily(void) { return OrderHasFamily(); }

    // -------------------------------------
    // Behavior
    // -------------------------------------
    
    // Normalize
    double PriceNormalized(double price) { return OrderPriceNormalized(ticket_, price); }
    double LotsNormalized(double lots) { return OrderLotsNormalized(ticket_, lots); }
    // Modify
    bool Modify( double open_price, double stoploss, double takeprofit, datetime expiration, color clr_arrow ) {
        if ( !this.Validate() )
            return false;
        return OrderModify( open_price, stoploss, takeprofit, expiration, clr_arrow );
    }
    bool Modify( double open_price, datetime expiration, color clr_arrow ) {
        if ( !this.Validate() )
            return false;
        return OrderModify( open_price, expiration, clr_arrow );
    }
    bool Modify( double stoploss, double takeprofit ) {
        if ( !this.Validate() )
            return false;
        return OrderModify( stoploss, takeprofit );
    }
    bool Modify( double open_price ) {
        if ( !this.Validate() )
            return false;
        return OrderModify( open_price );
    }
    bool ModifyTakeprofit(double takeprofit, color clr_arrow) { return OrderModifyTakeprofit(ticket_, takeprofit, clr_arrow); }
    bool ModifyTakeprofit(double takeprofit) { return OrderModifyTakeprofit(ticket_, takeprofit); }
    bool ModifyTakeprofit(PriceRangeParam &range, double price = NULL) { return OrderModifyTakeprofit(ticket_, range, price); }
    bool ModifyStoploss(double stoploss, color clr_arrow) { return OrderModifyStoploss(ticket_, stoploss, clr_arrow); }
    bool ModifyStoploss(double stoploss) { return OrderModifyStoploss(ticket_, stoploss); }
    bool ModifyStoploss(PriceRangeParam &range, double price = NULL) { return OrderModifyStoploss(ticket_, range, price); }
    //
    bool TakeprofitIsValidated(double takeprofit) { return OrderTakeprofitValidated(ticket_, takeprofit); }
    bool StoplossIsValidated(double stoploss) { return OrderStoplossValidated(ticket_, stoploss); }
    // If the new takeprofit setting is an offensive/defensive to the current one
    bool PriceIsOffensive(double price, double compare, bool strict = true) { return OrderPriceIsOffensive(ticket_, price, compare, strict); }
    bool PriceIsDefensive(double price, double compare, bool strict = true) { return OrderPriceIsDefensive(ticket_, price, compare, strict); }
    // Simple or Configurable Close
    bool Close(double lots, double close_price, int slippage, color clr_arrow) { return OrderClose(ticket_, lots, close_price, slippage, clr_arrow); }
    bool Close(double lots, int slippage, color clr_arrow = clrWhite) {
        if ( this.Validate() )
            return false;
        return OrderClose( lots, slippage, clr_arrow );
    }
    bool Close( color clr_arrow ) {
        if ( this.Validate() )
            return false;
        return OrderClose( OrderLots(), 10, clr_arrow );
    }
    bool Close(void) { return OrderClose(ticket_); }
    // Delete
    bool Delete(void) { return OrderDelete(ticket_); }
    // Destroy
    bool Destroy(void) { return OrderDestroy(); }
        
    // -------------------------------------
    // API
    // -------------------------------------
        
    /// Order Action
    virtual void Action(void) {}

    /// Shallow Clone
    virtual CObject* Clone(void) { return (new Order(this)); }
    
    /// Order object compare ticket number instead of pointer
    virtual int Compare(const CObject* node, const int mode = 0) const;

    // -------------------------------------
    // Getter, Setter
    // -------------------------------------
    
    // ticket_
    int Ticket( void ) const { return this.ticket_; }
    void Ticket( int ticket ) { this.ticket_ = ticket; }
};

// =============================================================================
// Implementation

static int Order::COMPARE_POINTER = 0;
static int Order::COMPARE_TICKET = 1;

// -----------------------------------------------------------------------------
// Virtual

/// Order object compare ticket number instead of pointer
/// @see CList::QuickSearch(), CList::Sort().
int Order::Compare( const CObject* node, const int mode = 0 ) const {
    // Wrong Pointer has lower value
    if ( !CheckPointer( node ) )
        return 1;
    
    if ( mode == Order::COMPARE_POINTER ) {
        if ( GetPointer( this ) == GetPointer( node ) )
            return 0;
        else
            //return GetPointer( this ) > GetPointer( node ) ? 1 : -1;
            return 1;
    }
    if ( mode == Order::COMPARE_TICKET ) {
        Order* order = (Order*)node;
        if ( this.Ticket() == order.Ticket() )
            return 0;
        else
            return this.Ticket() > order.Ticket() ? 1 : -1;
    }

    return 0;
}
