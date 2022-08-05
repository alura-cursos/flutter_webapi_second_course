import 'dart:math';

/// Cria uma frase aleatória
String getRandomPhrase() {
  List<String> phrases = [
    "Hoje estou feliz pois fez Sol",
    "Não estou tão bem, choveu",
    "Hoje estudei bastante Flutter!",
    "Respondi a dúvida de uma pessoa no Fórum da Alura, que legal!",
    "Entrei na comunidade da Alura no Discord!",
    "Hoje conversei com uma pessoa que também está estudando Flutter!"
  ];

  Random rng = Random();
  return phrases[rng.nextInt(phrases.length - 1)];
}
