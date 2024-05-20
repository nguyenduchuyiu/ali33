List<PlaceModel> placesModelFromJson(List<dynamic> list) =>
    List<PlaceModel>.from(list.map((e) => PlaceModel.fromJson(e)));

class PlaceModel {
  String placeDescription;
  String placeId;

  PlaceModel({required this.placeDescription, required this.placeId});

  factory PlaceModel.fromJson(Map<String, dynamic> json) => PlaceModel(
        placeDescription: json["description"],
        placeId: json["place_id"],
      );
}
