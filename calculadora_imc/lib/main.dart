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
  String _classificacao = "";
  bool _campoAtivoPeso = false;

  @override
  void initState() {
    super.initState();
    _focarAltura();
  }

  void _focarAltura() {
    Future.delayed(Duration(milliseconds: 100), () {
      FocusScope.of(context).unfocus(); // Limpa o foco
    });
  }

  void _calcularIMC() {
    final altura = double.tryParse(_controladorAltura.text) ?? 0;
    final peso = double.tryParse(_controladorPeso.text) ?? 0;

    // Converter altura de cm para metros
    final alturaEmMetros = altura / 100;

    if (altura > 0 && peso > 0) {
      final imc = peso / (alturaEmMetros * alturaEmMetros);
      setState(() {
        _resultado = "IMC: ${imc.toStringAsFixed(2)}";
        _classificacao = _classificarIMC(imc);
      });
    } else {
      _mostrarMensagemErro("Por favor, insira valores válidos.");
    }
  }

  String _classificarIMC(double imc) {
    if (imc < 16) {
      return "Classificação: Magreza Grau III";
    } else if (imc >= 16 && imc <= 16.9) {
      return "Classificação: Magreza Grau II";
    } else if (imc >= 17 && imc <= 18.4) {
      return "Classificação: Magreza Grau I";
    } else if (imc >= 18.5 && imc <= 24.9) {
      return "Classificação: Eutrofia";
    } else if (imc >= 25 && imc <= 29.9) {
      return "Classificação: Pré-obesidade";
    } else if (imc >= 30 && imc <= 34.9) {
      return "Classificação: Obesidade Moderada (Grau I)";
    } else if (imc >= 35 && imc <= 39.9) {
      return "Classificação: Obesidade Severa (Grau II)";
    } else {
      return "Classificação: Obesidade Muito Severa (Grau III)";
    }
  }

  void _mostrarMensagemErro(String mensagem) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(mensagem)));
  }

  void _atualizarCampo(String valor) {
    setState(() {
      if (_campoAtivoPeso) {
        _controladorPeso.text += valor;
      } else {
        _controladorAltura.text += valor;
      }
    });
  }

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

  void _definirCampoAtivo(bool ativoPeso) {
    setState(() {
      _campoAtivoPeso = ativoPeso;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calculadora de IMC', textAlign: TextAlign.center),
        centerTitle: true, // Alinhar o título no centro
      ),
      body: SingleChildScrollView( // Adicionado para permitir rolagem
        child: Center(
          child: Container(
            width: 350, // Largura da calculadora
            margin: const EdgeInsets.all(10), // Margem menor
            padding: const EdgeInsets.all(20), // Espaçamento interno maior
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: Offset(0, 3), // Sombra abaixo
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                _construirImagem(),
                const SizedBox(height: 20),
                _construirCampoTexto(_controladorAltura, 'Altura (cm)', false),
                const SizedBox(height: 10), // Espaçamento entre os campos
                _construirCampoTexto(_controladorPeso, 'Peso (kg)', true),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _calcularIMC,
                  child: const Text('Calcular IMC'),
                ),
                const SizedBox(height: 20),
                Text(
                  _resultado,
                  style: const TextStyle(fontSize: 24),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                Text(
                  _classificacao,
                  style: const TextStyle(fontSize: 18),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                _construirTecladoNumerico(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _construirImagem() {
    return Center(
      child: Container(
        height: 200, // Altura da imagem
        width: 200,  // Largura da imagem
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(
              'https://play-lh.googleusercontent.com/ouL1lfSP_CyUgb5OUvI51jG3cevMfulA1GZGtS63r3Xfa8STYiIxq6KiY3PkMc6PcTk=w240-h480-rw',
            ),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  Widget _construirCampoTexto(TextEditingController controlador, String rotulo, bool ativoPeso) {
    return TextField(
      controller: controlador,
      decoration: InputDecoration(
        labelText: rotulo,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      keyboardType: TextInputType.number,
      onTap: () => _definirCampoAtivo(ativoPeso),
    );
  }

  Widget _construirTecladoNumerico() {
    List<List<String>> teclas = [
      ['7', '8', '9', 'DEL'],
      ['4', '5', '6', '.'],
      ['1', '2', '3', '0'],
    ];

    return Column(
      children: teclas.map((linha) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: linha.map((tecla) {
            return _construirBotaoTeclado(tecla);
          }).toList(),
        );
      }).toList(),
    );
  }

  Widget _construirBotaoTeclado(String texto) {
    return ElevatedButton(
      onPressed: () {
        if (texto == 'DEL') {
          _deletarUltimoCaracter();
        } else {
          _atualizarCampo(texto);
        }
      },
      style: ElevatedButton.styleFrom(
        fixedSize: const Size(60, 60),
      ),
      child: texto == 'DEL'
          ? const Icon(Icons.backspace, size: 24)
          : Text(
              texto,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 18,
              ),
            ),
    );
  }
}