// ignore_for_file: use_build_context_synchronously, must_be_immutable

import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:fluttercontactpicker/fluttercontactpicker.dart';
import 'package:intl/intl.dart';
import 'package:wanderlust_new/database/database_helper.dart';
import 'package:wanderlust_new/screens/parent_screen.dart';

import '../models/companion_model.dart';
import '../models/expense_model.dart';
import '../models/trip_model.dart';
import '../models/user_model.dart';
import '../utils/functions/image_picker_function.dart';
import '../utils/messages/flush_bar.dart';
import '../utils/messages/popup.dart';
import '../utils/styles/style.dart';
import '../widgets/custom_textfield.dart';

//global icon list
List<IconData> icons = [
  Icons.train,
  Icons.flight,
  Icons.directions_car_outlined,
  Icons.pedal_bike,
  Icons.directions_boat,
  Icons.directions_bus
];

// global trip cover photo
List<String> imageList = [
  'assets/image_one.jpg',
  'assets/image_two.jpg',
  'assets/image_three.jpg',
  'assets/image_four.jpg'
];

//global choice List
List<String> choice = ['Train', 'Flight', 'Car', 'Bike', 'Ship', 'Other'];
List<String> purpose = ['Business', 'Entertainment', 'Family', 'Other'];

class MyAddTrip extends StatefulWidget {
  MyAddTrip(
      {super.key, required this.loggedUser, this.isEdit = false, this.trip});
  UserModelClass loggedUser;
  bool isEdit;
  Trips? trip;
  @override
  State<MyAddTrip> createState() => _MyAddTripState();
}

class _MyAddTripState extends State<MyAddTrip> {
  final TextEditingController destinationController = TextEditingController();

  final TextEditingController startDateController = TextEditingController();

  final TextEditingController endDateController = TextEditingController();

  final TextEditingController budgetController = TextEditingController();

  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  final db = DatabaseHelper.instance;

  DateTime startingDate = DateTime.now();
  DateTime endingDate = DateTime.now().add(const Duration(days: 1));

  File? fileImage;

  String? assetImage;
  int selectedChoice = 0;
  int? assetImgIdx;
  bool error = false;

  String purposeValue = purpose[0];

  List<PhoneContact> tempCompanions = [];

  late Expenses tempExp;

