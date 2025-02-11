
import 'package:flutter/material.dart';
import 'database/database_helper.dart';
import 'models/planeta.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CRUD Planetas',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: PlanetasList(),
    );
  }
}

class PlanetasList extends StatefulWidget {
  @override
  _PlanetasListState createState() => _PlanetasListState();
}

class _PlanetasListState extends State<PlanetasList> {
  late Future<List<Planeta>> futurePlanetas;

  @override
  void initState() {
    super.initState();
    futurePlanetas = DatabaseHelper().getPlanetas();
  }

  void _navigateToAddPlaneta() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddPlaneta()),
    );
    setState(() {
      futurePlanetas = DatabaseHelper().getPlanetas();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Planetas'),
      ),
      body: FutureBuilder<List<Planeta>>(
        future: futurePlanetas,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erro ao carregar planetas'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Nenhum planeta cadastrado'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                Planeta planeta = snapshot.data![index];
                return ListTile(
                  title: Text(planeta.nome),
                  subtitle: Text(planeta.apelido ?? 'Sem apelido'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PlanetaDetails(planeta: planeta),
                      ),
                    );
                  },
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToAddPlaneta,
        child: Icon(Icons.add),
      ),
    );
  }
}

class AddPlaneta extends StatefulWidget {
  @override
  _AddPlanetaState createState() => _AddPlanetaState();
}

class _AddPlanetaState extends State<AddPlaneta> {
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _distanciaController = TextEditingController();
  final _tamanhoController = TextEditingController();
  final _apelidoController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Adicionar Planeta'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nomeController,
                decoration: InputDecoration(labelText: 'Nome'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Campo obrigatório';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _distanciaController,
                decoration: InputDecoration(labelText: 'Distância do Sol (UA)'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Campo obrigatório';
                  }
                  if (double.tryParse(value) == null || double.parse(value) <= 0) {
                    return 'Valor inválido';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _tamanhoController,
                decoration: InputDecoration(labelText: 'Tamanho (km)'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Campo obrigatório';
                  }
                  if (double.tryParse(value) == null || double.parse(value) <= 0) {
                    return 'Valor inválido';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _apelidoController,
                decoration: InputDecoration(labelText: 'Apelido (opcional)'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    Planeta planeta = Planeta(
                      nome: _nomeController.text,
                      distanciaSol: double.parse(_distanciaController.text),
                      tamanho: double.parse(_tamanhoController.text),
                      apelido: _apelidoController.text,
                    );
                    await DatabaseHelper().insertPlaneta(planeta);
                    Navigator.pop(context);
                  }
                },
                child: Text('Salvar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PlanetaDetails extends StatelessWidget {
  final Planeta planeta;

  PlanetaDetails({required this.planeta});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(planeta.nome),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Nome: ${planeta.nome}'),
            Text('Distância do Sol: ${planeta.distanciaSol} UA'),
            Text('Tamanho: ${planeta.tamanho} km'),
            Text('Apelido: ${planeta.apelido ?? 'Sem apelido'}'),
          ],
        ),
      ),
    );
  }
}
