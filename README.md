# explain

코드·개념·아키텍처를 사전지식이 없는 사람도 몰입해서 이해할 수 있는 **"가이드북" 문서**로 만들어주는 Claude Code 스킬.

## 사용법

```
/explain <설명할 주제 또는 대상>
/explain --html <설명할 주제 또는 대상>
```

- 기본: Markdown 가이드북 생성
- `--html`: 단일 HTML 가이드북 생성 (`assets/guidebook-template.html` 기반)

## 설치

이 저장소를 클론한 뒤 `explain/` 폴더를 `~/.claude/skills/` 아래에 두면 됩니다.

```
git clone https://github.com/raonrabbit/claude-explain.git
cp -r claude-explain ~/.claude/skills/explain
```

## 구성

- `SKILL.md` — 스킬 정의 및 가이드북 작성 방법론
- `assets/guidebook-template.html` — HTML 출력 템플릿
- `evals/evals.json` — 평가 케이스
