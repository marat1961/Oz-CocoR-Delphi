Oz Coco/R
========

Coco/R - это генератор компилятора, который берет атрибутивную грамматику
исходного языка и генерирует сканер и парсер для этого языка. 
Сканер работает как детерминистический конечный автомат. 
Парсер использует метод рекурсивного  спуска. 
Конфликты LL(1) могут быть разрешены  просмотром на несколько символов вперёд,
или семантическими проверками. 
Таким образом, класс принятой грамматики - LL(k) для произвольного k.

Почему появился это проект
--------------------------
Я долгое время пользовался версией Coco/R написанной для Турбо паскаля.
Иногда нужно было менять код.
Если исходники менялись я перекомпилировал его.
Но после какого то обновления виндоуз я обнаружил 
что Турбо паскаль приказал долго жить и перестал запускаться.
Вообще мне кажется у многих людей языки от Никлауса Вирта вызывают неприязнь. 

Я вообще считаю что мало таких людей которые внесли сопоставимый вклад в разработку языков программирование и информатики.

Легко найти сложное и частенько непонятное решение задачи. 
Сложно сделать простое, чистое и понятное решение.

Когда видишь такое решение становиться понятно что это работа ГрандМастера с большой буквы.
Сначала я портировал код с Турбо паскаль. Но обнаружил что за почти 20 лет 
утекло много воды и код COCO/R тоже был хорошо улучшен.

Последняя версию которую я нашел была C++, C#, Java.
Тогда я решил портировать код выбор пал на венрсию C#.
По духу это наиболее близкий к Дельфи язык, 
вероятно из за того что главный архитектор у них один.

1. Наиболее важными улучшениями я считаю поддержку LL(k) грамматики.
2. Также очень полезна поддержка кодировки utf-8.
3. Большое внимание обращено на хорошее качество генерируемого кода.
4. Также обратитие внимание была выделен отдельно модуль CocoLib.
Эты библиотеку я разработал ещё во времена использования версии для Турбо паскаль.
Обычно я всегда включаю её в неизменном виде в разрабатываемые проекты 
с использованием Coco/r.
Можете посмотреть пример использования в проекте protobuf-delphi.
 
Новые возможности 
-----------------
<h3>Унифицированная структура классов и фреймов</h3>
При использовании COCO/R предполагается, что будет использована похожая структура классов:
 - Oz.Cocor.Utils - классы для работы с битами и множествами;
 - Oz.Cocor.Lib - базовые классы для сканера и парзера;
 - table - таблица - структуры данных разрабатываемого языка;
 - gen - генератор кода для разрабатываемого языка;
 - options - настройки программы;
 - главная программа.

Предполагается, что будет использован один и тот же набор фреймов для сканера и парзера для разных языков.

Компилятор компиляторов опирается на достаточно фиксированную структуру фрейма для сканера и парзера.
Не желательно менять порядок секций, это может привести к ошибкам компиляции сгенерированного кода.

<h3>Особенности синтаксиса</h3>

<h4>Пространство имён</h4>

Сейчас для текущей реализации необходимо обязательно указать этот параметр.
В противном случае будет сгенерирован код с ошибками.
Пример запуска программы
```
Cocor.exe -namespace Taste -checkEOF -trace AG taste.atg.
```

Пространство имён используется при генерации имени модуля.
Сейчас это используется в фрейме парзера и сканера.   
   
<h4>Макрос</h4>
Добавлена возможность определить простейший макрос - текстовую замену.
Три макроса по умолчанию добавляются в программу:
 - scanner
 - parser
 - namespace

<h4>Префикс</h4>
При генерации типов есть возможность добавить prefix (обычно это две-три буквы).
Например, имя сканера будет сгенерирована путем T + prefix + 'Scanner'.
Это позволяет избавиться от совпадений с уже имеющими типами с Дельфи и других библиотек. 

```
MACROS
  prefix = "cr" .
```

