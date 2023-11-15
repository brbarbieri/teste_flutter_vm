import 'dart:math';

abstract class ExamApi {
  List<int> getRandomNumbers(int quantity);
  bool checkOrder(List<int> numbers);
}

class ExamApiImpl extends ExamApi {
  @override
  List<int> getRandomNumbers(int quantity) {
    if (quantity > 100) {
      throw ArgumentError('Deve ser menor que 100');
    }

    List<int> randomNumbers = [];
    Random random = Random();

    while (randomNumbers.length < quantity) {
      int randomNumber = random.nextInt(100);

      if (!randomNumbers.contains(randomNumber)) {
        randomNumbers.add(randomNumber);
      }
    }

    return randomNumbers;
  }

  @override
  bool checkOrder(List<int> numbers) {
    for (int i = 0; i < numbers.length - 1; i++) {
      if (numbers[i] > numbers[i + 1]) {
        return false;
      }
    }
    return true;
  }
}
