import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:hive_ce/hive_ce.dart';
import 'package:practico_2/src/hive/hive_registrar.g.dart';
import 'package:practico_2/src/models/cliente.dart';
import 'package:practico_2/src/models/itemproducto.dart';
import 'package:practico_2/src/models/pedido.dart';
import 'package:practico_2/src/services/hive_service.dart';

Pedido crearPedido({String? id, String idCliente = 'c1'}) => Pedido(
  id: id,
  idCliente: idCliente,
  nombreCliente: 'Ana',
  items: [
    ItemProducto(
      idProducto: 'p1',
      nombreProducto: 'Torta',
      precioUnitario: 100,
      cantidad: 2,
    ),
    ItemProducto(
      idProducto: 'p2',
      nombreProducto: 'Tarta',
      precioUnitario: 50.5,
    ),
  ],
  imagen: '',
  sena: 50,
  fechaEntrega: DateTime(2030, 1, 15),
  fechaEncargo: DateTime(2030, 1, 1),
  pagoRealizado: false,
);

Future<void> abrirCajas() async {
  await Hive.openBox<Cliente>('clientes');
  await Hive.openBox<Pedido>('pedidos');
}

void main() {
  late Directory carpeta;

  setUpAll(() => Hive.registerAdapters());

  setUp(() async {
    carpeta = await Directory.systemTemp.createTemp('pedidos_test');
    Hive.init(carpeta.path);
    await abrirCajas();
  });

  tearDown(() async {
    await Hive.close();
    await carpeta.delete(recursive: true);
  });

  test('el pedido y sus items sobreviven a cerrar y reabrir las cajas', () async {
    final pedido = crearPedido();
    await HiveService.guardarPedido(pedido);
    final id = pedido.id;

    // Al cerrar se descarta la memoria: lo que se lee ahora viene del disco
    await Hive.close();
    await abrirCajas();

    final leido = HiveService.pedidos.get(id)!;
    expect(leido.nombreCliente, 'Ana');
    expect(leido.items.length, 2);
    expect(leido.items.first.nombreProducto, 'Torta');
    expect(leido.items.first.cantidad, 2);
    expect(leido.items.last.precioUnitario, 50.5);
    expect(leido.total, 250.5);
    expect(leido.diferencia, 200.5);
    expect(leido.fechaEntrega, DateTime(2030, 1, 15));
  });

  test('guardar con el mismo id actualiza sin duplicar', () async {
    final pedido = crearPedido();
    await HiveService.guardarPedido(pedido);

    final editado = crearPedido(id: pedido.id)..items.removeLast();
    await HiveService.guardarPedido(editado);

    expect(HiveService.obtenerPedidos().length, 1);
    expect(HiveService.pedidos.get(pedido.id)!.total, 200);
  });

  test('borrarPedido lo elimina', () async {
    final pedido = crearPedido();
    await HiveService.guardarPedido(pedido);

    await HiveService.borrarPedido(pedido.id!);

    expect(HiveService.obtenerPedidos(), isEmpty);
  });

  test('guardarCliente actualiza el nombre solo en sus pedidos', () async {
    final delCliente = crearPedido(idCliente: 'c1');
    final deOtro = crearPedido(idCliente: 'c2');
    await HiveService.guardarPedido(delCliente);
    await HiveService.guardarPedido(deOtro);

    await HiveService.guardarCliente(
      Cliente(id: 'c1', nombre: 'Ana María', telefono: '111'),
    );

    await Hive.close();
    await abrirCajas();

    expect(HiveService.pedidos.get(delCliente.id)!.nombreCliente, 'Ana María');
    expect(HiveService.pedidos.get(deOtro.id)!.nombreCliente, 'Ana');
  });
}
