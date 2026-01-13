class Fruit {
  final String label;
  final String displayname;
  final String desciription;
  final String about;

  final Minerals mineral;
  final Nutrition nutrition;
  final Vitamins vitamin;

  Fruit({
    required this.label,
    required this.displayname,
    required this.desciription,
    required this.about,
    required this.mineral,
    required this.nutrition,
    required this.vitamin
  });

  factory Fruit.fromJson(Map<String, dynamic> json){
    return Fruit(
      label: json['label'] ?? '', 
      displayname: json['displayname'] ?? '', 
      desciription: json['desciription'] ?? '', 
      about: json['about'] ?? '', 
      mineral: Minerals.fromMap(json['minerals'] ?? {}), 
      nutrition: Nutrition.fromMap(json['nutrition'] ?? {}), 
      vitamin: Vitamins.fromMap(json['vitamins'] ?? {})
    );
  }
}

class Nutrition{
  final String calories;
  final String carbs;
  final String fat;
  final String protein;

  Nutrition({
    required this.calories,
    required this.carbs,
    required this.fat,
    required this.protein
  });

  factory Nutrition.fromMap(Map<String, dynamic>json){
    return Nutrition(
      calories: json['calories']?.toString() ?? '', 
      carbs: json['carbs']?.toString() ?? '', 
      fat: json['fat']?.toString() ?? '', 
      protein: json['protein']?.toString() ?? ''
    );
  }
}

class Minerals{
  final String calcium;
  final String magnesium;
  final String phosphorus;
  final String potassium;
  final String sodium;

  Minerals({
    required this.calcium,
    required this.magnesium,
    required this.phosphorus,
    required this.potassium,
    required this.sodium
  });

  factory Minerals.fromMap(Map<String, dynamic>json){
    return Minerals(
      calcium: json['calcium']?.toString() ?? '', 
      magnesium: json['magnesium']?.toString() ?? '', 
      phosphorus: json['phosphorus']?.toString() ?? '', 
      potassium: json['potassium']?.toString() ?? '', 
      sodium: json['sodium']?.toString() ?? ''
    );
  }
}

class Vitamins{
  final String vitamin_A;
  final String vitmin_C;

  Vitamins({
    required this.vitamin_A,
    required this.vitmin_C,
  });

  factory Vitamins.fromMap(Map<String, dynamic>json){
    return Vitamins(
      vitamin_A: json['vitamin_A']?.toString() ?? '', 
      vitmin_C: json['vitamin_C']?.toString() ?? ''
    );
  }
}
