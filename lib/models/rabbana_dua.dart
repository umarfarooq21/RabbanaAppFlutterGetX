class RabbanaDua {
  const RabbanaDua({
    required this.id,
    required this.number,
    required this.arabic,
    required this.transliteration,
    required this.translation,
    required this.reference,
    required this.surah,
    required this.ayahStart,
    required this.ayahEnd,
  });

  final int id;
  final int number;
  final String arabic;
  final String transliteration;
  final String translation;
  final String reference;
  final int surah;
  final int ayahStart;
  final int ayahEnd;

  List<int> get ayahNumbers {
    return [for (var ayah = ayahStart; ayah <= ayahEnd; ayah++) ayah];
  }

  factory RabbanaDua.fromJson(Map<String, dynamic> json) {
    final ayahStart = json['ayahStart'] as int;
    return RabbanaDua(
      id: json['id'] as int,
      number: json['number'] as int,
      arabic: json['arabic'] as String,
      transliteration: json['transliteration'] as String,
      translation: json['translation'] as String,
      reference: json['reference'] as String,
      surah: json['surah'] as int,
      ayahStart: ayahStart,
      ayahEnd: (json['ayahEnd'] as int?) ?? ayahStart,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'number': number,
      'arabic': arabic,
      'transliteration': transliteration,
      'translation': translation,
      'reference': reference,
      'surah': surah,
      'ayahStart': ayahStart,
      'ayahEnd': ayahEnd,
    };
  }
}
