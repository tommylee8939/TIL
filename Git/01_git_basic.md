### GIT

## git 시작하기



### git init

1. 폴더 하나 생성
2. `git init`
3. .git 이라는 폴더 하나생성되고 master 속성 뜻
4. 지우고 싶으면 rm -rf .git master속성 사라짐

### config 설정

`git config --global user.name ''`

`git config --global user.email ''`

### git status

1. `git status`
2. `git add`
3. `git commit -m 'mesage'`



### vim

1. `i` insert mode
2. `esc` 명령모드 종료
3. `:w` 저장
4.  `:q`  종료
5. `:wq` 수정 후 종료
6. `:q!` 수정안하고 그냥 나가고 싶을때



### 현재상태 확인하기

`git status`

초록색으로 뜬 파일만 커밋에 포함됨

변경사항이 없는 파일은 표시되지 않음



### 리모트 연결하기 

`git remote add origin <url>`

`git remote remove <name>`

`git remote rename <name> <new name>`



### 리모트에서 클론 받기

- 우선 다른 경로라고 가정
- `git clone <url.git>`

