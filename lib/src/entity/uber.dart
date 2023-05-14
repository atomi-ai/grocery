class UberQuoteRequest {
  final String dropoffAddress;
  final String dropoffName;
  final String dropoffPhoneNumber;
  final String pickupAddress;
  final String pickupName;
  final String pickupPhoneNumber;

  UberQuoteRequest({
    required this.dropoffAddress,
    required this.dropoffName,
    required this.dropoffPhoneNumber,
    required this.pickupAddress,
    required this.pickupName,
    required this.pickupPhoneNumber,
  });

  factory UberQuoteRequest.fromJson(Map<String, dynamic> json) {
    return UberQuoteRequest(
      dropoffAddress: json['dropoff_address'] as String,
      dropoffName: json['dropoff_name'] as String,
      dropoffPhoneNumber: json['dropoff_phone_number'] as String,
      pickupAddress: json['pickup_address'] as String,
      pickupName: json['pickup_name'] as String,
      pickupPhoneNumber: json['pickup_phone_number'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'dropoff_address': dropoffAddress,
      'dropoff_name': dropoffName,
      'dropoff_phone_number': dropoffPhoneNumber,
      'pickup_address': pickupAddress,
      'pickup_name': pickupName,
      'pickup_phone_number': pickupPhoneNumber,
    };
  }
}

class UberQuoteResponse {
  final String created;
  final String currencyType;
  final String dropoffDeadline;
  final String dropoffEta;
  final int duration;
  final String expires;
  final int fee;
  final String id;
  final String kind;
  final int pickupDuration;

  UberQuoteResponse({
    required this.created,
    required this.currencyType,
    required this.dropoffDeadline,
    required this.dropoffEta,
    required this.duration,
    required this.expires,
    required this.fee,
    required this.id,
    required this.kind,
    required this.pickupDuration,
  });

  factory UberQuoteResponse.fromJson(Map<String, dynamic> json) {
    return UberQuoteResponse(
      created: json['created'] as String,
      currencyType: json['currency_type'] as String,
      dropoffDeadline: json['dropoff_deadline'] as String,
      dropoffEta: json['dropoff_eta'] as String,
      duration: json['duration'] as int,
      expires: json['expires'] as String,
      fee: json['fee'] as int,
      id: json['id'] as String,
      kind: json['kind'] as String,
      pickupDuration: json['pickup_duration'] as int,
    );
  }
}

enum UberQuoteResultStatus { SUCCEEDED, FAILED }
class UberQuoteResult {
  final UberQuoteResultStatus result;
  final String id;
  final int fee;
  final int duration;
  final String expires;

  UberQuoteResult({
    required this.result,
    this.id = "",
    this.fee = 0,
    this.duration = 0,
    this.expires = "",
    });
}

class UberDeliveryData {
  final String quoteId;
  final String dropoffAddress;
  final String dropoffName;
  final String dropoffPhoneNumber;
  final List<ManifestItem> manifestItems;
  final String pickupAddress;
  final String pickupName;
  final String pickupPhoneNumber;

  UberDeliveryData({
    required this.quoteId,
    required this.dropoffAddress,
    required this.dropoffName,
    required this.dropoffPhoneNumber,
    required this.manifestItems,
    required this.pickupAddress,
    required this.pickupName,
    required this.pickupPhoneNumber,
  });

  factory UberDeliveryData.fromJson(Map<String, dynamic> json) {
    var manifestItemsJson = json['manifest_items'] as List;
    List<ManifestItem> manifestItemsList = manifestItemsJson.map((i) => ManifestItem.fromJson(i)).toList();

    return UberDeliveryData(
      quoteId: json['quote_id'] as String,
      dropoffAddress: json['dropoff_address'] as String,
      dropoffName: json['dropoff_name'] as String,
      dropoffPhoneNumber: json['dropoff_phone_number'] as String,
      manifestItems: manifestItemsList,
      pickupAddress: json['pickup_address'] as String,
      pickupName: json['pickup_name'] as String,
      pickupPhoneNumber: json['pickup_phone_number'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    List<Map<String, dynamic>> manifestItemsList = this.manifestItems.map((i) => i.toJson()).toList();

    return {
      'quote_id': quoteId,
      'dropoff_address': dropoffAddress,
      'dropoff_name': dropoffName,
      'dropoff_phone_number': dropoffPhoneNumber,
      'manifest_items': manifestItemsList,
      'pickup_address': pickupAddress,
      'pickup_name': pickupName,
      'pickup_phone_number': pickupPhoneNumber,
    };
  }
}

class ManifestItem {
  final String name;
  final int quantity;

  ManifestItem({
    required this.name,
    required this.quantity,
  });

  factory ManifestItem.fromJson(Map<String, dynamic> json) {
    return ManifestItem(
      name: json['name'] as String,
      quantity: json['quantity'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'quantity': quantity,
    };
  }
}
