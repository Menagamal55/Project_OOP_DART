class Car {
  String model;
  String colour;
  bool is_available;
  double daily_price;
  String car_number;

  Car(this.model, this.colour, this.daily_price, this.car_number, {this.is_available = true});

  // Method to check if car is available to rent or not.
  String rent() {
    if (is_available) {
      is_available = false;
      return "Car $model with $car_number is available and has been rented.";
    } else {
      return "Car $model ($car_number) is already rented.";
    }
  }

  // Method to return state of car.
  String returnCar() {
    if (!is_available) {
      is_available = true;
      return "Car $model ($car_number) has been returned and is now available.";
    } else {
      return "Car $model ($car_number) is already available.";
    }
  }
}

class Customer {
  // Some information about customers.
  String name;
  String id;
  String email;
  String phone;

  Customer(this.name, this.id, this.email, this.phone);

  List<Map<String, dynamic>> rentedCars = []; // Store rented cars with the number of days rented.
//method to rent car and count number of day and daily_price.
  String rentCar(Car car, int days) {
    if (car.is_available) {
      rentedCars.add({"car": car, "days": days});
      car.rent();
      double totalCost = car.daily_price * days;
      return "$name has rented ${car.model} for $days days. Total cost: $totalCost EGP.";
    } else {
      return "Sorry, ${car.model} is not available.";
    }
  }

  String returnCar(Car car) {
    var rentedCar = rentedCars.firstWhere((rc) => rc["car"] == car, orElse: () => null);//search about selected car if find in rented cars ==>remove and make it available to rent again
    if (rentedCar != null) {
      rentedCars.remove(rentedCar);//remove from rented car and become available.
      car.returnCar();
      return "$name has returned ${car.model} and it is now available for rent.";
    } else {
      return "$name did not rent ${car.model}.";
    }
  }
}

class RentalSystem {
  List<Car> cars = [];
  List<Customer> customers = [];

  void addCar(Car car) {
    cars.add(car);
    print("Car ${car.model} (${car.car_number}) added to the system.");
  }

  void addCustomer(Customer customer) {
    customers.add(customer);
    print("Customer ${customer.name} (ID: ${customer.id}) added to the system.");
  }

  String rentCarToCustomer(String customerName, String carModel, int days) {
    Customer customer = customers.firstWhere((c) => c.name == customerName, orElse: () => null);
    Car car = cars.firstWhere((c) => c.model == carModel && c.is_available, orElse: () => null);

    if (customer == null) {
      return "Rental failed. Customer $customerName not found.";
    }
    if (car == null) {
      return "Rental failed. Car $carModel is not available.";
    }

    return customer.rentCar(car, days);
  }

  void displayAvailableCars() {
    print("\nAvailable Cars:");
    cars.where((car) => car.is_available).forEach((car) {
      print("${car.model} (${car.car_number}) - ${car.colour} - ${car.daily_price} EGP/day");
    });
  }

  void displayRentedCars() {
    print("\nRented Cars:"); //loop in rented car ==> to print car has been rented.
    customers.forEach((customer) {
      customer.rentedCars.forEach((rentedCar) {
        Car car = rentedCar["car"];
        int days = rentedCar["days"];
        print("${customer.name} has rented ${car.model} for $days days.");
      });
    });
  }
}

void main() {
  RentalSystem system = RentalSystem();

  // Add cars
  Car car1 = Car("Toyota", "red", 500, "MNM250");
  Car car2 = Car("BMW", "white", 250, "FMS00");
  system.addCar(car1);
  system.addCar(car2);

  // Add customers
  Customer customer1 = Customer("Menna", "001", "menna@email.com", "01080730181");
  Customer customer2 = Customer("Hema", "002", "hema@email.com", "01080730182");
  system.addCustomer(customer1);
  system.addCustomer(customer2);

  // Display available cars
  system.displayAvailableCars();

  // Rent cars
  print(system.rentCarToCustomer("Menna", "Toyota", 3)); // Menna rents Toyota for 3 days
  print(system.rentCarToCustomer("Hema", "BMW", 5)); // Hema rents BMW for 5 days

  // Display rented cars
  system.displayRentedCars();

  // Try to rent an already rented car
  print(system.rentCarToCustomer("Menna", "Toyota", 2)); // Attempt to rent Toyota again

  // Return cars
  print(customer1.returnCar(car1)); // Menna returns Toyota
  print(customer2.returnCar(car2)); // Hema returns BMW

  // Display available cars after returning
  system.displayAvailableCars();
}