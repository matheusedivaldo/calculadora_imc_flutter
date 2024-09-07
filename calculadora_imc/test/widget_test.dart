import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:calculadora_imc/main.dart';

void main() {
  testWidgets('Verifica se a calculadora IMC é exibida corretamente', (WidgetTester tester) async {
    // Construa o aplicativo e acione um frame.
    await tester.pumpWidget(MeuApp());

    // Verifique se o texto 'Calculadora de IMC' está presente.
    expect(find.text('Calculadora de IMC'), findsOneWidget);

    // Verifique se o botão 'Calcular IMC' está presente.
    expect(find.text('Calcular IMC'), findsOneWidget);

    // Verifique se o campo de texto para altura está presente.
    expect(find.byType(TextField).at(0), findsOneWidget);

    // Verifique se o campo de texto para peso está presente.
    expect(find.byType(TextField).at(1), findsOneWidget);

    // Verifique se o botão de exclusão do teclado numérico está presente.
    expect(find.byIcon(Icons.backspace), findsOneWidget);
  });
}