## Jupyter notebook 과 R 연동하기

### 크게 두가지 방법이 있다

1. Anaconda로 R과 같이 설치 

2. 기존 사용하고있던 R을 Jupyter notebook에 연결하기

### Anaconda로 설치하기

- 가장 편하게 설치가 가능하다
- 문제는 package 설치 및 관리가 너무 불편하다
- `conda install -c r r-package` 등의 conda 언어로 terminal에서 직접 설치해주어야 한다(윈도우 환경에서는 문제 없었다)
- 기존 base enviroment에 설치할 경우 jupyter notebook kernel 에 R이 추가되지 않는 문제를 여러번 격었다 => R을 위한 가상환경에 추가하기를 추천한다
- 순서
  1. Anaconda를 설치하고
  2. 터미널에서 `conda create -n r_env r-essentials r-base `
  3. `conda activate r_env` : r_env라는 가상 환경 진입
  4.  jupyter kernelspec list : python 은 자동으로 잡혀있고 ir도 추가되어있어야 된다
  5. jupyter notebook 실행

###  R 직접 연결

- 파이썬과 Jupyter notebook이 설치되어있음을 가정한다

- 지역적인 pacakge 설치에 용이하다 ex)KoLNP

- Package 설치 매우 쉽다

- 순서

  1. terminal 에서 R 콘솔 진입

  2. ```R
     install.packages('devtools')
     devtools::install_github('IRkernel/IRkernel')
     IRkernel::installspec()
     ```

  3. `q()` R콘솔 종료

  4. `jupyter kernelspec list` : ir 이 추가되어있는지 확인 

     











