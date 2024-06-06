import 'dart:convert';
import 'dart:io';

import 'package:banking_app/features/transaction/model/transaction_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:form_validator/form_validator.dart';
import '../../../common_widgets/snackbar/info_floating_snackbar.dart';
import '../../../common_widgets/category_icons.dart';
import 'package:banking_app/features/transaction/viewmodel/transaction_view_model.dart';
import 'package:image_picker/image_picker.dart';

import '../model/ai_recognize_bill_response_model.dart';

class TransactionFormView extends StatefulWidget {
  const TransactionFormView({super.key, this.transaction});

  final Transaction? transaction;

  @override
  _TransactionFormViewState createState() => _TransactionFormViewState();
}

class _TransactionFormViewState extends State<TransactionFormView> {
  late bool isEditing;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final ValueNotifier<bool> _isFormValid = ValueNotifier<bool>(false);
  final ValueNotifier<bool> _isLoading = ValueNotifier<bool>(false);

  File? _image;
  final picker = ImagePicker();
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();

    final transaction = widget.transaction;
    isEditing = transaction != null;

    // Access the transaction controller after the widget is created
    final transactionController =
        Provider.of<TransactionViewModel>(context, listen: false);

    // transactionController.categoryController.addListener

    // Set default values
    if (transaction != null) {
      _isFormValid.value = true;
      transactionController.updateSelectedTransactionType(transaction.type);
      transactionController.dateTimeController.text =
          transaction.date.toIso8601String();
      transactionController.amountController.text =
          transaction.amount.toString();
      transactionController.labelController.text = transaction.label;
      transactionController.categoryController.text =
          transaction.category ?? 'Other';
    } else {
      transactionController
          .updateSelectedTransactionType(TransactionType.expense);
      transactionController.updateSelectedDateTime(
          selectedDate: DateTime.now(), selectedTime: TimeOfDay.now());
      transactionController.categoryController.text = 'Other';
    }

