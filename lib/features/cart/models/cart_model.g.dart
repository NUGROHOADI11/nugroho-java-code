// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cart_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CartItemModelAdapter extends TypeAdapter<CartItemModel> {
  @override
  final int typeId = 1;

  @override
  CartItemModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CartItemModel(
      menuId: fields[0] as int,
      harga: fields[2] as int,
      jumlah: fields[3] as int,
      productName: fields[1] as String,
      notes: fields[4] as String?,
      level: fields[5] as int?,
      topping: (fields[6] as List?)?.cast<int>(),
      imageUrl: fields[7] as String?,
      hargaLevel: fields[9] as int?,
      hargaTopping: fields[10] as int?,
      addedAt: fields[8] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, CartItemModel obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.menuId)
      ..writeByte(1)
      ..write(obj.productName)
      ..writeByte(2)
      ..write(obj.harga)
      ..writeByte(3)
      ..write(obj.jumlah)
      ..writeByte(4)
      ..write(obj.notes)
      ..writeByte(5)
      ..write(obj.level)
      ..writeByte(6)
      ..write(obj.topping)
      ..writeByte(7)
      ..write(obj.imageUrl)
      ..writeByte(8)
      ..write(obj.addedAt)
      ..writeByte(9)
      ..write(obj.hargaLevel)
      ..writeByte(10)
      ..write(obj.hargaTopping);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CartItemModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class OrderModelAdapter extends TypeAdapter<OrderModel> {
  @override
  final int typeId = 2;

  @override
  OrderModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return OrderModel(
      idUser: fields[0] as int,
      potongan: fields[2] as int,
      totalBayar: fields[3] as int,
      menu: (fields[4] as List).cast<CartItemModel>(),
      idVoucher: fields[1] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, OrderModel obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.idUser)
      ..writeByte(1)
      ..write(obj.idVoucher)
      ..writeByte(2)
      ..write(obj.potongan)
      ..writeByte(3)
      ..write(obj.totalBayar)
      ..writeByte(4)
      ..write(obj.menu);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OrderModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
