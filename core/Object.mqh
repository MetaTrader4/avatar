// CODE IS POETRY
// TRADING IS MARTIAL ART
// Kolier.Li <kolier.li@gmail.com> [http://kolier.li]

// Base Object class

#include <Object.mqh>

class Object : public CObject {

    // -------------------------------------
    // Constructor, Destructor
    // -------------------------------------
public:
    Object( void ) {}
    ~Object( void ) {}

    // -------------------------------------
    // Core
    // -------------------------------------
    
    // Since this in MQL seems always represent the current class type of the variable modifier, this can fix that.
    // Usually just copy to subclass to return class name.
    // Get the object class type.
    virtual string Typename(void) { return typename(this); }
    
    //
    template<typename T>
    T* Pointer(void) { return GetPointer(this); }

    // Convert to string expression.
    virtual string ToString(void) { return this.Typename(); }

};
