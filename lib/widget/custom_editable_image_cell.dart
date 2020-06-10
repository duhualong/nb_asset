import 'package:flutter/material.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../common/model/image_gallery_item.dart';
import '../common/style/string_set.dart';
import '../page/image_gallery_page.dart';

class CustomEditableImageCell extends StatefulWidget {
  final String title;
  final String attribute;
  final List<String> urls;
  final List<String> paths;
  final String source;

  CustomEditableImageCell({
    Key key,
    @required this.title,
    @required this.attribute,
    this.urls = const [],
    this.paths = const [],
    this.source ='0',
  }) : super(key: key);

  @override
  _CustomEditableImageCellState createState() =>
      _CustomEditableImageCellState();
}

class _CustomEditableImageCellState extends State<CustomEditableImageCell> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(

        children: <Widget>[
          ConstrainedBox(
            constraints: BoxConstraints(minHeight: 50.0),
            child: UnconstrainedBox(
              constrainedAxis: Axis.horizontal,
              child: Row(
                children: <Widget>[
                  SizedBox(width: 20),
                  SizedBox(
                    width: 100,
                    child: Text(
                      widget.title,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  SizedBox(width: 20),
                  Expanded(
                    child: Container(),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.add_circle_outline,
                      color: Color.fromRGBO(140, 140, 140, 1),
                    ),
                    onPressed: () {
                      switch (widget.source) {
                        case '2':
                          _pickImage(source: ImageSource.camera);
                          return;
                        case '1':
                          _pickImage(source: ImageSource.gallery);
                          return;
                        default:
                          _showSimpleDialog();
                          return;
                      }
                    },
                  ),
                  SizedBox(width: 10,),
                ],
              ),
            ),
          ),
          Divider(height: 2,color: Colors.grey,),
          SizedBox(height: 10,),
          Offstage(
            offstage: widget.urls.isEmpty && widget.paths.isEmpty,
            child: Container(
              height: 100,
              child: !(widget.urls.isEmpty && widget.paths.isEmpty)
                  ? GridView.builder(
                padding: EdgeInsets.symmetric(horizontal: 20),
                scrollDirection: Axis.horizontal,
                itemCount: widget.urls.length + widget.paths.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 1,
                  crossAxisSpacing: 0,
                  mainAxisSpacing: 10,
                  childAspectRatio: 3 / 4,
                ),
                itemBuilder: (context, index) {
                  return Stack(
                    children: <Widget>[
                      SizedBox.expand(
                        child: GestureDetector(
                          onTap: () => _openImageGallery(context, index),
                          child: index < widget.paths.length
                              ? Image.file(
                            File(widget.paths[index]),
                            fit: BoxFit.cover,
                          )
                              : Image.network(
                            widget
                                .urls[index - widget.paths.length],
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Positioned(
                        right: 0,
                        top: 0,
                        child: GestureDetector(
                          child: Icon(
                            Icons.remove_circle,
                            color: Colors.red,
                          ),
                          onTap: () {
                            index < widget.paths.length
                                ? widget.paths.removeAt(index)
                                : widget.urls.removeAt(
                                index - widget.paths.length);
                            setState(() {});
                          },
                        ),
                      ),
                    ],
                  );
                },
              )
                  : null,
            ),
          ),
          Offstage(
            offstage: widget.urls.isEmpty && widget.paths.isEmpty,
            child: SizedBox(height: 16),
          ),
          Divider(
            height: 1,
            color: Theme.of(context).dividerColor,
          ),
        ],
      ),
    );
  }

  Future<void> _showSimpleDialog() async {
    await showDialog(
      context: context,
      builder: (context) {
        return SimpleDialog(
          children: <Widget>[
            SimpleDialogOption(
              child: ListTile(
                leading: Icon(
                  Icons.photo_camera,
                  color: Theme.of(context).primaryColor,
                ),
                title: Text(StringSet.CAMERA),
              ),
              onPressed: () {
                _pickImage(source: ImageSource.camera);
                Navigator.of(context).pop();
              },
            ),
            SimpleDialogOption(
              child: ListTile(
                leading: Icon(
                  Icons.photo_library,
                  color: Theme.of(context).primaryColor,
                ),
                title: Text(StringSet.GALLERY),
              ),
              onPressed: () {
                _pickImage(source: ImageSource.gallery);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _pickImage({ImageSource source}) async {
    File file = await ImagePicker.pickImage(source: source);
    if (file != null) {
      File compressedFile = await FlutterNativeImage.compressImage(file.path,
          quality: 20, percentage: 100);
      widget.paths.insert(0, compressedFile.path);
    }
    setState(() {});
  }

  void _openImageGallery(BuildContext context, int index) {
    List<ImageGalleryItem> urlImageItems = widget.urls
        .map((url) => NetworkImage(url))
        .map((imageProvider) => ImageGalleryItem(
      id: '${widget.attribute}-$index',
      imageProvider: imageProvider,
    ))
        .toList();
    List<ImageGalleryItem> fileImageItems = widget.paths
        .map((path) => FileImage(File(path)))
        .map((imageProvider) => ImageGalleryItem(
      id: '${widget.attribute}-$index',
      imageProvider: imageProvider,
    ))
        .toList();
    List<ImageGalleryItem> imageItems = fileImageItems + urlImageItems;

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ImageGalleryPage(
          galleryItems: imageItems,
          loadingChild: Center(
            child: Container(
              width: 20.0,
              height: 20.0,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(
                    Theme.of(context).primaryColor),
              ),
            ),
          ),
          backgroundDecoration: BoxDecoration(color: Colors.black),
          initialIndex: index,
        ),
      ),
    );
  }
}
