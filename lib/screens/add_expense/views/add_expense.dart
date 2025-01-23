// ignore_for_file: deprecated_member_use, library_private_types_in_public_api

import 'package:expense_repository/expense_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:personal_finance_tracker/screens/add_expense/blocs/create_category_bloc/create_category_bloc.dart';
import 'package:uuid/uuid.dart';

class AddExpense extends StatefulWidget {
  const AddExpense({super.key});

  @override
  State<AddExpense> createState() => _AddExpenseState();
}

class IconSelector extends StatefulWidget {
  final ValueChanged<IconData?> onChanged;
  final IconData? initialIcon;

  IconSelector({required this.onChanged, this.initialIcon});

  @override
  _IconSelectorState createState() => _IconSelectorState();
}

class _IconSelectorState extends State<IconSelector> {
  late IconData? _selectedIcon;

  @override
  void initState() {
    _selectedIcon = widget.initialIcon;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: _openIconPicker,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.transparent),
        ),
        padding: EdgeInsets.symmetric(vertical: 16, horizontal: 0),
        child: Row(
          children: [
            SizedBox(width: 10),
            if (_selectedIcon != null) ...[
              Icon(_selectedIcon, size: 30),
              SizedBox(width: 16),
            ] else ...[
              SizedBox(
                width: 215,
                height: 20,
                child: Text(
                  'Icon',
                  style: TextStyle(
                    color: Colors.grey[600], // Same color as hint text
                    fontSize: 16,
                  ),
                ),
              ),
            ],
            Icon(
              CupertinoIcons.chevron_down,
              size: 12,
            )
          ],
        ),
      ),
    );
  }

  void _openIconPicker() async {
    final IconData? icon = await showModalBottomSheet<IconData>(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => IconPickerBottomSheet(),
    );

    if (icon != null) {
      setState(() {
        _selectedIcon = icon;
      });
      widget.onChanged(icon);
    }
  }
}

class _AddExpenseState extends State<AddExpense> {
  TextEditingController expenseController = TextEditingController();
  TextEditingController categoryController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController iconController = TextEditingController();
  DateTime selectDate = DateTime.now();
  IconData? selectedIcon;

