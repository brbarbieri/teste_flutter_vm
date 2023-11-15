import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:reorderable_grid_view/reorderable_grid_view.dart';

import 'ExamApi.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final ExamApi examApi = ExamApiImpl();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(examApi: examApi),
      debugShowCheckedModeBanner: false,
    );
  }
}

class OnlyNumbersFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    String newText = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');

    return TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: newText.length),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final ExamApi examApi;
  MyHomePage({required this.examApi});
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<int> numbers = [];
  TextEditingController _controller = TextEditingController();
  int draggingIndex = -1;
  bool isVerifying = false;

  // WIDGET - Display dos números da lista
  Widget numberCard(String text) {
    return Card(
      key: ValueKey(text),
      color: Color(0xff2b2b2b),
      elevation: 5,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16, color: Color(0xfff5f5f5)),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfff5f5f5),
      appBar: AppBar(
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Color(0x00ffffff),
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.light,
        ),
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.transparent,
        title: Text(
          'Gerador e Organizador de Números'.toUpperCase(),
          style: TextStyle(fontSize: 16, color: Color(0xff2b2b2b)),
        ),
      ),
      floatingActionButton: Container(
        width: MediaQuery.of(context).size.width * 0.4,
        height: MediaQuery.of(context).size.height * 0.05,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xff2b2b2b),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(MediaQuery.of(context).size.height * 0.05),
            ),
          ),
          onPressed: () {
            _restartProcess();
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.refresh, color: Color(0xfff5f5f5)),
              SizedBox(width: 8),
              Text(
                'REINICIAR',
                style: TextStyle(fontSize: 16, color: Color(0xfff5f5f5)),
              ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.015,
            ),
            Opacity(
              opacity: numbers.isEmpty ? 1.0 : 0.4,
              child: Column(children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.8,
                  padding: EdgeInsets.only(bottom: 15),
                  child: Text(
                    '1º Informe a quantidade de números que deseja gerar a sua lista:',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, color: Color(0xff808080)),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.8,
                  height: MediaQuery.of(context).size.height * 0.08,
                  padding: EdgeInsets.only(bottom: 15),
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.done,
                    enabled: numbers.isEmpty,
                    onFieldSubmitted: (text) async {
                      if (_controller.text != "") {
                        FocusManager.instance.primaryFocus?.unfocus();
                        await Future.delayed(const Duration(milliseconds: 150), () async {
                          int quantity = int.parse(_controller.text);
                          setState(() {
                            numbers = widget.examApi.getRandomNumbers(quantity);
                          });
                        });
                      }
                    },
                    style: const TextStyle(color: Color(0xff808080), fontSize: 16),
                    onChanged: (text) {
                      (context as Element).markNeedsBuild();
                    },
                    controller: _controller,
                    inputFormatters: [
                      OnlyNumbersFormatter(),
                      LengthLimitingTextInputFormatter(2),
                    ],
                    decoration: InputDecoration(
                      labelStyle: const TextStyle(
                        color: Color(0xff808080),
                        fontSize: 16,
                      ),
                      fillColor: Color(0xff4b4b4b),
                      disabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: const BorderSide(
                          color: Color(0xff808080),
                          width: 2.0,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: const BorderSide(
                          width: 2.0,
                          color: Color(0xff4b4b4b),
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: const BorderSide(
                          color: Color(0xff808080),
                          width: 2.0,
                        ),
                      ),
                    ),
                  ),
                ),
                numbers.isEmpty
                    ? SizedBox(
                        width: MediaQuery.of(context).size.width * 0.8,
                        height: MediaQuery.of(context).size.height * 0.05,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _controller.text != "" ? Color(0xff2b2b2b) : Color(0xffa0a0a0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                          onPressed: () async {
                            if (_controller.text != "") {
                              FocusManager.instance.primaryFocus?.unfocus();
                              await Future.delayed(const Duration(milliseconds: 150), () async {
                                int quantity = int.parse(_controller.text);
                                setState(() {
                                  numbers = widget.examApi.getRandomNumbers(quantity);
                                });
                              });
                            }
                          },
                          child: Text(
                            'GERAR LISTA DE NÚMEROS',
                            style: TextStyle(
                              fontSize: 16,
                              color: Color(0xfff5f5f5),
                            ),
                          ),
                        ),
                      )
                    : SizedBox(),
              ]),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.02,
            ),
            if (numbers.isNotEmpty) ...[
              Opacity(
                opacity: numbers.isNotEmpty && isVerifying == false ? 1.0 : 0.4,
                child: Column(children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 0.8,
                    padding: EdgeInsets.only(bottom: 15),
                    child: Text(
                      '2º Segure e arraste os números da lista para reordena-los em ordem crescente:',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16, color: Color(0xff808080)),
                    ),
                  ),
                  Scrollbar(
                    child: Container(
                      padding: EdgeInsets.only(right: 10, left: 10),
                      width: MediaQuery.of(context).size.width * 0.8 + 20,
                      height: numbers.length > 15
                          ? MediaQuery.of(context).size.width * 0.8 * 4 / 5
                          : numbers.length > 10
                              ? MediaQuery.of(context).size.width * 0.8 * 3 / 5
                              : numbers.length > 5
                                  ? MediaQuery.of(context).size.width * 0.8 * 2 / 5
                                  : MediaQuery.of(context).size.width * 0.8 * 1 / 5,
                      color: Color(0x00ffffff),
                      child: ReorderableGridView.count(
                        crossAxisSpacing: 8,
                        mainAxisSpacing: 8,
                        crossAxisCount: 5,
                        children: this.numbers.map((e) => numberCard("$e")).toList(),
                        onReorder: (oldIndex, newIndex) {
                          setState(() {
                            final element = numbers.removeAt(oldIndex);
                            numbers.insert(newIndex, element);
                          });
                        },
                      ),
                    ),
                  ),
                ]),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.03,
              ),
              Opacity(
                opacity: numbers.isNotEmpty ? 1.0 : 0.4,
                child: Column(children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 0.8,
                    padding: EdgeInsets.only(bottom: 20),
                    child: Text(
                      '3º Pressione o botão abaixo para verificar se a lista está em ordem crescente:',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16, color: Color(0xff808080)),
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.8,
                    height: MediaQuery.of(context).size.height * 0.05,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      onPressed: () async {
                        setState(() {
                          isVerifying = true;
                        });
                        await Future.delayed(const Duration(seconds: 2), () async {
                          _checkOrder();
                        });
                        setState(() {
                          isVerifying = false;
                        });
                      },
                      child: isVerifying == true
                          ? SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                color: Color(0xfff5f5f5),
                                strokeWidth: 2,
                              ))
                          : Text(
                              'VERIFICAR ORDEM',
                              style: TextStyle(
                                fontSize: 16,
                                color: Color(0xfff5f5f5),
                              ),
                            ),
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.03,
                  ),
                ]),
              ),
            ],
          ],
        ),
      ),
      ),
    );
  }

  // Função para reiniciar o processo.
  void _restartProcess() {
    setState(() {
      numbers.clear();
      _controller.text = "";
      FocusManager.instance.primaryFocus?.unfocus();
    });
  }

  // Função para veirificar se os números estão em ordem crescente.
  void _checkOrder() {
    bool isOrdered = widget.examApi.checkOrder(numbers);
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            'RESULTADO',
            style: TextStyle(fontSize: 20, color: Color(0xff2b2b2b)),
          ),
          content: Text(
            isOrdered ? 'Está em ordem crescente.' : 'Não está em ordem crescente.',
            style: TextStyle(fontSize: 16, color: Color(0xff808080)),
          ),
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xff2b2b2b),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
