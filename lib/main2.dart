import 'dart:convert';

void main() {
  String jsonText = '''[1,5,8,3,2]''';

  final lista = jsonDecode(jsonText);

  int dlugosc_listy = lista.length;
  int suma = 0;

  print("\nZadanie 1A");

  for (int i = 0; i < dlugosc_listy; i++) {
    print(lista[i]);
    suma += lista[i] as int;
  }

  print("Suma: $suma");

  String jsonText2 = '''
  {
    "group": "Dart",
    "students": ["Ola","Adam","Kasia"]
  }
  ''';

  final grupa = jsonDecode(jsonText2);

  print("\nZadanie 1B");
  print("Grupa: ${grupa["group"]}");
  print("Studenci:");
  for(int i = 0; i < grupa["students"].length; i++) {
    print(grupa["students"][i]);
  }

  print("\nZadanie 1C");
  String jsonText3 = '''
  {
  "product": {
    "name": "Laptop",
    "price": 3500
    }
  }
   ''';

  final produkt = jsonDecode(jsonText3);
  print("Nazwa produktu: ${produkt["product"]["name"]}");
  print("Cena produktu: ${produkt["product"]["price"]}");
}
