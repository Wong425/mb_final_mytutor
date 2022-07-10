class Cart {
  String? cartid;
  String? crname;
  String? crqty;
  String? crice;
  String? cartqty;
  String? crid;
  String? cricetotal;

  Cart(
      {this.cartid,
      this.crname,
      this.crqty,
      this.crice,
      this.cartqty,
      this.crid,
      this.cricetotal});

  Cart.fromJson(Map<String, dynamic> json) {
    cartid = json['cartid'];
    crname = json['crname'];
    crqty = json['crqty'];
    crice = json['crice'];
    cartqty = json['cartqty'];
    crid = json['crid'];
    cricetotal = json['cricetotal'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['cartid'] = cartid;
    data['crname'] = crname;
    data['crqty'] = crqty;
    data['crice'] = crice;
    data['cartqty'] = cartqty;
    data['crid'] = crid;
    data['cricetotal'] = cricetotal;
    return data;
  }
}