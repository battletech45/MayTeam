class AppMath {
  const AppMath._();

  static double generalNormalizeValue({
    required double value,
    required double minValue,
    required double maxValue,
    required double minNormalizedValue,
    required double maxNormalizedValue,
  }) {
    // Değerin normalleştirilmiş karşılığını hesapla
    double normalizedValue = minNormalizedValue + ((value - minValue) / (maxValue - minValue)) * (maxNormalizedValue - minNormalizedValue);

    // Eğer sonuç minNormalizedValue'dan küçükse minNormalizedValue'a ayarla
    normalizedValue = normalizedValue < minNormalizedValue ? minNormalizedValue : normalizedValue;

    // Eğer sonuç maxNormalizedValue'dan büyükse maxNormalizedValue'a ayarla
    normalizedValue = normalizedValue > maxNormalizedValue ? maxNormalizedValue : normalizedValue;

    return normalizedValue;
  }
}
