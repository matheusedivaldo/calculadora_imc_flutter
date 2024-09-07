import 'package:flutter/material.dart';

void main() {
  runApp(MeuApp());
}

class MeuApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calculadora de IMC',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: CalculadoraIMC(),
    );
  }
}

class CalculadoraIMC extends StatefulWidget {
  @override
  _CalculadoraIMCState createState() => _CalculadoraIMCState();
}

class _CalculadoraIMCState extends State<CalculadoraIMC> {
  final _controladorAltura = TextEditingController();
  final _controladorPeso = TextEditingController();
  String _resultado = "";
  bool _campoAtivoPeso = false; // Indica se o campo ativo é o Peso ou Altura

  @override
  void initState() {
    super.initState();
    _focarAltura();
  }

  // Limpa o foco quando a tela é inicializada
  void _focarAltura() {
    Future.delayed(Duration(milliseconds: 100), () {
      FocusScope.of(context).requestFocus(FocusNode());
      FocusScope.of(context).requestFocus(FocusNode()); // Limpa o foco
    });
  }

  // Calcula o IMC com base na altura e peso fornecidos
  void _calcularIMC() {
    final altura = double.tryParse(_controladorAltura.text) ?? 0;
    final peso = double.tryParse(_controladorPeso.text) ?? 0;

    if (altura > 0 && peso > 0) {
      final imc = peso / (altura * altura);
      setState(() {
        _resultado = "IMC: ${imc.toStringAsFixed(2)}";
      });
    } else {
      setState(() {
        _resultado = "Por favor, insira valores válidos.";
      });
    }
  }

  // Atualiza o campo ativo (Peso ou Altura) com o valor digitado
  void _atualizarCampo(String valor) {
    setState(() {
      if (_campoAtivoPeso) {
        _controladorPeso.text += valor;
      } else {
        _controladorAltura.text += valor;
      }
    });
  }

  // Deleta o último caractere do campo ativo (Peso ou Altura)
  void _deletarUltimoCaracter() {
    setState(() {
      if (_campoAtivoPeso) {
        _controladorPeso.text = _controladorPeso.text.isNotEmpty
            ? _controladorPeso.text.substring(0, _controladorPeso.text.length - 1)
            : '';
      } else {
        _controladorAltura.text = _controladorAltura.text.isNotEmpty
            ? _controladorAltura.text.substring(0, _controladorAltura.text.length - 1)
            : '';
      }
    });
  }

  // Define qual campo está ativo (Peso ou Altura)
  void _definirCampoAtivo(bool ativoPeso) {
    setState(() {
      _campoAtivoPeso = ativoPeso;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Calculadora de IMC'),
      ),
      body: Center(
        child: Container(
          constraints: BoxConstraints(maxWidth: 400), // Define a largura máxima do container
          margin: EdgeInsets.all(5), // Margem ao redor do container
          padding: EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.blue, width: 1), // Adiciona borda ao redor do container
            borderRadius: BorderRadius.circular(8), // Arredonda os cantos do container
            color: Colors.white, // Cor de fundo do container
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min, // Faz com que a coluna ocupe apenas o espaço necessário
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Center(
                child: Container(
                  height: 150, // Ajuste a altura conforme necessário
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(
                        'https://play-lh.googleusercontent.com/ouL1lfSP_CyUgb5OUvI51jG3cevMfulA1GZGtS63r3Xfa8STYiIxq6KiY3PkMc6PcTk=w240-h480-rw',
                      ),
                      fit: BoxFit.cover, // Ajusta a imagem ao container
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _controladorAltura,
                decoration: InputDecoration(labelText: 'Altura (m)'),
                keyboardType: TextInputType.number,
                onTap: () => _definirCampoAtivo(false), // Define que o campo ativo é Altura
              ),
              TextField(
                controller: _controladorPeso,
                decoration: InputDecoration(labelText: 'Peso (kg)'),
                keyboardType: TextInputType.number,
                onTap: () => _definirCampoAtivo(true), // Define que o campo ativo é Peso
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _calcularIMC,
                child: Text('Calcular IMC'),
              ),
              SizedBox(height: 20),
              Text(
                _resultado,
                style: TextStyle(fontSize: 24),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              _construirTecladoNumerico(),
            ],
          ),
        ),
      ),
    );
  }

  // Constrói o teclado numérico com botões
  Widget _construirTecladoNumerico() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _construirBotaoTeclado('7'),
            SizedBox(width: 5), // Espaçamento horizontal entre os botões
            _construirBotaoTeclado('8'),
            SizedBox(width: 5), // Espaçamento horizontal entre os botões
            _construirBotaoTeclado('9'),
            SizedBox(width: 5), // Espaçamento horizontal entre os botões
            _construirBotaoTeclado('DEL', isSpecial: true),
          ],
        ),
        SizedBox(height: 5), // Espaçamento vertical entre as linhas
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _construirBotaoTeclado('4'),
            SizedBox(width: 5), // Espaçamento horizontal entre os botões
            _construirBotaoTeclado('5'),
            SizedBox(width: 5), // Espaçamento horizontal entre os botões
            _construirBotaoTeclado('6'),
            SizedBox(width: 5), // Espaçamento horizontal entre os botões
            _construirBotaoTeclado('.'),
          ],
        ),
        SizedBox(height: 5), // Espaçamento vertical entre as linhas
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _construirBotaoTeclado('1'),
            SizedBox(width: 5), // Espaçamento horizontal entre os botões
            _construirBotaoTeclado('2'),
            SizedBox(width: 5), // Espaçamento horizontal entre os botões
            _construirBotaoTeclado('3'),
            SizedBox(width: 5), // Espaçamento horizontal entre os botões
            _construirBotaoTeclado('0'),
          ],
        ),
      ],
    );
  }

  // Constrói um botão do teclado com o texto especificado
  Widget _construirBotaoTeclado(String texto, {bool isSpecial = false}) {
    return ElevatedButton(
      onPressed: () {
        if (texto == 'DEL') {
          _deletarUltimoCaracter();
        } else if (texto == '.') {
          _atualizarCampo('.');
        } else {
          _atualizarCampo(texto);
        }
      },
      style: ElevatedButton.styleFrom(
        fixedSize: Size(60, 60), // Tamanho fixo para os botões
      ),
      child: isSpecial
          ? Icon(Icons.backspace, size: 24) // Ícone de exclusão
          : Text(
              texto,
              style: TextStyle(
                color: Colors.black,
                fontSize: 18,
              ),
            ),
    );
  }
}