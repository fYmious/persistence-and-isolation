#show link: underline

#set document(
  title: [ЛР3],
)

#let img(imagePath, caption, supplement: [Рисунок]) = {
  align(center)[
    #figure(image(imagePath), caption: caption, supplement: supplement)
  ]
}


#set page(
  paper: "a4",
  numbering: "1",
)

#set par(
  justify: true,
  first-line-indent: (
    amount: 1.25cm,
    all: true,
  ),
  spacing: 0.65em,
)

#set text(
  lang: "ru",
  font: "Times New Roman",
  size: 14pt,
)

#set page(footer: context {
  if counter(page).get().first() > 1 [
    #align(center)[
      #counter(page).display("1")
    ]
  ]
  if counter(page).get().first() == 1 [
    #align(center)[
      Санкт-Петербург \ 2026
    ]
  ]
})

#set page(header: context {
  if counter(page).get().first() == 1 [
    #align(center)[
      *Министерство науки и высшего образования Российской Федерации* \
    ]
  ]
})

#show raw: set text(font: "Consolas")
#show raw.where(block: false): box.with(
  fill: luma(240),
  inset: (x: 3pt, y: 0pt),
  outset: (y: 3pt),
  radius: 2pt,
)

#show raw.where(block: true): block.with(
  fill: luma(240),
  inset: 10pt,
  radius: 4pt,
)

// title

#align(center)[
  ФЕДЕРАЛЬНОЕ ГОСУДАРСТВЕННОЕ АВТОНОМНОЕ ОБРАЗОВАТЕЛЬНОЕ УЧРЕЖДЕНИЕ ВЫСШЕГО ОБРАЗОВАНИЯ
]

#align(center)[
  #text(size: 12pt)[
    \ *НАЦИОНАЛЬНЫЙ ИССЛЕДОВАТЕЛЬСКИЙ УНИВЕРСИТЕТ ИТМО*
  ]
]

#align(center)[
  \ *ITMO University*
]


#for _ in range(5) { linebreak() }

#align(center)[*ЛАБОРАТОРНАЯ 3*]

#table(
  stroke: white,
  columns: 1,
  inset: 10pt,

  [*По дисциплине* Контейнеризация и оркестрация приложений],
  [*Тема работы* Персистентность и изоляция: добавляем БД и настраиваем сети],
  [*Обучающийся* Дощенников Никита Андреевич],
  [*Факультет* Прикладной информатики],
  [*Группа* К3321],
  [*Направление подготовки* 11.03.02 Инфокоммуникационные технологии и системы связи],
  [*Образовательная программа* Программирование в инфокоммуникационных системах],
  [],
)

