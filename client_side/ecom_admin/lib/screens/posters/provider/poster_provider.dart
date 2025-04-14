import 'dart:developer';
import 'dart:io';
import '../../../models/api_response.dart';
import '../../../services/http_services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart' hide Category;
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../../core/data/data_provider.dart';
import '../../../models/category.dart';
import '../../../models/poster.dart';
import '../../../utility/snack_bar_helper.dart';

class PosterProvider extends ChangeNotifier {
  HttpService service = HttpService();
  final DataProvider _dataProvider;
  final addPosterFormKey = GlobalKey<FormState>();
  TextEditingController posterNameCtrl = TextEditingController();
  TextEditingController productIdCtrl = TextEditingController();
  Poster? posterForUpdate;

  File? selectedImage;
  XFile? imgXFile;

  PosterProvider(this._dataProvider);

  addPoster() async {
    try {
      if (selectedImage == null) {
        SnackBarHelper.showErrorSnackBar('Pleas Choose A Image !');
        return; //? stop the program eviction
      }
      Map<String, dynamic> formDataMap = {
        'posterName': posterNameCtrl.text,
        'productId': productIdCtrl.text,
        'imageUrl': 'no_data', //? image path will add from server side
      };

      final FormData form =
          await createFormData(imgXFile: imgXFile, formData: formDataMap);

      final response =
          await service.addItem(endpointUrl: 'posters', itemData: form);
      if (response.isOk && response.body != null) {
        ApiResponse apiResponse = ApiResponse.fromJson(response.body, null);

        if (apiResponse.success == true) {
          clearFields();
          SnackBarHelper.showSuccessSnackBar('${apiResponse.message}');
          log('poster added');
          _dataProvider.getAllPosters();
        } else {
          SnackBarHelper.showErrorSnackBar(
              'Failed to add posters: ${apiResponse.message}');
        }
      } else {
        SnackBarHelper.showErrorSnackBar(
            'Error ${response.body?['message'] ?? response.statusText}');
      }
    } catch (e) {
      print(e);
      SnackBarHelper.showErrorSnackBar('An error occurred: $e');
      rethrow;
    }
  }

  updatePoster() async {
    try {
      Map<String, dynamic> formDataMap = {
        'posterName': posterNameCtrl.text,
        'productId': productIdCtrl.text,
        'imageUrl': posterForUpdate?.imageUrl ?? '',
      };

      final FormData form =
          await createFormData(imgXFile: imgXFile, formData: formDataMap);

      final response = await service.updateItem(
          endpointUrl: 'posters',
          itemData: form,
          itemId: posterForUpdate?.sId ?? '');

      if (response.isOk && response.body != null) {
        ApiResponse apiResponse = ApiResponse.fromJson(response.body, null);
        if (apiResponse.success == true) {
          // clearFields();
          SnackBarHelper.showSuccessSnackBar('${apiResponse.message}');
          log('poster updated');
          _dataProvider.getAllPosters();
        } else {
          SnackBarHelper.showErrorSnackBar(
              'Failed to add poster: ${apiResponse.message}');
        }
      } else {
        SnackBarHelper.showErrorSnackBar(
            'Error ${response.body?['message'] ?? response.statusText}');
      }
    } catch (e) {
      print(e);
      SnackBarHelper.showErrorSnackBar('An error occurred: $e');
      rethrow;
    }
  }

  submitPoster() {
    if (posterForUpdate != null) {
      updatePoster();
    } else {
      addPoster();
    }
  }

  deletePoster(Poster poster) async {
    try {
      Response response = await service.deleteItem(
          endpointUrl: 'posters', itemId: poster.sId ?? '');
      if (response.isOk) {
        ApiResponse apiResponse = ApiResponse.fromJson(response.body, null);
        if (apiResponse.success == true) {
          SnackBarHelper.showSuccessSnackBar('Poster Deleted Successfully');
          _dataProvider.getAllPosters();
        }
      } else {
        SnackBarHelper.showErrorSnackBar(
            'Error ${response.body?['message'] ?? response.statusText}');
      }
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  //? to pick image for poster
  void pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      selectedImage = File(image.path);
      imgXFile = image;
      notifyListeners();
    }
  }

  //? to set data initially for updating poster form
  setDataForUpdatePoster(Poster? poster) {
    if (poster != null) {
      clearFields();
      posterForUpdate = poster;
      posterNameCtrl.text = poster.posterName ?? '';
      productIdCtrl.text = poster.productId ?? '';
    } else {
      clearFields();
    }
  }

  //? to create form data fir send image with data
  Future<FormData> createFormData(
      {required XFile? imgXFile,
      required Map<String, dynamic> formData}) async {
    if (imgXFile != null) {
      final String fileName = imgXFile.name;
      final String extension = fileName.split('.').last.toLowerCase();

      // Determine the content type
      String mimeType = 'image/jpeg'; // Default fallback
      if (extension == 'png') {
        mimeType = 'image/png';
      } else if (extension == 'jpg' || extension == 'jpeg') {
        mimeType = 'image/jpeg';
      } else if (extension == 'webp') {
        mimeType = 'image/webp';
      }

      MultipartFile multipartFile;

      if (kIsWeb) {
        Uint8List byteImg = await imgXFile.readAsBytes();
        multipartFile = await MultipartFile(byteImg,
            filename: fileName, contentType: mimeType);
      } else {
        String fileName = imgXFile.path.split('/').last;
        multipartFile = await MultipartFile(imgXFile.path,
            filename: fileName, contentType: mimeType);
      }
      formData['imageUrl'] = multipartFile;
    }
    final FormData form = FormData(formData);
    return form;
  }

  //? to clear images and text field after submit poster
  clearFields() {
    posterNameCtrl.clear();
    productIdCtrl.clear();
    selectedImage = null;
    imgXFile = null;
    posterForUpdate = null;
  }
}
