class CitasModel {
  String idCita;
  String idPaciente;
  String fecha;
  String hora;
  String medico;
  String comentarios;
  String estado;
  String paNombre;
  String papellido;
  String padni;
  String haycita;

  CitasModel({
    this.idCita,
    this.hora,
    this.idPaciente,
    this.medico,
    this.fecha,
    this.comentarios,
    this.estado,
    this.paNombre,
    this.papellido,
    this.padni,
    this.haycita,
  });

  factory CitasModel.fromJson(Map<String, dynamic> json) => CitasModel(
        idCita: json["idCita"],
        idPaciente: json["idPaciente"],
        fecha: json["fecha"],
        hora: json["hora"],
        comentarios: json["comentarios"],
        estado: json["estado"],
        paNombre: json["panombre"],
        papellido: json["papellido"],
        padni: json["padni"],
      );
}
