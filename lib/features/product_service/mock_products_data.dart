const mockCategoriesData = '''
[
  {"categoryId": "c1", "name": "Beauty"},
  {"categoryId": "c2", "name": "Fragrances"},
  {"categoryId": "c3", "name": "Furniture"},
  {"categoryId": "c4", "name": "Groceries"},
  {"categoryId": "c5", "name": "Pet Supplies"}
]
''';

const mockDistributorsData = '''
[
  {
    "distributorId": "d1",
    "name": "Lasco",
    "distributorImage": "assets/images/lasco.png",
    "brands": [
      {
        "brandId": "b1",
        "brandImage":"assets/images/degree.png",
        "name": "Degree",
        "categoryId": "c1",
        "products": [
          {"productId": "p1", "title": "Essence Mascara Lash Princess", "description": "Popular mascara known for its volumizing and lengthening effects.", "thumbnail": "assets/images/product_item.png", "price": 9.99, "categoryId": "c1"},
          {"productId": "p2", "title": "Eyeshadow Palette with Mirror", "description": "Versatile range of eyeshadow shades with a built-in mirror.", "thumbnail": "assets/images/product_item.png", "price": 19.99, "categoryId": "c1"},
          {"productId": "p3", "title": "Powder Canister", "description": "Finely milled setting powder designed to set makeup and control shine.", "thumbnail": "assets/images/product_item.png", "price": 14.99, "categoryId": "c1"},
          {"productId": "p4", "title": "Red Lipstick", "description": "Classic and bold choice for adding a pop of color to your lips.", "thumbnail": "assets/images/product_item.png", "price": 12.99, "categoryId": "c1"},
          {"productId": "p5", "title": "Red Nail Polish", "description": "Rich and glossy red hue for vibrant and polished nails.", "thumbnail": "assets/images/product_item.png", "price": 8.99, "categoryId": "c1"}
        ]
      },
      {
        "brandId": "b2",
        "name": "Calvin Klein",
        "brandImage":"assets/images/salada.png",
        "categoryId": "c2",
        "products": [
          {"productId": "p6", "title": "Calvin Klein CK One", "description": "Classic unisex fragrance, known for its fresh and clean scent.", "thumbnail": "https://cdn.dummyjson.com/products/images/fragrances/Calvin%20Klein%20CK%20One/thumbnail.png", "price": 49.99, "categoryId": "c2"},
          {"productId": "p7", "title": "Chanel Coco Noir Eau De", "description": "Elegant and mysterious fragrance, featuring notes of grapefruit, rose, and sandalwood.", "thumbnail": "https://cdn.dummyjson.com/products/images/fragrances/Chanel%20Coco%20Noir%20Eau%20De/thumbnail.png", "price": 129.99, "categoryId": "c2"},
          {"productId": "p8", "title": "Dior J'adore", "description": "Luxurious and floral fragrance, known for its blend of ylang-ylang, rose, and jasmine.", "thumbnail": "https://cdn.dummyjson.com/products/images/fragrances/Dior%20J'adore/thumbnail.png", "price": 89.99, "categoryId": "c2"}
        ]
      },
      {
        "brandId": "b3",
        "name": "Chic Cosmetics",
        "brandImage":"assets/images/dove.png",
        "categoryId": "c1",
        "products": [
          {"productId": "p9", "title": "Red Lipstick", "description": "Classic and bold choice for adding a pop of color to your lips.", "thumbnail": "https://cdn.dummyjson.com/products/images/beauty/Red%20Lipstick/thumbnail.png", "price": 12.99, "categoryId": "c1"},
          {"productId": "p10", "title": "Eyeshadow Palette with Mirror", "description": "Versatile range of eyeshadow shades with a built-in mirror.", "thumbnail": "https://cdn.dummyjson.com/products/images/beauty/Eyeshadow%20Palette%20with%20Mirror/thumbnail.png", "price": 19.99, "categoryId": "c1"}
        ]
      }
    ]
  },
  {
    "distributorId": "d2",
    "name": "Tesco",
    "distributorImage": "assets/images/tesco.png",
    "brands": [
      {
        "brandId": "b4",
        "name": "Furniture Co.",
        "brandImage":"assets/images/degree.png",
        "categoryId": "c3",
        "products": [
          {"productId": "p11", "title": "Annibale Colombo Bed", "description": "Luxurious and elegant bed frame, crafted with high-quality materials.", "thumbnail": "https://cdn.dummyjson.com/products/images/furniture/Annibale%20Colombo%20Bed/thumbnail.png", "price": 1899.99, "categoryId": "c3"},
          {"productId": "p12", "title": "Annibale Colombo Sofa", "description": "Sophisticated and comfortable seating option, featuring exquisite design.", "thumbnail": "https://cdn.dummyjson.com/products/images/furniture/Annibale%20Colombo%20Sofa/thumbnail.png", "price": 2499.99, "categoryId": "c3"},
          {"productId": "p13", "title": "Bedside Table African Cherry", "description": "Stylish and functional addition to your bedroom, providing convenient storage space.", "thumbnail": "https://cdn.dummyjson.com/products/images/furniture/Bedside%20Table%20African%20Cherry/thumbnail.png", "price": 299.99, "categoryId": "c3"}
        ]
      },
      {
        "brandId": "b5",
        "name": "Nail Couture",
        "brandImage":"assets/images/dove.png",
        "categoryId": "c1",
        "products": [
          {"productId": "p14", "title": "Red Nail Polish", "description": "Rich and glossy red hue for vibrant and polished nails.", "thumbnail": "https://cdn.dummyjson.com/products/images/beauty/Red%20Nail%20Polish/thumbnail.png", "price": 8.99, "categoryId": "c1"}
        ]
      }
    ]
  },
  {
    "distributorId": "d3",
    "name": "ASOS",
    "distributorImage": "assets/images/asos.png",
    "brands": [
      {
        "brandId": "b6",
        "name": "Glamour Beauty",
        "brandImage":"assets/images/dove.png",
        "categoryId": "c1",
        "products": [
          {"productId": "p15", "title": "Eyeshadow Palette with Mirror", "description": "Versatile range of eyeshadow shades with a built-in mirror.", "thumbnail": "https://cdn.dummyjson.com/products/images/beauty/Eyeshadow%20Palette%20with%20Mirror/thumbnail.png", "price": 19.99, "categoryId": "c1"},
          {"productId": "p16", "title": "Powder Canister", "description": "Finely milled setting powder designed to set makeup and control shine.", "thumbnail": "https://cdn.dummyjson.com/products/images/beauty/Powder%20Canister/thumbnail.png", "price": 14.99, "categoryId": "c1"}
        ]
      },
      {
        "brandId": "b7",
        "name": "Chic Cosmetics",
        "brandImage":"assets/images/degree.png",
        "categoryId": "c1",
        "products": [
          {"productId": "p17", "title": "Red Lipstick", "description": "Classic and bold choice for adding a pop of color to your lips.", "thumbnail": "https://cdn.dummyjson.com/products/images/beauty/Red%20Lipstick/thumbnail.png", "price": 12.99, "categoryId": "c1"},
          {"productId": "p18", "title": "Red Nail Polish", "description": "Rich and glossy red hue for vibrant and polished nails.", "thumbnail": "https://cdn.dummyjson.com/products/images/beauty/Red%20Nail%20Polish/thumbnail.png", "price": 8.99, "categoryId": "c1"}
        ]
      }
    ]
  },
  {
    "distributorId": "d4",
    "name": "Tesco",
    "distributorImage": "assets/images/tesco mobile.png",
    "brands": [
      {
        "brandId": "b8",
        "name": "Dolce & Gabbana",
        "brandImage":"assets/images/degree.png",
        "categoryId": "c2",
        "products": [
          {"productId": "p19", "title": "Dolce Shine Eau de", "description": "Vibrant and fruity fragrance, featuring notes of mango, jasmine, and blonde woods.", "thumbnail": "https://cdn.dummyjson.com/products/images/fragrances/Dolce%20Shine%20Eau%20de/thumbnail.png", "price": 69.99, "categoryId": "c2"},
          {"productId": "p20", "title": "Gucci Bloom Eau de", "description": "Floral and captivating fragrance, with notes of tuberose, jasmine, and Rangoon creeper.", "thumbnail": "https://cdn.dummyjson.com/products/images/fragrances/Gucci%20Bloom%20Eau%20de/thumbnail.png", "price": 79.99, "categoryId": "c2"}
        ]
      },
      {
        "brandId": "b9",
        "name": "Chanel",
        "brandImage":"assets/images/dove.png",
        "categoryId": "c2",
        "products": [
          {"productId": "p21", "title": "Chanel Coco Noir Eau De", "description": "Elegant and mysterious fragrance, featuring notes of grapefruit, rose, and sandalwood.", "thumbnail": "https://cdn.dummyjson.com/products/images/fragrances/Chanel%20Coco%20Noir%20Eau%20De/thumbnail.png", "price": 129.99, "categoryId": "c2"}
        ]
      }
    ]
  },
  {
    "distributorId": "d5",
    "name": "Target",
    "distributorImage": "assets/images/lasco.png",
    "brands": [
      {
        "brandId": "b10",
        "name": "Furniture Co.",
        "brandImage":"assets/images/dove.png",
        "categoryId": "c3",
        "products": [
          {"productId": "p22", "title": "Annibale Colombo Bed", "description": "Luxurious and elegant bed frame, crafted with high-quality materials.", "thumbnail": "https://cdn.dummyjson.com/products/images/furniture/Annibale%20Colombo%20Bed/thumbnail.png", "price": 1899.99, "categoryId": "c3"},
          {"productId": "p23", "title": "Annibale Colombo Sofa", "description": "Sophisticated and comfortable seating option, featuring exquisite design.", "thumbnail": "https://cdn.dummyjson.com/products/images/furniture/Annibale%20Colombo%20Sofa/thumbnail.png", "price": 2499.99, "categoryId": "c3"},
          {"productId": "p24", "title": "Bedside Table African Cherry", "description": "Stylish and functional addition to your bedroom, providing convenient storage space.", "thumbnail": "https://cdn.dummyjson.com/products/images/furniture/Bedside%20Table%20African%20Cherry/thumbnail.png", "price": 299.99, "categoryId": "c3"}
        ]
      },
      {
        "brandId": "b11",
        "name": "Nail Couture",
        "brandImage":"assets/images/degree.png",
        "categoryId": "c1",
        "products": [
          {"productId": "p25", "title": "Red Nail Polish", "description": "Rich and glossy red hue for vibrant and polished nails.", "thumbnail": "https://cdn.dummyjson.com/products/images/beauty/Red%20Nail%20Polish/thumbnail.png", "price": 8.99, "categoryId": "c1"}
        ]
      }
    ]
  },
  {
    "distributorId": "d6",
    "name": "Walmart",
    "distributorImage": "assets/images/tesco.png",
    "brands": [
      {
        "brandId": "b12",
        "name": "Glamour Beauty",
        "brandImage":"assets/images/dove.png",
        "categoryId": "c1",
        "products": [
          {"productId": "p26", "title": "Eyeshadow Palette with Mirror", "description": "Versatile range of eyeshadow shades with a built-in mirror.", "thumbnail": "https://cdn.dummyjson.com/products/images/beauty/Eyeshadow%20Palette%20with%20Mirror/thumbnail.png", "price": 19.99, "categoryId": "c1"},
          {"productId": "p27", "title": "Powder Canister", "description": "Finely milled setting powder designed to set makeup and control shine.", "thumbnail": "https://cdn.dummyjson.com/products/images/beauty/Powder%20Canister/thumbnail.png", "price": 14.99, "categoryId": "c1"}
        ]
      },
      {
        "brandId": "b13",
        "name": "Chic Cosmetics",
        "brandImage":"assets/images/degree.png",
        "categoryId": "c1",
        "products": [
          {"productId": "p28", "title": "Red Lipstick", "description": "Classic and bold choice for adding a pop of color to your lips.", "thumbnail": "https://cdn.dummyjson.com/products/images/beauty/Red%20Lipstick/thumbnail.png", "price": 12.99, "categoryId": "c1"},
          {"productId": "p29", "title": "Red Nail Polish", "description": "Rich and glossy red hue for vibrant and polished nails.", "thumbnail": "https://cdn.dummyjson.com/products/images/beauty/Red%20Nail%20Polish/thumbnail.png", "price": 8.99, "categoryId": "c1"}
        ]
      }
    ]
  },
  {
    "distributorId": "d7",
    "name": "Best Buy",
    "distributorImage": "assets/images/asos.png",
    "brands": [
      {
        "brandId": "b14",
        "name": "Dolce & Gabbana",
        "brandImage":"assets/images/degree.png",
        "categoryId": "c2",
        "products": [
          {"productId": "p30", "title": "Dolce Shine Eau de", "description": "Vibrant and fruity fragrance, featuring notes of mango, jasmine, and blonde woods.", "thumbnail": "https://cdn.dummyjson.com/products/images/fragrances/Dolce%20Shine%20Eau%20de/thumbnail.png", "price": 69.99, "categoryId": "c2"},
          {"productId": "p31", "title": "Gucci Bloom Eau de", "description": "Floral and captivating fragrance, with notes of tuberose, jasmine, and Rangoon creeper.", "thumbnail": "https://cdn.dummyjson.com/products/images/fragrances/Gucci%20Bloom%20Eau%20de/thumbnail.png", "price": 79.99, "categoryId": "c2"}
        ]
      },
      {
        "brandId": "b15",
        "name": "Chanel",
        "brandImage":"assets/images/dove.png",
        "categoryId": "c2",
        "products": [
          {"productId": "p32", "title": "Chanel Coco Noir Eau De", "description": "Elegant and mysterious fragrance, featuring notes of grapefruit, rose, and sandalwood.", "thumbnail": "https://cdn.dummyjson.com/products/images/fragrances/Chanel%20Coco%20Noir%20Eau%20De/thumbnail.png", "price": 129.99, "categoryId": "c2"}
        ]
      }
    ]
  },
  {
    "distributorId": "d8",
    "name": "Amazon",
    "distributorImage": "assets/images/tesco mobile.png",
    "brands": [
      {
        "brandId": "b16",
        "name": "Furniture Co.",
        "brandImage":"assets/images/degree.png",
        "categoryId": "c3",
        "products": [
          {"productId": "p33", "title": "Annibale Colombo Bed", "description": "Luxurious and elegant bed frame, crafted with high-quality materials.", "thumbnail": "https://cdn.dummyjson.com/products/images/furniture/Annibale%20Colombo%20Bed/thumbnail.png", "price": 1899.99, "categoryId": "c3"},
          {"productId": "p34", "title": "Annibale Colombo Sofa", "description": "Sophisticated and comfortable seating option, featuring exquisite design.", "thumbnail": "https://cdn.dummyjson.com/products/images/furniture/Annibale%20Colombo%20Sofa/thumbnail.png", "price": 2499.99, "categoryId": "c3"},
          {"productId": "p35", "title": "Bedside Table African Cherry", "description": "Stylish and functional addition to your bedroom, providing convenient storage space.", "thumbnail": "https://cdn.dummyjson.com/products/images/furniture/Bedside%20Table%20African%20Cherry/thumbnail.png", "price": 299.99, "categoryId": "c3"}
        ]
      },
      {
        "brandId": "b17",
        "name": "Nail Couture",
        "brandImage":"assets/images/dove.png",
        "categoryId": "c1",
        "products": [
          {"productId": "p36", "title": "Red Nail Polish", "description": "Rich and glossy red hue for vibrant and polished nails.", "thumbnail": "https://cdn.dummyjson.com/products/images/beauty/Red%20Nail%20Polish/thumbnail.png", "price": 8.99, "categoryId": "c1"}
        ]
      }
    ]
  },
  {
    "distributorId": "d9",  
    "name": "Target",
    "distributorImage": "assets/images/lasco.png",
    "brands": [
      {
        "brandId": "b18",
        "name": "Glamour Beauty",
        "brandImage":"assets/images/degree.png",
        "categoryId": "c1",
        "products": [
          {"productId": "p37", "title": "Eyeshadow Palette with Mirror", "description": "Versatile range of eyeshadow shades with a built-in mirror.", "thumbnail": "https://cdn.dummyjson.com/products/images/beauty/Eyeshadow%20Palette%20with%20Mirror/thumbnail.png", "price": 19.99, "categoryId": "c1"},
          {"productId": "p38", "title": "Powder Canister", "description": "Finely milled setting powder designed to set makeup and control shine.", "thumbnail": "https://cdn.dummyjson.com/products/images/beauty/Powder%20Canister/thumbnail.png", "price": 14.99, "categoryId": "c1"}
        ]
      },
      {
        "brandId": "b19",
        "name": "Chic Cosmetics",
        "brandImage":"assets/images/dove.png",
        "categoryId": "c1",
        "products": [
          {"productId": "p39", "title": "Red Lipstick", "description": "Classic and bold choice for adding a pop of color to your lips.", "thumbnail": "https://cdn.dummyjson.com/products/images/beauty/Red%20Lipstick/thumbnail.png", "price": 12.99, "categoryId": "c1"},
          {"productId": "p40", "title": "Red Nail Polish", "description": "Rich and glossy red hue for vibrant and polished nails.", "thumbnail": "https://cdn.dummyjson.com/products/images/beauty/Red%20Nail%20Polish/thumbnail.png", "price": 8.99, "categoryId": "c1"}
        ]
      }
    ]
  },
  {
    "distributorId": "d10",
    "name": "Walmart",
    "distributorImage": "assets/images/tesco.png",
    "brands": [
      {
        "brandId": "b20",
        "name": "Dolce & Gabbana",
        "brandImage":"assets/images/dove.png",
        "categoryId": "c2",
        "products": [
          {"productId": "p41", "title": "Dolce Shine Eau de", "description": "Vibrant and fruity fragrance, featuring notes of mango, jasmine, and blonde woods.", "thumbnail": "https://cdn.dummyjson.com/products/images/fragrances/Dolce%20Shine%20Eau%20de/thumbnail.png", "price": 69.99, "categoryId": "c2"},
          {"productId": "p42", "title": "Gucci Bloom Eau de", "description": "Floral and captivating fragrance, with notes of tuberose, jasmine, and Rangoon creeper.", "thumbnail": "https://cdn.dummyjson.com/products/images/fragrances/Gucci%20Bloom%20Eau%20de/thumbnail.png", "price": 79.99, "categoryId": "c2"}
        ]
      },
      {
        "brandId": "b21",
        "name": "Chanel",
        "brandImage":"assets/images/degree.png",
        "categoryId": "c2",
        "products": [
          {"productId": "p43", "title": "Chanel Coco Noir Eau De", "description": "Elegant and mysterious fragrance, featuring notes of grapefruit, rose, and sandalwood.", "thumbnail": "https://cdn.dummyjson.com/products/images/fragrances/Chanel%20Coco%20Noir%20Eau%20De/thumbnail.png", "price": 129.99, "categoryId": "c2"}
        ]
      }
    ]
  },
  {
    "distributorId": "d11",
    "name": "Best Buy",
    "distributorImage": "assets/images/asos.png",
    "brands": [
      {
        "brandId": "b22",
        "name": "Furniture Co.",
        "brandImage":"assets/images/dove.png",
        "categoryId": "c3",
        "products": [
          {"productId": "p44", "title": "Annibale Colombo Bed", "description": "Luxurious and elegant bed frame, crafted with high-quality materials.", "thumbnail": "https://cdn.dummyjson.com/products/images/furniture/Annibale%20Colombo%20Bed/thumbnail.png", "price": 1899.99, "categoryId": "c3"},
          {"productId": "p45", "title": "Annibale Colombo Sofa", "description": "Sophisticated and comfortable seating option, featuring exquisite design.", "thumbnail": "https://cdn.dummyjson.com/products/images/furniture/Annibale%20Colombo%20Sofa/thumbnail.png", "price": 2499.99, "categoryId": "c3"},
          {"productId": "p46", "title": "Bedside Table African Cherry", "description": "Stylish and functional addition to your bedroom, providing convenient storage space.", "thumbnail": "https://cdn.dummyjson.com/products/images/furniture/Bedside%20Table%20African%20Cherry/thumbnail.png", "price": 299.99, "categoryId": "c3"}
        ]
      },
      {
        "brandId": "b23",
        "name": "Nail Couture",
        "brandImage":"assets/images/degree.png",
        "categoryId": "c1",
        "products": [
          {"productId": "p47", "title": "Red Nail Polish", "description": "Rich and glossy red hue for vibrant and polished nails.", "thumbnail": "https://cdn.dummyjson.com/products/images/beauty/Red%20Nail%20Polish/thumbnail.png", "price": 8.99, "categoryId": "c1"}
        ]
      }
    ]
  },
  {
    "distributorId": "d12",
    "name": "Amazon",
    "distributorImage": "assets/images/tesco mobile.png",
    "brands": [
      {
        "brandId": "b24",
        "name": "Glamour Beauty",
        "brandImage":"assets/images/degree.png",
        "categoryId": "c1",
        "products": [
          {"productId": "p48", "title": "Eyeshadow Palette with Mirror", "description": "Versatile range of eyeshadow shades with a built-in mirror.", "thumbnail": "https://cdn.dummyjson.com/products/images/beauty/Eyeshadow%20Palette%20with%20Mirror/thumbnail.png", "price": 19.99, "categoryId": "c1"},
          {"productId": "p49", "title": "Powder Canister", "description": "Finely milled setting powder designed to set makeup and control shine.", "thumbnail": "https://cdn.dummyjson.com/products/images/beauty/Powder%20Canister/thumbnail.png", "price": 14.99, "categoryId": "c1"}
        ]
      },
      {
        "brandId": "b25",
        "name": "Chic Cosmetics",
        "brandImage":"assets/images/dove.png",
        "categoryId": "c1",
        "products": [
          {"productId": "p50", "title": "Red Lipstick", "description": "Classic and bold choice for adding a pop of color to your lips.", "thumbnail": "https://cdn.dummyjson.com/products/images/beauty/Red%20Lipstick/thumbnail.png", "price": 12.99, "categoryId": "c1"},
          {"productId": "p51", "title": "Red Nail Polish", "description": "Rich and glossy red hue for vibrant and polished nails.", "thumbnail": "https://cdn.dummyjson.com/products/images/beauty/Red%20Nail%20Polish/thumbnail.png", "price": 8.99, "categoryId": "c1"}
        ]
      }
    ]
  },
  {
    "distributorId": "d13",
    "name": "Target",
    "distributorImage": "assets/images/lasco.png",
    "brands": [
      {
        "brandId": "b26",
        "name": "Dolce & Gabbana",
        "brandImage":"assets/images/dove.png",
        "categoryId": "c2",
        "products": [
          {"productId": "p52", "title": "Dolce Shine Eau de", "description": "Vibrant and fruity fragrance, featuring notes of mango, jasmine, and blonde woods.", "thumbnail": "https://cdn.dummyjson.com/products/images/fragrances/Dolce%20Shine%20Eau%20de/thumbnail.png", "price": 69.99, "categoryId": "c2"},
          {"productId": "p53", "title": "Gucci Bloom Eau de", "description": "Floral and captivating fragrance, with notes of tuberose, jasmine, and Rangoon creeper.", "thumbnail": "https://cdn.dummyjson.com/products/images/fragrances/Gucci%20Bloom%20Eau%20de/thumbnail.png", "price": 79.99, "categoryId": "c2"}
        ]
      },
      {
        "brandId": "b27",
        "name": "Chanel", 
        "brandImage":"assets/images/degree.png",
        "categoryId": "c2",
        "products": [
          {"productId": "p54", "title": "Chanel Coco Noir Eau De", "description": "Elegant and mysterious fragrance, featuring notes of grapefruit, rose, and sandalwood.", "thumbnail": "https://cdn.dummyjson.com/products/images/fragrances/Chanel%20Coco%20Noir%20Eau%20De/thumbnail.png", "price": 129.99, "categoryId": "c2"}
        ]
      }
    ]
  },
  {
    "distributorId": "d14",
    "name": "Walmart",
    "distributorImage": "assets/images/tesco.png",
    "brands": [
      {
        "brandId": "b28",
        "name": "Furniture Co.",
        "brandImage":"assets/images/dove.png",
        "categoryId": "c3",
        "products": [
          {"productId": "p55", "title": "Annibale Colombo Bed", "description": "Luxurious and elegant bed frame, crafted with high-quality materials.", "thumbnail": "https://cdn.dummyjson.com/products/images/furniture/Annibale%20Colombo%20Bed/thumbnail.png", "price": 1899.99, "categoryId": "c3"},
          {"productId": "p56", "title": "Annibale Colombo Sofa", "description": "Sophisticated and comfortable seating option, featuring exquisite design.", "thumbnail": "https://cdn.dummyjson.com/products/images/furniture/Annibale%20Colombo%20Sofa/thumbnail.png", "price": 2499.99, "categoryId": "c3"},
          {"productId": "p57", "title": "Bedside Table African Cherry", "description": "Stylish and functional addition to your bedroom, providing convenient storage space.", "thumbnail": "https://cdn.dummyjson.com/products/images/furniture/Bedside%20Table%20African%20Cherry/thumbnail.png", "price": 299.99, "categoryId": "c3"}
        ]
      },
      {
        "brandId": "b29",
        "name": "Nail Couture",
        "brandImage":"assets/images/degree.png",
        "categoryId": "c1",
        "products": [
          {"productId": "p58", "title": "Red Nail Polish", "description": "Rich and glossy red hue for vibrant and polished nails.", "thumbnail": "https://cdn.dummyjson.com/products/images/beauty/Red%20Nail%20Polish/thumbnail.png", "price": 8.99, "categoryId": "c1"}
        ]
      }
    ]
  },
  {
    "distributorId": "d15",
    "name": "Best Buy",
    "distributorImage": "assets/images/asos.png",
    "brands": [
      {
        "brandId": "b30",
        "name": "Glamour Beauty",
        "brandImage":"assets/images/degree.png",
        "categoryId": "c1",
        "products": [
          {"productId": "p59", "title": "Eyeshadow Palette with Mirror", "description": "Versatile range of eyeshadow shades with a built-in mirror.", "thumbnail": "https://cdn.dummyjson.com/products/images/beauty/Eyeshadow%20Palette%20with%20Mirror/thumbnail.png", "price": 19.99, "categoryId": "c1"},
          {"productId": "p60", "title": "Powder Canister", "description": "Finely milled setting powder designed to set makeup and control shine.", "thumbnail": "https://cdn.dummyjson.com/products/images/beauty/Powder%20Canister/thumbnail.png", "price": 14.99, "categoryId": "c1"}
        ]
      },
      {
        "brandId": "b31",
        "name": "Chic Cosmetics",
        "brandImage":"assets/images/dove.png",
        "categoryId": "c1",
        "products": [
          {"productId": "p61", "title": "Red Lipstick", "description": "Classic and bold choice for adding a pop of color to your lips.", "thumbnail": "https://cdn.dummyjson.com/products/images/beauty/Red%20Lipstick/thumbnail.png", "price": 12.99, "categoryId": "c1"},
          {"productId": "p62", "title": "Red Nail Polish", "description": "Rich and glossy red hue for vibrant and polished nails.", "thumbnail": "https://cdn.dummyjson.com/products/images/beauty/Red%20Nail%20Polish/thumbnail.png", "price": 8.99, "categoryId": "c1"}
        ]
      }
    ]
  }
]
''';
