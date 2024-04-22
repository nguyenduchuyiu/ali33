const int defaultLimit = 20;
const String rupeeSymbol = "\u{20B9}";

int calculateSavedAmount(int sPrice, int offPrice) {
  return (sPrice - offPrice).toInt();
}

String calculateOffPercentage(int sPrice, int offPrice) {
  return (((sPrice - offPrice) / sPrice) * 100).round().toString();
}
