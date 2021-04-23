class Hotel {
  String imgUrl;
  String name;
  String address;
  double price;
  Hotel({
    this.imgUrl,
    this.name,
    this.address,
    this.price,
  });
}

final List<Hotel> hotels = [
  Hotel(
    imgUrl:
        "https://cdn.pixabay.com/photo/2016/03/28/09/34/bedroom-1285156_960_720.jpg",
    name: "Luna hotel",
    address: "122 m.11 r.kjarr 2020",
    price: 500,
  ),
  Hotel(
    imgUrl: "Tawan hotel",
    name:
        "https://cdn.pixabay.com/photo/2019/05/28/00/15/indoors-4234071_960_720.jpg",
    address: "122 m.11 r.kjarr 2020",
    price: 450,
  ),
  Hotel(
    imgUrl:
        "https://cdn.pixabay.com/photo/2020/10/18/09/16/bedroom-5664221_960_720.jpg",
    name: "Sara Prudential",
    address: "122 m.11 r.kjarr 2020",
    price: 300,
  ),
  Hotel(
    imgUrl:
        "https://cdn.pixabay.com/photo/2016/06/10/01/05/hotel-room-1447201_960_720.jpg",
    name: "Butterfy hotel",
    address: "122 m.11 r.kjarr 2020",
    price: 400,
  ),
];