  @override
  void initState() {
    super.initState();
    if (widget.isEdit) {
      setDataOnEdit();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context),
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Form(
        key: _formkey,
        child: ListView(
          padding: const EdgeInsets.all(15),
          physics: const BouncingScrollPhysics(),
          children: [
            const SizedBox(height: 10),
            coverPhoto(context),
            const SizedBox(height: 20),
            CustomTextField(
              validator: (value) =>
                  value == null || destinationController.text.trim().isEmpty
                      ? 'Choose your Destination'
                      : null,
              label: 'Your Destination',
              controller: destinationController,
            ),
            const SizedBox(height: 20),
            CustomTextField(
              controller: startDateController,
              isreadOnly: true,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Select Starting Date';
                } else if (!db.isStartDateAvailable) {
                  return 'You have already scheduled a trip on this day.';
                } else if (!db.isTripAvailable) {
                  return '';
                }
                return null;
              },
              onTap: () => _showCalender(startingDate, startDateController),
              label: 'Choose starting date',
              prefix: true,
              icon: Icons.calendar_today_outlined,
            ),
            const SizedBox(height: 20),
            CustomTextField(
              controller: endDateController,
              isreadOnly: true,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Select Ending Date';
                } else if (!isDateValid()) {
                  return 'End Date should be after the Starting Date';
                } else if (!db.isEndDateAvailable) {
                  return 'You have already scheduled a trip on this day.';
                } else if (!db.isTripAvailable) {
                  return 'There is already a trip on this date range';
                }
                return null;
              },
              onTap: () {
                _showCalender(endingDate, endDateController);
              },
              label: 'Choose Ending date',
              prefix: true,
              icon: Icons.calendar_today_outlined,
            ),
            const SizedBox(height: 20),
            Text(
              'Choose your transport',
              style: TextStyle(color: error == true ? Colors.red : Colors.grey),
            ),
            const SizedBox(height: 10),
            choiceChipBuilder(),
            Divider(
              thickness: 1,
              color: error == true ? Colors.red : Colors.grey.shade500,
            ),
            const SizedBox(height: 10),
            CustomTextField(
                controller: budgetController,
                validator: (value) {
                  if (value == null || budgetController.text.trim().isEmpty) {
                    return 'Please Enter your Budget';
                  } else if (value.contains(RegExp(r'[a-z]'))) {
                    return 'only Numbers allowed';
                  }
                  return null;
                },
                label: 'Enter Your Budget',
                inputType: TextInputType.number),
            const SizedBox(height: 20),
            dropDownButton(),
            const SizedBox(height: 20),
            companionButton(context),
            const SizedBox(height: 20),
            doneButton(),
            const SizedBox(
              height: 100,
            ),
          ],
        ),
      ),
    );
  }

  AppBar appBar(BuildContext context) {
    return AppBar(
      centerTitle: true,
      title: widget.isEdit == false
          ? Text('New Trip',
              style: subTextStyle(
                  size: 25, weight: FontWeight.w500, color: secondaryColor))
          : Text('Edit Trip',
              style: subTextStyle(
                  size: 25, weight: FontWeight.w500, color: secondaryColor)),
      backgroundColor: Theme.of(context).colorScheme.background,
      elevation: 0,
      leading: widget.isEdit
          ? IconButton(
              icon: const Icon(Icons.arrow_back_rounded,
                  color: mainColor, size: 26),
              onPressed: () {
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                        builder: (context) =>
                            ScreenMain(loggedUser: widget.loggedUser)),
                    (route) => false);
              })
          : null,
    );
  }

  ElevatedButton doneButton() {
    return ElevatedButton(
      style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(Colors.grey.shade700),
          fixedSize:
              MaterialStateProperty.all(const Size(double.maxFinite, 55))),
      onPressed: () async {
        if (await onAddButtonClicked()) {
          customToast(
              bgcolor: Colors.green,
              msg: widget.isEdit
                  ? 'Trip Updated Successfully'
                  : 'Trip Added Successfully');
        }
      },
      child: widget.isEdit == true
          ? Text('Done',
              style: subTextStyle(
                  color: Colors.white, size: 16, weight: FontWeight.w500))
          : Text('Finish',
              style: subTextStyle(
                size: 16,
                color: Colors.white,
                weight: FontWeight.w500,
              )),
    );
  }

  Row companionButton(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: ElevatedButton(
            onPressed: () {
              showCompanions(context);
            },
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.black87),
                fixedSize:
                    MaterialStateProperty.all(const Size.fromHeight(54))),
            child: Text(
              'Show companions',
              style: TextStyle(color: Colors.grey.shade300),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: OutlinedButton(
            onPressed: () => selectCompanion(),
            style: ButtonStyle(
              fixedSize: MaterialStateProperty.all(const Size(100, 54)),
              padding: MaterialStateProperty.all(EdgeInsets.zero),
            ),
            child: const Text(
              'Add Companions',
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 11),
            ),
          ),
        )
      ],
    );
  }

  Container dropDownButton() {
    return Container(
      padding: const EdgeInsets.only(left: 10),
      height: 54,
      width: double.maxFinite,
      decoration: BoxDecoration(
          border: Border.all(width: 1, color: secondaryColor),
          borderRadius: BorderRadius.circular(4)),
      child: DropdownButton(
        icon: const Padding(
            padding: EdgeInsets.only(right: 10),
            child: Icon(Icons.keyboard_arrow_down_rounded, size: 28)),
        iconEnabledColor: secondaryColor,
        isExpanded: true,
        underline: Container(),
        value: purposeValue,
        onChanged: (String? newValue) {
          setState(() {
            purposeValue = newValue!;
          });
        },
        items: <String>['Business', 'Entertainment', 'Family', 'Other']
            .map((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(
              value,
              style: const TextStyle(color: secondaryColor),
            ),
          );
        }).toList(),
      ),
    );
  }

  SizedBox choiceChipBuilder() {
    return SizedBox(
      height: 150,
      child: GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        itemCount: choice.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3, childAspectRatio: 1 / .6),
        itemBuilder: (context, index) {
          return ChoiceChip(
            selectedColor: const Color(0xFF3C654D),
            showCheckmark: false,
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(4))),
            label: SizedBox(
                height: 45,
                width: 80,
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Icon(
                        icons[index],
                        color: selectedChoice == index
                            ? Colors.white
                            : Theme.of(context).colorScheme.primary,
                      ),
                      Text(
                        choice[index],
                        style: TextStyle(
                          color: selectedChoice == index
                              ? Colors.white
                              : Theme.of(context).colorScheme.primary,
                        ),
                      )
                    ])),
            selected: selectedChoice == index,
            onSelected: (isSelected) =>
                setState(() => selectedChoice = isSelected ? index : -1),
          );
        },
      ),
    );
  }

  InkWell coverPhoto(BuildContext context) {
    return InkWell(
      onTap: () => showImageOption(),
      child: DottedBorder(
        borderType: BorderType.RRect,
        color: Theme.of(context).colorScheme.onBackground,
        strokeWidth: 1,
        dashPattern: assetImage == null
            ? fileImage == null
                ? const [38, 10]
                : const [0, 1]
            : const [0, 1],
        child: SizedBox(
          height: 200,
          width: double.maxFinite,
          child: assetImage == null
              ? fileImage == null
                  ? const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.upload_file_outlined, size: 30),
                        SizedBox(height: 20),
                        Text('Choose a CoverPhoto'),
                        Text('or'),
                        Text('Select Your own'),
                      ],
                    )
                  : ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: Image(
                        image: FileImage(File(fileImage!.path)),
                        fit: BoxFit.cover,
                      ),
                    )
              : ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child:
                      Image(image: AssetImage(assetImage!), fit: BoxFit.cover),
                ),
        ),
      ),
    );
  }

  showCompanions(BuildContext ctx) {
    showModalBottomSheet(
      backgroundColor: Theme.of(context).colorScheme.onPrimary,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter refresh) {
            return SizedBox(
              height: 300,
              child: Column(
                children: [
                  SizedBox(
                    height: 45,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Text('Your Companions',
                          style: TextStyle(
                            fontSize: 20,
                            color: Theme.of(context).colorScheme.onBackground,
                            fontWeight: FontWeight.bold,
                          )),
                    ),
                  ),
                  Expanded(
                    child: tempCompanions.isEmpty
                        ? const Center(
                            child: Text(
                              'No companions added',
                              style: TextStyle(fontSize: 15),
                            ),
                          )
                        : ListView.builder(
                            physics: const BouncingScrollPhysics(),
                            itemCount: tempCompanions.length,
                            itemBuilder: (context, index) {
                              final contact = tempCompanions[index];
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 1),
                                child: ListTile(
                                  leading: CircleAvatar(
                                    backgroundColor:
                                        Theme.of(context).colorScheme.surface,
                                    child: Text(
                                      contact.fullName![0],
                                      style: TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onSurface),
                                    ),
                                  ),
                                  title: Text(contact.fullName!),
                                  subtitle: Text(
                                      contact.phoneNumber!.number.toString()),
                                  trailing: IconButton(
                                    onPressed: () {
                                      popUpMessenger(
                                        context,
                                        title: 'Remove Companion',
                                        optionOne: 'Remove',
                                        optionTwo: 'cancel',
                                        onProceed: () {
                                          refresh(
                                            () =>
                                                tempCompanions.removeAt(index),
                                          );

                                          Navigator.of(context).pop();
                                        },
                                        onCancel: () => Navigator.of(ctx).pop(),
                                      );
                                      //
                                    },
                                    icon: const Icon(
                                      Icons.close,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                  )
                ],
              ),
            );
          },
        );
      },
    );
  }