  @override
  void initState() {
    dateController.text = DateFormat('dd/MM/yyyy').format(DateTime.now());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.background,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                "Add Expenses",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.7,
                child: TextFormField(
                  controller: expenseController,
                  textAlignVertical: TextAlignVertical.center,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    prefixIcon: const Icon(
                      FontAwesomeIcons.dollarSign,
                      size: 16,
                      color: Colors.blueGrey,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: categoryController,
                readOnly: true,
                onTap: () {},
                textAlignVertical: TextAlignVertical.center,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  prefixIcon: const Icon(
                    FontAwesomeIcons.list,
                    size: 16,
                    color: Colors.blueGrey,
                  ),
                  suffixIcon: IconButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (ctx) {
                          TextEditingController categoryNameController =
                              TextEditingController();
                          TextEditingController categoryColorController =
                              TextEditingController();
                          Color categoryColor = Colors.white;
                          return StatefulBuilder(builder: (context, setState) {
                            return AlertDialog(
                              title: const Text('Create a Category'),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const SizedBox(height: 16),
                                  TextFormField(
                                    controller: categoryNameController,
                                    textAlignVertical: TextAlignVertical.center,
                                    decoration: InputDecoration(
                                      filled: true,
                                      fillColor: Colors.white,
                                      hintText: 'Name',
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: BorderSide.none,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  IconSelector(
                                    onChanged: (icon) {
                                      if (icon != null) {
                                        setState(() {
                                          selectedIcon = icon;
                                        });
                                        categoryController.text =
                                            ''; // Clear the text when an icon is selected
                                      }
                                    },
                                    initialIcon: selectedIcon,
                                  ),
                                  const SizedBox(height: 16),
                                  TextFormField(
                                    controller: categoryColorController,
                                    onTap: () {
                                      showDialog(
                                          context: context,
                                          builder: (ctx2) {
                                            return AlertDialog(
                                              content: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  ColorPicker(
                                                    pickerColor: categoryColor,
                                                    onColorChanged: (value) {
                                                      setState(() {
                                                        categoryColorController
                                                                .text =
                                                            value.toHexString();
                                                      });
                                                      setState(() {
                                                        categoryColor = value;
                                                      });
                                                    },
                                                  ),
                                                  SizedBox(
                                                    width: double.infinity,
                                                    height: 50,
                                                    child: TextButton(
                                                      onPressed: () {
                                                        Navigator.pop(ctx2);
                                                      },
                                                      style:
                                                          TextButton.styleFrom(
                                                        backgroundColor:
                                                            Colors.black,
                                                        shape:
                                                            RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(20),
                                                        ),
                                                      ),
                                                      child: Text(
                                                        'Save',
                                                        style: TextStyle(
                                                            fontSize: 22,
                                                            color:
                                                                Colors.white),
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            );
                                          });
                                    },
                                    textAlignVertical: TextAlignVertical.center,
                                    readOnly: true,
                                    decoration: InputDecoration(
                                      isDense: true,
                                      filled: true,
                                      fillColor: categoryColor,
                                      hintText: 'Color',
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: BorderSide.none,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 16,
                                  ),
                                  SizedBox(
                                    width: 250,
                                    height: 50,
                                    child: TextButton(
                                      onPressed: () {
                                        Category category = Category.empty;
                                        category.categoryId = Uuid().v1();
                                        category.name =
                                            categoryNameController.text;
                                        category.color =
                                            categoryColorController.text;
                                        category.icon = selectedIcon as String;
                                        context
                                            .read<CreateCategoryBloc>()
                                            .add(CreateCategory(category));
                                        Navigator.pop(context);
                                      },
                                      style: TextButton.styleFrom(
                                        backgroundColor: Colors.black,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                      ),
                                      child: Text(
                                        'Save',
                                        style: TextStyle(
                                            fontSize: 22, color: Colors.white),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          });
                        },
                      );
                    },
                    icon: const Icon(
                      FontAwesomeIcons.plus,
                      size: 16,
                      color: Colors.blueGrey,
                    ),
                  ),
                  hintText: 'Category',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: dateController,
                textAlignVertical: TextAlignVertical.center,
                readOnly: true,
                onTap: () async {
                  DateTime? newDate = await showDatePicker(
                    context: context,
                    initialDate: selectDate,
                    firstDate: DateTime.now().add(const Duration(days: -3650)),
                    lastDate: DateTime.now().add(const Duration(days: 3650)),
                  );
                  setState(() {
                    dateController.text =
                        DateFormat('dd/MM/yyyy').format(newDate!);
                    selectDate = newDate;
                  });
                },
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  prefixIcon: const Icon(
                    FontAwesomeIcons.calendar,
                    size: 16,
                    color: Colors.blueGrey,
                  ),
                  hintText: 'Date',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: kToolbarHeight,
                child: TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: Text(
                    'Save',
                    style: TextStyle(fontSize: 22, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class IconPickerBottomSheet extends StatefulWidget {
  @override
  _IconPickerBottomSheetState createState() => _IconPickerBottomSheetState();
}

class _IconPickerBottomSheetState extends State<IconPickerBottomSheet> {
  final List<IconData> icons = [
    FontAwesomeIcons.home,
    FontAwesomeIcons.car,
    FontAwesomeIcons.gasPump,
    FontAwesomeIcons.utensils,
    FontAwesomeIcons.book,
    FontAwesomeIcons.appleAlt,
    FontAwesomeIcons.burger,
    FontAwesomeIcons.calculator,
    FontAwesomeIcons.calendar,
    FontAwesomeIcons.earthAfrica,
    FontAwesomeIcons.baby,
    FontAwesomeIcons.gear,
    FontAwesomeIcons.hammer,
    FontAwesomeIcons.iceCream,
    FontAwesomeIcons.music,
    FontAwesomeIcons.guitar,
    FontAwesomeIcons.futbol,
    FontAwesomeIcons.paintRoller,
    FontAwesomeIcons.palette,
    FontAwesomeIcons.radio,
    FontAwesomeIcons.rainbow,
    FontAwesomeIcons.satelliteDish,
    FontAwesomeIcons.umbrella,
    FontAwesomeIcons.pencil,
    FontAwesomeIcons.scissors,
    FontAwesomeIcons.paintbrush,
    FontAwesomeIcons.camera,
    FontAwesomeIcons.palette,
    FontAwesomeIcons.splotch,
    FontAwesomeIcons.sprayCan,
    FontAwesomeIcons.balanceScale,
    FontAwesomeIcons.wifi,
    FontAwesomeIcons.truck,
    FontAwesomeIcons.shop,
    FontAwesomeIcons.shirt,
    FontAwesomeIcons.person,
    FontAwesomeIcons.laptop,
    FontAwesomeIcons.droplet,
    FontAwesomeIcons.trainSubway,
    FontAwesomeIcons.toilet,
    FontAwesomeIcons.suitcaseMedical,
    FontAwesomeIcons.tree,
    FontAwesomeIcons.mosque,
    FontAwesomeIcons.mobileScreen,
    FontAwesomeIcons.bottleWater,
    FontAwesomeIcons.mugSaucer,
    FontAwesomeIcons.shield,
    FontAwesomeIcons.motorcycle
    // Add more icons or fetch dynamically
  ];

  late List<IconData> filteredIcons;
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    filteredIcons = icons;
    searchController.addListener(_filterIcons);
  }

  @override
  void dispose() {
    searchController.removeListener(_filterIcons);
    searchController.dispose();
    super.dispose();
  }

  void _filterIcons() {
    final query = searchController.text.toLowerCase();
    setState(() {
      filteredIcons = icons
          .where((icon) => icon.toString().toLowerCase().contains(query))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: filteredIcons.length,
              itemBuilder: (context, index) {
                final icon = filteredIcons[index];
                return GestureDetector(
                  onTap: () => Navigator.of(context).pop(icon),
                  child: Icon(icon, size: 30),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