    // Add listeners to text controllers for title and amount fields
    transactionController.labelController.addListener(_validateForm);
    transactionController.amountController.addListener(_validateForm);
  }

  final _amountInputFormatters = [
    FilteringTextInputFormatter.deny(' '),
    FilteringTextInputFormatter.deny('-'),
    FilteringTextInputFormatter(',', allow: false, replacementString: '.'),
  ];

  void _validateForm() {
    final transactionController =
        Provider.of<TransactionViewModel>(context, listen: false);
    final isTitleFilled = transactionController.labelController.text.isNotEmpty;
    final isAmountFilled =
        transactionController.amountController.text.isNotEmpty;

    if (isTitleFilled && isAmountFilled) {
      _isFormValid.value = _formKey.currentState?.validate() ?? false;
    } else {
      _isFormValid.value = false;
    }
  }


  Future<void> _pickImage() async {
    final status = await Permission.camera.request();
    if (status.isGranted) {
      final pickedFile = await picker.pickImage(source: ImageSource.camera);

      setState(() {
        if (pickedFile != null) {
          print(pickedFile.path);
          _image = File(pickedFile.path);
          _uploadImageAndPrefillFields(_image!);
        } else {
          print('No image selected.');
        }
      });
    } else if (status.isDenied) {
      InfoFloatingSnackbar.show(context, 'Camera permission denied');
    } else if (status.isPermanentlyDenied) {
      openAppSettings();
    }
  }

  Future<String> encodeImage(File image) async {
    List<int> imageBytes = await image.readAsBytes();
    String base64Image = base64Encode(imageBytes);
    return base64Image;
  }

  Future<void> _uploadImageAndPrefillFields(File image) async {
    setState(() {
      _isProcessing = true; // Set processing flag to true
    });

    print('Uploading image');

    // Encode the image to base64
    String base64Image = base64Encode(await image.readAsBytes());

    try {
      print(dotenv.env['OPENAI_API_KEY']);
      final response = await http.post(
        Uri.parse('https://api.openai.com/v1/chat/completions'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${dotenv.env['OPENAI_API_KEY']}',
        },
        body: json.encode({
          'model': 'gpt-4o',
          'messages': [
            {
              'role': 'user',
              "content": [
                {
                  "type": "text",
                  "text":
                  'Scan the bill and extract the following details: Label;Amount;Merchant Name;Category;Date (DateTime type); provide them in json style with all of String type\n'
                      'If any detail is missing, use "null" for that field. If the photo is not clear, respond with "null" for all fields.\n'
                      'Respond only in the format provided.\n\n'
                      'For label : Carefully analyze the bill to identify the merchant name, considering different layouts and potential abbreviations. Look for names associated with store chains, addresses, or specific locations mentioned on the bill. If a clear and specific merchant name is found, use it. Keep in mind that the bill might be in languages other than English.\n\n'
                      'For the merchant name: put null'
                      'For categories, use "Other" if unsure (you can infer the category from the merchant name).\n\n'
                      'Categories: Groceries, Rent, Utilities, Entertainment, Transportation, Health, Insurance, Education, Clothing, Gifts, Food, Travel, Investments, Savings, Salary, Bonus, Interest, Dividends, Refund, Other',
                },
                {
                  "type": "image_url",
                  "image_url": {
                    "url":'data:image/jpeg;base64,$base64Image',
                    "detail":"high"
                  }
                }
              ]
            }
          ],
          'max_tokens': 1000,
        }),
      );

      print('Response: $response');
      print("Response status code: ${response.statusCode}");

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        print('Image uploaded successfully');
        print(responseData);

        final transactionController = Provider.of<TransactionViewModel>(context, listen: false);
        print('OpenAI Response: $responseData');

        if (responseData.containsKey('choices') && responseData['choices'].isNotEmpty) {
          final contentString = responseData['choices'][0]['message']['content'];

          // Extract JSON from the content string
          int jsonStartIndex = contentString.indexOf('{');
          int jsonEndIndex = contentString.lastIndexOf('}');
          if (jsonStartIndex != -1 && jsonEndIndex != -1) {
            var jsonString = contentString.substring(jsonStartIndex, jsonEndIndex + 1);
            var openAiResponse = OpenAiResponse.fromJson(json.decode(jsonString));

            print('Label: ${openAiResponse.label}');
            print('Amount: ${openAiResponse.amount}');
            print('Merchant Name: ${openAiResponse.merchantName}');
            print('Category: ${openAiResponse.category}');
            print('Date: ${openAiResponse.date}');


            setState(() {
              transactionController.labelController.text = openAiResponse.label == 'null' ? '' : openAiResponse.label;
              transactionController.amountController.text = openAiResponse.amount.toString();
              transactionController.bankNameController.text = openAiResponse.merchantName;
              transactionController.categoryController.text = openAiResponse.category;
              transactionController.dateTimeController.text = openAiResponse.date;
            });

            print('Label: ${transactionController.labelController.text}');
            print('Amount: ${transactionController.amountController.text}');
            print('Merchant Name: ${transactionController.bankNameController.text}');
            print('Category: ${transactionController.categoryController.text}');
            print('Date: ${transactionController.dateTimeController.text}');

            InfoFloatingSnackbar.show(context, 'Fields prefilled from image');
          } else {
            print('Invalid JSON content');
            InfoFloatingSnackbar.show(context, 'Invalid JSON content');
          }
        } else {
          print('Invalid response format');
          InfoFloatingSnackbar.show(context, 'Invalid response format');
        }
      } else {
        print('Image upload failed');
        print('Response status code: ${response.statusCode}');
        print('Response body: ${response.body}');
        InfoFloatingSnackbar.show(context, 'Image upload failed');
      }
    } catch (e) {
      print('Error uploading image: $e');
      InfoFloatingSnackbar.show(context, 'Error uploading image');
    } finally {
      setState(() {
        _isProcessing = false; // Set processing flag to false
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final transactionController = Provider.of<TransactionViewModel>(context);
    final isExpense = transactionController.typeController.text == 'Expense';
    // TODO use user service to get the user id
    final userId = FirebaseAuth.instance.currentUser!.uid;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit transaction' : 'New transaction'),
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            child: Form(
              key: _formKey,
              onChanged: _validateForm,
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: SegmentedButton(
                          style: ButtonStyle(
                            visualDensity: VisualDensity(vertical: 2),
                          ),
                          showSelectedIcon: false,
                          segments: [
                            ButtonSegment(
                              value: TransactionType.expense,
                              label: Text('Debit'),
                              icon: Icon(Icons.remove),
                            ),
                            ButtonSegment(
                              value: TransactionType.income,
                              label: Text('Credit'),
                              icon: Icon(Icons.add),
                            ),
                          ],
                          selected: {transactionController.typeController.text},
                          onSelectionChanged: (selected) {
                            transactionController.updateSelectedTransactionType(selected.first);
                            transactionController.notify();
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: transactionController.labelController,
                    maxLength: 64,
                    maxLengthEnforcement: MaxLengthEnforcement.enforced,
                    decoration: InputDecoration(
                      // Hide length counter
                      counterText: '',
                      labelText: 'Title',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.description_outlined),
                    ),
                    validator: ValidationBuilder().required('Title is required').build(),
                    onChanged: (value) => _validateForm(),
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    keyboardType: TextInputType.number,
                    controller: transactionController.amountController,
                    inputFormatters: _amountInputFormatters,
                    maxLength: amountMaxLength,
                    maxLengthEnforcement: MaxLengthEnforcement.enforced,
                    decoration: InputDecoration(
                      counterText: '',
                      prefixText: isExpense ? '-' : '',
                      suffixText: 'PLN',
                      labelText: 'Amount',
                      border: const OutlineInputBorder(),
                      prefixIcon: Icon(Icons.payments_outlined),
                    ),
                    validator: ValidationBuilder()
                        .regExp(RegExp(r'^(?=.*[1-9]).+$'), 'Amount cannot be null')
                        .required('Amount is required')
                        .build(),
                    onChanged: (value) => _validateForm(),
                  ),
                  SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          onTap: () async {
                            // Stops keyboard from appearing
                            FocusScope.of(context).requestFocus(new FocusNode());
                            // Show DatePicker
                            final selectedDate = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(DateTime.now().year - 3),
                              lastDate: DateTime(DateTime.now().year + 2),
                            );
                            // Update selected date in ViewModel
                            if (selectedDate != null) {
                              transactionController.updateSelectedDateTime(
                                  selectedDate: selectedDate);
                            }
                          },
                          controller: TextEditingController(
                            text: formatToDate(
                                transactionController.dateTimeController.text),
                          ),
                          decoration: InputDecoration(
                            labelText: 'Date',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.calendar_today_outlined),
                          ),
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: TextFormField(
                          onTap: () async {
                            // Stops keyboard from appearing
                            FocusScope.of(context).requestFocus(new FocusNode());
                            // Show TimePicker
                            final selectedTime = await showTimePicker(
                              context: context,
                              initialTime: TimeOfDay.now(),
                            );
                            // Update selected time in ViewModel
                            if (selectedTime != null) {
                              transactionController.updateSelectedDateTime(
                                  selectedTime: selectedTime);
                            }
                          },
                          controller: TextEditingController(
                            text: formatToTime(
                                transactionController.dateTimeController.text),
                          ),
                          decoration: InputDecoration(
                            labelText: 'Time',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.access_time),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  GestureDetector(
                    onTap: () {
                      context.pushNamed('categories');
                    },
                    child: AbsorbPointer(
                      child: TextFormField(
                        controller: TextEditingController(
                          text: transactionController.categoryController.text,
                        ),
                        decoration: InputDecoration(
                          labelText: 'Category',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(
                            categories[transactionController
                                .categoryController.text]
                                ?.icon ??
                                Icons.question_mark,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  ButtonBar(
                    alignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton.icon(
                        onPressed: _pickImage,
                        icon: Icon(Icons.camera_alt_outlined),
                        label: Text('Scan bill'),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  ValueListenableBuilder<bool>(
                    valueListenable: _isFormValid,
                    builder: (context, isFormValid, child) {
                      return ValueListenableBuilder<bool>(
                        valueListenable: _isLoading,
                        builder: (context, isLoading, child) {
                          return Row(
                            children: [
                              Expanded(
                                child: AnimatedSwitcher(
                                  duration: Duration(milliseconds: 300),
                                  transitionBuilder:
                                      (Widget child, Animation<double> animation) {
                                    return FadeTransition(
                                        opacity: animation, child: child);
                                  },
                                  child: Container(
                                    key: ValueKey<bool>(isLoading),
                                    width: double
                                        .infinity, // Ensure the button takes the full width
                                    child: FilledButton(
                                      onPressed: isFormValid && !isLoading
                                          ? () async {
                                        _isLoading.value = true;
                                        // Check if form is valid
                                        if (_formKey.currentState!
                                            .validate()) {
                                          try {
                                            final transaction =
                                                widget.transaction;
                                            if (transaction != null) {
                                              await transactionController
                                                  .updateTransaction(
                                                  userId, transaction);
                                              InfoFloatingSnackbar.show(
                                                  context,
                                                  'Transaction edited');
                                            } else {
                                              await transactionController
                                                  .addTransaction(userId);
                                              InfoFloatingSnackbar.show(
                                                  context,
                                                  'Transaction added');
                                            }
                                            context.pop();
                                          } catch (e) {
                                            InfoFloatingSnackbar.show(
                                                context,
                                                isEditing
                                                    ? 'Failed to edit transaction'
                                                    : 'Failed to add transaction');
                                          } finally {
                                            _isLoading.value = false;
                                          }
                                        }
                                      }
                                          : null,
                                      child: isLoading
                                          ? SizedBox(
                                        width: 24,
                                        height: 24,
                                        child: CircularProgressIndicator(
                                          color: Colors.white,
                                          strokeWidth: 2,
                                        ),
                                      )
                                          : Text(isEditing
                                          ? 'Edit transaction'
                                          : 'Add transaction'),
                                      style: ButtonStyle(
                                        visualDensity: VisualDensity(
                                          vertical: 2,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          if (_isProcessing)
            Positioned.fill(
              child: Container(
                color: Colors.black54,
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
  String formatToTime(String dateTimeString) {
  try {
    final DateTime dateTime = DateTime.parse(dateTimeString);
    final DateFormat timeFormat = DateFormat('HH:mm');
    return timeFormat.format(dateTime);
  } catch (e) {
    return 'Invalid DateTime';
  }
}

String formatToDate(String dateTimeString) {
  try {
    final DateTime dateTime = DateTime.parse(dateTimeString);
    final DateFormat dateFormat = DateFormat('yyyy-MM-dd');
    return dateFormat.format(dateTime);
  } catch (e) {
    return 'Invalid DateTime';
  }
}
