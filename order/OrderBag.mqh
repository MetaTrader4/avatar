// CODE IS POETRY
// TRADING IS MARTIAL ART
// Kolier.Li <kolier.li@gmail.com> [http://kolier.li]

// OrderBag Class
// Order Bag contains unique order objects.
// @todo

#include <Arrays/ArrayObj.mqh>

#include "Order.mqh"

class OrderBag : public CObject {

protected:
    CArrayObj bag;

    // -------------------------------------
    // Constructor, Destructor
    // -------------------------------------
public:
    OrderBag( void ) {}
    ~OrderBag( void ) {}
    
    // -------------------------------------
    // Behavior
    // -------------------------------------
    
    // Add with a ticket
    bool Add( int ticket ) {
        Order* order = new Order( ticket );
        bool result = this.Add( order );
        if ( !result )
            delete order;
        return result;
    }
    
    // Add with an prepared order object
    bool Add( Order* order ) {
        // Only add if not in bag
        if ( !this.InBag( order ) )
            return this.bag.Add( order );
        return false;
    }
    
    // Check if the order is in bag already
    bool InBag( const int ticket ) {
        Order order( ticket );
        return this.InBag( GetPointer( order ) );
    }
    
    bool InBag( const Order* order ) {
        this.bag.Sort( Order::COMPARE_TICKET );
        int pos = this.bag.SearchFirst( order );
        return pos != -1 ? true : false;
    }
    
    // Remove closed orders out of bag
    void ClearDestroyed( void ) {
        int i = 0, total = this.bag.Total();
        while ( i < total ) {
            Order* order = this.bag.At( i );
            if ( order.IsClosed() && this.bag.Delete( i ) )
                total = this.bag.Total();
            else
                i++;
        }
    }
    
    // Trigger Order Action
    void Trigger( void ) {
        for ( int i = 0; i < this.bag.Total(); i++ ) {
            this[i].Action();
        }
    }
    
    // Array like access, redirect to order in bag
    Order* operator[]( const int index ) {
        return this.bag.At( index );
    }

    // -------------------------------------
    // Getter, Setter
    // -------------------------------------
    
    // @todo Test if only const method can be run outside
    CArrayObj* Bag(void) const { return GetPointer(this.bag); }

};