#table(
  stroke: white,
  columns: 4,
  inset: 10pt,

  table.cell(align: top)[*Обучающийся*],

  table(
    columns: 1,
    inset: 2pt,
    stroke: white,
    table.cell(
      align: top + center,
    )[#text(size: 10pt, fill: white)[.]],
    [#line(length: 100pt)],
  ),

  table(
    columns: 1,
    inset: 2pt,
    stroke: white,
    table.cell(
      align: top + center,
    )[#text(size: 11pt, fill: white)[.]],
    [#line(length: 100pt)],
  ),

  table(
    columns: 1,
    inset: 2pt,
    stroke: white,
    table.cell(
      align: top + center,
    )[#text(size: 10pt)[Дощенников Н.А.]],
    [#line(length: 100pt)],
  ),

  [],
  table.cell(align: center)[#text(size: 10pt)[(дата)]],
  table.cell(align: center)[#text(size: 10pt)[(подпись)]],
  table.cell(align: center)[#text(size: 10pt)[(Ф.И.О.)]],

  table.cell(align: top)[*Руководитель*],

  table(
    columns: 1,
    inset: 2pt,
    stroke: white,
    table.cell(
      align: top + center,
    )[#text(size: 10pt, fill: white)[.]],
    [#line(length: 100pt)],
  ),

  table(
    columns: 1,
    inset: 2pt,
    stroke: white,
    table.cell(
      align: top + center,
    )[#text(size: 11pt, fill: white)[.]],
    [#line(length: 100pt)],
  ),

  table(
    columns: 1,
    inset: 2pt,
    stroke: white,
    table.cell(
      align: top + center,
    )[#text(size: 10pt)[Аминов Н.С.]],
    [#line(length: 100pt)],
  ),

  [],
  table.cell(align: center)[#text(size: 10pt)[(дата)]],
  table.cell(align: center)[#text(size: 10pt)[(подпись)]],
  table.cell(align: center)[#text(size: 10pt)[(Ф.И.О.)]],
)


#pagebreak()

#outline(title: [Содержание])

#pagebreak()
= Персональные параметры

#align(center)[
  #figure(
    table(
      columns: 2,
      inset: 10pt,
      align: horizon + center,
      fill: (x, y) => if (y == 0) { gray },
      table.header([*Параметр*], [*Значение*]),
      [Номер ИСУ], [_465797_],
      [Персональный порт], [_#(5430 + 97)_],
      [Персональный префикс], [_doschennikov_],
      [Секретный ключ], [_secret97doschennikov_],
      [Имя базы данных], [_doschennikov97_],
    ),
    caption: [Персональные параметры],
  )
]

#pagebreak()
= Этап 1. Запуск контейнера с именованным volume

== Задание 1.1

Я создал именованный volume для БД командой:

```sh
docker volume create doschennikov-pgdata
```

И проверил его создание:

```sh
docker volume ls | grep doschennikov-pgdata
docker volume inspect doschennikov-pgdata
```

#img("assets/1.png", [Создание volume])

== Задание 1.2

Затем я запустил PostgreSQL с созданным volume:

```sh
docker run -d \
  --name doschennikov-postgres \
  -e POSTGRES_USER=user_465797 \
  -e POSTGRES_PASSWORD=pgpass_465797 \
  -e POSTGRES_DB=assistant_465797 \
  -v doschennikov-pgdata:/var/lib/postgresql/data \
  -p 5527:5432 \
  postgres:15
```

#img("assets/2.png", [Запущенный PostgreSQL])

И проверил статус:

```sh
docker ps --filter "name=doschennikov-postgres" --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"
```

#img("assets/3.png", [Статус запущенного PostgreSQL])

== Задание 1.3

Образ приложения был собран в ЛР2 (#link("https://github.com/fYmious/docker-intro-2/blob/main/report/%D0%9F%D0%A02_%D0%94%D0%BE%D1%89%D0%B5%D0%BD%D0%BD%D0%B8%D0%BA%D0%BE%D0%B2_465797.pdf")[ссылка на отчет]).

== Задание 1.4

Я запустил ассистент и подключил к БД:

```sh
docker run -d \
  --name doschennikov-assistant \
  --add-host=host.docker.internal:host-gateway \
  -p 5527:5527 \
  -e APP_OWNER=doschennikov \
  -e APP_SECRET=secret97doschennikov \
  -e DATABASE_URL="postgresql://user_465797:pgpass_465797@host.docker.internal:5527/assistant_465797" \
  doschennikov-assistant:v3
```

#img("assets/4.png", [Запуск ассистента и подключение к БД])

== Задание 1.5

Я проверил работоспособность:

- Главная страница:
  ```sh
  curl http://localhost:5527/
  ```
  #img("assets/5.png", [Проверка главной страницы])

- Проверка подключения к БД:
  ```sh
  curl http://localhost:5527/health
  ```
  #img("assets/6.png", [Проверка подключения к БД])

- Создание заметки:
  ```sh
  curl -X POST http://localhost:5527/notes \
    -H "Content-Type: application/json" \
    -d '{"text": "ЛР3: данные в БД"}'
  ```
  #img("assets/7.png", [Проверка создания заметки])

- Получение заметки:
  ```sh
  curl http://localhost:5527/notes
  ```
  #img("assets/8.png", [Проверка получения заметки])

#pagebreak()
= Этап 2. Тест персистентности: пересоздание контейнера

== Задание 2.1

Я удалил контейнер с ассистентом командой:

```sh
docker stop doschennikov-assistant
docker rm doschennikov-assistant
```

#img("assets/9.png", [Удаление контейнера])

== Задание 2.2

Я пересоздал контейнер ассистента:

```sh
docker run -d \
  --name doschennikov-assistant \
  --add-host=host.docker.internal:host-gateway \
  -p 5527:5527 \
  -e APP_OWNER=doschennikov \
  -e APP_SECRET=secret97doschennikov \
  -e DATABASE_URL="postgresql://user_465797:pgpass_465797@host.docker.internal:5527/assistant_465797" \
  doschennikov-assistant:v3
```

#img("assets/4.png", [Повторное создание ассистента])

== Задание 2.3

Затем я проверил, что данные сохранились

```sh
curl http://localhost:5527/notes
```

#img("assets/10.png", [Проверка сохранности данных])

== Задание 2.4

Артефакт персистентности:

```sh
echo "========================================" && \
echo "Тест персистентности: $(date '+%H:%M:%S')" && \
echo "$(whoami)@$(hostname)" && \
echo "========================================" && \
curl -s http://localhost:5527/notes | python3 -m json.tool
```

#img("assets/11.png", [Артефакт персистентности])

#pagebreak()
= Этап 3. Bind mount для конфигурации

== Задание 3.1

Я изучил файл конфигурации `app.conf` в папке `config/`

#img("assets/12.png", [`config/app.conf`])

== Задание 3.2

Я создал контейнер с bind mount:

```sh
docker run -d \
  --name doschennikov-assistant-config \
  --add-host=host.docker.internal:host-gateway \
  -p 5527:5527 \
  -e APP_OWNER=doschennikov \
  -e APP_SECRET=secret97doschennikov \
  -e DATABASE_URL="postgresql://user_465797:pgpass_465797@host.docker.internal:5527/assistant_465797" \
  -v $(pwd)/config:/app/config:ro \
  doschennikov-assistant:v3
```

#img("assets/13.png", [Созданный контейнер с bind mount])

== Задание 3.3

Я проверил доступ к конфигурации:

```sh
docker exec -it doschennikov-assistant-config sh

cat /app/config/app.conf

exit
```

#img("assets/14.png", [Проверка доступа к конфигурации])

== Микро-челлендж

В `config/app.conf` я поменял `maintainance_mode` на `true`. Затем я перезапустил контейнер при помощи:

```sh
docker restart doschennikov-assistant-config
```

И проверил, что файл внутри контейнера обновился:

```sh
docker exec doschennikov-assistant-config cat /app/config/app.conf
```

#img("assets/15.png", [Проверка обновления файла])

#pagebreak()
= Этап 4. Пользовательские сети для изоляции

== Задание 4.1

Я создал пользовательскую сеть:

```sh
docker network create doschennikov-backend
```

#img("assets/16.png", [Создание пользовательской сети])

== Задание 4.2

Я остановил старые контейнеры:

```sh
doscker stop doschennikov-postgres doschennikov-assistant-config
doscker rm doschennikov-postgres doschennikov-assistant-config
```

#img("assets/17.png", [Остановка контейнеров])

Затем запустил БД в пользовтельской сети:

```sh
docker run -d \
  --name doschennikov-postgres \
  --network doschennikov-backend \
  -e POSTGRES_USER=user_465797 \
  -e POSTGRES_PASSWORD=pgpass_465797 \
  -e POSTGRES_DB=assistant_465797 \
  -v doschennikov-pgdata:/var/lib/postgresql/data \
  postgres:15
```

#img("assets/18.png", [Запуск БД в пользовательской сети])

И запустил ассистент в той же сети:

```sh
docker run -d \
  --name doschennikov-assistant \
  --network doschennikov-backend \
  -p 5527:5527 \
  -e APP_OWNER=doschennikov \
  -e APP_SECRET=secret97doschennikov \
  -e DATABASE_URL="postgresql://user_465797:pgpass_465797@doschennikov-postgres:5432/assistant_465797" \
  -v $(pwd)/config:/app/config:ro \
  doschennikov-assistant:v3
```

#img("assets/19.png", [Запуск ассистента])

== Задание 4.3

Я проверил работоспособность командой:

```sh
curl http://localhost:5527/health
```

#img("assets/20.png", [Проверка работоспособности])

Затем я создал новую заметку:

```sh
curl -X POST http://localhost:5527/notes \
  -H "Content-Type: application/json" \
  -d '{"text": "ЛР3: сеть работает!"}'
```

#img("assets/21.png", [Создание заметки])

А затем получил все заметки:

```sh
curl http://localhost:5527/notes
```

#img("assets/22.png", [Все заметки])

== Задание 4.4

Я исследовал сетевую изоляцию. Для этого я запустил временный контейнер вне сети:

```sh
docker run -it --rm alpine:3.18 ping -c 2 doschennikov-postgres
```

А также временный контейнер внутри сети:

```sh
docker run -it --rm --network doschennikov-backend alpine:3.18 ping -c 2 doschennikov-postgres
```

#img("assets/23.png", [Результаты пингов])

= Финальный артефакт

```sh
echo "========================================" && \
echo "ЛР3 завершена: $(date '+%d.%m.%Y %H:%M:%S')" && \
echo "Студент: $(whoami)@$(hostname)" && \
echo "========================================" && \
echo "" && \
echo "Контейнеры:" && \
docker ps --filter "name=doschennikov-" --format "table
{{.Names}}\t{{.Status}}\t{{.Ports}}" && \
echo "" && \
echo "Volumes:" && \
docker volume ls --filter "name=doschennikov-" && \
echo "" && \
echo "Сети:" && \
docker network ls --filter "name=doschennikov-"
```

#img("assets/24.png", [Финальный артефакт])
