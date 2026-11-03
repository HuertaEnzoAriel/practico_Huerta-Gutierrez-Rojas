import 'itemproducto.dart';

class Pedido {
  String? id;
  String idCliente;

  String nombreCliente;
  List<ItemProducto> items;
  String imagen;

  double get total => items.fold(0, (sum, item) => sum + item.subtotal);

  double sena;

  DateTime fechaEntrega;

  DateTime fechaEncargo;

  bool pagoRealizado;

  Pedido({
    this.id,
    required this.idCliente,
    required this.nombreCliente,
    required this.items,
    required this.imagen,
    required this.sena,
    required this.fechaEntrega,
    required this.fechaEncargo,
    required this.pagoRealizado,
  });

  double get diferencia => total - sena;
}
