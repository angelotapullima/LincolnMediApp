import 'package:flutter/material.dart';
import 'package:form_validation/src/bloc/provider.dart';
import 'package:form_validation/src/models/paciente_model.dart';
import 'package:form_validation/src/providers/pacientes_provider.dart';

class HomePage extends StatelessWidget {
  final pacientesProvider = new PacientesProvider();

  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of(context);

    return Scaffold(
      // appBar: AppBar(
      //   title: Text('Pacientes'),
      //   centerTitle: true,
      // ),
      body: _crearListado(),
      floatingActionButton: _crearBoton(context),
    );
  }

  Widget _crearListado() {
    return FutureBuilder(
      future: pacientesProvider.cargarPacientes(),
      builder:
          (BuildContext context, AsyncSnapshot<List<PacienteModel>> snapshot) {
        if (snapshot.hasData) {
          final pacientes = snapshot.data;

          return ListView.builder(
            itemCount: pacientes.length,
            itemBuilder: (context, i) => _crearItem(context, pacientes[i]),
          );
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Widget _crearItem(BuildContext context, PacienteModel paciente) {
    // return Container(
    //   child: _card(context, paciente),
    // );
    return Dismissible(
        key: UniqueKey(),
        onDismissed: (direction) {
          print('DISMISED');
          if (direction == DismissDirection.endToStart) {
            print('END TO START');
            pacientesProvider.borrarPaciente(paciente.id);
          } else {
            print('START TO END');
          }
        },
        confirmDismiss: (direction) {
          if(direction==DismissDirection.endToStart){
                  return showDialog(
              context: context,
              builder: (context) {
                
                return AlertDialog(
                  title: Text('Confirmar'),
                  content: Text('Estás seguro de eliminarlo?'),
                  actions: [
                    FlatButton(
                        onPressed: () {
                          print('No');
                          Navigator.of(context).pop(false);
                        },
                        child: Text('No')),
                    FlatButton(
                        onPressed: () {
                          print('Si');
                          Navigator.of(context).pop(true);
                        },
                        child: Text('Si')),
                  ],
                );
              });
            }
          
        },
        // direction: DismissDirection.endToStart,
        secondaryBackground: Container(
          color: Colors.red,
          child: Icon(Icons.delete, color: Colors.white, size: 30.0),
          alignment: Alignment.centerRight,
          padding: EdgeInsets.only(right: 10),
        ),
        background: Container(
          color: Colors.amber,
          child: Icon(Icons.book, color: Colors.white, size: 30.0),
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.only(left: 10),
        ),
        // onDismissed: (direccion) {
        //   pacientesProvider.borrarPaciente(paciente.id);
        // },
        child: Card(
          child: Column(
            children: <Widget>[
              ListTile(
                // leading: Icon(Icons.account_circle, size: 60.0,),
                leading: (paciente.fotoUrl == null)
                    ? CircleAvatar(
                        backgroundImage: AssetImage('assets/no-image.png'),
                        //radius: 20,
                      )
                    // ? Image(image: AssetImage('assets/no-image.png'))
                    : CircleAvatar(
                        backgroundColor: Colors.black26,
                        backgroundImage: NetworkImage(paciente.fotoUrl),
                        //radius: 20,
                      ),
                title: Text('${paciente.name}' + " " + '${paciente.lastname}'),
                subtitle: Text(paciente.number.toString()),
                onTap: () => Navigator.pushNamed(context, 'paciente',
                    arguments: paciente),
                // .then((value) => setState(() {})),
              ),
            ],
          ),
        ));
  }

  _crearBoton(BuildContext context) {
    return FloatingActionButton(
      child: Icon(Icons.add),
      backgroundColor: Colors.teal,
      onPressed: () => Navigator.pushNamed(context, 'paciente'),
    );
  }
}
