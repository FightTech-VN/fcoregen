// Copyright 2021 QSoft, Ltd. All rights reserved.

part of 'home_bloc.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object?> get props => [];
}

class HomeInitialEvent extends HomeEvent {
  final bool? forceRemote;

  HomeInitialEvent({this.forceRemote});
}
