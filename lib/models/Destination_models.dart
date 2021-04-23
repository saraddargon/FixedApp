import 'activity_models.dart';

class Destination {
  String imgUrl;
  String city;
  String country;
  String description;
  List<Activity> activities;
  Destination({
    this.imgUrl,
    this.city,
    this.country,
    this.description,
    this.activities,
  });
}

List<Activity> activities = [
  Activity(
    imageUrl:
        "https://cdn.pixabay.com/photo/2017/01/20/00/30/maldives-1993704_960_720.jpg",
    name: "samui fatival",
    type: "Thailand tour",
    startTime: ["09:00 am", "10:00 pm"],
    rating: 5,
    price: 100,
  ),
  Activity(
    imageUrl:
        "https://cdn.pixabay.com/photo/2015/10/30/20/13/sunrise-1014712_960_720.jpg",
    name: "phuket fatival",
    type: "Thailand tour",
    startTime: ["08:00 am", "11:00 pm"],
    rating: 4,
    price: 130,
  ),
  Activity(
    imageUrl:
        "https://cdn.pixabay.com/photo/2017/12/15/13/51/polynesia-3021072_960_720.jpg",
    name: "liipa fatival",
    type: "Thailand tour",
    startTime: ["10:00 am", "11:30 pm"],
    rating: 5,
    price: 120,
  )
];

List<Destination> destinations = [
  Destination(
    imgUrl:
        "https://cdn.pixabay.com/photo/2015/07/05/13/44/beach-832346_960_720.jpg",
    city: "smui",
    country: "Thailand",
    description: "Visit Venice for an amazing and unforgettable adventure.",
    activities: activities,
  ),
  Destination(
    imgUrl:
        "https://cdn.pixabay.com/photo/2014/07/31/22/50/photographer-407068_960_720.jpg",
    city: "peual",
    country: "Brazil",
    description: "Visit Venice for an amazing and unforgettable adventure.",
    activities: activities,
  ),
  Destination(
    imgUrl:
        "https://cdn.pixabay.com/photo/2018/07/16/16/08/island-3542290_960_720.jpg",
    city: "Kyoto",
    country: "Japan",
    description: "Visit Venice for an amazing and unforgettable adventure.",
    activities: activities,
  ),
  Destination(
    imgUrl:
        "https://cdn.pixabay.com/photo/2018/03/12/20/07/maldives-3220702_960_720.jpg",
    city: "paris",
    country: "France",
    description: "Visit Venice for an amazing and unforgettable adventure.",
    activities: activities,
  ),
];
