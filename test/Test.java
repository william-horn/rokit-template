package test;

class Thing {
    public static int count = 3;

    public static int getCount() {
        return count;
    }

    public static void setCount(int n) {
        count = n;
    }
}

class Foo extends Thing {
    public void test() {
        System.out.println(count);
    }
}

class Test {
    public static void main(String[] args) {
        Thing.setCount(300);
        new Foo().test();
    }
}