//Add button function//
  Future<bool> onAddButtonClicked() async {
    // checking if the start date is available //

    await db.isDateAvailable(
        dateToCheck: startDateController.text,
        isStart: true,
        editTripId: widget.trip?.id,
        userId: widget.loggedUser.id!);

    await db.isDateAvailable(
        dateToCheck: endDateController.text,
        isStart: false,
        editTripId: widget.trip?.id,
        userId: widget.loggedUser.id!);

    await db.tripAvailable(startDateController.text, endDateController.text,
        widget.loggedUser.id!, widget.trip?.id);

    if (fileImage == null && assetImage == null) {
      customToast(msg: 'Select a cover photo', bgcolor: Colors.red);
      return false;
    }
    if (selectedChoice == -1) {
      customToast(bgcolor: Colors.red, msg: 'Please select your transport');
      setState(() {
        error = true;
      });
      return false;
    }
    setState(() {
      error = false;
    });

    
    if (_formkey.currentState!.validate()) {
      int? budget = int.tryParse(budgetController.text);
      final trip = Trips(
        userId: widget.loggedUser.id!,
        destination: destinationController.text,
        startingDate: startDateController.text,
        endingDate: endDateController.text,
        transport: selectedChoice,
        purpose: purposeValue,
        budget: budget ?? 0,
        fileImage: fileImage?.path,
        assetImgIdx: assetImgIdx,
        companions: tempCompanions,
      );
      if (!widget.isEdit) {
        db.addTrip(trip);
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
              builder: (context) => ScreenMain(loggedUser: widget.loggedUser)),
          (route) => false,
        );
        return true;
      } else {
        trip.id = widget.trip!.id;
        db.updateTrip(trip);
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
              builder: (context) => ScreenMain(loggedUser: widget.loggedUser)),
          (route) => false,
        );
        return true;
      }
    }
    return false;
  }

