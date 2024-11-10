In the View Controller, when I press a button, it presents the Home View Controller. In the Home View Controller, there is a back button; pressing it dismisses the view. In `viewDidLoad` of the Home View Controller, there is a print statement `print("Home View Controller Allocated")`, and in `deinit`, another statement `print("Home View Controller Deallocated")` to track its lifecycle.

In `viewDidLoad`, there are two functions in the Home View Controller. In one function, `addTimer`, we set up a timer. If we create a blank block with no code, we won’t hold any references, so it will execute normally. However, if we call a function that prints "Hello" inside the timer block and reference `self` (which holds a strong reference to the Home View Controller), dismissing the Home View Controller will not release it immediately. Instead, it will be deallocated after 5 seconds, and "Hello" will be printed due to the strong reference. This causes a memory leak.

If the timer is set for a longer duration, such as 500 seconds, the issue worsens. To avoid this, we use `weak` or `unowned` references. Both are non-strong references, meaning they do not retain ownership and do not increase the retain count. The difference is that a `weak` reference can become `nil` if the object is deallocated, while an `unowned` reference assumes the object will still exist and cannot be `nil`.

In the background, ARC (Automatic Reference Counting) manages memory. It tracks the number of strong references to class instances, which determines the retain count. When an object is created, its retain count increases. If the object is referenced elsewhere, the count increases accordingly. When an object’s retain count drops to zero, ARC deallocates it. However, ARC does not count `weak` or `unowned` references, so if we use these, ARC does not prevent deallocation.

If we create a `weak` reference to `self` in the timer, the Home View Controller will deallocate as soon as it is dismissed, since `weak` does not hold a strong reference to the class. We can also use `unowned` in a similar way, but there’s a risk: if we reference an `unowned` variable after deallocation, it will crash the app.

Generally, `weak` works in most cases because it safely returns `nil` if the object is deallocated. But with `unowned`, if the class is deallocated before the timer fires (like in 5 seconds), using it will lead to a crash.

I used an example of a `Vehicle` and a `Car`. In `init`, we print "allocated," and in `deinit`, we print "deallocated." The `Vehicle` class has a strong reference to the `Car` class, and the `Car` class has a strong reference to the `Vehicle` class.

Let’s create an object for `Vehicle` with an ID of "123" and set the `Car` object to `nil`. Similarly, we create an object of `Car` with the name "Kia" and set the `Vehicle` object to `nil`. If we create the `Vehicle` object without assigning it to a variable, it will be allocated and then automatically deallocated.

However, if we create a `Vehicle` object and store it in a variable or constant, it will be allocated and not deallocated. The same goes for the `Car` object if it is stored in a variable.
var vehicle = Vehicle(car: nil, id: "123")
var car = Car(vehicle: nil, id: "123")

If we try to assign nil to car or vehicle, like:
car = nil // 'nil' cannot be assigned to type 'Car'
vehicle = nil // 'nil' cannot be assigned to type 'Vehicle'

it will throw an error because these are not optional types. This is why we use optionals. If we create `vehicle` and `car` as optional types and set them to `nil`, they will be deallocated. However, if we set `vehicle.car = car` and `car.vehicle = vehicle`, a strong reference cycle will be created, and setting both to `nil` will not deallocate them.

### Q: What is a strong reference cycle in iOS?

A strong reference cycle occurs when two objects hold strong references to each other, preventing either from being deallocated.

### How can we avoid it?

We can avoid a strong reference cycle by making one of the references `weak`. This allows the objects to be deallocated. Alternatively, using `unowned` also works if the reference is expected to be non-nil throughout the object's lifecycle.

import UIKit

class Vechicle {
    var car: Car?
    let id: String
    init(car: Car? = nil, id: String) {
        self.car = car
        self.id = id
        print("\(self) is allocated")
    }
    deinit {
        print("\(self) is deallocated")
    }
}

class Car {
    weak var vechicle: Vechicle?
    let id: String
    init(vechicle: Vechicle? = nil, id: String) {
        self.vechicle = vechicle
        self.id = id
        print("\(self) is allocated")
    }
    deinit {
        print("\(self) is deallocated")
    }
}

// Usage example
var vechicle: Vechicle? = Vechicle(car: nil, id: "123")
var car: Car? = Car(vechicle: nil, id: "123")

vechicle?.car = car
car?.vechicle = vechicle

car = nil
vechicle = nil
