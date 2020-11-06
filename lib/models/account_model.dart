import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'windmill_model.dart';

class AccountModel extends Equatable {
  final String name;
  final List<WindmillModel> windmills;
  final double cash = 0.0;

  AccountModel({@required this.name, @required this.windmills});

  @override
  List<Object> get props => [name, windmills, cash];
}