//Date validation
  bool isDateValid() {
    DateTime startDate = DateTime.parse(startDateController.text);
    DateTime endDate = DateTime.parse(endDateController.text);
    if (endDate.isAfter(startDate)) {
      return true;
    } else if (endDate.isBefore(startDate)) {
      return false;
    } else {
      return true;
    }
  }

//Contact book function//
  selectCompanion() async {
    try {
      if (tempCompanions.length >= 6) {
        customToast(bgcolor: Colors.red, msg: 'Only 6 companions can be added');
        return;
      }

      PhoneContact? contact = await FlutterContactPicker.pickPhoneContact();
      if (contact.fullName == null || contact.phoneNumber == null) {
        return;
      }
      setState(() {
        tempCompanions.add(contact);
      });

      customToast(
          bgcolor: Colors.grey,
          msg: '${tempCompanions.length} Companion added');
    } catch (e) {
      return;
    }
  }

//to retreive the companions in the trip in edit//
  Future<List<Companions>> getStoredCompanions() async {
    final compList = await db.getAllCompanions(widget.trip!.id!);
    return compList;
  }

// add Image bottomsheet //
  showImageOption() {
    return showModalBottomSheet(
      backgroundColor: Theme.of(context).colorScheme.background,
      context: context,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
          height: 350,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                alignment: Alignment.center,
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(30),
                    child: Container(
                      height: 5,
                      width: 40,
                      color: Colors.grey,
                    )),
              ),
              const SizedBox(height: 30),
              const Text('Choose a CoverPhoto',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
              GridView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.only(top: 15),
                  shrinkWrap: true,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    crossAxisSpacing: 5,
                  ),
                  itemBuilder: (context, index) {
                    final imagepath = imageList[index];

                    return InkWell(
                      onTap: () {
                        addAssetImage(index);
                        assetImgIdx = index;
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage(imagepath),
                                fit: BoxFit.cover),
                            borderRadius: BorderRadius.circular(5)),
                      ),
                    );
                  },
                  itemCount: imageList.length),
              const SizedBox(height: 10),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 10),
                alignment: Alignment.center,
                child: const Row(
                  children: [
                    Expanded(child: Divider(thickness: 1)),
                    Text(
                      'OR',
                      style: TextStyle(fontSize: 14, color: Colors.blue),
                    ),
                    Expanded(child: Divider(thickness: 1)),
                  ],
                ),
              ),
              const Text(
                'Choose From',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              Expanded(
                  child: Row(
                children: [
                  Expanded(
                      child: OutlinedButton.icon(
                    style: ButtonStyle(
                        shape: MaterialStateProperty.all(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8))),
                        side: MaterialStateProperty.all(BorderSide(
                            width: 3,
                            color: Theme.of(context).colorScheme.onBackground)),
                        fixedSize: MaterialStateProperty.all(
                            const Size.fromHeight(60))),
                    onPressed: () {
                      addTripImage(isCamara: true);
                      Navigator.of(context).pop();
                    },
                    icon: Icon(
                      Icons.camera_alt_rounded,
                      color: Theme.of(context).colorScheme.onBackground,
                    ),
                    label: Text(
                      'Camara',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onBackground,
                      ),
                    ),
                  )),
                  const SizedBox(width: 8),
                  Expanded(
                      child: OutlinedButton.icon(
                    style: ButtonStyle(
                        shape: MaterialStateProperty.all(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8))),
                        side: MaterialStateProperty.all(BorderSide(
                            width: 3,
                            color: Theme.of(context).colorScheme.primary)),
                        fixedSize: MaterialStateProperty.all(
                            const Size.fromHeight(60))),
                    onPressed: () {
                      addTripImage(isCamara: false);
                      Navigator.of(context).pop();
                    },
                    icon: Icon(
                      Icons.image,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    label: Text('Galary',
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.primary)),
                  )),
                ],
              )),
              const SizedBox(height: 20)
            ],
          ),
        );
      },
    );
  }

