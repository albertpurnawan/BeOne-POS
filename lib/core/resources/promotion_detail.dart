// ignore_for_file: public_member_api_docs, sort_constructors_first
class PromotionDetails {}

class PromoBuyXGetYDetails extends PromotionDetails {
  int applyCount;
  List<int> xGroups;
  List<int> yGroups;

  PromoBuyXGetYDetails({
    required this.applyCount,
    required this.xGroups,
    required this.yGroups,
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
