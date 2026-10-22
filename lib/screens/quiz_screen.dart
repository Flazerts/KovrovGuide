import 'package:flutter/material.dart';
import '../theme.dart';
import '../widgets/guide_widgets.dart';

class _Question {
  final String question;
  final List<String> answers;
  final int correct;
  final String explanation;
  const _Question(this.question, this.answers, this.correct, this.explanation);
}

const _questions = <_Question>[
  _Question(
    'Какой официальный статус имеет Ковров, отражающий его вклад в Победу?',
    ['Город-герой', 'Город трудовой доблести', 'Город воинской славы', 'Историческое поселение'],
    2,
    'Указом Президента РФ Коврову присвоено почетное звание «Город воинской славы» за мужество, стойкость и массовый трудовой героизм.',
  ),
  _Question(
    'Конструктором какого знаменитого оружия был Василий Дегтярёв?',
    ['Автомат Калашникова (АК-47)', 'Пулемёт ДП-27', 'Пистолет Макарова', 'Трехлинейная винтовка Мосина'],
    1,
    'Василий Алексеевич Дегтярёв разработал легендарный пехотный пулемёт системы Дегтярёва (ДП-27), ставший символом огневой мощи пехоты в Великой Отечественной войне.',
  ),
  _Question(
    'Какая отрасль машиностроения, помимо оборонной, принесла всероссийскую известность Коврову во второй половине XX века?',
    ['Производство тракторов', 'Мотоциклетно-спортивная техника (завод имени В.А. Дегтярёва)', 'Судостроение на Клязьме', 'Выпуск пассажирских вагонов'],
    1,
    'Ковров был одним из главных центров мотоциклостроения в стране. Здесь выпускались знаменитые мотоциклы марки «Ковровец» и «Восход».',
  ),
  _Question(
    'На каком историческом объекте города находится уникальный Иоанно-Воинский некрополь?',
    ['На территории старинного кремля', 'В историко-мемориальном парке, созданном на месте старого городского кладбища', 'Возле железнодорожного вокзала', 'На территории завода ЗиД'],
    1,
    'Иоанно-Воинский некрополь превращен в мемориальный парк, где сохраняется память об историческом прошлом старого Коврова и его выдающихся жителях.',
  ),
  _Question(
    'Какая река протекает вблизи исторического центра Коврова?',
    ['Ока', 'Волга', 'Клязьма', 'Нерль'],
    2,
    'Ковров живописно раскинулся на правом берегу реки Клязьмы — крупного притока Оки.',
  ),
];

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});
  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int _index = 0;
  int _score = 0;
  int? _selected;
  bool get _finished => _index >= _questions.length;

  void _answer(int index) {
    if (_selected != null) return;
    setState(() {
      _selected = index;
      if (index == _questions[_index].correct) _score++;
    });
  }

  void _next() => setState(() { _index++; _selected = null; });
  void _restart() => setState(() { _index = 0; _score = 0; _selected = null; });

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('Историческая викторина')),
        body: Center(child: ConstrainedBox(constraints: const BoxConstraints(maxWidth: 720), child: Padding(padding: const EdgeInsets.all(22), child: _finished ? _result(context) : _questionCard(context)))),
      );

  Widget _questionCard(BuildContext context) {
    final question = _questions[_index];
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const Eyebrow('История и факты о городе'),
      const SizedBox(height: 8),
      Text('Вопрос ${_index + 1} из ${_questions.length}', style: Theme.of(context).textTheme.bodyMedium),
      const SizedBox(height: 10),
      ClipRRect(borderRadius: BorderRadius.circular(10), child: LinearProgressIndicator(value: (_index + 1) / _questions.length, minHeight: 7, backgroundColor: GuideColors.line, color: GuideColors.green)),
      const SizedBox(height: 28),
      Text(question.question, style: Theme.of(context).textTheme.headlineMedium),
      const SizedBox(height: 22),
      ...question.answers.asMap().entries.map((entry) {
        final answerIndex = entry.key;
        final answer = entry.value;
        final chosen = _selected == answerIndex;
        final correctShown = _selected != null && answerIndex == question.correct;
        final wrongChosen = chosen && answerIndex != question.correct;
        final background = correctShown ? const Color(0xFFE1F2E8) : wrongChosen ? const Color(0xFFFFE8E5) : Colors.white;
        final border = correctShown ? GuideColors.green : wrongChosen ? const Color(0xFFB9493E) : GuideColors.line;
        return Padding(padding: const EdgeInsets.only(bottom: 9), child: InkWell(onTap: () => _answer(answerIndex), borderRadius: BorderRadius.circular(16), child: Container(width: double.infinity, padding: const EdgeInsets.all(15), decoration: BoxDecoration(color: background, border: Border.all(color: border), borderRadius: BorderRadius.circular(16)), child: Row(children: [
          Container(width: 30, height: 30, alignment: Alignment.center, decoration: BoxDecoration(color: Colors.white.withOpacity(.85), borderRadius: BorderRadius.circular(9)), child: Text(String.fromCharCode(65 + answerIndex), style: const TextStyle(fontWeight: FontWeight.w800, color: GuideColors.greenDark))),
          const SizedBox(width: 12),
          Expanded(child: Text(answer, style: const TextStyle(color: GuideColors.ink, fontWeight: FontWeight.w600, fontSize: 13))),
          if (correctShown) const Icon(Icons.check_circle_rounded, color: GuideColors.green),
          if (wrongChosen) const Icon(Icons.cancel_rounded, color: Color(0xFFB9493E)),
        ]))));
      }),
      if (_selected != null) ...[
        const SizedBox(height: 9),
        Container(padding: const EdgeInsets.all(14), decoration: BoxDecoration(color: GuideColors.paper, borderRadius: BorderRadius.circular(15)), child: Text(question.explanation, style: const TextStyle(fontSize: 13, height: 1.45, color: GuideColors.ink))),
        const Spacer(),
        SizedBox(width: double.infinity, child: FilledButton.icon(onPressed: _next, icon: Icon(_index == _questions.length - 1 ? Icons.flag_rounded : Icons.arrow_forward_rounded), label: Text(_index == _questions.length - 1 ? 'Узнать результат' : 'Следующий вопрос'), style: FilledButton.styleFrom(backgroundColor: GuideColors.green, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 15)))),
      ] else const Spacer(),
    ]);
  }

  Widget _result(BuildContext context) => Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Container(width: 94, height: 94, decoration: const BoxDecoration(color: GuideColors.mint, shape: BoxShape.circle), child: const Icon(Icons.emoji_events_rounded, color: GuideColors.green, size: 48)),
        const SizedBox(height: 23),
        const Eyebrow('Итоги викторины'),
        const SizedBox(height: 8),
        Text('$_score из ${_questions.length}', style: Theme.of(context).textTheme.headlineLarge),
        const SizedBox(height: 12),
        Text(_score == _questions.length ? 'Великолепно! Вы отлично знаете историю и достопримечательности Коврова.' : _score >= 3 ? 'Хороший результат! Вы неплохо ориентируетесь в культурном наследии города.' : 'Есть повод изучить каталог мест и открыть для себя новые факты о городе.', textAlign: TextAlign.center, style: Theme.of(context).textTheme.bodyLarge),
        const SizedBox(height: 25),
        PrimaryAction(label: 'Пройти снова', icon: Icons.replay_rounded, onPressed: _restart),
      ]);
}