// add trip image //

  addTripImage({required bool isCamara}) async {
    File? image;
    image = await addImage(camera: isCamara, context: context);
    setState(() {
      fileImage = image;
      assetImage = null;
      assetImgIdx = null;
    });
  }

  // adding asset image //
  addAssetImage(int selectedImage) {
    setState(() {
      assetImage = imageList[selectedImage];
      fileImage = null;
    });
    Navigator.of(context).pop();
  }

  _showCalender(DateTime pickeDate, TextEditingController controller) {
    showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime.now(),
            lastDate: DateTime(2050))
        .then((value) {
      setState(() {
        if (value == null) {
          return;
        }
        controller.text = DateFormat('yyyy-MM-dd').format(value);
      });
    });
  }

  setDataOnEdit() {
    destinationController.text = widget.trip!.destination;
    startDateController.text = widget.trip!.startingDate;
    endDateController.text = widget.trip!.endingDate;
    selectedChoice = widget.trip!.transport;
    budgetController.text = widget.trip!.budget.toString();
    purposeValue = widget.trip!.purpose;
    if (widget.trip?.fileImage != null) {
      fileImage = File(widget.trip!.fileImage!);
    } else {
      assetImage = imageList[widget.trip!.assetImgIdx!];
      assetImgIdx = widget.trip!.assetImgIdx;
    }
    getStoredCompanions().then((compList) {
      tempCompanions = compList
          .map((companion) => PhoneContact(
              companion.companion, PhoneNumber(companion.phonenumber, '')))
          .toList();
    });
  }
}
