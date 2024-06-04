// ignore_for_file: public_member_api_docs, sort_constructors_first
class PromotionDetails {}

class PromoBuyXGetYDetails extends PromotionDetails {
  int applyCount;
  bool isY;
  double quantity;
  double sellingPrice;

  PromoBuyXGetYDetails({
    required this.applyCount,
    required this.isY,
    required this.quantity,
    required this.sellingPrice,
  });
}

class PromoBuyXGetYSummaryDetails extends PromotionDetails {
  int? applyCount;
  double? totalDiscount;

  PromoBuyXGetYSummaryDetails({
    this.applyCount,
    this.totalDiscount,
  });
}
