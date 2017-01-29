// CODE IS POETRY
// TRADING IS MARTIAL ART
// Kolier.Li <kolier.li@gmail.com> [http://kolier.li]

// Order Action class

#include "../order/Order.mqh"

class OrderAction : public Order {

private:
    // It's not being managed here
    Order* order_; // @managed Hold on previous decorated object.
    // Useful Flags
    bool ignore_; // If ignore this action

public:
    // -------------------------------------
    // Constructor, Destructor
    // -------------------------------------
    
    // Constructor
    OrderAction( void ) : order_( NULL ), ignore_( false ) {}
    
    // When use this constructor, the order passing in will be cloned, not the actual one
    OrderAction( Order* order ) : Order( order ), order_( order ), ignore_( false ) {}
    
    /// Delete the decorated object as well
    ~OrderAction( void ) {
        PointerDelete( order_ );
    }
    
    // -------------------------------------
    // API
    // -------------------------------------

    // Condition check for the order action.
    virtual bool Test( void ) {
        if ( ignore_ )
            return false;
        return true;
    }
    
    // Main behavior of this order action.
    virtual void Execute( void ) {}
    
    // Chain behaviors of multiple order actions.
    virtual void Action( void ) {
        // Execute the Order Action Behavior
        if ( this.Test() )
            this.Execute();
        // Don't let the chain action stop, keep it going
        if ( CheckPointer( order_ ) )
            order_.Action();
    }
    
    // Implement to clear junk
    virtual void Clear( void ) {}
    
    // -------------------------------------
    // Getter, Setter
    // -------------------------------------
    
    Order* Order( void ) { return order_; }
    void Order( Order* &order, bool pnt_replace = true ) {
        if ( pnt_replace )
            PointerReplace( order_, order );
        else
            order_ = order;
    }
    
    bool Ignore( void ) { return ignore_; }
    void Ignore( bool ignore ) { ignore_ = ignore; }
};
