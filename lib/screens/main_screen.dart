import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'cubit/main_screen_cubit.dart';
import 'cubit/main_screen_state.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
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
        child: BlocBuilder<MainScreenCubit, MainScreenState>(
          builder: (context, state) {
            if (state is MainScreenCalculated) {
              return _buildResult(state);
            }
            if (state is MainScreenError) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.message)),
                );
              });
            }
            return _buildForm();
          },
        ),
      ),
    );
  }

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          const Text('Масса тела (кг):', style: TextStyle(fontSize: 20.0)),
          TextFormField(
            controller: _massController,
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Пожалуйста введите массу';
              }
              final number = double.tryParse(value.replaceAll(',', '.'));
              if (number == null) return 'Введите число';
              if (number <= 0) return 'Масса должна быть больше 0';
              return null;
            },
          ),
          const SizedBox(height: 20.0),
          const Text('Скорость (м/с):', style: TextStyle(fontSize: 20.0)),
          TextFormField(
            controller: _speedController,
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Пожалуйста введите скорость';
              }
              final number = double.tryParse(value.replaceAll(',', '.'));
              if (number == null) return 'Введите число';
              if (number <= 0) return 'Скорость должна быть больше 0';
              return null;
            },
          ),
          const SizedBox(height: 20.0),
          CheckboxListTile(
            value: _agreement,
            title: const Text('Я согласен на обработку персональных данных'),
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
                    content: Text('Поставьте галочку согласия на обработку данных'),
                  ),
                );
                return;
              }
              if (_formKey.currentState!.validate()) {
                final mass = double.parse(_massController.text.replaceAll(',', '.'));
                final speed = double.parse(_speedController.text.replaceAll(',', '.'));
                context.read<MainScreenCubit>().calculate(mass, speed);
              }
            },
            child: const Text('Рассчитать'),
          ),
        ],
      ),
    );
  }

  Widget _buildResult(MainScreenCalculated state) {
    return Column(
      children: <Widget>[
        const Text('Входные данные:', style: TextStyle(fontSize: 20.0)),
        Text('Масса: ${state.mass} кг'),
        Text('Скорость: ${state.speed} м/с'),
        const SizedBox(height: 20.0),
        const Text('Кинетическая энергия:', style: TextStyle(fontSize: 20.0)),
        Text('${state.energy.toStringAsFixed(2)} Дж', style: const TextStyle(fontSize: 20.0)),
        const Text('E = m·v²/2'),
        const SizedBox(height: 20.0),
        ElevatedButton(
          onPressed: () {
            context.read<MainScreenCubit>().reset();
          },
          child: const Text('Вернуться назад'),
        ),
      ],
    );
  }
}