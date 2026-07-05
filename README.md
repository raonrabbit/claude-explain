# explain

> 코드·개념·아키텍처를, **사전지식이 전혀 없는 사람도 끝까지 몰입해서 이해할 수 있는 "가이드북" 문서**로 만들어주는 Claude Code 스킬.

블로그 글 하나가 아니라, 표지·목차·챕터로 이어지는 **한 권짜리 학습 자료**를 만듭니다. 어떤 개념을 쓰기 전에 그 개념을 그 자리에서 먼저 가르치고(사전지식을 밖에서 찾게 하지 않음), 쉬운 것에서 어려운 것으로 계단을 쌓아 올립니다.

---

## 무엇을 만들어 주나

`/explain`을 호출하면 레포 루트에 `explain-docs/` 폴더를 만들고 그 안에 가이드북을 생성합니다.

```
explain-docs/<주제-슬러그>/
├── index.md          # 표지 + 목차 + "이 가이드북 읽는 법" + 필요한 사전지식 지도
├── 01-<챕터>.md
├── 02-<챕터>.md
└── ...
```

- **레포 코드**를 설명할 땐 관련 파일을 실제로 읽고(`Read`/`Grep`/`Glob`), 원문 코드를 `파일:줄`과 함께 인용합니다. 어림짐작하지 않습니다.
- **일반 개념·라이브러리**를 설명할 땐 불확실한 부분을 `WebSearch`/`WebFetch`로 확인하고, 주장·수치가 나오는 자리마다 **공식문서 링크**를 인라인으로 답니다.
- 각 챕터는 **동기 → 먼저 알아야 할 것 → 본 설명 → 정리**의 리듬으로, "한 번에 소화 가능한 한 입" 크기로 나뉩니다.

> 📌 산출물 폴더 `explain-docs/`는 스킬이 자동으로 `.git/info/exclude`에 등록하므로, 여러분의 커밋이나 팀 `.gitignore`를 건드리지 않습니다(로컬 전용 무시).

---

## 설치

Claude Code 스킬은 `~/.claude/skills/<스킬이름>/` 아래에 두면 인식됩니다. 이 레포를 **`explain`이라는 이름의 폴더**로 클론하세요.

```bash
git clone https://github.com/raonrabbit/claude-explain.git ~/.claude/skills/explain
```

이미 다른 곳에 클론해 뒀다면 폴더째 복사해도 됩니다:

```bash
git clone https://github.com/raonrabbit/claude-explain.git
cp -r claude-explain ~/.claude/skills/explain
```

설치 후 Claude Code에서 `/explain`이 자동완성에 뜨면 성공입니다. (세션이 이미 떠 있으면 재시작)

**업데이트**는 폴더에서 `git pull`:

```bash
cd ~/.claude/skills/explain && git pull
```

---

## 사용법

```
/explain <설명할 주제 또는 대상>
/explain --html <설명할 주제 또는 대상>
```

- 기본 출력은 **Markdown**. `--html`을 붙이면 자체 완결형 **단일 HTML**(사이드바 목차·앵커 이동·코드 하이라이트·챕터 네비게이션 내장)로 만듭니다.
- 명시적으로 `/explain`을 치지 않아도, "이거 어떻게 동작하는지 설명해줘", "공부 자료로 만들어줘" 같은 요청에도 이 스킬이 활성화됩니다.

### 예시 1 — 레포 코드 설명 (Markdown)

```
/explain flightrail의 GlobeTileLayer가 지구본 타일을 어떻게 로딩하는지
```

→ `GlobeTileLayer.tsx`와 관련 파일을 읽고, **타일/슬리피 맵 좌표계** 같은 사전지식을 먼저 가르친 뒤, 실제 코드를 인용하며 로딩 흐름을 단계별로 푼 가이드북을 `explain-docs/flightrail-globe-tile-layer/`에 생성.

### 예시 2 — 개념 설명 (HTML)

```
/explain --html React Server Components가 뭔지 처음 보는 사람도 이해하게
```

→ 클라이언트/서버 렌더링 기본기부터 쌓아 올리는 챕터형 HTML 가이드북을 `explain-docs/react-server-components/`에 생성. `index.html`을 브라우저로 열면 됩니다.

---

## 설계 원칙 (북극성: "얼마나 잘 이해시키는가")

분량이나 형식이 아니라 **독자의 이해**가 유일한 성공 기준입니다.

- **사전지식을 밖에서 찾게 하지 않는다** — 필요한 개념은 쓰기 전에 그 자리에서 가르친다.
- **점층적으로 쌓는다** — 앞에서 가르친 것이 뒤를 이해하는 재료가 되도록 순서를 설계한다.
- **코드는 반드시 실제 원문을 인용**하고, 그 코드를 읽는 데 필요한 문법·개념도 같이 가르친다.
- **출처는 2단으로** — 주장이 나오는 자리에 인라인 링크(↗ 새 탭), 챕터 끝에 `참고 자료` 종합. 죽은 링크를 만들지 않도록 URL은 검색으로 확인한다.

---

## 레포 구성

| 파일 | 역할 |
|------|------|
| `SKILL.md` | 스킬 정의(frontmatter) + 가이드북 작성 방법론 전체 |
| `assets/guidebook-template.html` | `--html` 출력에 쓰는 자체 완결형 템플릿(목차·네비·출처 태그 내장) |
| `evals/evals.json` | 스킬 품질 평가 케이스 |
