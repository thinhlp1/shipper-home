import 'dart:io';

import 'package:base/config/view_widget.dart';
import 'package:base/models/customer.dart';
import 'package:base/utils/utils.dart';
import 'package:flutter/material.dart';

import 'customer_component_action.dart';

class CustomerComponent extends StatefulWidget {
  @override
  // ignore: overridden_fields
  final Key? key;
  final Customer customer;

  final void Function(int) onFavoritePressed;
  final void Function(int) onCallPressed;
  final void Function(Customer) onEditPressed;

  const CustomerComponent({
    this.key,
    required this.customer,
    required this.onFavoritePressed,
    required this.onCallPressed,
    required this.onEditPressed,
  }) : super(key: key);

  @override
  State<CustomerComponent> createState() => _CustomerComponenttState();
}

class _CustomerComponenttState
    extends ViewWidget<CustomerComponent, CustomerComponentAction>
    with TickerProviderStateMixin {
  @override
  CustomerComponentAction createViewActions() => CustomerComponentAction();

  final double _maxImageHigh = 100.0;
  final double _defaultImageHight = 100.0;
  final double _defaultImageWidth = 100.0;

  bool _toggle = false;
  bool _isToggleImage = false;
  bool _showImages = false;

  /// Toggle image show/hide
  void _toggleImage() {
    setState(() {
      _showImages = !_showImages;
      _isToggleImage = !_isToggleImage;
    });
  }

  /// Toggle size of container
  void _toggleSize() {
    setState(() {
      _toggle = !_toggle;
      if (!_toggle) {
        _showImages = false; // Hide images when close container
      }
    });
  }

  /// Displays a full-screen image in a dialog.
  ///
  /// This function shows a dialog containing an image fetched from the provided
  /// [imageUrl]. The image can be zoomed in and out using pinch gestures, and the
  /// dialog can be dismissed by either tapping on the background or pressing the
  /// close button.
  ///
  /// The dialog is transparent, and the image is displayed using an
  /// [InteractiveViewer] to allow for zooming and panning.
  ///
  /// Parameters:
  /// - [context]: The build context to use for displaying the dialog.
  /// - [imageUrl]: The URL of the image to display.
  ///
  /// The dialog includes:
  /// - An [InteractiveViewer] widget to allow zooming and panning of the image.
  /// - A close button positioned at the top-right corner to dismiss the dialog.
  void _showFullScreenImage(BuildContext context, String imageUrl) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: GestureDetector(
          onTap: () =>
              Navigator.pop(context), // Close dialog when tap on background
          child: Stack(
            alignment: Alignment.center,
            children: [
              InteractiveViewer(
                boundaryMargin: const EdgeInsets.all(20.0),
                minScale: 0.5,
                maxScale: 4.0,
                child: imageUrl.startsWith('http')
                    ? Image.network(
                        imageUrl,
                        fit: BoxFit.contain,
                      )
                    : Image.file(
                        File(imageUrl),
                        fit: BoxFit.contain,
                      ),
              ),
              Positioned(
                top: 20,
                right: 20,
                child: IconButton(
                  icon: const Icon(Icons.close, color: Colors.white, size: 30),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget render(BuildContext context) {
    Customer customer = widget.customer;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      width: double.infinity,
      padding: const EdgeInsets.all(8.0),
      margin: const EdgeInsets.symmetric(vertical: 4.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min, //  Auto size depend on children
        children: [
          GestureDetector(
            onTap: _toggleSize,
            child: Row(
              children: [
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(customer.name ?? "",
                                style: Theme.of(context)
                                    .textTheme
                                    .labelSmall!
                                    .copyWith(fontWeight: FontWeight.bold),
                                overflow: TextOverflow.ellipsis),
                          ),
                          const SizedBox(width: 8),
                          if (customer.isFavorite)
                            Icon(Icons.star,
                                color: Colors.yellowAccent.shade700, size: 20),
                          Expanded(
                              child: Container(
                            alignment: Alignment.centerRight,
                            child: Text(Utils.formatDate(customer.createdAt),
                                style: Theme.of(context)
                                    .textTheme
                                    .labelSmall!
                                    .copyWith(
                                        color: Colors.grey,
                                        fontStyle: FontStyle.italic)),
                          )),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(customer.phone,
                          style: Theme.of(context)
                              .textTheme
                              .labelSmall!
                              .copyWith(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      Text(customer.address,
                          style: Theme.of(context).textTheme.labelSmall),
                      const SizedBox(height: 4),
                      Text('Note: ${customer.note}',
                          style: Theme.of(context).textTheme.labelSmall),

                      /// Show images text slowly when click
                      AnimatedSize(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                        child: _toggle
                            ? AnimatedOpacity(
                                opacity: _toggle ? 1.0 : 0.0,
                                duration: const Duration(milliseconds: 300),
                                child: GestureDetector(
                                  onTap: () {
                                    _toggleImage();
                                  },
                                  child: GestureDetector(
                                    onTap: () => {
                                      // Open map
                                    },
                                    child: const Text(
                                      "Xem vị trí",
                                      style: TextStyle(color: Colors.blue),
                                    ),
                                  ),
                                ),
                              )
                            : const SizedBox.shrink(),
                      ),
                    ],
                  ),
                ),
                AnimatedRotation(
                  turns: _toggle ? 0.5 : 0.0,
                  duration: const Duration(milliseconds: 300),
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Icon(Icons.keyboard_arrow_up, color: Colors.grey),
                  ),
                )
              ],
            ),
          ),
          const SizedBox(height: 8),
          // Container for show images
          AnimatedSize(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            child: _toggle && customer.imageUrl.isNotEmpty
                ? Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      child: SizedBox(
                        height: _maxImageHigh, // Max height of images
                        child: NotificationListener<ScrollNotification>(
                          onNotification: (ScrollNotification notification) {
                            return true; // Stop scroll when reach max height
                          },
                          child: ListView.builder(
                            key: ValueKey(_showImages),
                            scrollDirection: Axis.horizontal,
                            itemCount: customer.imageUrl.length,
                            physics: const ClampingScrollPhysics(),
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 4.0),
                                child: GestureDetector(
                                  onTap: () {
                                    _showFullScreenImage(
                                        context, customer.imageUrl[index]);
                                  },
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(8.0),
                                    child: customer.imageUrl[index]
                                            .startsWith('http')
                                        ? Image.network(
                                            customer.imageUrl[index],
                                            width: _defaultImageWidth,
                                            height: _defaultImageHight,
                                            fit: BoxFit.cover,
                                          )
                                        : Image.file(
                                            File(customer.imageUrl[index]),
                                            width: _defaultImageWidth,
                                            height: _defaultImageHight,
                                            fit: BoxFit.cover,
                                          ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  )
                : const SizedBox.shrink(),
          ),
          AnimatedSize(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            child: _toggle
                ? Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          children: [
                            IconButton(
                                onPressed: () => {
                                      widget.onCallPressed(customer.id!),
                                    },
                                iconSize: 25,
                                color: Colors.blue,
                                icon: const Icon(Icons.call)),
                            Text("Gọi",
                                style: Theme.of(context).textTheme.labelSmall!),
                          ],
                        ),
                        Column(
                          children: [
                            IconButton(
                                onPressed: () => {
                                      widget.onFavoritePressed(customer.id!),
                                    },
                                padding: const EdgeInsets.all(20),
                                iconSize: 25,
                                color: Colors.yellowAccent.shade700,
                                icon: customer.isFavorite
                                    ? const Icon(Icons.star)
                                    : const Icon(Icons.star_border)),
                            Text("Quan trọng",
                                style: Theme.of(context).textTheme.labelSmall!),
                          ],
                        ),
                        Column(
                          children: [
                            IconButton(
                                onPressed: () => {
                                      widget.onEditPressed(customer),
                                    },
                                padding: const EdgeInsets.all(20),
                                iconSize: 25,
                                color: Colors.pink,
                                icon: const Icon(Icons.edit)),
                            Text("Chỉnh sửa",
                                style: Theme.of(context).textTheme.labelSmall!),
                          ],
                        ),
                      ],
                    ),
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}
