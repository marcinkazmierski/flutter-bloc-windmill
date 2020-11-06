import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class WindmillModel extends Equatable {
  final String name;
  final String location;
  final double power;

  const WindmillModel(
      {@required this.name, @required this.location, @required this.power});

  @override
  List<Object> get props => [name, location, power];
}
