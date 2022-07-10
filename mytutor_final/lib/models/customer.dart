class Customer {
  String? id;
  String? name;
  String? email;
  String? phone;
  String? address;
  String? state;
  // String? credit;
  // String? otp;
  String? cart;

  Customer(
      {this.id,
      this.name,
      this.email,
      this.phone,
      this.address,
      this.state,
      // this.credit,
      // this.otp,
      this.cart
      });

  Customer.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    phone = json['phone'];
    address = json['address'];
    state = json['state'];
    // credit = json['credit'];
    // otp = json['otp'];
    cart = json['cart'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['email'] = email;
    data['phone'] = phone;
    data['address'] = address;
    data['state'] = state;
    // data['credit'] = credit;
    // data['otp'] = otp;
    data['cart'] = cart.toString();
    return data;
  }
}