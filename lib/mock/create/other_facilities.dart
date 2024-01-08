bool hasLift = true;
bool hasGenarators = false;
bool hasSecurityGuard = false;
bool hasParking = true;
bool hasGas = true;
bool hasWifi = true;

/// Data Map Structure(Rental Type)...
var otherFacilitiesData = <String, bool>{
  "lift": hasLift,
  "generator": hasGenarators,
  "securityGuard": hasSecurityGuard,
  "parking": hasParking,
  "gas": hasGas,
  "wifi": hasWifi,
};

List otherFacilities = [];
