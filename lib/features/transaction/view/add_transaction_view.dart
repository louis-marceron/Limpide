import 'dart:io';
import 'dart:ui';
import 'package:banking_app/extensions/color_extension.dart';
import 'package:flutter/material.dart';
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';
import 'package:form_validator/form_validator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:permission_handler/permission_handler.dart';
import '../model/ai_recognize_bill_request_model.dart';
import '../../../common_widgets/snackbar/info_floating_snackbar.dart';
import '../../../common_widgets/category_icons.dart';
import 'package:banking_app/features/transaction/viewmodel/transaction_view_model.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../model/ai_recognize_bill_response_model.dart';

class AddTransactionView extends StatefulWidget {
  const AddTransactionView({Key? key}) : super(key: key);

  @override
  _AddTransactionViewState createState() => _AddTransactionViewState();
}

class _AddTransactionViewState extends State<AddTransactionView> {
  final _formKey = GlobalKey<FormState>();
  File? _image;
  final picker = ImagePicker();
  bool _isProcessing = false; // Flag to indicate if processing is ongoing

  @override
  void initState() {
    super.initState();

    final transactionController =
    Provider.of<TransactionViewModel>(context, listen: false);

    transactionController.updateSelectedTransactionType({"Expense"});
    transactionController.updateSelectedDate(DateTime.now());
  }

  Future<void> _pickImage() async {
    final status = await Permission.camera.request();
    if (status.isGranted) {
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);

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
                  'Scan the bill and extract the following details: Label;Amount;Merchant Name;Category;Date (DateTime type); provide them in json style\n'
                      'If any detail is missing, use "null" for that field. If the photo is not clear, respond with "null".\n'
                      'Respond only in the format provided.\n\n'
                      'For label, provide a short description of 3 words max.\n\n'
                      'For the merchant name: Carefully analyze the bill to identify the merchant name, considering different layouts and potential abbreviations. Look for names associated with store chains, addresses, or specific locations mentioned on the bill. If a clear and specific merchant name is found, use it. If the name on the bill seems like a generic term or something that isn\'t a real business name (e.g., "Receipt", "Invoice", etc.), respond with "null". Keep in mind that the bill might be in languages other than English.\n\n'
                      'For categories, use "Miscellaneous" if unsure (you can infer the category from the merchant name).\n\n'
                      'Categories: Groceries, Electronics, Clothing, Restaurant, Entertainment, Transportation, Health, Miscellaneous',
                },
                {
                  "type": "image_url",
                  "image_url": {
                    "url":'data:image/jpeg;base64,$base64Image',
                  }
                }
              ]
            }
          ],
          'max_tokens': 300,
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
              transactionController.labelController.text = openAiResponse.label;
              transactionController.amountController.text = openAiResponse.amount;
              transactionController.bankNameController.text = openAiResponse.merchantName;
              transactionController.categoryController.text = openAiResponse.category;
              transactionController.dateController.text = openAiResponse.date;
            });

            print('Label: ${transactionController.labelController.text}');
            print('Amount: ${transactionController.amountController.text}');
            print('Merchant Name: ${transactionController.bankNameController.text}');
            print('Category: ${transactionController.categoryController.text}');
            print('Date: ${transactionController.dateController.text}');

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
    final transactionController =
    Provider.of<TransactionViewModel>(context);

    final userId = FirebaseAuth.instance.currentUser!.uid;

    return Scaffold(
      appBar: AppBar(
        title: Text('Add Transaction'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Stack(
          children: [
            AbsorbPointer(
              absorbing: _isProcessing, // Disable user interaction while processing
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    TextFormField(
                      controller: transactionController.labelController,
                      decoration: InputDecoration(
                        labelText: 'Label',
                      ),
                      validator: ValidationBuilder()
                          .required('Label is required')
                          .maxLength(
                          50, 'Label can\'t be more than 50 characters')
                          .build(),
                    ),
                    TextFormField(
                      keyboardType: TextInputType.number,
                      controller: transactionController.amountController,
                      decoration: InputDecoration(
                        labelText: 'Amount',
                      ),
                      validator: ValidationBuilder()
                          .required('Amount is required')
                          .regExp(
                          RegExp(r'^\d+(\.\d{1,2})?$'), 'Enter a valid amount')
                          .maxLength(10, 'Amount can\'t be more than 1,000,000,000')
                          .build(),
                    ),
                    TextFormField(
                      controller: transactionController.bankNameController,

                      decoration: InputDecoration(
                        labelText: 'Bank Name',
                      ),
                      validator: ValidationBuilder()
                          .required('Bank Name is required')
                          .maxLength(
                          50, 'Bank Name can\'t be more than 50 characters')
                          .build(),
                    ),
                    Consumer<TransactionViewModel>(
                      builder: (context, transactionController, _) {
                        return SegmentedButton(
                          style: SegmentedButton.styleFrom(
                            backgroundColor: Theme.of(context).colorScheme.primary,
                            selectedBackgroundColor:
                            Theme.of(context).colorScheme.primaryContainer,
                          ),
                          segments: [
                            ButtonSegment(
                              value: "Expense",
                              label: Text('Expense'),
                              icon: Icon(Icons.remove),
                            ),
                            ButtonSegment(
                              value: "Income",
                              label: Text('Income'),
                              icon: Icon(Icons.add),
                            ),
                          ],
                          selected: transactionController.selectedTransactionType,
                          onSelectionChanged: (selected) {
                            transactionController
                                .updateSelectedTransactionType(selected);
                            transactionController.notify();
                          },
                          emptySelectionAllowed: false,
                        );
                      },
                    ),
                    ElevatedButton(
                      onPressed: () {
                        context.pushNamed('categories');
                      },
                      child: Icon(
                        categories[transactionController.categoryController.text]
                            ?.icon ??
                            Icons.question_mark,
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        final selectedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(DateTime.now().year - 1),
                          lastDate: DateTime(DateTime.now().year + 2),
                        );
                        if (selectedDate != null) {
                          transactionController.updateSelectedDate(selectedDate);
                        }
                      },
                      child: Icon(Icons.calendar_today),
                    ),
                    ElevatedButton(
                      onPressed: _pickImage,
                      child: Text('Pick Image'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          transactionController.addTransaction(userId);

                          InfoFloatingSnackbar.show(
                              context, 'Transaction added');
                          context.pop();
                        }
                      },
                      child: Text('Add Transaction'),
                    ),
                  ],
                ),
              ),
            ),
            if (_isProcessing) // Show a loading indicator if processing is ongoing
              Container(
                color: Colors.black.withOpacity(0.2), // Adjust opacity as needed
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 1, sigmaY: 1), // Adjust blur intensity
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
