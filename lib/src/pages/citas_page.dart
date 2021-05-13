import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:form_validation/src/bloc/provider.dart';
import 'package:form_validation/src/models/citas_model.dart';
import 'package:form_validation/src/utils/responsive.dart';

class CitasPage extends StatefulWidget {
  @override
  _CitasPageState createState() => _CitasPageState();
}

class _CitasPageState extends State<CitasPage> {
  @override
  Widget build(BuildContext context) {
    final citasBloc = Provider.citas(context);
    citasBloc.obtenerCitas();

    DateTime _selectedValue = DateTime.now();
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          DatePicker(
            DateTime.now(),
            initialSelectedDate: DateTime.now(),
            selectionColor: Colors.teal,
            selectedTextColor: Colors.white,
            onDateChange: (date) {
              // New date selected
              setState(() {
                _selectedValue = date;
              });
              print(_selectedValue);
            },
          ),
          StreamBuilder(
            stream: citasBloc.emailStream,
            builder: (BuildContext context,
                AsyncSnapshot<List<CitasModel>> snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data.length > 0) {
                  return Expanded(
                    child: ListView.builder(
                      itemCount: snapshot.data.length,
                      itemBuilder: (context, index) {
                        return Container(
                          margin:
                              EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                          padding: EdgeInsets.symmetric(
                              horizontal: 10, vertical: 10),
                          width: double.infinity,
                          height: 100,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                              color: ('${snapshot.data[index].estado}' == '1')
                                  ? Colors.red
                                  : Colors.green),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${snapshot.data[index].hora}',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 18),
                              ),
                              Text(
                                '${snapshot.data[index].paciente}',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 18),
                              ),
                              Text(
                                '${snapshot.data[index].medico}',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 18),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  );
                } else {
                  return CupertinoActivityIndicator();
                }
              } else {
                return CupertinoActivityIndicator();
              }
            },
          ),
        ],
      ),
    );
  }


}