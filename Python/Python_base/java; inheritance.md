# 자바 클래스 상속

#### super class

```java
public class Person {
    static String nationality = "korea";
    String name;
    int age;

    String job = "직업이 없음";
    String language = "Korean";


    public Person(String name , int age){
        this.name = name;
        this.age = age;
    }

    public void printName(){
        System.out.println(name);
    }

    public void printLangauge(){
        System.out.println(language);
    }

    public void printJob(){
        System.out.println("Super class에서 호출합니다 "+job);
    }

    public static void printNationality (){
        System.out.println(nationality);
    }
}

```

#### sub class

```java
public class Student extends Person {

    String job; // super class에도 같은 이름의 멤버 변수 존재 => instance variable hiding 발생.
    //static 변수도 똑같은 이름쓰면 hidden된다

    public Student(String name, int age){
        super(name,age); //Person에 default constructor 없기때문에 직접 호출                 			                    // => 반드시 첫줄에 호출되어야 한다
      
        job = "Student"; // 재정의된 job 초기화
        nationality = "France"; // static 변수 값 변경
        language = "French";    // 상속된 insatnace 변수 값 변경 
    }
    
    public static void printNationality (){ // static method 오버라이드 안됨
        System.out.println("sub class에서 호출합니다 " + nationality);
    }
    
}

```

#### test class

```java
public class test {

    public static void main(String[] args) {
        Student a = new Student("Kanghee",25);
        Person b = new Person("chulsoo",20);

        System.out.println(a.nationality); // static 변수 건드리는 순간 끝난다
        System.out.println(b.nationality); // Person 거도 바껴있다 그래서 주로 					                                     // static final 로 선언한다

        a.printName();       // 문제없다
        a.printLangauge();   // 문제없다
        
        System.out.println(a.job); // 재정의된 'student'로 출력
        a.printJob();              // super class의 '직없없음'으로 출력
      
        // 기본적으로 superclass의 함수를 호출할 때는 super 클래스를 참조한다
        // suepr class멤버 변수가 hidden되지 않는다면 문제가 없다
        // 하지만 히든이 된경우 super class에만 존재하는 함수를 부르면 hidden 된값을 참조한다
        // 이게 싫으면 method overwrite를 하면 된다

        a.printNationality();    //static method는 overwirte 안된다. 위에서 이미 France로 static변수 바뀐거 확인했다
    }
}

```





#### class casting

위에 예시에서

```java
Person c = new Student("hooni",18);
        System.out.println(c.job);
        System.out.println(c.language);
```

Student()객체를 부르면 job은 hidden되고 langauge는 super클래스에서 상속되어진게 그대로 update되었다. 따라서 출력하면 각각 직업이 없음과 French가 출력됨

