import '../../../models/category.dart';
import '../provider/category_provider.dart';
import '../../../utility/extensions.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import '../../../utility/constants.dart';
import '../../../widgets/category_image_card.dart';
import '../../../widgets/custom_text_field.dart';

// class CategorySubmitForm extends StatelessWidget {
//   final Category? category;

//   const CategorySubmitForm({super.key, this.category});
class CategorySubmitForm extends StatefulWidget {
  final Category? category;

  const CategorySubmitForm({Key? key, this.category}) : super(key: key);

  @override
  State<CategorySubmitForm> createState() => _CategorySubmitFormState();
}

class _CategorySubmitFormState extends State<CategorySubmitForm> {
  @override
  void initState() {
    super.initState();
    context.categoryProvider.setDataForUpdateCategory(widget.category);
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final screenWidth = MediaQuery.of(context).size.width;
    // context.categoryProvider.setDataForUpdateCategory(category);

    return SingleChildScrollView(
      child: Form(
        key: context.categoryProvider.addCategoryFormKey,
        child: Container(
          padding: EdgeInsets.all(defaultPadding),
          width: size.width,
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Gap(defaultPadding),
              // Title at the top
              Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: Text(
                  (widget.category == null ? 'ADD' : 'UPDATE') + ' Product',
                  style: TextStyle(
                    color: primaryColor,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Gap(defaultPadding),
              Consumer<CategoryProvider>(
                builder: (context, catProvider, child) {
                  return CategoryImageCard(
                    labelText: "Category",
                    imageFile: catProvider.selectedImage,
                    imageUrlForUpdateImage: widget.category?.image,
                    onTap: () {
                      catProvider.pickImage();
                    },
                  );
                },
              ),
              Gap(defaultPadding),
              CustomTextField(
                controller: context.categoryProvider.categoryNameCtrl,
                labelText: 'Category Name',
                onSave: (val) {},
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a category name';
                  }
                  return null;
                },
              ),
              Gap(defaultPadding * 2),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: secondaryColor,
                    ),
                    onPressed: () {
                      Navigator.of(context).pop(); // Close the popup
                    },
                    child: Text('Cancel'),
                  ),
                  Gap(defaultPadding),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: primaryColor,
                    ),
                    onPressed: () {
                      // Validate and save the form
                      if (context
                          .categoryProvider
                          .addCategoryFormKey
                          .currentState!
                          .validate()) {
                        context
                            .categoryProvider
                            .addCategoryFormKey
                            .currentState!
                            .save();
                        context.categoryProvider.submitCategory();
                        // Navigator.of(context).pop();
                      }
                    },
                    child: Text('Submit'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// How to show the category popup
void showAddCategoryForm(BuildContext context, Category? category) {
  final formWidget = CategorySubmitForm(
    key: const ValueKey("AddCategoryForm"),
    category: category,
  );

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: bgColor,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (BuildContext context) {
      final screenHeight = MediaQuery.of(context).size.height;
      return Container(
        height: screenHeight * 0.8,
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        // child: SingleChildScrollView(
        //   child: CategorySubmitForm(category: category),
        // ),
        child: SingleChildScrollView(child: formWidget),
      );
    },
  );
}
