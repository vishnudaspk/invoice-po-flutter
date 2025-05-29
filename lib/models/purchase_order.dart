class PurchaseOrder {
  final String poNumber;
  final String deliveryDate;
  final SupplierDetails supplierDetails;
  final ShipTo shipTo;
  final List<Item> items;
  final double totalAmount;

  PurchaseOrder({
    required this.poNumber,
    required this.deliveryDate,
    required this.supplierDetails,
    required this.shipTo,
    required this.items,
    required this.totalAmount,
  });

  factory PurchaseOrder.fromJson(Map<String, dynamic> json) {
    return PurchaseOrder(
      poNumber: json['po_number'],
      deliveryDate: json['delivery_date'],
      supplierDetails: SupplierDetails.fromJson(json['supplier_details']),
      shipTo: ShipTo.fromJson(json['ship_to']),
      items: List<Item>.from(json['items'].map((item) => Item.fromJson(item))),
      totalAmount: json['total_amount'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'po_number': poNumber,
      'delivery_date': deliveryDate,
      'supplier_details': supplierDetails.toJson(),
      'ship_to': shipTo.toJson(),
      'items': items.map((item) => item.toJson()).toList(),
      'total_amount': totalAmount,
    };
  }
}

class SupplierDetails {
  final String name;
  final String location;

  SupplierDetails({
    required this.name,
    required this.location,
  });

  factory SupplierDetails.fromJson(Map<String, dynamic> json) {
    return SupplierDetails(
      name: json['name'],
      location: json['location'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'location': location,
    };
  }
}

class ShipTo {
  final String name;
  final String address;

  ShipTo({
    required this.name,
    required this.address,
  });

  factory ShipTo.fromJson(Map<String, dynamic> json) {
    return ShipTo(
      name: json['name'],
      address: json['address'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'address': address,
    };
  }
}

class Item {
  final String itemName;
  final String uom;
  final int quantity;
  final double unitPrice;
  final double total;

  Item({
    required this.itemName,
    required this.uom,
    required this.quantity,
    required this.unitPrice,
    required this.total,
  });

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      itemName: json['item_name'],
      uom: json['uom'],
      quantity: json['quantity'],
      unitPrice: json['unit_price'],
      total: json['total'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'item_name': itemName,
      'uom': uom,
      'quantity': quantity,
      'unit_price': unitPrice,
      'total': total,
    };
  }
}
