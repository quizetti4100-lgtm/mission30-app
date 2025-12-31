class InstituteConfig {
  final String name;
  final String logo;
  final String primaryColor;

  InstituteConfig({
    required this.name,
    required this.logo,
    required this.primaryColor,
  });

  // Firebase से आने वाले JSON को क्लास ऑब्जेक्ट में बदलना
  factory InstituteConfig.fromJson(Map<String, dynamic> json) {
    return InstituteConfig(
      name: json['name'] ?? 'Coaching App',
      logo: json['logo'] ?? '',
      // अगर डेटाबेस में रंग नहीं है, तो डिफ़ॉल्ट नारंगी रंग (#FF5722) देगा
      primaryColor: json['primaryColor'] ?? '#FF5722',
    );
  }
}