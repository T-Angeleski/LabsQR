class QRCode {
  final String id;
  final String? qrCode;
  final String? qrCodeBase64;

  QRCode({
    required this.id,
    this.qrCode,
    this.qrCodeBase64,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'qrCode': qrCode,
      'qrCodeBase64': qrCodeBase64,
    };
  }

  factory QRCode.fromJson(Map<String, dynamic> json) {
    return QRCode(
      id: json['id'] ?? 'unknown',
      qrCode: json['qrCode'],
      qrCodeBase64: json['qrCodeBase64'],
    );
  }
}