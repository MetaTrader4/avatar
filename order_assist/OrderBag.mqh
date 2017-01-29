// CODE IS POETRY
// TRADING IS MARTIAL ART
// Kolier.Li <kolier.li@gmail.com> [http://kolier.li]

// Collection of Orders
// @module-notready

#include <Arrays/ArrayObj.mqh>
#include "../avatar.mqh"
#include "Order.mqh"

class OrderBag : public CObject {

public:
    string Symbol;
    int Magic;
    string Comment;
    ENUM_ORDER_POOL Pool;
    //
    CArrayObj Bag;
    
public:
    OrderBag( void ) : Symbol( NULL ), Magic( 0 ), Comment( NULL ), Pool( ORDER_POOL_TRADES ) {}
    OrderBag( string symbol, int magic, string comment, ENUM_ORDER_POOL pool ) : 
        Symbol( symbol ), Magic( magic ), Comment( comment ), Pool( pool ) {}
    ~OrderBag( void ) {}
    
    // Collect orders into bag
    void Collect( void ) {
        ENUM_ORDER_POOL trades[2] = { ORDER_POOL_ALL, ORDER_POOL_TRADES };
        ENUM_ORDER_POOL history[2] = { ORDER_POOL_ALL, ORDER_POOL_HISTORY };
        int i, total;
        if ( ArrayContains( trades, this.Pool ) ) {
            total = OrdersTotal();
            for ( i = total - 1; i >= 0; i-- ) {
                if ( OrderSelect(i, SELECT_BY_POS, MODE_TRADES) ) {
                    if ( !this.IsOrderMatched() ) continue;
                    this.Bag.Add( new Order( OrderTicket() ) );
                }
            }
        }
        if ( ArrayContains( history, this.Pool ) ) {
            total = OrdersHistoryTotal();
            for ( i = total - 1; i >= 0; i-- ) {
                if ( OrderSelect(i, SELECT_BY_POS, MODE_HISTORY) ) {
                    if ( !this.IsOrderMatched() ) continue;
                    this.Bag.Add( new Order( OrderTicket() ) );
                }
            }
        }

    }
    
    //
    bool IsOrderMatched( void ) {
        if ( OrderTicket() <= 0
            || OrderSymbol() != this.Symbol
            || OrderMagicNumber() != this.Magic
            || OrderComment() != this.Comment
        ) {
            return false;
        }
        return true;
    }

    // Get the current bag by clone, intened to keep the data
    CArrayObj* CloneBag( void ) {
        CArrayObj* bag_clone = new CArrayObj();
        bag_clone.AddArray( GetPointer(this.Bag) );
        
        return bag_clone;
    }
    
};
