import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Калькулятор кинетической энергии',
      home: const FirstScreen(),
    );
  }
}

class FirstScreen extends StatefulWidget {
  const FirstScreen({super.key});

  @override
  State<FirstScreen> createState() => _FirstScreenState();
}

class _FirstScreenState extends State<FirstScreen> {
  final _formKey = GlobalKey<FormState>();
  final _massController = TextEditingController();
  final _speedController = TextEditingController();
  bool _agreement = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Пермякова А.Р.'),
      ),
      body: Container(
        padding: const EdgeInsets.all(10.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              const Text(
                'Масса тела (кг):',
                style: TextStyle(fontSize: 20.0),
              ),
              TextFormField(
                controller: _massController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Пожалуйста введите массу';
                  }
                  final number = double.tryParse(value.replaceAll(',', '.'));
                  if (number == null) {
                    return 'Введите число';
                  }
                  if (number <= 0) {
                    return 'Масса должна быть больше 0';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20.0),

              const Text(
                'Скорость (м/с):',
                style: TextStyle(fontSize: 20.0),
              ),
              TextFormField(
                controller: _speedController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Пожалуйста введите скорость';
                  }
                  final number = double.tryParse(value.replaceAll(',', '.'));
                  if (number == null) {
                    return 'Введите число';
                  }
                  if (number <= 0) {
                    return 'Скорость должна быть больше 0';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20.0),

              CheckboxListTile(
                value: _agreement,
                title: const Text(
                  'Я согласен на обработку персональных данных',
                ),
                onChanged: (bool? value) {
                  setState(() {
                    _agreement = value!;
                  });
                },
              ),
              const SizedBox(height: 20.0),

              ElevatedButton(
                onPressed: () {
                  if (!_agreement) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Поставьте галочку согласия на обработку данных',
                        ),
                      ),
                    );
                    return;
                  }
                  if (_formKey.currentState!.validate()) {
                    final mass = double.parse(
                      _massController.text.replaceAll(',', '.'),
                    );
                    final speed = double.parse(
                      _speedController.text.replaceAll(',', '.'),
                    );

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            SecondScreen(mass: mass, speed: speed),
                      ),
                    );
                  }
                },
                child: const Text('Рассчитать'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SecondScreen extends StatelessWidget {
  final double mass;
  final double speed;

  const SecondScreen({
    super.key,
    required this.mass,
    required this.speed,
  });

  @override
  Widget build(BuildContext context) {
    final double energy = mass * speed * speed / 2;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Результат вычисления'),
      ),
      body: Container(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: <Widget>[
            const Text(
              'Входные данные:',
              style: TextStyle(fontSize: 20.0),
            ),
            Text('Масса: $mass кг'),
            Text('Скорость: $speed м/с'),
            const SizedBox(height: 20.0),

            const Text(
              'Кинетическая энергия:',
              style: TextStyle(fontSize: 20.0),
            ),
            Text(
              '${energy.toStringAsFixed(2)} Дж',
              style: const TextStyle(fontSize: 20.0),
            ),
            Text('E = m·v²/2'),
            const SizedBox(height: 20.0),

            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Закрыть'),
            ),
          ],
        ),
      ),
    );
  }
}