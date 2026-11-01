// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hive_adapters.dart';

// **************************************************************************
// AdaptersGenerator
// **************************************************************************

class ClienteAdapter extends TypeAdapter<Cliente> {
  @override
  final typeId = 0;

  @override
  Cliente read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Cliente(
      id: fields[0] as String?,
      nombre: fields[1] as String,
      telefono: fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Cliente obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.nombre)
      ..writeByte(2)
      ..write(obj.telefono);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ClienteAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ProductoAdapter extends TypeAdapter<Producto> {
  @override
  final typeId = 1;

  @override
  Producto read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Producto(
      id: fields[0] as String?,
      nombre: fields[1] as String,
      precio: (fields[2] as num).toDouble(),
      imagen: fields[3] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Producto obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.nombre)
      ..writeByte(2)
      ..write(obj.precio)
      ..writeByte(3)
      ..write(obj.imagen);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProductoAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ItemProductoAdapter extends TypeAdapter<ItemProducto> {
  @override
  final typeId = 2;

  @override
  ItemProducto read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ItemProducto(
      idProducto: fields[0] as String,
      nombreProducto: fields[1] as String,
      precioUnitario: (fields[2] as num).toDouble(),
      cantidad: fields[3] == null ? 1 : (fields[3] as num).toInt(),
    );
  }

  @override
  void write(BinaryWriter writer, ItemProducto obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.idProducto)
      ..writeByte(1)
      ..write(obj.nombreProducto)
      ..writeByte(2)
      ..write(obj.precioUnitario)
      ..writeByte(3)
      ..write(obj.cantidad);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ItemProductoAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class PedidoAdapter extends TypeAdapter<Pedido> {
  @override
  final typeId = 3;

  @override
  Pedido read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Pedido(
      id: fields[0] as String?,
      idCliente: fields[1] as String,
      nombreCliente: fields[2] as String,
      items: (fields[3] as List).cast<ItemProducto>(),
      imagen: fields[4] as String,
      sena: (fields[5] as num).toDouble(),
      fechaEntrega: fields[6] as DateTime,
      fechaEncargo: fields[7] as DateTime,
      pagoRealizado: fields[8] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, Pedido obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.idCliente)
      ..writeByte(2)
      ..write(obj.nombreCliente)
      ..writeByte(3)
      ..write(obj.items)
      ..writeByte(4)
      ..write(obj.imagen)
      ..writeByte(5)
      ..write(obj.sena)
      ..writeByte(6)
      ..write(obj.fechaEntrega)
      ..writeByte(7)
      ..write(obj.fechaEncargo)
      ..writeByte(8)
      ..write(obj.pagoRealizado);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PedidoAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
