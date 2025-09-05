import 'package:flutter/material.dart';
import '../../models/product_model.dart';

class ProductTile extends StatefulWidget {
  final Product product;
  final void Function(Product, int)? onAddToCart;
  final int selectedQuantity;

  const ProductTile({
    super.key,
    required this.product,
    this.onAddToCart,
    this.selectedQuantity = 0,
  });

  @override
  State<ProductTile> createState() => _ProductTileState();
}

class _ProductTileState extends State<ProductTile> {
  bool showQuantity = false;
  int quantity = 1;

  @override
  void initState() {
    super.initState();
    quantity = widget.selectedQuantity > 0 ? widget.selectedQuantity : 1;
    showQuantity = widget.selectedQuantity > 0;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade200),
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
        ],
      ),
      child: Row(
        children: [
          // Left: Image
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(10),
              bottomLeft: Radius.circular(10),
            ),
            child:
                (widget.product.image != null && widget.product.image != 'null')
                    ? Image.network(
                      'https://apibrize.brizindia.com/storage/${widget.product.image}',
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => _noImage(),
                    )
                    : _noImage(),
          ),

          const SizedBox(width: 10),

          // Center: Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.product.name ?? '',
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                // Text(
                //   widget.product.unit ?? '', // like 230g or 350ml
                //   style: const TextStyle(fontSize: 12, color: Colors.grey),
                // ),
                const SizedBox(height: 6),
                Text(
                  "₹${widget.product.rate ?? '0.00'}",
                  style: const TextStyle(
                    color: Colors.deepOrange,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),

          // Right: + OR - qty +
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child:
                showQuantity
                    ? Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              if (quantity > 1) {
                                setState(() => quantity--);
                                widget.onAddToCart?.call(
                                  widget.product,
                                  quantity,
                                );
                              } else {
                                setState(() {
                                  showQuantity = false;
                                  quantity = 1;
                                });
                                widget.onAddToCart?.call(widget.product, 0);
                              }
                            },
                            child: const Icon(
                              Icons.remove,
                              size: 16,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            '$quantity',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(width: 10),
                          GestureDetector(
                            onTap: () {
                              setState(() => quantity++);
                              widget.onAddToCart?.call(
                                widget.product,
                                quantity,
                              );
                            },
                            child: const Icon(
                              Icons.add,
                              size: 16,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                    )
                    : GestureDetector(
                      onTap: () {
                        setState(() {
                          showQuantity = true;
                          quantity = 1;
                        });
                        widget.onAddToCart?.call(widget.product, quantity);
                      },
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.green.shade100,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: const Icon(
                          Icons.add,
                          size: 20,
                          color: Colors.green,
                        ),
                      ),
                    ),
          ),
        ],
      ),
    );
  }

  Widget _noImage() {
    return Container(
      width: 80,
      height: 80,
      color: Colors.grey.shade200,
      child: const Center(
        child: Icon(Icons.image_not_supported, size: 24, color: Colors.grey),
      ),
    );
  }
}
