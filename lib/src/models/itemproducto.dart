class ItemProducto {
  String idProducto;
  String nombreProducto;
  double precioUnitario;
  int cantidad;

  ItemProducto({
    required this.idProducto,
    required this.nombreProducto,
    required this.precioUnitario,
    this.cantidad = 1,
  });

  double get subtotal => precioUnitario * cantidad;
}
