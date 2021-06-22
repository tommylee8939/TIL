# Git_intermdiate 

### git commit 메세지 수정

```
$git commit amend
#vim 창 등장 수정 후 저장 종료
```





### git clone <url.git>





### git pull origin master

### git push origin master



### .gitignore 파일

https://github.com/tommylee8939/TIL 접속해서

필요한 설정 검색해서 .gitignore파일에 복사



### head 변경

`git checkout key`



### Local Branching

#### create branch

- branch 생성 `git branch <new branch name>`
- branch 확인 `git branch`
- branch 이동 `git switch <branch name>`

- branch 생성 후 이동 `git switch -c <branch name>`

#### delete branch

- branch 제거(이미 merge 된 ) : `git branch -d <branch name>`
- branch 제거(미완료) : `git branch -D <branch name>`

#### merge branch

##### 1. Fast Forwarding

```
$ git branch aaa (master)
$ git switch aaa (aaa)
$ git add . (aaa)
$ git commit -m 'aaa 1' (aaa)
$ git switch master (master)
$ git merge aaa (master)
```

##### 2. Conflict Auto Merge

- a branch 수정
- master branch 수정
- `git merge a (master)`
- 운이 좋아 겹치는 commit 존재하지 않았음 
- auto merge

##### 3. Conflict Manually Merge

- a branch 수정
- master branch 수정
- `git merge a (master)`
- 수동으로 충돌 해결 후 저장
- git add . && git commit 까지 완료해줘야 한다



### collaborating

#### 가장 헷갈리지 말아야할 것은 remote에서 local에 각각 클론을 만들었는데 그 자체가 branch다 commit해도, master가 움직이지 않는다

1. 조장이 remote repository 생성
   - README, .gitignore 같이 생성
   - settings -> manage access : 팀원 추가



2. 모든 팀원이 리모트 리포 clone
3. 브랜치 생성후 각자 진행 
4. remote 로 해당 branch를 보내면 된다 (이러면 아직 평행세계가 각각 존재하는거다)
   - git push origin <branch name>
5. 그러면 각 작성자에 따라 pul l request 형태로 요청되어잇음
6. 요청 수락하면 merge되는거임
   - 위에서 conflict 발생시
   - remote github에서 resolve conflict 후 요청 처리 한다
7. 다시 각자 브랜치에서 master로 이동후 `git pull origin master`
   - branch는 직접 가져오지 않는다
   - 그냥 commit들만 가져오기 때문에 결과들은 보일거다 
   - 그치만 branch 목록에 다른 사람이 만든 branch 없다

