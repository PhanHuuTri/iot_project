import 'package:flutter/material.dart';
import 'package:web_iot/main.dart';

List<Color> gradientColors = [
  const Color(0xff23b6e6),
  const Color(0xff02d39a),
];

final List<double> peopleHighHeat = [
  2261,
  5680,
  3058,
  7851,
  1354,
  6571,
  5412,
  1544,
  4285,
];
final List<String> lineChartUnits = [
  '0',
  '1k',
  '2k',
  '3k',
  '4k',
  '5k',
  '6k',
  '7k',
  '8k',
  '9k',
  '10k',
];
final List<String> lineChartTime = [
  '18/8',
  '19/8',
  '20/8',
  '21/8',
  '22/8',
  '23/8',
  '24/8',
  '25/8',
  '26/8',
  '27/8',
];

//DataTable
// loai \vi tri\ noi dung\ thoi gian\ trang thai

class PersonModel {
  final String? id;
  final String? name;
  final String? gender;
  final double? age;
  final String? department;
  final String? position;
  final String? dateOfBirth;
  PersonModel({
    this.id,
    this.name,
    this.age,
    this.gender,
    this.department,
    this.position,
    this.dateOfBirth,
  });
}

final List<PersonModel> userTableRows = [
  PersonModel(
    id: '1',
    name: 'Jhon',
    age: 29,
    gender: 'Male',
    department: 'Dev',
    position: 'Employee',
    dateOfBirth: '20/05/1992',
  ),
  PersonModel(
    id: '2',
    name: 'Sammy',
    age: 27,
    gender: 'Female',
    department: 'QC',
    position: 'Team leader',
    dateOfBirth: '21/04/1994',
  ),
  PersonModel(
    id: '3',
    name: 'Canne',
    age: 25,
    gender: 'Female',
    department: 'QC',
    position: 'Employee',
    dateOfBirth: '20/05/1996',
  ),
  PersonModel(
    id: '4',
    name: 'Kevin',
    age: 39,
    gender: 'Male',
    department: 'Director',
    position: 'Director',
    dateOfBirth: '20/05/1982',
  ),
  PersonModel(
    id: '5',
    name: 'Kay',
    age: 35,
    gender: 'Male',
    department: 'Dev',
    position: 'Manager',
    dateOfBirth: '20/05/1986',
  ),
  PersonModel(
    id: '6',
    name: 'Susan',
    age: 33,
    gender: 'Female',
    department: 'Dev',
    position: 'Employee',
    dateOfBirth: '20/05/1988',
  ),
  PersonModel(
    id: '7',
    name: 'Lily',
    age: 37,
    gender: 'Female',
    department: 'QC',
    position: 'Manager',
    dateOfBirth: '20/05/1984',
  ),
  PersonModel(
    id: '8',
    name: 'Khan',
    age: 29,
    gender: 'Male',
    department: 'Dev',
    position: 'Employee',
    dateOfBirth: '20/05/1992',
  ),
  PersonModel(
    id: '9',
    name: 'Kim',
    age: 23,
    gender: 'Female',
    department: 'Dev',
    position: 'Trainee',
    dateOfBirth: '20/05/1998',
  ),
  PersonModel(
    id: '10',
    name: 'Blue',
    age: 24,
    gender: 'Male',
    department: 'Dev',
    position: 'Employee',
    dateOfBirth: '04/03/1997',
  ),
];

class WarningModel {
  final String? id;
  final String? name;
  final String? warning;
  final String? location;
  final String? warningTime;
  final String? status;
  WarningModel({
    this.id,
    this.name,
    this.warning,
    this.location,
    this.warningTime,
    this.status,
  });
}

final List<WarningModel> warningTableRows = [
  WarningModel(
    id: 'FA01',
    name: 'Fire alarm',
    warning: 'Fire at C2',
    location: 'C2 building, room 204',
    warningTime: '20/05/2021 \n5:45:05',
    status: 'Done',
  ),
  WarningModel(
    id: 'SE01',
    name: 'System error',
    warning: 'Camera not working',
    location: 'A1 building, park G9',
    warningTime: '26/08/2021 \n8:45:25',
    status: 'In process',
  ),
  WarningModel(
    id: 'SE02',
    name: 'System error',
    warning: 'Automatic number-plate recognition not working',
    location: 'C1 building park',
    warningTime: '27/08/2021 \n11:23:24',
    status: 'New',
  ),
  WarningModel(
    id: 'R01',
    name: 'Room not open',
    warning: 'Room is lock',
    location: 'C3 building Room 205',
    warningTime: '27/08/2021 \n20:45:15',
    status: 'To do',
  ),
  WarningModel(
    id: 'F01',
    name: 'Face check',
    warning: 'Face Recognition not working',
    location: 'A2 building G1',
    warningTime: '20/07/2021 \n15:45:07',
    status: 'Done',
  ),
];

//Chart

class ChartItemData {
  final String title;
  final double value;
  final Color? color;
  final double? total;
  final String? note;
  ChartItemData({
    required this.title,
    required this.value,
    this.color,
    this.total,
    this.note,
  });
}

final faceChart = [
  ChartItemData(
    color: const Color(0xff0293ee),
    value: 578,
    title: 'Success',
    total: 1000,
  ),
  ChartItemData(
    color: const Color(0xFFD2585B),
    value: 422,
    title: 'Fail',
    total: 1000,
  ),
];
final parkingChartcarandmoto=[
  ChartItemData(
    color: const Color(0xFF50AF9D),
    value: 500,
    title: ScreenUtil.t(I18nKey.availableslots)!,
    total: 511,
  ),
  ChartItemData(
    color: const Color(0xFFD2585B),
    value: 11,
    title: ScreenUtil.t(I18nKey.totalnumber)!,
    total: 511,
  ),
];
final parkingChartcar= [
  ChartItemData(
    color: const Color(0xFF50AF9D),
    value: 100,
    title: ScreenUtil.t(I18nKey.availableslots)!,
    total: 111,
  ),
  ChartItemData(
    color: const Color(0xFFD2585B),
    value: 11,
    title: ScreenUtil.t(I18nKey.totalnumber)!,
    total: 111,
  ),
];
final parkingChartmoto= [
  ChartItemData(
    color: const Color(0xFF50AF9D),
    value: 340,
    title: ScreenUtil.t(I18nKey.availableslots)!,
    total: 400,
  ),
  ChartItemData(
    color: const Color(0xFFD2585B),
    value: 60,
    title: ScreenUtil.t(I18nKey.totalnumber)!,
    total: 400,
  ),
];

final occupancyChart = [
  ChartItemData(
    color: const Color(0xFF637681),
    value: 59,
    title: 'Used',
    total: 80,
  ),
  ChartItemData(
    color: const Color(0xffEFC132),
    value: 21,
    title: 'Free',
    total: 80,
  ),
];

final meetingChart = [
  ChartItemData(
    color: const Color(0xff0293ee),
    value: 264,
    title: 'Online',
    total: 500,
  ),
  ChartItemData(
    color: const Color(0xFF637681),
    value: 175,
    title: 'Offline',
    total: 500,
  ),
  ChartItemData(
    color: const Color(0xfff8b250),
    value: 61,
    title: 'Lock',
    total: 500,
  ),
];

final healthyChart = [
  ChartItemData(value: 0, title: 'Vertical Unit', note: 'Num of people'),
  ChartItemData(value: 0, title: 'Horizontal Unit', note: 'Days'),
];
