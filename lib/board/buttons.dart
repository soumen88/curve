//Creating the button for movement of pawn
class MotionButton {
  int? id;
  String? name;
  String? icon;
  bool? isVisible;

  MotionButton({
    this.id,
    this.name,
    this.icon,
    this.isVisible
  });
}

List<MotionButton> motionButtonCategories = [
  MotionButton(
      id: 1,
      name: 'Left',
      icon: 'assets/food.svg',
      isVisible : true
  ),
  MotionButton(
      id: 2,
      name: 'Right',
      icon: 'assets/drinks.svg',
      isVisible : true
  ),
  MotionButton(
      id: 3,
      name: 'Move',
      icon: 'assets/fruit.svg',
      isVisible : true
  ),
  MotionButton(
      id: 4,
      name: 'Move 2 Steps',
      icon: 'assets/chat.svg',
      isVisible : true
  ),
];