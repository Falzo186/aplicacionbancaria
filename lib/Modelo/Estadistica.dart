class Estadistica {
 String id;
 int numeroSolicitudes;
int SolucionesAprobadas;
int SolucionesRechazadas;
int SolucionesPendientes;
double porcentajeAprobadas;

Estadistica({
  required this.id,
  required this.numeroSolicitudes,
  required this.SolucionesAprobadas,
  required this.SolucionesRechazadas,
  required this.SolucionesPendientes,
  double? porcentajeAprobadas,
}) : porcentajeAprobadas = porcentajeAprobadas ?? 0.0 {
  calcularPorcentajeAprobadas();
}

void calcularPorcentajeAprobadas() {
  if (numeroSolicitudes > 0) {
    porcentajeAprobadas = (SolucionesAprobadas / numeroSolicitudes * 100)
        .toStringAsFixed(3)
        .parseDouble();
  } else {
    porcentajeAprobadas = 0.0;
  }
}


factory Estadistica.fromMap(Map<String, dynamic> data) {
  return Estadistica(
    id: data['id'] as String,
    numeroSolicitudes: data['numerosolicitudes'] as int,
    SolucionesAprobadas: data['solucionesaprobadas'] as int,
    SolucionesRechazadas: data['solucionesrechazadas'] as int,
    SolucionesPendientes: data['solucionespendientes'] as int,
  );
}

Map<String, dynamic> toMap() {
  return {
    'id': id,
    'numerosolicitudes': numeroSolicitudes,
    'solucionesaprobadas': SolucionesAprobadas,
    'solucionesrechazadas': SolucionesRechazadas,
    'solucionespendientes': SolucionesPendientes,
  };
}


}

extension StringParsing on String {
double parseDouble() => double.parse(this);
}

